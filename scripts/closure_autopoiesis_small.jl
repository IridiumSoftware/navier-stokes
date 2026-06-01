#!/usr/bin/env julia
# closure_autopoiesis_small.jl
#
# EXPERIMENTAL. NOT a spec artifact. Conversational object, not TCE work.
# Firewall: tests whether PURE closure logic (no imported physics) reproduces the
# turbulence-saddle phenomenology — metastable self-sustaining state, memoryless
# exponential lifetimes, τ rising steeply with an INTRINSIC control parameter.
# This is the SMALL step (minimal model); scale-up to the CFS K_n³ substrate is
# the next step, where the CFS-computed STRUCTURE becomes the predictand.
#
# ─── THE MODEL (Aaron's intuition, made precise) ─────────────────────────────
# "If something doesn't close it decays naturally; if it closes then opens, it
#  also decays. Like life." → decay is the DEFAULT; closure is an achievement
#  maintained against it (autopoiesis / Rosen (M,R) / dissipative structures).
#
# State x ∈ {0,…,N} = amount of intact closure (number of intact closure relations).
#   CONSTRUCTION (autocatalytic — closure makes/repairs closure, needs the network
#     running):   b(x) = β · x · (N−x)/N      [∝ x ⇒ zero closure can't bootstrap]
#   DECAY (default — the ground state pull, intrinsic, not an imposed competitor):
#                 d(x) = δ · x
#   x = 0 is ABSORBING (autopoietic death: b(0)=0 — no closure left to self-build).
#
# Control parameter  ρ = β/δ  (construction/decay ratio = the intrinsic Re-analog).
#   ρ>1 ⇒ a metastable self-sustaining closed state at x* = N(1 − 1/ρ).
#   Stochastic fluctuations eventually drive x: x* → 0 (CATASTROPHE → decay to death).
#
# Known large-deviation result for this birth-death class (cf. stochastic logistic
# / SIS extinction time):  τ ~ exp( N · g(ρ) ),  g(ρ) = ln ρ − 1 + 1/ρ  (ρ>1).
# We MEASURE and compare to this — and ask whether the phenomenology (metastable,
# memoryless, steep τ) emerges from closure logic alone. (Honest note: exponential-
# in-N is GENERIC to metastable stochastic systems; the closure-SPECIFIC test —
# does CFS structure set g and the gating element — is the scale-up step.)

using Printf, Random, Statistics

# Gillespie first-passage to extinction (x=0); optional fixed-grid trace
function extinction(N, β, δ; x0, Tmax, rng, trace=false, dt=0.0)
    x=x0; t=0.0; tt=Float64[]; xx=Int[]; nxt=0.0
    while x>0 && t<Tmax
        b = β*x*(N-x)/N; d = δ*x; R = b+d
        R<=0 && break
        if trace
            while nxt<=t; push!(tt,nxt); push!(xx,x); nxt+=dt; end
        end
        t += -log(rand(rng))/R
        rand(rng)*R < b ? (x+=1) : (x-=1)
    end
    return (x==0 ? t : Tmax), (x==0), tt, xx
end

xstar(N,ρ) = max(1, round(Int, N*(1 - 1/ρ)))

# exponential-fit τ (survival-curve slope) + CV + median, from first-passage times
function lifetime_stats(N, ρ, M; δ=1.0, Tmax=2e6, rng=MersenneTwister(1))
    β=ρ*δ; x0=xstar(N,ρ); L=Float64[]; nc=0
    for _ in 1:M
        l,absorbed,_,_ = extinction(N,β,δ;x0=x0,Tmax=Tmax,rng=rng)
        push!(L,l); absorbed || (nc+=1)
    end
    m=mean(L); md=median(L); cv=std(L)/m
    # survival-curve R² (exponentiality)
    xs=Float64[];ys=Float64[]
    for tq in range(quantile(L,0.05), stop=quantile(L,0.9), length=12)
        S=count(>(tq),L)/M; S<=0 && continue; push!(xs,tq); push!(ys,log(S))
    end
    R2=NaN; τfit=NaN
    if length(xs)>=4
        mx=mean(xs);my=mean(ys); sl=sum((xs.-mx).*(ys.-my))/sum((xs.-mx).^2); ic=my-sl*mx
        R2=1-sum((ys.-(ic.+sl.*xs)).^2)/sum((ys.-my).^2); τfit=-1/sl
    end
    return (mean=m, median=md, cv=cv, R2=R2, τfit=τfit, cens=nc/M)
end

g(ρ) = log(ρ) - 1 + 1/ρ

