#!/usr/bin/env julia
# ns050_hl_diag.jl — diagnostic for the HL divergence in ns050_dynrescale_profile.jl.
# Prints the early HL trajectory (μ, c_l, ‖W‖∞, ‖G‖∞, ‖U‖∞, res) to localize the blowup mechanism.
# Scope: numerical-tooling diagnostic. :proved=0.
using Printf, LinearAlgebra
function fft!(a::Vector{ComplexF64}; inv::Bool=false)
    N=length(a); j=0
    for i in 1:N-1
        bit=N>>1; while j & bit != 0; j ⊻= bit; bit>>=1; end; j |= bit
        if i<j; tmp=a[i+1]; a[i+1]=a[j+1]; a[j+1]=tmp; end
    end
    len=2
    while len<=N
        ang=(inv ? 2π : -2π)/len; wlen=cis(ang); i=0
        while i<N
            w=ComplexF64(1)
            for k in 0:(len>>1)-1
                u=a[i+k+1]; v=a[i+k+(len>>1)+1]*w; a[i+k+1]=u+v; a[i+k+(len>>1)+1]=u-v; w*=wlen
            end
            i+=len
        end
        len<<=1
    end
    if inv; a ./= N; end; a
end
fwd(v)=fft!(ComplexF64.(v)); inv_re(V)=real.(fft!(copy(V); inv=true)); keff(k,N)= k<=N>>1 ? k : k-N
function build(N,L; filt_α=36.0, filt_p=36)
    θ=[2π*(j+0.5)/N for j in 0:N-1]; ξ=[L*cot(t/2) for t in θ]
    dθ = f->(W=fwd(f); for k in 0:N-1; κ=keff(k,N); W[k+1]*= (abs(κ)==N>>1 ? 0.0+0im : im*κ); end; inv_re(W))
    dξ = f-> -(2/L).*(sin.(θ./2).^2).*dθ(f); ξdξ= f-> -sin.(θ).*dθ(f)
    hilb=f->(W=fwd(f); for k in 0:N-1; κ=keff(k,N); W[k+1]*= (abs(κ)==N>>1 ? 0.0+0im : im*sign(κ)); end;
             Kc=-sum(f[j]*cot(θ[j]/2) for j in 1:N)/N; inv_re(W).+Kc)
    fk=[exp(-filt_α*(abs(keff(k,N))/(N>>1))^filt_p) for k in 0:N-1]
    filt=f->(W=fwd(f); for k in 0:N-1; W[k+1]*=fk[k+1]; end; inv_re(W))
    (; θ, ξ, dξ, ξdξ, hilb, filt, N, L)
end
oddproj(f)=[0.5*(f[j+1]-f[length(f)-j]) for j in 0:length(f)-1]
evenproj(f)=[0.5*(f[j+1]+f[length(f)-j]) for j in 0:length(f)-1]
function pin_indices(W,ξ)
    pos=[i for i in 1:length(ξ) if ξ[i]>0]; pk=maximum(abs.(W[pos])); ip=pos[argmax(abs.(W[pos]))]
    outer=[i for i in pos if ξ[i]>ξ[ip]]; ib=isempty(outer) ? ip : outer[argmin(abs.(abs.(W[outer]).-0.4*pk))]
    (ip,ib)
end
function pin(W,aW,xdxW,ia,ib)
    M=[W[ia] xdxW[ia]; W[ib] xdxW[ib]]; b=[aW[ia];aW[ib]]
    (!all(isfinite,M)||!all(isfinite,b)||abs(det(M))<1e-12) && return (NaN,NaN)
    s=M\b; (s[1],s[2])
end

function diag(; N=1024, L=1.0, dτ=1e-5, nsteps=6000, every=200, renormG=false)
    op=build(N,L); ξ=op.ξ
    W=oddproj(-ξ./(1 .+ξ.^2)); G=evenproj(1 ./(1 .+ξ.^2)); W ./= maximum(abs.(W))
    ia,ib=pin_indices(W,ξ); p=sortperm(ξ); j0=argmin(abs.(ξ))
    vel=HW->(U=zeros(N); acc=0.0; for m in 2:N; i=p[m]; q=p[m-1]; acc+=0.5*(HW[i]+HW[q])*(ξ[i]-ξ[q]); U[i]=acc; end; U[p[1]]=0.0; U.-=U[j0]; U)
    @printf("  N=%d L=%.1f dτ=%.1e renormG=%s  pin ξ_a=%.3f ξ_b=%.3f\n", N,L,dτ,renormG,ξ[ia],ξ[ib])
    @printf("  %-8s %-9s %-9s %-9s %-9s %-9s %-10s\n","step","μ","c_l","‖W‖∞","‖G‖∞","‖U‖∞","‖∂τW‖")
    for s in 1:nsteps
        U=vel(op.hilb(W)); aW=op.dξ(G).-U.*op.dξ(W); xdxW=op.ξdξ(W)
        μ,cl=pin(W,aW,xdxW,ia,ib)
        if !isfinite(μ)||!isfinite(cl); @printf("  step %d: pin NaN (W finite=%s G finite=%s)\n",s,all(isfinite,W),all(isfinite,G)); break; end
        FW=aW.-μ.*W.-cl.*op.ξdξ(W); FG=-(cl-2).*G.-U.*op.dξ(G).-cl.*op.ξdξ(G)
        Wt=W.+dτ.*FW; Gt=G.+dτ.*FG; Ut=vel(op.hilb(Wt))
        FW2=op.dξ(Gt).-μ.*Wt.-Ut.*op.dξ(Wt).-cl.*op.ξdξ(Wt); FG2=-(cl-2).*Gt.-Ut.*op.dξ(Gt).-cl.*op.ξdξ(Gt)
        W=W.+(dτ/2).*(FW.+FW2); G=G.+(dτ/2).*(FG.+FG2)
        W=oddproj(op.filt(W)); G=evenproj(op.filt(G))
        renormG && (G ./= maximum(abs.(G)))
        if s%every==0 || s<=3
            @printf("  %-8d %-9.4f %-9.4f %-9.3e %-9.3e %-9.3e %-10.3e\n",
                s,μ,cl,maximum(abs.(W)),maximum(abs.(G)),maximum(abs.(U)),maximum(abs.(FW)))
            if !all(isfinite,W)||!all(isfinite,G); println("  → NON-FINITE field at step $s"); break; end
            (maximum(abs.(FW))<1e-5) && (println("  → CONVERGED (res<1e-5) at step $s"); break)
        end
    end
end

println("="^78); println("  HL divergence diagnostic — long trajectory + G-renorm variant"); println("="^78)
println("\n── A) standard, long (does the wrong-way drift reverse, or run to blowup?) ──")
diag(N=1024, dτ=1e-5, nsteps=400000, every=20000)
println("\n── B) with ‖G‖∞ renormalized each step (is the G-amplitude runaway the (fixable) cause?) ──")
diag(N=1024, dτ=1e-5, nsteps=400000, every=20000, renormG=true)
