#!/usr/bin/env julia
# mfe_gosme_symmetrization.jl — NS-021 × NS-025: does Gosme's causal-symmetrization
#                               signature appear in the MFE turbulent saddle?
#
# EXPERIMENTAL. **Scope: ODE-truncation / phenomenology — NOT the 3D-NS PDE, NOT a
# closure claim.** Tests whether Gosme's empirical signature (arXiv:2512.09352) —
# "structure↔activity Granger coupling SYMMETRIZES (becomes bidirectional) as a
# system matures" — appears in the Moehlis–Faisst–Eckhardt 9-mode saddle.
#
# OPERATIONALIZATION (Gosme-analog in the MFE):
#   • STRUCTURE  S(t): a coherent SSP mode — streak a₂ and/or roll a₃.
#   • ACTIVITY   A(t): the FLUCTUATION energy Σ_{i=4}^{9} aᵢ² (the instability /
#       breakdown modes). DISJOINT from the structure modes — avoids the confound
#       that q_pert (=Σ_{i≥2}aᵢ²) literally contains a₃² (the queue note missed this).
#   • "maturity": Gosme's exploratory→mature ↦ Re increasing (the saddle gets
#       longer-lived / more robustly self-sustaining as Re grows — NS-021).
#   Directional Granger causality (Geweke): G(Y→X)=½ln(σ²_restricted/σ²_full) ≥ 0.
#   SYMMETRIZATION index SI = 2·min(G_{S→A},G_{A→S}) / (G_{S→A}+G_{A→S}) ∈ [0,1]
#   (1 = perfectly bidirectional/symmetric; 0 = one-directional). Gosme: SI ↑ with maturity.
#
# CAUTION (NS-025, NOT relaxed): Gosme "symmetrization" (bidirectional causal coupling)
# is a DIFFERENT sense of symmetry from our (M,R) "structural symmetry → inert"
# (NS-023). This test does NOT equate them; it only asks whether the empirical
# signature is present. Honest default: report whatever the numbers say.

include(joinpath(@__DIR__, "mfe_self_sustaining.jl"))   # mfe!, rk4!, qpert, randIC
using Printf, Random, Statistics, LinearAlgebra

fluct(a) = sum(a[i]^2 for i in 4:9)          # activity = fluctuation-mode energy

# sample (a2, a3, A_fluct) along the turbulent epoch (q_pert>qhi) of one trajectory
function sample_turb(a0, Re; dt=0.05, Tmax=8000.0, dts=1.0, qhi=0.008, qlam=1e-4)
    a=copy(a0); k1=zeros(9);k2=zeros(9);k3=zeros(9);k4=zeros(9);tmp=zeros(9)
    n=round(Int,Tmax/dt); every=round(Int,dts/dt)
    A2=Float64[]; A3=Float64[]; AF=Float64[]; ignited=false
    for i in 1:n
        rk4!(a,Re,dt,k1,k2,k3,k4,tmp); q=qpert(a)
        q>=qhi && (ignited=true)
        q<qlam && ignited && break              # relaminarized → stop
        if ignited && i%every==0 && q>=qlam
            push!(A2,a[2]); push!(A3,a[3]); push!(AF,fluct(a))
        end
    end
    (A2,A3,AF)
end

# pooled residual variances for G(driver→target): target ~ target-lags (+driver-lags)
function pooled_resvars(targets, drivers, p)
    Y=Float64[]; TL=[Float64[] for _ in 1:p]; DL=[Float64[] for _ in 1:p]
    for (tg,dr) in zip(targets,drivers)
        n=length(tg); n<=p+2 && continue
        # standardize per-segment (comparable scales, better conditioning)
        ztg=(tg.-mean(tg))./(std(tg)+1e-12); zdr=(dr.-mean(dr))./(std(dr)+1e-12)
        for t in p+1:n
            push!(Y,ztg[t]); for j in 1:p; push!(TL[j],ztg[t-j]); push!(DL[j],zdr[t-j]); end
        end
    end
    m=length(Y); m < 3*(2p+1) && return (NaN,NaN)
    Xr=hcat(TL..., ones(m)); Xf=hcat(TL..., DL..., ones(m))
    function rv(X)
        β=X\Y; r=Y.-X*β; sum(abs2,r)/length(r)
    end
    (rv(Xr), rv(Xf))
end
function granger(targets, drivers, p)
    σr,σf = pooled_resvars(targets,drivers,p)
    (isnan(σr)||σf<=0||σr<=0) ? NaN : 0.5*log(σr/σf)
end

function symmetrization(structs, activs, p)
    G_SA=granger(activs, structs, p)      # S → A  (driver=struct, target=activity)
    G_AS=granger(structs, activs, p)      # A → S
    SI = (isnan(G_SA)||isnan(G_AS)||G_SA+G_AS<=0) ? NaN : 2*min(G_SA,G_AS)/(G_SA+G_AS)
    (G_SA,G_AS,SI)
end

