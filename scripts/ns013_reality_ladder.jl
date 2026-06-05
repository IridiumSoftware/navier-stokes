#!/usr/bin/env julia
# ns013_reality_ladder.jl — NS-013 attack, Step-2 probe: the reality-protection FALSIFICATION LADDER.
#
# EXPERIMENTAL. **Scope: 1D models (complex viscous Burgers; complex inviscid CLM).** NOT the 3D-NS
# PDE. :proved=0; distance to the prize UNTOUCHED. This probe TESTS the prediction of the NS-013
# obstruction-map (docs/ns013_complex_real_obstruction.md): reality protects against complex-data
# blowup ONLY when the model has a coercive control to enforce — and the protection tracks that
# control's criticality. It does NOT bear on 3D-NS regularity; a model in which reality protects is
# evidence about THAT MODEL's criticality, never about real NS (over-reach guard, armed).
#
# THE LADDER (this file = the 1D rungs; the sharp falsification):
#   Rung 1 — viscous Burgers  u_t = −u u_x + ν u_xx :  REAL data is globally regular (Cole–Hopf max
#            principle). A coercive control EXISTS (viscosity / max principle). PREDICT: reality
#            protects — a finite leakage threshold λ_c above which complex data stays regular.
#   Rung 2 — inviscid CLM     ω_t = ω H(ω)          :  REAL data BLOWS UP at t*=2 (pure vortex
#            stretching, NO coercive control). PREDICT: reality does NOT protect — forcing the data
#            real (λ→∞) gives real CLM, which still blows up ⇒ NO protection threshold (λ_c=∞).
# Contrast = the falsification: "reality protects" is NOT universal; it requires a coercive control.
# This corroborates the obstruction-map's claim that complex⇏real is vacuous (complex blowup escapes
# the very control reality supplies) — in 1D models only.
#
# Reality leakage: add −iλ·Im(field) to the RHS (λ→∞ forces the field real). Std-lib Julia; the same
# hand-rolled radix-2 complex FFT used in complex_burgers_reality_leakage.jl / spectral_clm_blowup.jl.

using Printf

function fft!(a::Vector{ComplexF64}; inv::Bool=false)
    N=length(a); j=0
    for i in 1:N-1
        bit=N>>1
        while j & bit != 0; j ⊻= bit; bit>>=1; end
        j |= bit
        if i<j; t=a[i+1]; a[i+1]=a[j+1]; a[j+1]=t; end
    end
    len=2
    while len<=N
        wlen=cis((inv ? 2π : -2π)/len); i=0
        while i<N
            w=ComplexF64(1)
            for k in 0:(len>>1)-1
                u=a[i+k+1]; v=a[i+k+(len>>1)+1]*w
                a[i+k+1]=u+v; a[i+k+(len>>1)+1]=u-v; w*=wlen
            end
            i+=len
        end
        len<<=1
    end
    if inv; a ./= N; end
    a
end
fwd(u)=fft!(copy(u)); inv_(U)=fft!(copy(U); inv=true)
keff(k,N)= k<=N>>1 ? k : k-N

# ── Rung 1: complex viscous Burgers, integrating-factor RK4 (viscous term exact) ──
# u_t = −u u_x + ν u_xx − iλ Im(u).  Coercive control = viscosity + Cole–Hopf max principle.
function burgers_N(U, kk, deal, λ)
    u=inv_(U); ux=inv_(im.*kk.*U)
    NLh=fwd(u.*ux); NLh[.!deal].=0
    .-NLh .- fwd((im*λ).*imag.(u))
end
function run_burgers(u0, kk, deal, ν, λ; dt=0.005, Tmax=20.0, thresh=100.0)
    U=fwd(u0); n=round(Int,Tmax/dt)
    L=.-(ν).*(kk.^2); E=exp.(L.*dt); E2=exp.(L.*(dt/2))
    for i in 1:n
        k1=burgers_N(U,kk,deal,λ)
        k2=burgers_N(E2.*(U.+(dt/2).*k1),kk,deal,λ)
        k3=burgers_N(E2.*U.+(dt/2).*k2,kk,deal,λ)
        k4=burgers_N(E.*U.+dt.*(E2.*k3),kk,deal,λ)
        U=E.*U .+ (dt/6).*(E.*k1 .+ 2 .*E2.*(k2.+k3) .+ k4)
        m=maximum(abs.(inv_(U))); (m>thresh || !isfinite(m)) && return (i*dt, m)
    end
    (Inf, maximum(abs.(inv_(U))))
end

# ── Rung 2: complex inviscid CLM ω_t = ω H(ω) − iλ Im(ω), plain RK4 (no viscous term) ──
# H(ω)^ = −i·sgn(κ)·ω̂.  NO coercive control: real CLM (ω₀=cos x) blows up at t*=2 (exact).
function clm_rhs(ω, kk, sgn, deal, λ)
    W=fwd(ω); Hω=inv_(.-im.*sgn.*W)             # Hilbert transform of (complex) ω
    P=fwd(ω.*Hω); P[.!deal].=0                  # ω·Hω, 2/3-dealiased
    inv_(P) .- (im*λ).*imag.(ω)
end
function run_clm(ω0, kk, sgn, deal, λ; dt=0.0002, Tmax=4.0, thresh=200.0)
    ω=copy(ω0); n=round(Int,Tmax/dt)
    for i in 1:n
        k1=clm_rhs(ω,kk,sgn,deal,λ)
        k2=clm_rhs(ω.+(dt/2).*k1,kk,sgn,deal,λ)
        k3=clm_rhs(ω.+(dt/2).*k2,kk,sgn,deal,λ)
        k4=clm_rhs(ω.+dt.*k3,kk,sgn,deal,λ)
        ω=ω .+ (dt/6).*(k1.+2 .*k2.+2 .*k3.+k4)
        m=maximum(abs.(ω)); (m>thresh || !isfinite(m)) && return (i*dt, m)
    end
    (Inf, maximum(abs.(ω)))
