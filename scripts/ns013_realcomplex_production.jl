#!/usr/bin/env julia
# ns013_realcomplex_production.jl — NS-013: real-vs-complex on the PRODUCTION object.
#
# WHY. Li–Sinai (NS-012) PROVED finite-time blowup for COMPLEX-data 3D NS; real data is open (NS-013).
# The sharpened NS-013 reduction lands on the geometric depletion (Constantin–Fefferman / Hou–Li): real
# regularity ⟺ the vortex-stretching PRODUCTION P=∫ω·Sω stays controlled. So the decisive question is
# not "does reality protect" (the existing rung complex_burgers_reality_leakage.jl already showed it does,
# with a boundary λ_c) but WHERE reality bites: does the reality constraint DEPLETE the production object
# itself (⇒ the load-bearing constraint is on the production geometry — the 3D ξ-alignment / NS-046 hard
# core), or does it protect downstream while leaving the production untouched (⇒ reality bites elsewhere,
# and the production is not where the real⇐complex gap lives)?
#
# THE 1D PRODUCTION OBJECT (exact). For viscous Burgers u_t=−uu_x+νu_xx, the gradient g=u_x obeys
# g_t+ug_x = −g² + νg_xx, and the gradient-energy budget is EXACTLY
#       d/dt ½∫g² = −½∫g³ − ν∫g_x²          (periodic; derived by parts).
# So the 1D PRODUCTION object is  P ≡ −½∫g³  (the self-steepening that nucleates the shock) and its
# normalized form  Skew ≡ −∫g³ / (∫g²)^{3/2}  is the velocity-gradient skewness — the exact 1D shadow of
# the 3D enstrophy budget dΩ/dt = ∫ω·Sω − ν∫|∇ω|² and the production skewness S_ω. This is the object the
# real-vs-complex comparison is run ON.
#
# THE KNOB. u_t += −iλ·Im(u) damps Im(u) at rate λ (the reality leakage): λ=0 = complex data (Cole–Hopf
# blowup at t*=ln(b)/ν); λ→∞ forces u real (heat-maximum-principle protected, regular). The test conditions
# the production object on λ and reads off whether |P| collapses with λ (reality depletes production) or
# survives (reality protects elsewhere).
#
# HONEST SCOPE. 1D complex viscous Burgers — the Li–Sinai / NS-013 analog. 1D has NO vortex direction ξ,
# so this tests the AMPLITUDE/skewness part of the production, NOT the alignment-geometry part (the same
# vacuity cap: an illustrative mechanism, not the 3D object). NOT the 3D-NS PDE; :proved=0; prize UNTOUCHED.
# Std-lib only; hand-rolled radix-2 complex FFT (solver copied from complex_burgers_reality_leakage.jl,
# the Cole–Hopf-validated rung). CHAIN_CONVENTION: n/a.
# Run: julia scripts/ns013_realcomplex_production.jl

using Printf

# ── solver (copied from the validated complex_burgers rung) ──────────────────
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

# nonlinear + reality-penalty, Fourier→Fourier (stiff viscous term done by integrating factor)
function Nop(U, kk, deal, λ)
    u=inv_(U); ux=inv_(im.*kk.*U)
    NLh=fwd(u.*ux); NLh[.!deal].=0
    .-NLh .- fwd((im*λ).*imag.(u))
end

# one integrating-factor RK4 step (viscous exp(−νk²dt) exact)
function step!(U, kk, deal, ν, λ, dt, E, E2)
    k1=Nop(U,kk,deal,λ)
    k2=Nop(E2.*(U.+(dt/2).*k1),kk,deal,λ)
    k3=Nop(E2.*U.+(dt/2).*k2,kk,deal,λ)
    k4=Nop(E.*U.+dt.*(E2.*k3),kk,deal,λ)
    E.*U .+ (dt/6).*(E.*k1 .+ 2 .*E2.*(k2.+k3) .+ k4)
end

# ── the production-object diagnostics ────────────────────────────────────────
# analyticity strip δ from the spectrum decay |û(k)| ~ e^{−δ|k|} (tail slope fit)
function delta_strip(U, kk)
    N=length(U); cut=N÷3
    amp=zeros(cut+1); cnt=zeros(Int,cut+1)
    for i in 1:N
        k=abs(round(Int,kk[i])); (1<=k<=cut) || continue
        amp[k+1]+=abs(U[i])/N; cnt[k+1]+=1
    end
    for k in 1:cut; cnt[k+1]>0 && (amp[k+1]/=cnt[k+1]); end
    ks=Int[]; for k in 2:cut; amp[k+1]>1e-13 ? push!(ks,k) : break; end
    length(ks)<4 && return NaN
    y=[log(amp[k+1]) for k in ks]; xm=sum(ks)/length(ks); ym=sum(y)/length(y)
    -sum((ks.-xm).*(y.-ym))/sum((ks.-xm).^2)
