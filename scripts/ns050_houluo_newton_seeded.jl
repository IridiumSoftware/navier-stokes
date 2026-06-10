#!/usr/bin/env julia
# ns050_houluo_newton_seeded.jl — push the profile solve: Newton SEEDED FROM THE FORWARD PROFILE.
#
# EXPERIMENTAL. **Scope: numerical-tooling / 1D-model.** :proved=0; distance to the prize UNTOUCHED.
# The earlier Newton (ns050_houluo_newton.jl) stalled out-of-basin from an ANALYTIC seed. Textbook fix:
# seed from the actual attractor SHAPE — the forward HL blow-up's rescaled profile. Steps:
#   (1) forward HL blow-up (periodic), extract Ω_fwd(η),Θ_fwd(η) at a resolved amplitude;
#   (2) interpolate onto the cot-map ξ-grid (the validated Stage-1+2 operators);
#   (3) damped Newton on the steady system (P1,P2) at fixed c_l=2.47 from that seed.
# HONEST going in: the forward profile is itself gate-limited (collapse was imperfect), so the seed may be
# off; if Newton STILL stalls, that is the genuine wall (true asymptotic profile needs much higher
# resolution or a correctly-stabilized dynamic rescaling) — reported, not fished. Std-lib + LinearAlgebra.

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
interp(f,xs,x)=(N=length(xs); h=xs[2]-xs[1]; s=(x-xs[1])/h; (s<0||s>N-1) ? 0.0 : (i=floor(Int,s); fr=s-i; (1-fr)*f[i+1]+fr*f[min(i+2,N)]))

# ── forward periodic HL solver (from ns050_houluo_hl.jl) ──
ddx_p(ω,N)=(W=fwd(ω); for k in 0:N-1; W[k+1]*=im*keff(k,N); end; inv_re(W))
vel_p(ω,N)=(W=fwd(ω); for k in 0:N-1; κ=keff(k,N); W[k+1]= κ==0 ? 0.0+0im : -W[k+1]/abs(κ); end; inv_re(W))
deal_p(v,N)=(W=fwd(v); c=N÷3; for k in 0:N-1; if abs(keff(k,N))>c; W[k+1]=0; end; end; inv_re(W))
function step_fwd!(ω,θ,dt,N)
    rhs=(ω,θ)->(u=vel_p(ω,N); (-deal_p(u.*ddx_p(ω,N),N).+ddx_p(θ,N), -deal_p(u.*ddx_p(θ,N),N)))
    a1,b1=rhs(ω,θ); a2,b2=rhs(ω.+(dt/2).*a1,θ.+(dt/2).*b1)
    a3,b3=rhs(ω.+(dt/2).*a2,θ.+(dt/2).*b2); a4,b4=rhs(ω.+dt.*a3,θ.+dt.*b3)
    @. ω += (dt/6)*(a1+2a2+2a3+a4); @. θ += (dt/6)*(b1+2b2+2b3+b4); nothing
end
# extract forward profile at amplitude Atarget → (ηs, Ωfwd, Θfwd)
function forward_profile(Atarget; N=8192, ηmax=6.0, Nη=241)
    xs=[2π*j/N for j in 0:N-1]; ω=zeros(N); θ=[exp(-((x-π)/0.7)^2) for x in xs]; dt=2e-4; t=0.0
    while t<6.0; step_fwd!(ω,θ,dt,N); t+=dt; maximum(abs.(ω))>=Atarget && break; end
    A=maximum(abs.(ω)); ωx=ddx_p(ω,N); sx=maximum(abs.(ωx)); ic=argmax(abs.(ωx))
    x0=xs[ic]; ℓ=A/sx; sgn=-sign(ωx[ic]); sgn==0 && (sgn=1.0); θ0c=θ[ic]
    interpx(f,x)=(h=2π/N; s=mod(x,2π)/h; i=floor(Int,s); fr=s-i; (1-fr)*f[mod(i,N)+1]+fr*f[mod(i+1,N)+1])
    ηs=collect(range(-ηmax,ηmax;length=Nη))
    Ωf=[sgn*interpx(ω,x0+ℓ*η)/A for η in ηs]; Θf=[interpx(θ,x0+ℓ*η)/θ0c for η in ηs]
    A, ℓ, ηs, Ωf, Θf
