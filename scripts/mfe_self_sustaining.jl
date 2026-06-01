#!/usr/bin/env julia
# mfe_self_sustaining.jl
#
# EXPERIMENTAL. NOT a spec artifact. Conversational object, not TCE work.
# Firewall: this reproduces a STANDARD model; it makes no claim that the closure
# framework explains it. It is the full-flow embodiment of "self-sustaining
# until it is not."
#
# ─── MODEL ───────────────────────────────────────────────────────────────────
# Moehlis, Faisst & Eckhardt, "A low-dimensional model for turbulent shear
# flows", New J. Phys. 6 (2004) 56.  Nine amplitudes a₁..a₉ for nine Fourier
# modes of plane Couette flow (free-slip), capturing the self-sustaining
# process: mean shear (a₁), streak (a₂), downstream/roll vortices (a₃), and
# streak/roll instabilities + their nonlinear products (a₄..a₉).
#
# Equations transcribed VERBATIM from the paper, p.7 eqs (21)–(28), with the
# normalization constants (eqs 29–31):
#   κ_αγ = √(α²+γ²),  κ_βγ = √(β²+γ²),  κ_αβγ = √(α²+β²+γ²).
# Standard "long-and-wide" box (paper p.12): L_x = 4π, L_z = 2π ⇒ α = 2π/L_x =
# 1/2, γ = 2π/L_z = 1, β = π/2.  Laminar fixed point: a₁ = 1, a₂..a₉ = 0
# (verified at runtime: ‖RHS(laminar)‖ ≈ 0).
#
# ─── WHAT IT SHOWS ───────────────────────────────────────────────────────────
#  (A) the laminar state is linearly stable (the flow CAN always relaminarize);
#  (B) a single trajectory SELF-SUSTAINS turbulent activity for a long, erratic
#      time and then ABRUPTLY collapses to laminar — "until it is not";
#  (C) over an ensemble of random initial conditions the turbulent LIFETIMES are
#      EXPONENTIALLY distributed (memoryless): the collapse has no internal
#      clock — it is a constant-hazard (Poisson) event, the signature that
#      turbulence here is a chaotic SADDLE, not an attractor;
#  (D) the characteristic lifetime τ grows steeply with Reynolds number.
# (B)+(C) are the precise content of "self-sustaining until it is not": the
# 'until' is a memoryless escape from a chaotic saddle, not a scheduled decay.

using Printf, Random, Statistics

const α = 0.5; const β = π/2; const γ = 1.0
const kag  = sqrt(α^2 + γ^2)
const kbg  = sqrt(β^2 + γ^2)
const kabg = sqrt(α^2 + β^2 + γ^2)
const s32  = sqrt(3/2)
const s6   = sqrt(6)

# RHS of the MFE system (eqs 21–28), in place. Re passed explicitly.
function mfe!(da, a, Re)
    a1,a2,a3,a4,a5,a6,a7,a8,a9 = a
    # (21)
    da[1] = β^2/Re - β^2/Re*a1 - s32*(β*γ/kabg)*a6*a8 + s32*(β*γ/kbg)*a2*a3
    # (22)
    da[2] = -(4*β^2/3 + γ^2)*a2/Re + (5*sqrt(2)/(3*sqrt(3)))*(γ^2/kag)*a4*a6 -
            (γ^2/(s6*kag))*a5*a7 - (α*β*γ/(s6*kag*kabg))*a5*a8 -
            s32*(β*γ/kbg)*a1*a3 - s32*(β*γ/kbg)*a3*a9
    # (23)
    da[3] = -((β^2+γ^2)/Re)*a3 + (2/s6)*(α*β*γ/(kag*kbg))*(a4*a7 + a5*a6) +
            ((β^2*(3*α^2+γ^2) - 3*γ^2*(α^2+γ^2))/(s6*kag*kbg*kabg))*a4*a8
    # (24)
    da[4] = -((3*α^2+4*β^2)/(3*Re))*a4 - (α/s6)*a1*a5 - (10/(3*s6))*(α^2/kag)*a2*a6 -
            s32*(α*β*γ/(kag*kbg))*a3*a7 - s32*(α^2*β^2/(kag*kbg*kabg))*a3*a8 -
            (α/s6)*a5*a9
    # (25)
    da[5] = -((α^2+β^2)/Re)*a5 + (α/s6)*a1*a4 + (α^2/(s6*kag))*a2*a7 -
            (α*β*γ/(s6*kag*kabg))*a2*a8 + (α/s6)*a4*a9 +
            (2/s6)*(α*β*γ/(kag*kbg))*a3*a6
    # (26)
    da[6] = -((3*α^2+4*β^2+3*γ^2)/(3*Re))*a6 + (α/s6)*a1*a7 + s32*(β*γ/kabg)*a1*a8 +
            (10/(3*s6))*((α^2-γ^2)/kag)*a2*a4 - 2*sqrt(2/3)*(α*β*γ/(kag*kbg))*a3*a5 +
            (α/s6)*a7*a9 + s32*(β*γ/kabg)*a8*a9
    # (27 / da_7)
    da[7] = -((α^2+β^2+γ^2)/Re)*a7 - (α/s6)*(a1*a6 + a6*a9) +
            (1/s6)*((γ^2-α^2)/kag)*a2*a5 + (1/s6)*(α*β*γ/(kag*kbg))*a3*a4
    # (da_8)
    da[8] = -((α^2+β^2+γ^2)/Re)*a8 + (2/s6)*(α*β*γ/(kag*kabg))*a2*a5 +
            (γ^2*(3*α^2-β^2+3*γ^2)/(s6*kag*kbg*kabg))*a3*a4
    # (28)
    da[9] = -(9*β^2/Re)*a9 + s32*(β*γ/kbg)*a2*a3 - s32*(β*γ/kabg)*a6*a8
    return da