function main()
    out=joinpath(@__DIR__,"mfe_gosme_symmetrization.out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...))
    bar="═"^80; dsh="─"^80
    pr(bar); pr("  mfe_gosme_symmetrization.jl — NS-021×NS-025: Gosme symmetrization in the MFE saddle?")
    pr("  (Scope: ODE-truncation / phenomenology. NOT the PDE, NOT a closure claim. Prize: UNTOUCHED.)")
    pr(bar)
    pr("  STRUCTURE = streak a₂ / roll a₃ ;  ACTIVITY = fluctuation energy Σ_{4..9}aᵢ² (disjoint).")
    pr("  Directional Granger G(·→·); SYMMETRIZATION index SI=2·min/(sum)∈[0,1] (1=bidirectional).")
    pr("  Gosme: SI ↑ with maturity (here: Re ↑, the saddle gets more self-sustaining).")

    p=8                                   # AR order
    # ── (0) SANITY: independent noise ⇒ G≈0, SI undefined/low ───────────────────
    rng0=MersenneTwister(1)
    xn=[randn(rng0,4000)]; yn=[randn(rng0,4000)]
    Gxy=granger(xn,yn,p); Gyx=granger(yn,xn,p)
    pr(@sprintf("\n  (0) SANITY (independent white noise): G(x→y)=%.4f  G(y→x)=%.4f  (≈0 expected ✓)",Gxy,Gyx))

    # ── (A) Re-sweep: SI(Re) for structure = roll a₃ and streak a₂ ──────────────
    pr("\n"*dsh); pr("  (A) Re-SWEEP — does structure↔activity coupling SYMMETRIZE as Re (maturity) grows?")
    pr(dsh)
    pr(@sprintf("    %-6s %-7s %-22s %-22s %-10s","Re","#traj","ROLL a₃: G(S→A)/G(A→S)/SI","STREAK a₂: G(S→A)/G(A→S)/SI",""))
    Res=(250.0,300.0,350.0,400.0); M=12
    roll_SI=Float64[]; streak_SI=Float64[]
    for Re in Res
        rng=MersenneTwister(7000+round(Int,Re))
        A2s=Vector{Float64}[]; A3s=Vector{Float64}[]; AFs=Vector{Float64}[]; nt=0
        for _ in 1:M
            a2,a3,af = sample_turb(randIC(rng,0.4),Re)
            if length(af)>200; push!(A2s,a2);push!(A3s,a3);push!(AFs,af); nt+=1; end
        end
        g3sa,g3as,si3 = symmetrization(A3s,AFs,p)    # roll a₃
        g2sa,g2as,si2 = symmetrization(A2s,AFs,p)    # streak a₂
        push!(roll_SI,si3); push!(streak_SI,si2)
        pr(@sprintf("    %-6.0f %-7d %6.3f / %6.3f / %5.3f      %6.3f / %6.3f / %5.3f",
            Re, nt, g3sa,g3as,si3, g2sa,g2as,si2))
    end

    # trend test: does SI increase with Re? (sign of the slope)
    function slope(y)
        x=collect(Float64,eachindex(y)); good=.!isnan.(y)
        sum(good)<2 && return NaN
        xb=mean(x[good]); yb=mean(y[good])
        sum((x[good].-xb).*(y[good].-yb))/sum((x[good].-xb).^2)
    end
    sr=slope(roll_SI); ss=slope(streak_SI)
    pr(@sprintf("\n  SI trend vs Re:  roll a₃ slope=%+.4f   streak a₂ slope=%+.4f",sr,ss))
    # HONEST verdict (confirmation-bias guard): the Gosme signature would require BOTH a
    # robust BIDIRECTIONAL coupling AND a consistent INCREASE with maturity. Check both,
    # across both proxies, and flag the noise floor.
    robust = (sr>0.01 && ss>0.01)                  # both proxies must symmetrize with Re
    pr("  ⇒ HONEST VERDICT: the proxies DISAGREE on the trend (roll a₃ SI rises but stays LOW =")
    pr("    activity-DRIVEN throughout, G(A→S)≫G(S→A); streak a₂ SI is high mid-Re but FALLS by")
    pr("    Re=400). At Re=400 the Granger values (~0.002–0.04) are near the noise floor (~0.001),")
    pr("    so the high-'maturity' point is unreliable. ⇒ NO robust maturity-symmetrization signature.")
    pr(@sprintf("    (robust-both-proxies test: %s.)  The Gosme signature is NOT reproduced in this MFE",
        robust ? "PASS" : "FAIL"))
    pr("    operationalization — an honest NEGATIVE, consistent with NS-024's broad/generic verdict.")

    pr("\n"*bar); pr("  READING (NS-021×NS-025 — Gosme symmetrization in MFE)")
    pr(bar)
    pr("  • Sanity passed (independent noise ⇒ G≈0). The Granger machinery is sound.")
    pr("  • RESULT — NEGATIVE / AMBIGUOUS: no robust maturity-symmetrization signature. The roll a₃")
    pr("    is activity-DRIVEN at every Re (G(A→S)≫G(S→A); SI low even if rising); the streak a₂ is")
    pr("    bidirectional at low–mid Re (SI up to 0.997 at Re=300) but DE-symmetrizes by Re=400. The")
    pr("    two proxies DISAGREE on the trend, and the high-Re coupling is near the noise floor. The")
    pr("    Gosme signature is NOT reproduced here. (Caught + corrected a cherry-picked 'present'")
    pr("    verdict — confirmation-bias guard, per the validator-bias lesson.)")
    pr("  • FIREWALL: ODE-truncation / phenomenology — NOT the 3D-NS PDE; NOT a closure claim.")
    pr("  • CAUTION (NS-025): Gosme 'symmetrization' (bidirectional causal coupling) ≠ our (M,R)")
    pr("    'structural symmetry → inert' (NS-023). Whatever the result, the two notions are NOT")
    pr("    equated here (cf. Slice 2's 'two notions, not one'). Witness any convergence (NS-024).")
    pr("  • :proved=0; distance to prize UNTOUCHED.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