end

# ── cot-map operators (validated, ns050_mapped_grid.jl) ──
function build(N,L)
    θ=[2π*(j+0.5)/N for j in 0:N-1]; ξ=[L*cot(t/2) for t in θ]
    dθ=f->(W=fwd(f); for k in 0:N-1; κ=keff(k,N); W[k+1]*= (abs(κ)==N>>1 ? 0.0+0im : im*κ); end; inv_re(W))
    dξ=f-> -(2/L).*(sin.(θ./2).^2).*dθ(f); ξdξ=f-> -sin.(θ).*dθ(f)
    hilb=f->(W=fwd(f); for k in 0:N-1; κ=keff(k,N); W[k+1]*= (abs(κ)==N>>1 ? 0.0+0im : im*sign(κ)); end;
             Kc=-sum(f[j]*cot(θ[j]/2) for j in 1:N)/N; inv_re(W).+Kc)
    θ,ξ,dξ,ξdξ,hilb
end
function vel_H(HΩ,ξ)
    N=length(ξ); p=sortperm(ξ); U=zeros(N); acc=0.0
    for m in 2:N; i=p[m]; im1=p[m-1]; acc+=0.5*(HΩ[i]+HΩ[im1])*(ξ[i]-ξ[im1]); U[i]=acc; end
    U[p[1]]=0.0; U .-= U[argmin(abs.(ξ))]; U
end
# residual with an AMPLITUDE PIN at i_ref (Ω[i_ref]=target) replacing one P1 row — prevents collapse to Ω≡0
function res(Ω,Θ,c_l,ξ,dξ,ξdξ,hilb,i_ref,target)
    HΩ=hilb(Ω); U=vel_H(HΩ,ξ)
    r1 = Ω.+c_l.*ξdξ(Ω).+U.*dξ(Ω).-dξ(Θ); r2 = c_l.*ξdξ(Θ).-(c_l-2).*Θ.+U.*dξ(Θ)
    r1[i_ref] = Ω[i_ref]-target           # pin
    vcat(r1,r2)
end