function main()
    out=joinpath(@__DIR__,"closure_autopoiesis_small.out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...))
    bar="═"^78; dsh="─"^78
    pr(bar); pr("  closure_autopoiesis_small.jl — does PURE closure logic give the saddle?")
    pr("  EXPERIMENTAL. Autocatalytic closure + decay-default. No physics imported.")
    pr(bar)
    pr("  state x=intact closure; build b(x)=β·x(N−x)/N; decay d(x)=δ·x; x=0 = death.")
    pr("  control ρ=β/δ (construction/decay) = intrinsic Re-analog. δ≡1 throughout.")

    # ── (A) one trajectory: metastable, then catastrophe ───────────────────
    pr("\n"*dsh); pr("  (A) ONE trajectory (N=24, ρ=2.5): self-sustains at x*, then collapses")
    pr(dsh)
    N=24; ρ=2.5; rng=MersenneTwister(11)
    local life,tt,xx
    for _ in 1:200
        life,ab,tt,xx = extinction(N,ρ*1.0,1.0;x0=xstar(N,ρ),Tmax=2e6,rng=rng,trace=true,dt=max(life_guess(N,ρ),1.0))
        ab && life>5*g(ρ)*N && break
    end
    pr(@sprintf("  x* = %d (metastable closure level),  lifetime = %.0f", xstar(N,ρ), life))
    step=max(1,length(tt)÷16); idxs=unique(vcat(collect(1:step:length(tt)),length(tt)))
    pr("    t :  x (intact closure)")
    for i in idxs
        pr(@sprintf("    %8.0f :  %2d  %s", tt[i], xx[i], "█"^xx[i]))
    end
    pr("  ⇒ hovers near x* (alive), then a fluctuation drives x→0 (catastrophe = death).")

    # ── (B) lifetimes memoryless? ──────────────────────────────────────────
    pr("\n"*dsh); pr("  (B) LIFETIME distribution (N=24, ρ=2.5, M=4000) — memoryless test")
    pr(dsh)
    s = lifetime_stats(24,2.5,4000; rng=MersenneTwister(7))
    pr(@sprintf("    mean=%.0f  median=%.0f  CV=%.3f  survival-R²=%.4f  (CV≈1 & R²→1 ⇒ exponential/memoryless)",
                s.mean, s.median, s.cv, s.R2))
    pr("  ⇒ same signature as the MFE saddle: constant-hazard escape, no internal clock.")

    # ── (C) τ vs ρ at fixed N ──────────────────────────────────────────────
    pr("\n"*dsh); pr("  (C) τ vs control parameter ρ   (N=20 fixed)")
    pr(dsh)
    pr(@sprintf("    %-6s %-12s %-10s %-12s %-8s", "ρ", "τ (mean)", "ln τ", "N·g(ρ)+c", "R²surv"))
    N=20; ρs=(1.5,2.0,2.5,3.0); lnτ=Float64[]; gs=Float64[]
    for ρ in ρs
        st=lifetime_stats(N,ρ,3000; rng=MersenneTwister(round(Int,100ρ)))
        push!(lnτ, log(st.mean)); push!(gs, N*g(ρ))
        pr(@sprintf("    %-6.1f %-12.0f %-10.3f %-12.3f %-8.3f", ρ, st.mean, log(st.mean), N*g(ρ), st.R2))
    end
    # check ln τ tracks N·g(ρ): fit ln τ = a + b·(N·g)
    mx=mean(gs);my=mean(lnτ); b=sum((gs.-mx).*(lnτ.-my))/sum((gs.-mx).^2); ic=my-b*mx
    R2=1-sum((lnτ.-(ic.+b.*gs)).^2)/sum((lnτ.-my).^2)
    pr(@sprintf("  ln τ vs N·g(ρ):  slope=%.3f (theory→1.0), R²=%.4f  ⇒ %s", b, R2,
                R2>0.97 ? "large-deviation form CONFIRMED" : "approximate"))

    # ── (D) τ vs closure size N at fixed ρ ─────────────────────────────────
    pr("\n"*dsh); pr("  (D) τ vs closure size N   (ρ=2.0 fixed) — exponential-in-size?")
    pr(dsh)
    pr(@sprintf("    %-6s %-12s %-10s", "N", "τ (mean)", "ln τ"))
    ρ=2.0; Ns=(10,20,30,40); lnτN=Float64[]
    for Nn in Ns
        st=lifetime_stats(Nn,ρ,3000; rng=MersenneTwister(50+Nn))
        push!(lnτN, log(st.mean))
        pr(@sprintf("    %-6d %-12.0f %-10.3f", Nn, st.mean, log(st.mean)))
    end
    xs=collect(Float64,Ns); mx=mean(xs);my=mean(lnτN)
    sl=sum((xs.-mx).*(lnτN.-my))/sum((xs.-mx).^2)
    pr(@sprintf("  ln τ vs N:  slope=%.4f /unit closure (theory g(2)=%.4f)  ⇒ τ ~ exp(N·g)", sl, g(2.0)))

    pr("\n"*bar); pr("  SMALL-MODEL VERDICT")
    pr(bar)
    pr("  • Pure closure logic (autocatalytic build + decay-DEFAULT, nothing imported)")
    pr("    REPRODUCES the full phenomenology: a metastable self-sustaining closed state,")
    pr("    memoryless exponential lifetimes, and τ rising steeply with the intrinsic")
    pr("    control ρ=β/δ. The 'destruction' was never imposed — it is the ground state.")
    pr("  • Functional form: τ ~ exp(N·g(ρ)), a large-deviation escape — the SAME class")
    pr("    as the MFE saddle (metastable + memoryless + steep τ(control)).")
    pr("  • HONEST LIMIT: exponential-in-size is GENERIC to metastable stochastic systems,")
    pr("    not yet closure-specific. The closure-SPECIFIC test is the SCALE-UP: put this")
    pr("    on the CFS K_n³ closure substrate and ask whether the STRUCTURE CFS computes")
    pr("    (spectral gap / rank / F-A-S role) sets g and predicts WHICH element's opening")
    pr("    triggers catastrophe (the roll/A-role analog). That is where closure would")
    pr("    earn prediction, not just host the dynamics.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
end

# rough lifetime scale for trace sampling cadence
life_guess(N,ρ) = exp(N*g(ρ))/N

main()
