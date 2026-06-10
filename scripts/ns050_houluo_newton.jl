#!/usr/bin/env julia
# ns050_houluo_newton.jl — Stage 3 (Newton): solve the HL self-similar profile (Ω,Θ) at fixed c_l by
# damped Newton with a numerical Jacobian, on the validated cot-map operators. The completion the
# relaxation could not reach (the profile is a relaxation-saddle; Newton handles unstable modes).
#
# EXPERIMENTAL. **Scope: numerical-tooling / 1D-model.** :proved=0; distance to the prize UNTOUCHED.
# Steady HL profile system (μ=−c_ω=1), Ω odd / Θ even, U'=HΩ:
#   (P1)  Ω + c_l ξ Ω' + U Ω' − Θ' = 0
#   (P2)  c_l ξ Θ' − (c_l−2) Θ + U Θ' = 0
# c_l∈(2,4.53) is a 1-PARAMETER FAMILY (all members have μ=1); the forward run (ns050_houluo_hl, β=2.47)
# SELECTS one. So we fix c_l=2.47 (forward-selected) and Newton-solve the isolated (Ω,Θ) — the amplitude is
# fixed by the U·Ω' nonlinearity (no scaling freedom). HONEST: c_l is INPUT (not independently re-derived;
# selecting it needs the stability analysis — Chen–Hou's harder content). V3 = residual ‖F‖→0.
# Operators from the validated ns050_mapped_grid.jl (V1/V2 machine-precision). Std-lib + LinearAlgebra.

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
fwd(v)=fft!(ComplexF64.(v)); inv_re(V)=real.(fft!(copy(V); inv=true))
keff(k,N)= k<=N>>1 ? k : k-N
function build(N,L)
    θ=[2π*(j+0.5)/N for j in 0:N-1]; ξ=[L*cot(t/2) for t in θ]
    dθ = f->(W=fwd(f); for k in 0:N-1; κ=keff(k,N); W[k+1]*= (abs(κ)==N>>1 ? 0.0+0im : im*κ); end; inv_re(W))
    dξ = f-> -(2/L).*(sin.(θ./2).^2).*dθ(f)
    ξdξ= f-> -sin.(θ).*dθ(f)
    hilb=f->(W=fwd(f); for k in 0:N-1; κ=keff(k,N); W[k+1]*= (abs(κ)==N>>1 ? 0.0+0im : im*sign(κ)); end;
             Kc=-sum(f[j]*cot(θ[j]/2) for j in 1:N)/N; inv_re(W).+Kc)
    θ,ξ,dξ,ξdξ,hilb
end
function velocity_from_H(HΩ, ξ)
    N=length(ξ); p=sortperm(ξ); U=zeros(N); acc=0.0
    for m in 2:N; i=p[m]; im1=p[m-1]; acc += 0.5*(HΩ[i]+HΩ[im1])*(ξ[i]-ξ[im1]); U[i]=acc; end
    U[p[1]]=0.0; U .-= U[argmin(abs.(ξ))]; U
end
function residual(Ω,Θ,c_l,ξ,dξ,ξdξ,hilb)
    HΩ=hilb(Ω); U=velocity_from_H(HΩ,ξ)
    r1 = Ω .+ c_l.*ξdξ(Ω) .+ U.*dξ(Ω) .- dξ(Θ)
    r2 = c_l.*ξdξ(Θ) .- (c_l-2).*Θ .+ U.*dξ(Θ)
    vcat(r1,r2)
end

