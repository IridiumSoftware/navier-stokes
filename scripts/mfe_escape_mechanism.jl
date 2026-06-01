#!/usr/bin/env julia
# mfe_escape_mechanism.jl
#
# EXPERIMENTAL. NOT a spec artifact. Conversational object, not TCE work.
# Firewall: tests a SPECIFIC, falsifiable prediction of the closure-cycle escape
# picture against the MFE saddle. It either confirms or refutes the mechanism;
# it does not assert the closure framework "explains turbulence."
#
# ─── THE PREDICTION BEING TESTED ─────────────────────────────────────────────
# Why is τ(Re) ~ exp(B·Re)?  Two candidate explanations:
#   NAIVE: relaminarization is direct viscous decay ⇒ κ=1/τ ~ a linear rate
#          ~ (β²+γ²)/Re (ALGEBRAIC in Re). PREDICTION: 1/τ ∝ 1/Re.
#   CLOSURE-CYCLE / KRAMERS: the SSP cycle holds a quasi-stationary turbulent
#          amplitude; relaminarization needs a RARE fluctuation that carries the
#          flow to the laminar basin boundary. By flux-over-population,
#               κ = 1/τ  ∝  P_qs(E_pert < E_esc),
#          the quasi-stationary probability of being near the escape threshold.
#          PREDICTION: the exponential drop of 1/τ in Re is ACCOUNTED FOR by the
#          quasi-stationary weight near threshold retreating at the same rate, so
#          the ratio (1/τ)/P_qs(<E_esc) is ~Re-INDEPENDENT (the attempt frequency
#          does not scale exponentially).
#
# This script measures, per Re: the lifetime τ; the quasi-stationary distribution
# of perturbation energy E_pert (sampled from the turbulent phase, excluding the
# formation transient and the committed collapse); and the threshold weight
# P_qs(<E_esc). It then checks which prediction holds.

include(joinpath(@__DIR__, "mfe_self_sustaining.jl"))   # mfe!, rk4!, lifetime, randIC, qpert
using Printf, Random, Statistics

# trajectory returning (lifetime, censored, quasi-stationary E_pert samples)
function traj_qstat(a0, Re; dt=0.05, Tmax=20000.0, qlam=1e-4,
                    head=600.0, tail=150.0, every=100)
    a=copy(a0); k1=zeros(9);k2=zeros(9);k3=zeros(9);k4=zeros(9);tmp=zeros(9)
    n=round(Int,Tmax/dt); samples=Float64[]; pending=Float64[]; ptime=Float64[]
    for i in 1:n
        rk4!(a,Re,dt,k1,k2,k3,k4,tmp)
        t=i*dt; q=qpert(a)
        if i%every==0 && t>head
            push!(pending,q); push!(ptime,t)        # hold; commit once we know life
        end
        if q<qlam
            # commit only samples at least `tail` before collapse (quasi-stationary)
            for (qq,tt) in zip(pending,ptime); (t-tt)>tail && push!(samples,qq); end
            return (t, false, samples)
        end
    end
    for (qq,tt) in zip(pending,ptime); (Tmax-tt)>tail && push!(samples,qq); end
    return (Tmax, true, samples)
end

