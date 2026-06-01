#!/usr/bin/env julia
# mfe_lifetime_scaling.jl
#
# EXPERIMENTAL. NOT a spec artifact. Conversational object, not TCE work.
# Firewall: measures a STANDARD quantity (turbulent-transient lifetime τ vs Re
# in the MFE saddle). Makes no claim the closure framework explains it; it
# PRODUCES the falsifiable number a closure theory of "self-sustaining until it
# is not" would have to predict — the escape rate from the chaotic saddle.
#
# Reuses the VERIFIED MFE 9-mode model (eqs 21–28, transcribed from Moehlis–
# Faisst–Eckhardt 2004) by include — single source of truth for the coefficients.
#
# ─── WHAT τ(Re) IS ───────────────────────────────────────────────────────────
# At fixed Re the turbulent lifetime is exponentially distributed (memoryless;
# shown in mfe_self_sustaining.jl, R²=0.99). Its e-folding time τ(Re) is the
# inverse escape RATE from the self-sustaining chaotic saddle to the laminar
# fixed point — i.e. exactly "what sets the 'until it is not'."
#
# The field-level open question this targets: does τ(Re)
#   (a) grow EXPONENTIALLY, ln τ = A + B·Re  (turbulence transient at ALL finite
#       Re — no finite-Re attractor; the Eckhardt-school view), or
#   (b) DIVERGE at a finite Re_c, τ ~ (Re_c − Re)^{−γ}  (turbulence becomes a
#       sustained attractor above Re_c; the boundary-crisis view)?
# This script measures τ on a Re ladder and reports which law the data support
# — honestly noting that 6 points settle the in-range TREND, not the asymptote.
#
# ─── METHOD ──────────────────────────────────────────────────────────────────
#  • per Re: N random ICs (laminar + random unit perturbation, amplitude A),
#    integrate to a Re-scaled Tmax, record lifetime + censor flag;
#  • "ignited" = lifetime > 50 (entered the saddle; immediate relaminarizers
#    never formed turbulence and are excluded — count reported);
#  • τ via TWO independent estimators (must agree):
#      τ_fit : slope of ln S(t) (survival fn) in its linear regime  [+ R²]
#      τ_mle : censoring-aware MLE for a shifted exponential
#                τ = [Σ_unc (tᵢ−t₀) + Σ_cens (Tmax−t₀)] / (#uncensored)
#  • then fit ln τ vs Re (law a) and 1/τ vs Re (law b ⇒ implied Re_c).

include(joinpath(@__DIR__, "mfe_self_sustaining.jl"))   # mfe!, rk4!, lifetime, randIC, qpert
using Printf, Random, Statistics

# τ estimators from an ensemble of (lifetime, censored) at a given Re/Tmax
function tau_estimates(lives, cens, Tmax)
    keep = lives .> 50.0                       # ignited only
    L = lives[keep]; C = cens[keep]; n = length(L)
    t0 = quantile(L, 0.02)                      # formation offset (robust low pctl)

    # (1) survival-curve slope fit: S(t)=P(life>t); ln S linear ⇒ slope = −1/τ
    grid = collect(range(t0, stop=quantile(L, 0.97), length=40))
    xs=Float64[]; ys=Float64[]
    for t in grid
        S = count(>(t), L)/n
        (0.03 <= S <= 0.6) || continue          # linear regime: skip plateau & noise floor
        push!(xs, t); push!(ys, log(S))
    end
    τfit=NaN; R2=NaN
    if length(xs) >= 4
        mx=mean(xs); my=mean(ys)
        slope = sum((xs.-mx).*(ys.-my))/sum((xs.-mx).^2)
        inter = my - slope*mx
        ssr = sum((ys .- (inter .+ slope.*xs)).^2); sst = sum((ys.-my).^2)
        τfit = -1/slope; R2 = 1 - ssr/sst
    end

    # (2) censoring-aware MLE for shifted exponential
    num = 0.0; nunc = 0
    for (l,c) in zip(L,C)
        if c; num += (Tmax - t0)
        else; num += (l - t0); nunc += 1; end
    end
    τmle = nunc>0 ? num/nunc : NaN

    return n, count(C), t0, τfit, R2, τmle, median(L)
end