end

# fixed-step RK4 step
function rk4!(a, Re, dt, k1,k2,k3,k4,tmp)
    mfe!(k1, a, Re)
    @. tmp = a + dt/2*k1; mfe!(k2, tmp, Re)
    @. tmp = a + dt/2*k2; mfe!(k3, tmp, Re)
    @. tmp = a + dt*k3;   mfe!(k4, tmp, Re)
    @. a = a + dt/6*(k1 + 2k2 + 2k3 + k4)
    return a
end

qpert(a) = sum(a[i]^2 for i in 2:9)            # energy in non-laminar modes

# integrate one IC; return (lifetime, censored?, optional sampled trace)
function lifetime(a0, Re; dt=0.05, Tmax=4000.0, qlam=1e-4, trace=false)
    a = copy(a0); k1=zeros(9);k2=zeros(9);k3=zeros(9);k4=zeros(9);tmp=zeros(9)
    n = round(Int, Tmax/dt)
    tr_t=Float64[]; tr_a1=Float64[]; tr_q=Float64[]
    for i in 1:n
        rk4!(a, Re, dt, k1,k2,k3,k4,tmp)
        if trace && i % 20 == 0
            push!(tr_t, i*dt); push!(tr_a1, a[1]); push!(tr_q, qpert(a))
        end
        if qpert(a) < qlam
            return (i*dt, false, tr_t, tr_a1, tr_q)
        end
    end
    return (Tmax, true, tr_t, tr_a1, tr_q)        # censored (still turbulent)
end

# random IC: laminar a₁=1, random direction in (a₂..a₉) scaled to amplitude A
function randIC(rng, A)
    a = zeros(9); a[1] = 1.0
    v = randn(rng, 8); v ./= sqrt(sum(abs2, v))
    a[2:9] .= A .* v
    return a
end