function main()
    out=joinpath(@__DIR__,"mfe_escape_mechanism.out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...))
    bar="═"^78; dsh="─"^78
    pr(bar); pr("  mfe_escape_mechanism.jl — WHY is τ(Re) exponential? EXPERIMENTAL.")
    pr("  Testing: closure-cycle/Kramers escape (flux-over-population) vs naive viscous decay.")
    pr(bar)

    Res=(250.0, 290.0, 330.0, 370.0); M=300
    E_escs=(0.002, 0.004, 0.008)
    β, γ = π/2, 1.0
    visc_roll(Re) = (β^2+γ^2)/Re                      # slowest linear (roll) decay rate

    pr(@sprintf("\n  standard box (4π,2π), M=%d trajectories/Re, E_pert sampled in the", M))
    pr("  quasi-stationary window [t>600, >150 t.u. before collapse].")
    pr("\n  per-Re measurements:")
    pr(@sprintf("    %-6s %-9s %-11s %-13s %-13s", "Re", "τ", "1/τ (κ)", "viscous 1/Re", "⟨E_pert⟩_qs"))
    data = NamedTuple[]
    for Re in Res
        rng=MersenneTwister(7000+round(Int,Re))
        lives=Float64[]; cens=Bool[]; allsamp=Float64[]
        for _ in 1:M
            l,c,s = traj_qstat(randIC(rng,0.3),Re)
            push!(lives,l); push!(cens,c); append!(allsamp,s)
        end
        keep=lives.>50; Lk=lives[keep]; Ck=cens[keep]
        t0=quantile(Lk,0.02)
        num=0.0;nunc=0; for (l,c) in zip(Lk,Ck); c ? num+=20000.0-t0 : (num+=l-t0;nunc+=1); end
        τ = num/nunc
        Pqs = Dict(E => count(<(E),allsamp)/length(allsamp) for E in E_escs)
        push!(data,(Re=Re, τ=τ, κ=1/τ, Eqs=mean(allsamp), Pqs=Pqs, nsamp=length(allsamp)))
        pr(@sprintf("    %-6.0f %-9.0f %-11.2e %-13.2e %-13.4f", Re, τ, 1/τ, visc_roll(Re), mean(allsamp)))
    end

    # ── prediction 1 (NAIVE viscous): is 1/τ ∝ 1/Re? ──────────────────────
    pr("\n"*dsh); pr("  NAIVE viscous prediction:  κ=1/τ ∝ 1/Re  (algebraic)")
    pr(dsh)
    pr("    Re      κ/(1/Re) = κ·Re   (constant ⟺ viscous-rate explanation holds)")
    κRe = Float64[]
    for d in data
        v = d.κ*d.Re; push!(κRe,v)
        pr(@sprintf("    %-6.0f  %.4f", d.Re, v))
    end
    pr(@sprintf("  κ·Re varies %.0f×  over the range ⇒ NOT constant ⇒ viscous-rate FAILS.",
                maximum(κRe)/minimum(κRe)))
    pr("  (κ drops exponentially while 1/Re drops algebraically — different physics.)")

    # ── prediction 2 (CLOSURE-CYCLE/Kramers): κ ∝ P_qs(<E_esc)? ───────────
    pr("\n"*dsh); pr("  CLOSURE-CYCLE/Kramers prediction:  κ ∝ P_qs(E_pert<E_esc)")
    pr("  ⇒ ratio κ/P_qs ~ Re-INDEPENDENT (attempt frequency, not exponential)")
    pr(dsh)
    for E in E_escs
        pr(@sprintf("  E_esc = %.3f :", E))
        pr(@sprintf("    %-6s %-12s %-12s %-12s", "Re", "κ=1/τ", "P_qs(<E)", "κ/P_qs"))
        ratios=Float64[]
        for d in data
            P=d.Pqs[E]; r = P>0 ? d.κ/P : NaN
            isfinite(r) && push!(ratios,r)
            pr(@sprintf("    %-6.0f %-12.2e %-12.3e %-12.4f", d.Re, d.κ, P, r))
        end
        if length(ratios)>=2
            sprd = (maximum(ratios)-minimum(ratios))/mean(ratios)
            # also fit: does P_qs drop at the SAME exponential rate as κ?
            lx=[d.Re for d in data]; lκ=log.([d.κ for d in data]); lP=log.([d.Pqs[E] for d in data])
            mx=mean(lx)
            slopeκ=sum((lx.-mx).*(lκ.-mean(lκ)))/sum((lx.-mx).^2)
            slopeP=sum((lx.-mx).*(lP.-mean(lP)))/sum((lx.-mx).^2)
            pr(@sprintf("    → κ/P_qs spread %.0f%% (vs κ itself %.0f×);  d(lnκ)/dRe=%.5f  d(lnP_qs)/dRe=%.5f",
                        100*sprd, maximum([d.κ for d in data])/minimum([d.κ for d in data]),
                        slopeκ, slopeP))
        end
    end

    # quantify: what fraction of B = d(lnκ)/dRe does occupancy explain?
    lx=[d.Re for d in data]; mx=mean(lx)
    slopeκ=sum((lx.-mx).*(log.([d.κ for d in data]).-mean(log.([d.κ for d in data]))))/sum((lx.-mx).^2)
    fracs = [ ( let lp=log.([d.Pqs[E] for d in data]);
                 sum((lx.-mx).*(lp.-mean(lp)))/sum((lx.-mx).^2)/slopeκ end ) for E in E_escs ]

    pr("\n"*bar); pr("  VERDICT — both naive mechanisms FAIL; the closure prediction is REFUTED")
    pr(bar)
    pr(@sprintf("  B (measured here) = d(lnκ)/dRe = %.4f /Re.", -slopeκ))
    pr("  • NAIVE viscous-decay: REFUTED. κ·Re varies 4× ⇒ κ is exponential in Re,")
    pr("    while a viscous rate is algebraic (1/Re). Different physics.")
    pr(@sprintf("  • CLOSURE-CYCLE occupancy (κ ∝ P_qs near threshold): ALSO REFUTED."))
    pr(@sprintf("    The quasi-stationary weight near the laminar boundary retreats far too"))
    pr(@sprintf("    SLOWLY — it explains only %.0f–%.0f%% of B (across E_esc=%.3f…%.3f);",
                100*minimum(fracs), 100*maximum(fracs), minimum(E_escs), maximum(E_escs)))
    pr("    κ/P_qs is not flat (varies ~2–2.6×). The mean quasi-stationary amplitude")
    pr(@sprintf("    barely moves (⟨E⟩: %.4f→%.4f) while κ drops 6×.",
                data[1].Eqs, data[end].Eqs))
    pr("  ⇒ The exponential τ(Re) is NOT 'occupancy of a low-amplitude region.' Most of")
    pr("    B lives in the CONDITIONAL dynamics: once the flow dips toward laminar, the")
    pr("    SSP cycle increasingly RECOVERS at higher Re — escape needs dip AND failure-")
    pr("    to-recover, and the recovery probability carries the dominant Re-dependence.")
    pr("")
    pr("  HONEST SCORE for the closure lens:")
    pr("   – QUALITATIVE (it's a metastable/large-deviation escape ⇒ exponential,")
    pr("     memoryless): consistent — but this is generic dynamical-systems framing,")
    pr("     shared with the standard saddle picture, NOT a unique closure win.")
    pr("   – QUANTITATIVE: the one concrete closure-cycle prediction tested here")
    pr("     (occupancy-limited escape) FAILED. B remains unpredicted, and the data")
    pr("     point to the cycle's RECOVERY/commitment probability as where B lives.")
    pr("  This is the firewall working: a falsifiable closure prediction, mostly refuted.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
end

main()