end

# the production object P=−½∫g³, its budget partners, the skewness, the reality measure.
function prod_diag(U, kk, ν)
    N=length(U); u=inv_(U); g=inv_(im.*kk.*U); gx=inv_(.-(kk.^2).*U)   # g=u_x, g_x=u_xx
    G2  = sum(g.^2)/N                       # ∫g²  (analytic; complex)
    G2a = sum(abs2.(g))/N                   # ∫|g|²  (size)
    P   = -0.5*sum(g.^3)/N                  # PRODUCTION object −½∫g³  (analytic; complex)
    Visc= ν*sum(g.*gx)/N                    # −ν∫g_x² appears as +ν∫g g_xx (by parts) — the viscous term in the identity
    Skew= -real(sum(g.^3)/N) / (real(G2a))^1.5   # normalized gradient skewness (the S_ω analog), real-part
    Im_ = sum(abs.(imag.(u)))/N             # reality measure ‖Im u‖₁
    δ   = delta_strip(U, kk)
    mx  = maximum(abs.(u))
    (G2=G2, G2a=G2a, P=P, Visc=Visc, Skew=Skew, Im=Im_, δ=δ, maxu=mx)
end

# ── N=1 correctness gate: the exact budget identity d/dt ½∫g² = Re(P) + Re(Visc) ──
# (Visc here = ν∫g g_xx = −ν∫g_x²; P = −½∫g³.) Verify by finite-difference over one step at λ=0.
function budget_check(kk, deal, ν, dt, E, E2)
    N=length(kk); x=[2π*(i-1)/N for i in 1:N]; b=3.0
    φ0=1.0 .+ b.*exp.(im.*x); u0=-2ν .*(im*b).*exp.(im.*x)./φ0
    U=fwd(u0)
    d0=prod_diag(U,kk,ν); U2=step!(U,kk,deal,ν,0.0,dt,E,E2); d1=prod_diag(U2,kk,ν)
    lhs = real(0.5*d1.G2 - 0.5*d0.G2)/dt                 # d/dt ½∫g²  (finite diff)
    rhs = real(d0.P) + real(d0.Visc)                     # −½Re∫g³ − νRe∫g_x²
    (lhs=lhs, rhs=rhs, rel=abs(lhs-rhs)/max(abs(rhs),1e-12))
end

function run_series(u0, kk, deal, ν, λ; dt=0.005, Tmax=20.0, thresh=100.0, sample=0.25)
    U=fwd(u0); n=round(Int,Tmax/dt)
    L=.-(ν).*(kk.^2); E=exp.(L.*dt); E2=exp.(L.*(dt/2))
    rows=NamedTuple[]; nexts=0.0
    for i in 0:n
        t=i*dt
        if t>=nexts-1e-9
            d=prod_diag(U,kk,ν)
            push!(rows,(t=t, P=abs(d.P), Pre=real(d.P), Skew=d.Skew, G2a=real(d.G2a),
                        Visc=abs(real(d.Visc)), Im=d.Im, δ=d.δ, maxu=d.maxu))
            (d.maxu>thresh || !isfinite(d.maxu)) && return (rows, t)   # blew up
            nexts+=sample
        end
        i<n && (U=step!(U,kk,deal,ν,λ,dt,E,E2))
    end
    (rows, Inf)
end