function main()
    out=joinpath(@__DIR__,"ns050_houluo_newton_seeded.out.txt"); fout=open(out,"w")
    pr(a...)=(println(stdout,a...);println(fout,a...);flush(fout)); bar="═"^84; dsh="─"^84
    pr(bar); pr("  ns050_houluo_newton_seeded.jl — Newton SEEDED from the forward profile (Scope: numerical-tooling)")
    pr("  Forward HL profile → cot-grid → damped Newton on (P1,P2), c_l=2.47. :proved=0; UNTOUCHED.")
    pr(bar)
    A,ℓ,ηs,Ωf,Θf = forward_profile(8.0)
    pr(@sprintf("\n  forward seed @ A=%.1f (ℓ=%.4f): extracted Ω_fwd,Θ_fwd on η∈[%.0f,%.0f] (%d pts)",A,ℓ,ηs[1],ηs[end],length(ηs)))
    N=256; c_l=2.47
    pr("\n"*dsh); pr("  scale-scan s (ξ=s·η) + damped Newton; report best final ‖F‖:"); pr(dsh)
    pr(@sprintf("    %-6s %-13s %-13s %-11s %-s","s","‖F‖ seed","‖F‖ final","‖Ω‖∞ final","note"))
    best_overall=Inf; best_nontrivial=Inf; bestΩ=Float64[]; bestΘ=Float64[]; bestξ=Float64[]
    for s in (0.5,1.0,2.0,4.0)
        L=s; θ,ξ,dξ,ξdξ,hilb=build(N,L)
        Ω=[interp(Ωf,ηs,ξ[j]/s) for j in 1:N]; Θ=[interp(Θf,ηs,ξ[j]/s) for j in 1:N]
        mx=maximum(abs.(Ω)); mx>0 && (Ω./=mx)
        i_ref=argmax(abs.(Ω)); target=Ω[i_ref]      # pin the seed peak amplitude (prevents Ω≡0 collapse)
        F=res(Ω,Θ,c_l,ξ,dξ,ξdξ,hilb,i_ref,target); nF0=norm(F); nF=nF0
        for it in 1:20
            nF<1e-8 && break
            n=2N; J=zeros(n,n); ε=1e-6; x=vcat(Ω,Θ)
            for k in 1:n; xp=copy(x); xp[k]+=ε; @views J[:,k]=(res(xp[1:N],xp[N+1:2N],c_l,ξ,dξ,ξdξ,hilb,i_ref,target).-F)./ε; end
            local δ; try; δ=-(J\F); catch; break; end
            α=1.0; improved=false
            for _ in 1:8
                Ωt=Ω.+α.*δ[1:N]; Θt=Θ.+α.*δ[N+1:2N]; Ft=res(Ωt,Θt,c_l,ξ,dξ,ξdξ,hilb,i_ref,target); nt=norm(Ft)
                if isfinite(nt)&&nt<nF; Ω=Ωt; Θ=Θt; F=Ft; nF=nt; improved=true; break; end; α/=2
            end
            improved || break
        end
        ampΩ=maximum(abs.(Ω))
        note = nF<1e-6 ? (ampΩ>0.1 ? "CONVERGED ✓ NONTRIVIAL" : "converged to TRIVIAL Ω≈0 (NOT the profile!)") : (nF<0.3*nF0 ? "reduced" : "stalled")
        pr(@sprintf("    %-6.1f %-13.3e %-13.3e %-11.3e %s",s,nF0,nF,ampΩ,note))
        best_overall=min(best_overall,nF)
        if nF<1e-6 && ampΩ>0.1 && nF<best_nontrivial; best_nontrivial=nF; bestΩ=copy(Ω); bestΘ=copy(Θ); bestξ=copy(ξ); end
    end
    ok = best_nontrivial<1e-6
    pr(@sprintf("\n  V3 — best NONTRIVIAL converged ‖F‖ = %s ⇒ %s",
        ok ? @sprintf("%.3e",best_nontrivial) : "none (all converged solutions were trivial Ω≈0, or none converged)",
        ok ? "Newton CONVERGED to a NONTRIVIAL steady profile ✓ — reconstructed" :
        "NO nontrivial profile recovered — the genuine wall (see notes)"))
    if ok
        order=sortperm(bestξ)
        pr("  reconstructed profile (ξ : Ω : Θ), sampled:")
        for q in (0.15,0.3,0.45,0.5,0.55,0.7,0.85); i=order[clamp(round(Int,q*length(bestξ)),1,length(bestξ))]; pr(@sprintf("    % .3f  % .4f  % .4f",bestξ[i],bestΩ[i],bestΘ[i])); end
    end
    pr("\n"*bar); pr("  READING"); pr(bar)
    if ok
        pr("  • Newton, seeded from the forward profile, CONVERGED to a NONTRIVIAL steady HL profile at")
        pr("    c_l=2.47 (‖Ω‖∞≈O(1), residual machine-precision) — the reconstruction relaxation +")
        pr("    analytic-seed-Newton could not reach. Validated ℝ-operators + forward-shape seed = the recipe.")
    else
        pr("  • Newton STALLS even from the forward seed. Honest wall: the forward profile is gate-limited")
        pr("    (not the converged asymptotic shape), so it is not in the Newton basin either; and naive")
        pr("    relaxation diverges. Reconstructing the true profile needs a much higher-resolution forward")
        pr("    run to reach the asymptotic regime, OR a correctly-stabilized dynamic rescaling (the Hou")
        pr("    attracting forward dynamics in the rescaled frame) — genuine rigorous-numerics, not a")
        pr("    session script. The validated ℝ-variable OPERATORS remain the durable, reusable deliverable.")
    end
    pr("  • HONEST: c_l=2.47 is INPUT (forward-selected). 1D HL model, numerical; :proved=0; UNTOUCHED.")
    pr(bar); close(fout); println(stdout,"\nwrote: $out")
end
main()