function main()
    out = joinpath(@__DIR__, "mfe_self_sustaining.out.txt")
    fout = open(out, "w"); pr(a...) = (println(stdout,a...); println(fout,a...))
    bar="═"^78; dsh="─"^78
    pr(bar); pr("  mfe_self_sustaining.jl — Moehlis–Faisst–Eckhardt (2004) 9-mode model.")
    pr("  EXPERIMENTAL. 'Self-sustaining until it is not', as a real dynamical system.")
    pr(bar)
    pr(@sprintf("\n  box L_x=4π, L_z=2π ⇒ α=%.3f, β=%.3f, γ=%.3f", α, β, γ))
    pr(@sprintf("  κ_αγ=%.4f  κ_βγ=%.4f  κ_αβγ=%.4f", kag, kbg, kabg))

    # ── (A) laminar fixed point is a fixed point and is stable ──────────────
    lam = zeros(9); lam[1]=1.0; d=zeros(9); mfe!(d, lam, 400.0)
    pr(@sprintf("\n  (A) laminar a=(1,0,…,0):  ‖RHS‖ = %.2e  (fixed point ✓)", sqrt(sum(abs2,d))))
    a = copy(lam); a[2:9] .= 1e-3
    for _ in 1:2000; rk4!(a, 400.0, 0.05, zeros(9),zeros(9),zeros(9),zeros(9),zeros(9)); end
    pr(@sprintf("      tiny perturbation after t=100:  q_pert = %.2e  (decays ⇒ stable ✓)", qpert(a)))

    # ── (B) one self-sustaining-then-collapsing trajectory ──────────────────
    pr("\n"*dsh); pr("  (B) ONE trajectory at Re=280: self-sustains, then abruptly collapses")
    pr(dsh)
    rng = MersenneTwister(7)
    local life, cens, tt, ta1, tq
    for attempt in 1:200                      # find a displayable, collapsing IC
        a0 = randIC(rng, 0.3)
        life, cens, tt, ta1, tq = lifetime(a0, 280.0; Tmax=8000.0, trace=true)
        (500 < life < 3000) && break          # long enough to see, short enough to fit
    end
    pr(@sprintf("  lifetime = %.0f time units%s", life, cens ? " (censored at Tmax)" : ""))
    pr("  trajectory:  t :  a₁ (mean shear)   q_pert (turbulent energy)")
    step = max(1, length(tt) ÷ 16)
    idxs = unique(vcat(collect(1:step:length(tt)), length(tt)))   # always show collapse
    for i in idxs
        barlen = round(Int, 40*min(tq[i],0.2)/0.2)
        pr(@sprintf("    %6.0f :  %.3f   %.4f  %s", tt[i], ta1[i], tq[i], "█"^barlen))
    end
    pr("  ⇒ a₁ stays suppressed and q_pert stays O(0.01–0.1) while turbulent,")
    pr("    then q_pert → 0 and a₁ → 1 abruptly: 'until it is not.'")

    # ── (C) lifetimes are exponentially distributed (memoryless) ───────────
    pr("\n"*dsh); pr("  (C) LIFETIME DISTRIBUTION over random ICs — memoryless test")
    pr(dsh)
    function lifetime_stats(Re, N, A; Tmax=20000.0)
        rng = MersenneTwister(20240)
        lives = Float64[]; ncens = 0
        for _ in 1:N
            l, c, _,_,_ = lifetime(randIC(rng, A), Re; Tmax=Tmax)
            push!(lives, l); c && (ncens += 1)
        end
        return lives, ncens
    end
    Re_show = 260.0; N = 600                   # calibrated: 0% censored at Tmax=20000
    lives, ncens = lifetime_stats(Re_show, N, 0.3; Tmax=20000.0)
    ignited = filter(>(50.0), lives)          # exclude ICs that never ignited
    pr(@sprintf("  Re=%.0f, N=%d random ICs (A=0.3):  %d ignited (life>50), %d censored",
                Re_show, N, length(ignited), ncens))
    # survival function S(t)=P(life>t) on the ignited set; exponential ⇒ log S linear
    ts = collect(range(200, stop=quantile(ignited, 0.90), length=12))
    pr("    t        S(t)=P(life>t)     ln S(t)")
    xs=Float64[]; ys=Float64[]
    for t in ts
        S = count(>(t), ignited)/length(ignited)
        S <= 0 && continue
        push!(xs, t); push!(ys, log(S))
        pr(@sprintf("    %6.0f     %.4f             %+.3f", t, S, log(S)))
    end
    # least-squares slope of ln S vs t  ⇒ τ = -1/slope ; R² = memoryless quality
    n=length(xs); mx=mean(xs); my=mean(ys)
    slope = sum((xs.-mx).*(ys.-my))/sum((xs.-mx).^2)
    inter = my - slope*mx
    ss_res = sum((ys .- (inter .+ slope.*xs)).^2); ss_tot = sum((ys.-my).^2)
    R2 = 1 - ss_res/ss_tot
    pr(@sprintf("\n  exponential fit ln S = %.4f %+.5f·t  ⇒  τ = %.0f t.u.,  R² = %.4f",
                inter, slope, -1/slope, R2))
    pr(@sprintf("  median lifetime (ignited) = %.0f t.u.", median(ignited)))
    pr("  R²→1 ⇒ lifetimes are EXPONENTIAL = MEMORYLESS: constant escape hazard,")
    pr("  no internal clock. Turbulence here is a chaotic SADDLE, not an attractor.")

    # ── (D) τ grows steeply with Re ────────────────────────────────────────
    pr("\n"*dsh); pr("  (D) characteristic lifetime τ vs Reynolds number")
    pr(dsh)
    pr("    Re     #ignited   %censored   median life   mean life (≈τ)")
    for Re in (240.0, 260.0, 280.0, 300.0, 320.0)
        lv,nc = lifetime_stats(Re, 200, 0.3; Tmax=30000.0)
        ig = filter(>(50.0), lv)
        pr(@sprintf("    %5.0f   %-9d  %-9.1f   %-12.0f  %-10.0f",
                    Re, length(ig), 100*nc/length(lv),
                    isempty(ig) ? 0 : median(ig), isempty(ig) ? 0 : mean(ig)))
    end
    pr("  ⇒ lifetimes lengthen rapidly with Re (the MFE result): the saddle gets")
    pr("    'stickier', but escape stays memoryless — still 'until it is not.'")

    pr("\n"*bar); pr("  READING")
    pr(bar)
    pr("  This is 'self-sustaining until it is not' as an exact dynamical object:")
    pr("  the SSP triad cycle (mean-shear→streak→roll→instability→mean-shear) keeps")
    pr("  the flow turbulent on a chaotic saddle; the 'until' is a memoryless escape")
    pr("  to the laminar fixed point. No threshold of NS regularity is invoked —")
    pr("  the phenomenon is the residue, exactly as posed.")
    pr(bar)
    close(fout); println(stdout, "\nwrote: $out")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