function main()
    out=joinpath(@__DIR__,"ns050_houluo_newton.out.txt"); fout=open(out,"w")
    pr(a...)=(println(stdout,a...);println(fout,a...);flush(fout)); bar="═"^84; dsh="─"^84
    pr(bar); pr("  ns050_houluo_newton.jl — Newton solve of the HL self-similar profile (Scope: numerical-tooling)")
    pr("  Fixed c_l=2.47 (forward-selected); damped Newton + numerical Jacobian on validated operators. :proved=0.")
    pr(bar)
    N=256; L=1.0; c_l=2.47; θ,ξ,dξ,ξdξ,hilb=build(N,L)
    Ω=ξ./(1 .+ξ.^2).^2; Ω./=maximum(abs.(Ω)); Θ=1 ./(1 .+ξ.^2)      # odd / even analytic seed
    pr(@sprintf("\n  N=%d L=%.1f c_l=%.2f. Seed: Ω=ξ/(1+ξ²)² (odd), Θ=1/(1+ξ²) (even).", N, L, c_l))
    pr("\n"*dsh); pr("  DAMPED NEWTON (numerical Jacobian, 2N×2N):"); pr(dsh)
    pr(@sprintf("    %-5s %-13s %-8s %-s","it","‖F‖","step α","note"))
    F=residual(Ω,Θ,c_l,ξ,dξ,ξdξ,hilb); nF=norm(F)
    pr(@sprintf("    %-5d %-13.4e %-8s %s",0,nF,"—","seed residual"))
    converged=false
    for it in 1:25
        nF<1e-8 && (converged=true; break)
        n=2N; J=zeros(n,n); ε=1e-6; x=vcat(Ω,Θ)
        for k in 1:n
            xp=copy(x); xp[k]+=ε; Fp=residual(xp[1:N],xp[N+1:2N],c_l,ξ,dξ,ξdξ,hilb)
            @views J[:,k]=(Fp.-F)./ε
        end
        local δ
        try; δ=-(J\F); catch; pr("    (Jacobian singular — stop)"); break; end
        # line search on ‖F‖
        α=1.0; best=nF; bestΩ=Ω; bestΘ=Θ; bestF=F
        for _ in 1:6
            Ωt=Ω.+α.*δ[1:N]; Θt=Θ.+α.*δ[N+1:2N]
            Ft=residual(Ωt,Θt,c_l,ξ,dξ,ξdξ,hilb); nt=norm(Ft)
            if isfinite(nt) && nt<best; best=nt; bestΩ=Ωt; bestΘ=Θt; bestF=Ft; break; end
            α/=2
        end
        if best>=nF; pr(@sprintf("    %-5d %-13.4e %-8.3f %s",it,nF,α,"no decrease — stuck")); break; end
        Ω=bestΩ; Θ=bestΘ; F=bestF; nF=best
        pr(@sprintf("    %-5d %-13.4e %-8.3f %s",it,nF,α,nF<1e-8 ? "CONVERGED ✓" : ""))
    end
    pr(@sprintf("\n  V3 — final residual ‖F‖ = %.3e  ⇒  %s", nF,
        nF<1e-6 ? "Newton CONVERGED to the steady profile ✓ (the relaxation-unreachable saddle, solved)" :
        (nF<norm(residual(ξ./(1 .+ξ.^2).^2 ./ maximum(abs.(ξ./(1 .+ξ.^2).^2)),1 ./(1 .+ξ.^2),c_l,ξ,dξ,ξdξ,hilb))*0.1 ? "reduced but not fully converged (partial)" : "did NOT converge (see notes)")))
    if nF<1e-6
        ic=argmax(abs.(Ω)); pr(@sprintf("  profile: ‖Ω‖∞=%.3f at ξ*=%.3f; Θ(0)=%.3f. Sample (ξ:Ω:Θ):",maximum(abs.(Ω)),ξ[ic],Θ[argmin(abs.(ξ))]))
        order=sortperm(ξ)
        for q in 0.1:0.15:0.95; i=order[clamp(round(Int,q*N),1,N)]; pr(@sprintf("    % .3f  % .4f  % .4f",ξ[i],Ω[i],Θ[i])); end
    end
    pr("\n"*bar); pr("  READING (Newton profile solve)"); pr(bar)
    pr("  • Newton (numerical Jacobian + line search) targets the steady profile DIRECTLY — handling the")
    pr("    unstable modes that made naive relaxation diverge. V3 (‖F‖→0) above is the test of success.")
    pr("  • HONEST: c_l=2.47 is INPUT (forward-selected); this reconstructs THAT family member's profile, it")
    pr("    does NOT independently re-derive c_l (the family is 1-parameter; selecting c_l needs the")
    pr("    stability analysis). Numerical, not Chen–Hou's interval-arithmetic rigor.")
    pr("  • FIREWALL: 1D HL model, numerical-tooling; :proved=0; distance to the prize UNTOUCHED.")
    pr(bar); close(fout); println(stdout,"\nwrote: $out")
end
main()