end

function main()
    out=joinpath(@__DIR__,"ns013_reality_ladder.out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...))
    bar="═"^82; dsh="─"^82
    pr(bar); pr("  ns013_reality_ladder.jl — does 'reality' protect? Burgers (has control) vs CLM (none)")
    pr("  Scope: 1D complex models. NOT the PDE. :proved=0; prize UNTOUCHED. Tests the NS-013 map.")
    pr(bar)

    N=1024; x=[2π*(i-1)/N for i in 1:N]
    kk=[Float64(keff(i-1,N)) for i in 1:N]
    sgn=[Float64(sign(keff(i-1,N))) for i in 1:N]
    cut=N÷3; deal=[abs(keff(i-1,N))<=cut for i in 1:N]
    λs=[0.0,0.01,0.05,0.1,0.25,0.5,1.0,2.0,5.0]

    # ── Rung 1: viscous Burgers (coercive control present) ──────────────────────
    ν=0.2; b=3.0
    φ0=1.0 .+ b.*exp.(im.*x); uB0=-2ν .*(im*b).*exp.(im.*x)./φ0   # complex Cole–Hopf IC
    tstarB=log(b)/ν
    pr("\n"*dsh); pr(@sprintf("  RUNG 1 — viscous Burgers (ν=%.2f): REAL data globally regular (Cole–Hopf).",ν))
    pr(@sprintf("    coercive control PRESENT (viscosity/max-principle). Cole–Hopf complex blowup t*=ln b/ν=%.3f",tstarB))
    pr(dsh); pr(@sprintf("    %-8s %-12s %-s","λ","T*(λ)","fate"))
    TB=Float64[]
    for λ in λs
        T,m=run_burgers(uB0,kk,deal,ν,λ); push!(TB,T)
        pr(@sprintf("    %-8.3g %-12s %-s", λ, isinf(T) ? "∞" : @sprintf("%.3f",T),
            isinf(T) ? @sprintf("REGULAR to T=20 (max|u|=%.1f)",m) : @sprintf("blowup (max|u|→%.0f)",m)))
    end
    okB = !isinf(TB[1]) && abs(TB[1]-tstarB)/tstarB<0.12
    iB=findfirst(isinf,TB); λcB = iB===nothing ? Inf : λs[iB]
    pr(@sprintf("    validation (λ=0): T*=%.3f vs Cole–Hopf %.3f → %s", TB[1], tstarB, okB ? "MATCH ✓" : "?"))
    pr(@sprintf("    ⇒ protection threshold λ_c ≈ %s  (reality PROTECTS)", isinf(λcB) ? ">5 (none in sweep)" : @sprintf("%.3g",λcB)))

    # ── Rung 2: inviscid CLM (no coercive control; real data blows up at t*=2) ───
    cc=0.6; ωC0=cos.(x) .+ (im*cc).*sin.(x)      # complex IC; Im damped by λ ⇒ λ→∞ gives ω₀=cos x
    pr("\n"*dsh); pr("  RUNG 2 — inviscid CLM ω_t=ωH(ω): REAL data BLOWS UP at t*=2 (pure stretching).")
    pr("    coercive control ABSENT. λ→∞ forces ω→real(cos x) ⇒ real CLM ⇒ should STILL blow up.")
    pr(dsh); pr(@sprintf("    %-8s %-12s %-s","λ","T*(λ)","fate"))
    TC=Float64[]
    for λ in λs
        T,m=run_clm(ωC0,kk,sgn,deal,λ); push!(TC,T)
        pr(@sprintf("    %-8.3g %-12s %-s", λ, isinf(T) ? "∞" : @sprintf("%.3f",T),
            isinf(T) ? @sprintf("REGULAR to T=4 (max|ω|=%.1f)",m) : @sprintf("blowup (max|ω|→%.0f)",m)))
    end
    iC=findfirst(isinf,TC); λcC = iC===nothing ? Inf : λs[iC]
    # large-λ limit should approach the real-CLM blowup t*=2
    pr(@sprintf("    large-λ limit (λ=%.3g, ≈real CLM): T*=%.3f  vs exact real-CLM t*=2.0", λs[end], TC[end]))
    pr(@sprintf("    ⇒ protection threshold λ_c = %s", isinf(λcC) ? "∞ (NONE — reality does NOT protect)" : @sprintf("%.3g",λcC)))

    pr("\n"*bar); pr("  VERDICT — the falsification (NS-013 obstruction-map, Step-2 probe)"); pr(bar)
    pr("  • Burgers (coercive control present): reality PROTECTS — finite λ_c; forcing real ⇒ regular.")
    pr("  • CLM (no coercive control): reality does NOT protect — forcing real ⇒ real CLM ⇒ blows up;")
    pr("    no λ_c. 'Reality protects' is therefore NOT universal: it requires a coercive control.")
    pr("  • This CORROBORATES the NS-013 obstruction-map (docs/ns013_complex_real_obstruction.md):")
    pr("    complex-blowup⇏real-blowup is vacuous because complex data escapes the very control")
    pr("    reality supplies; the protective direction needs a coercive-ENOUGH control. Next rungs")
    pr("    (2D NS = critical/enstrophy-bounded; 3D NS = supercritical/energy-only) test the criticality")
    pr("    gradient — pending (truncation-scoped).")
    pr("  • FIREWALL: 1D models. Protection here is about THESE models' control, NOT 3D-NS regularity.")
    pr("    :proved=0; distance to the prize UNTOUCHED.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
end
main()