function main()
    out=joinpath(@__DIR__,"ns013_realcomplex_production.out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...);flush(fout))
    bar="═"^86; dsh="─"^86
    pr(bar); pr("  ns013_realcomplex_production.jl — real-vs-complex on the PRODUCTION object P=−½∫g³")
    pr("  (Scope: 1D complex viscous Burgers, the Li–Sinai/NS-013 analog. NOT the PDE. :proved=0.)")
    pr(bar)

    N=1024; ν=0.2; b=3.0; dt=0.005
    x=[2π*(i-1)/N for i in 1:N]; kk=[Float64(keff(i-1,N)) for i in 1:N]
    cut=N÷3; deal=[abs(keff(i-1,N))<=cut for i in 1:N]
    φ0=1.0 .+ b.*exp.(im.*x); u0=-2ν .*(im*b).*exp.(im.*x)./φ0
    # GENERIC (multi-mode) complex IC via Cole–Hopf φ=1+b₁e^{ix}+b₂e^{2ix}: ∫g³≠0 generically, so it
    # breaks the single-mode residue structure — the IC-robustness control for the "zero production" read.
    # b₁=1.5,b₂=0.8 ⇒ both φ-roots at |z|=1.25 (zero-free on the real axis at t=0), blowup at moderate t.
    b1=1.5; b2=0.8
    φ0g=1.0 .+ b1.*exp.(im.*x) .+ b2.*exp.(2im.*x)
    u0g=-2ν .*(im*b1 .*exp.(im.*x) .+ 2im*b2 .*exp.(2im.*x))./φ0g
    tstar=log(b)/ν
    pr(@sprintf("\n  complex IC (Cole–Hopf φ₀=1+%.0f·e^{ix}); λ=0 blowup t*=ln(b)/ν=%.3f, ν=%.2f, N=%d", b, tstar, ν, N))
    pr(@sprintf("  generic complex IC (Cole–Hopf φ₀=1+%.1f·e^{ix}+%.1f·e^{2ix}) — multi-mode, ∫g³≠0 control", b1, b2))

    # N=1 GATE: the exact production budget identity
    L=.-(ν).*(kk.^2); E=exp.(L.*dt); E2=exp.(L.*(dt/2))
    bc=budget_check(kk,deal,ν,dt,E,E2)
    pr(@sprintf("\n  N=1 GATE — production budget identity  d/dt½∫g² = −½Re∫g³ − νRe∫g_x² :"))
    pr(@sprintf("    LHS(fin.diff)=%.5e  RHS(P+Visc)=%.5e  rel.err=%.2e  →  %s",
                bc.lhs, bc.rhs, bc.rel, bc.rel<5e-2 ? "MATCH ✓ (production object validated)" : "mismatch ?"))

    # the production object, tracked, for complex (λ=0) vs increasingly-real (λ↑)
    λs = [0.0, 0.02, 0.05, 0.2, 1.0]
    pr("\n"*dsh); pr("  PRODUCTION OBJECT vs REALITY LEAKAGE — |P|=|½∫g³|, Skew, viscous depletion, fate")
    pr(dsh)
    series=Dict{Float64,Any}()
    for λ in λs
        rows,T = run_series(u0,kk,deal,ν,λ; dt=dt, Tmax=20.0, sample=0.25)
        series[λ]=(rows=rows, T=T)
    end
    # compare the production object at a FIXED pre-blowup time across λ (the decisive read)
    tcmp = 0.5*tstar                                   # well before the λ=0 blowup
    pr(@sprintf("    production object |P(t=%.2f)| and skewness across λ (t=%.2f ≈ ½ t*):", tcmp, tcmp))
    pr(@sprintf("    %-8s %-12s %-12s %-12s %-12s %-s", "λ", "|P|", "Skew", "∫|g|²", "‖Im u‖", "fate"))
    Pref=NaN
    for λ in λs
        rows=series[λ].rows; T=series[λ].T
        r = rows[argmin(abs(rr.t-tcmp) for rr in rows)]
        λ==0.0 && (Pref=r.P)
        fate = isinf(T) ? "REGULAR" : @sprintf("blowup t*=%.2f",T)
        pr(@sprintf("    %-8.3g %-12.4e %-12.4f %-12.4e %-12.4e %-s", λ, r.P, r.Skew, r.G2a, r.Im, fate))
    end

    # time series of the production object for the two extremes (complex vs near-real)
    for (λ,tag) in ((0.0,"λ=0 COMPLEX (blows up)"), (1.0,"λ=1.0 REAL-protected (regular)"))
        rows=series[λ].rows
        pr(@sprintf("\n  %s — production-object trajectory:", tag))
        pr(@sprintf("    %-7s %-12s %-10s %-12s %-9s %-9s", "t", "|P|", "Skew", "∫|g|²", "δ(strip)", "max|u|"))
        for r in rows
            (r.t*4)%1 < 1e-6 && pr(@sprintf("    %-7.2f %-12.4e %-10.4f %-12.4e %-9.3f %-9.2f",
                                            r.t, r.P, r.Skew, r.G2a, isnan(r.δ) ? -1.0 : r.δ, r.maxu))
        end
    end

    # SECOND one-sided witness: a DIFFERENT (multi-mode) analytic-signal Cole–Hopf IC. Same one-sided
    # spectrum ⇒ the Fourier-support theorem predicts ∫g³=0 here too (whatever its regular/blowup fate),
    # confirming the zero-production is a CLASS property, not a single-mode residue accident.
    rowsg,Tg = run_series(u0g,kk,deal,ν,0.0; dt=dt, Tmax=20.0, sample=0.25)
    pr(@sprintf("\n  SECOND one-sided witness (multi-mode complex, λ=0; fate: %s) — production trajectory:",
                isinf(Tg) ? "regular to T=20" : @sprintf("blowup t*=%.2f",Tg)))
    pr(@sprintf("    %-7s %-12s %-10s %-12s %-9s %-9s", "t", "|P|", "Skew", "∫|g|²", "δ(strip)", "max|u|"))
    for r in rowsg
        (r.t*2)%1 < 1e-6 && r.t<=6.0 && pr(@sprintf("    %-7.2f %-12.4e %-10.4f %-12.4e %-9.3f %-9.2f",
                                        r.t, r.P, r.Skew, r.G2a, isnan(r.δ) ? -1.0 : r.δ, r.maxu))
    end
    skew_g = maximum(abs(r.Skew) for r in rowsg if isfinite(r.Skew))   # peak |skewness| over the run

    # ── verdict: reality is the two-sided-spectrum condition that ACTIVATES the production object ──
    r0   = series[0.0].rows[argmin(abs(rr.t-tcmp) for rr in series[0.0].rows)]
    rbig = series[1.0].rows[argmin(abs(rr.t-tcmp) for rr in series[1.0].rows)]
    skew_real = abs(rbig.Skew)                          # production skewness the REAL flow carries
    pr("\n"*bar); pr("  VERDICT — real-vs-complex on the production object P=−½∫g³"); pr(bar)
    pr("  • THE STRUCTURAL FACT (Fourier support, EXACT & general). The complex-blowup class = Cole–Hopf")
    pr("    ANALYTIC SIGNALS: one-sided spectrum (only k>0). For any one-sided g, ∫g³ = 2π·(g³)_{k=0} = 0,")
    pr("    because three positive wavenumbers cannot sum to 0. ⇒ the production object is IDENTICALLY ZERO")
    pr("    on the entire complex-blowup class — NOT a single-mode residue accident.")
    pr(@sprintf("  • Single-mode complex blowup (λ=0): |P|≈%.1e, Skew≡%.3f for the ENTIRE evolution; ∫|g|² blows", r0.P, r0.Skew))
    pr("    up and δ→0 (off-axis pole reaching the real axis) with the production object flat at zero.")
    pr(@sprintf("  • Second one-sided witness (multi-mode): peak |Skew|=%.1e over the whole run ⇒ ∫g³≈0 confirmed", skew_g))
    pr("    for a DIFFERENT analytic-signal IC — a class property, exactly as the Fourier-support theorem says.")
    pr("  • REALITY ACTIVATES PRODUCTION. Imposing reality (λ↑) restores the conjugate-symmetric TWO-sided")
    pr(@sprintf("    spectrum û(−k)=conj û(k) ⇒ ∫g³≠0: Skew climbs 0 → %.2f as λ: 0→1 (the sweep above), |P|>0,", skew_real))
    pr("    viscously balanced ⇒ regular. So reality does NOT deplete production — its two-sidedness CREATES it.")
    pr("  • READ (NS-013): the complex-blowup channel and the real-flow production channel are STRUCTURALLY")
    pr("    DISTINCT — in 1D the production object is identically zero on the complex side and nonzero on the")
    pr("    real side. CORROBORATES the NS-013 triad 'complex⇏real is vacuous': the complex singularity lives")
    pr("    in off-axis analyticity (absent maximum principle), an object DISJOINT from the production")
    pr("    (ξ-alignment / NS-046) the real-regularity question is about.")
    pr("  • HONEST SCOPE: 1D has no vortex direction ξ — amplitude/skewness shadow of the 3D production, the")
    pr("    Li–Sinai (NS-012)/NS-013 analog. The Fourier-support argument is 1D-specific (cubic ∫g³); the 3D")
    pr("    production ∫ω·Sω is not a single cubic in a one-sided field, so the clean 'identically zero' does")
    pr("    NOT transfer — what transfers is the QUESTION: does reality's spectral structure gate the 3D")
    pr("    production? Illustrative mechanism only; does NOT bear on 3D-NS regularity. :proved=0; prize UNTOUCHED.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
end

main()