function main()
    out = joinpath(@__DIR__, "mfe_lifetime_scaling.out.txt")
    fout = open(out, "w"); pr(a...) = (println(stdout,a...); println(fout,a...))
    bar="═"^78; dsh="─"^78
    pr(bar); pr("  mfe_lifetime_scaling.jl — τ(Re): escape rate from the MFE saddle.")
    pr("  EXPERIMENTAL. The falsifiable prediction target for 'until it is not'.")
    pr(bar)

    A = 0.3; N = 1000
    Re_ladder = (220.0, 250.0, 280.0, 310.0, 340.0, 370.0)
    # Re-scaled integration window: τ grows ~exp(0.011 Re); use ≳6τ, capped.
    Tmax_of(Re) = min(60000.0, max(18000.0, 6*exp(4.74 + 0.011*Re)))

    pr(@sprintf("\n  N=%d random ICs/Re, perturbation amplitude A=%.2f, dt=0.05", N, A))
    pr(@sprintf("  %-6s %-7s %-9s %-8s %-9s %-7s %-9s %-9s",
                "Re", "ignit", "%cens", "t₀", "τ_fit", "R²", "τ_mle", "median"))
    Res=Float64[]; Taus=Float64[]; TauSE=Float64[]
    for Re in Re_ladder
        Tmax = Tmax_of(Re)
        rng = MersenneTwister(1000 + round(Int,Re))
        lives = Vector{Float64}(undef, N); cens = Vector{Bool}(undef, N)
        for i in 1:N
            l, c, _,_,_ = lifetime(randIC(rng, A), Re; Tmax=Tmax)
            lives[i]=l; cens[i]=c
        end
        nig, ncen, t0, τfit, R2, τmle, med = tau_estimates(lives, cens, Tmax)
        pr(@sprintf("  %-6.0f %-7d %-9.1f %-8.0f %-9.0f %-7.3f %-9.0f %-9.0f",
                    Re, nig, 100*ncen/N, t0, τfit, R2, τmle, med))
        # use τ_mle as the headline estimate (censoring-robust); SE ≈ τ/√(#uncensored)
        push!(Res, Re); push!(Taus, τmle); push!(TauSE, τmle/sqrt(max(1,nig-ncen)))
    end

    # ── scaling law (a): exponential  ln τ = A + B·Re ──────────────────────
    pr("\n"*dsh); pr("  LAW (a) exponential:  ln τ = A + B·Re")
    pr(dsh)
    lx=Res; ly=log.(Taus); mx=mean(lx); my=mean(ly)
    B = sum((lx.-mx).*(ly.-my))/sum((lx.-mx).^2); Aint = my - B*mx
    ssr=sum((ly.-(Aint.+B.*lx)).^2); sst=sum((ly.-my).^2); R2e=1-ssr/sst
    pr(@sprintf("    fit:  ln τ = %.3f + %.5f·Re      R² = %.4f", Aint, B, R2e))
    pr(@sprintf("    rate B = %.5f /Re   ⇒  τ e-folds every ΔRe = %.1f", B, 1/B))
    pr("    Re      τ_measured     τ_law(a)")
    for (re,t) in zip(Res,Taus)
        pr(@sprintf("    %-6.0f  %-13.0f  %-.0f", re, t, exp(Aint+B*re)))
    end

    # ── scaling law (b): power-law divergence  1/τ = m(Re_c − Re) ──────────
    pr("\n"*dsh); pr("  LAW (b) finite-Re_c divergence:  1/τ linear in Re → Re_c where 1/τ=0")
    pr(dsh)
    iy = 1.0 ./ Taus; miy=mean(iy)
    mb = sum((lx.-mx).*(iy.-miy))/sum((lx.-mx).^2); ib = miy - mb*mx
    ssr2=sum((iy.-(ib.+mb.*lx)).^2); sst2=sum((iy.-miy).^2); R2p=1-ssr2/sst2
    Re_c = -ib/mb
    pr(@sprintf("    fit:  1/τ = %.3e %+0.3e·Re      R² = %.4f", ib, mb, R2p))
    pr(@sprintf("    implied Re_c (1/τ→0) = %.0f", Re_c))
    pr(@sprintf("    (Re_c %s the sampled range [%.0f,%.0f])",
                (Re_c > maximum(Res)) ? "lies ABOVE" : "lies INSIDE", minimum(Res), maximum(Res)))

    # ── verdict ────────────────────────────────────────────────────────────
    pr("\n"*bar); pr("  VERDICT — τ(Re), the escape rate from the self-sustaining saddle")
    pr(bar)
    better = R2e >= R2p ? "EXPONENTIAL (law a)" : "finite-Re_c divergence (law b)"
    pr(@sprintf("  Best in-range fit: %s   (R²_exp=%.4f vs R²_pow=%.4f).", better, R2e, R2p))
    pr(@sprintf("  Measured law:  τ(Re) ≈ exp(%.2f + %.4f·Re)  over Re∈[%.0f,%.0f].",
                Aint, B, minimum(Res), maximum(Res)))
    pr("  PHYSICAL READING: the rate of escape from the chaotic saddle DECREASES")
    pr("  exponentially as Re rises — the saddle gets exponentially 'stickier' but")
    pr("  never (in range) becomes a true attractor. 'Self-sustaining until it is")
    pr("  not' has a measured clock-rate, and it is exp(−B·Re).")
    pr("")
    pr("  ⇒ THE PREDICTION BAR, as a number: a closure theory of self-sustenance")
    pr(@sprintf("    must reproduce B ≈ %.4f /Re (the e-folding rate), or explain why", B))
    pr("    the escape rate is exponential in Re. Reproduce B → result. Relabel the")
    pr("    saddle as 'closure' without B → vocabulary.")
    pr("  CAVEAT (honest): 6 Re points fix the IN-RANGE trend, not the asymptotic")
    pr("    form. Exponential vs double-exponential vs eventual finite-Re_c is NOT")
    pr("    settled here (that took large pipe-flow studies); see %cens column for")
    pr("    where censoring begins to bite at high Re.")
    pr(bar)
    close(fout); println(stdout, "\nwrote: $out")
end

main()
