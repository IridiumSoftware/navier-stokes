#!/usr/bin/env julia
# ns046_besov_smallness_probe.jl — NS-046/047: the critical-Besov budget, measured shell-by-shell.
#
# WHY. NS-047 found the harmonic-analytic route to the NS-046 deformation inequality is NOT blocked at
# Beale–Kato–Majda: the Calderón–Zygmund / Riesz operators that produce the pressure Hessian ∇²p from the
# velocity gradients are bounded on the CRITICAL Besov space Ḃ⁰_{∞,1} with NO log-penalty (unlike the
# L^∞ endpoint, where BKM lives). The route's real obstacle relocated to a LOCAL-REYNOLDS smallness that
# CKN supplies only on already-regular cylinders — i.e. it would have to hold on the ≤1-D singular set,
# where local Reynolds is O(1). This probe turns those two analytic statements into measured numbers, in
# the Besov metric, on a resolved DNS:
#
#   (C1, the framework)  R_j = ‖Δ_j ∇²p‖_∞ / ‖Δ_j Q‖_∞   per dyadic shell j (Q = tr(G²) = −Δp source).
#                        UNIFORM in j  ⟺  the CZ operator is Ḃ⁰_{∞,1}-bounded with no log  ⟺  the
#                        critical-Besov framework is the right one (NS-047 C1 corroborated, or not).
#   (C2, the gap)        Re_j = ‖Δ_j ω‖_∞ / (ν k_j²)       = (nonlinear stretching rate)/(viscous rate)
#                        at scale 2^{-j}. The smallness FRONTIER j* = largest j with Re_j ≥ 1 (viscosity
#                        wins beyond it). Tail Re_j ≪ 1 ⇒ absorbed (a regular truncation MUST show this);
#                        the test is whether the frontier + the whole budget CONVERGE with N (a stable
#                        diagnostic, NOT the resolution-fragile δ-fit that was Ryan-Class-I, NS-035).
#   (Besov norm)         ‖ω‖_{Ḃ⁰_{∞,1}} = Σ_j ‖Δ_j ω‖_∞   — the Kozono–Taniuchi (2000) blowup quantity
#                        (∫‖ω‖_{Ḃ⁰_{∞,∞}} = ∞ ⟺ blowup; Ḃ⁰_{∞,1} is the log-refined endpoint). Reported
#                        against ‖ω‖_∞ to show the refinement, with per-shell spatial concentration
#                        conc_j (top-1% mass fraction of |Δ_j ω|²) — the spectral shadow of localization.
#
# HONEST SCOPE / what this can and cannot say. Resolved 3D pseudospectral DNS truncation at Re=1600 — a
# REGULAR flow (vacuity cap: a regular truncation cannot reach the singular limit, so this is NOT a PDE
# result, NOT evidence about the inequality on a real singular set; :proved=0; prize distance UNTOUCHED).
# Besov norms are GLOBAL (Fourier) objects; they cannot be localized to the CKN singular set — that
# physical-space localization is the COMPLEMENTARY probe (ns046_uniform_domination_probe.jl, which found
# the pointwise domination NON-uniform). Together they bracket the question: this one asks whether the
# critical-Besov BUDGET (production vs pressure-Hessian + viscosity) is a clean, resolution-stable,
# no-log diagnostic and WHERE its margin is thinnest; the other asks whether the physical-space
# domination is uniform on the intense set. Per the witness discipline, neither bears on the analytic
# inequality directly — both are witness / counter-witness generators for it.
#
# Flows: TUBES (anti-parallel Kerr tubes — the reconnection worst case, weakest Beltramization, ρ_H≈0)
# and TG (Taylor–Green — the Brachet-1983 literature anchor, H≡0). N-convergence by running NS_N=64
# then NS_N=128 and comparing (j*, ‖ω‖_Besov at peak, R_j spread) across the two.
#
# CHAIN_CONVENTION: n/a (spectral velocity–vorticity, not a chain complex).
#
# Reuses the validated solver + pressure_hessian source algebra + ICs from the NS-045/046 chain.
# Run:  julia -t auto scripts/ns046_besov_smallness_probe.jl           (real run, writes _N{N}.out.txt)
#       SMOKE=1 julia -t auto scripts/ns046_besov_smallness_probe.jl   (N=16 correctness gate first)
# Env:  NS_N(64) NS_T(6) NS_DT(.01) NS_NU(1/1600) NS_SAMPLE(1.0)

using Printf, LinearAlgebra
include(joinpath(@__DIR__, "ns046_gradxi_pressure_probe.jl"))   # → solver + ICs + pressure algebra + diagnose

# Dyadic Littlewood–Paley shells [2^j, 2^{j+1}) ∩ {|k| ≤ dealias cut}, masks precomputed once per op.
function dyadic_shells(op)
    cut = op.cut; kmag = sqrt.(op.k2); shells = NamedTuple[]; j = 0
    while 2.0^j <= cut
        lo = 2.0^j; hi = 2.0^(j+1)
        mask = (kmag .>= lo) .& (kmag .< hi) .& (kmag .<= cut)
        n = count(mask)
        if n > 0
            kj = sqrt(sum(op.k2[mask]) / n)                 # RMS wavenumber in the shell
            push!(shells, (j=j, lo=lo, hi=min(hi, cut+1.0), kj=kj, mask=mask, n=n))
        end
        j += 1
    end
    shells
end

# Per-shell critical-Besov budget. For each dyadic block Δ_j: L^∞ of band-passed ω (Besov vort block),
# of the pressure source Q, and of the pressure Hessian ∇²p (Frobenius); then Re_j, R_j, conc_j.
function besov_budget(U, op, ν, shells)
    uh, vh, wh = U
    ωxh, ωyh, ωzh = curl_hat(uh, vh, wh, op)
    # velocity gradients → Q = tr(G²) = ∂_iu_j ∂_ju_i  (the −Δp source) → p̂ = Q̂/|k|² → Hessian hats
    dux=real.(ifft3(im.*op.kx.*uh)); duy=real.(ifft3(im.*op.ky.*uh)); duz=real.(ifft3(im.*op.kz.*uh))
    dvx=real.(ifft3(im.*op.kx.*vh)); dvy=real.(ifft3(im.*op.ky.*vh)); dvz=real.(ifft3(im.*op.kz.*vh))
    dwx=real.(ifft3(im.*op.kx.*wh)); dwy=real.(ifft3(im.*op.ky.*wh)); dwz=real.(ifft3(im.*op.kz.*wh))
    Q  = dux.^2 .+ dvy.^2 .+ dwz.^2 .+ 2 .*(duy.*dvx .+ duz.*dwx .+ dvz.*dwy)
    Qh = fft3(Q); ph = Qh ./ op.k2p
    Hxxh = .-op.kx.*op.kx.*ph; Hyyh = .-op.ky.*op.ky.*ph; Hzzh = .-op.kz.*op.kz.*ph
    Hxyh = .-op.kx.*op.ky.*ph; Hxzh = .-op.kx.*op.kz.*ph; Hyzh = .-op.ky.*op.kz.*ph
    rows = NamedTuple[]
    for s in shells
        m = s.mask
        ωxj=real.(ifft3(ωxh.*m)); ωyj=real.(ifft3(ωyh.*m)); ωzj=real.(ifft3(ωzh.*m))
        wfield = sqrt.(ωxj.^2 .+ ωyj.^2 .+ ωzj.^2); wj = maximum(wfield)
        Qj = maximum(abs.(real.(ifft3(Qh.*m))))
        hxx=real.(ifft3(Hxxh.*m)); hyy=real.(ifft3(Hyyh.*m)); hzz=real.(ifft3(Hzzh.*m))
        hxy=real.(ifft3(Hxyh.*m)); hxz=real.(ifft3(Hxzh.*m)); hyz=real.(ifft3(Hyzh.*m))
        Hj = maximum(sqrt.(hxx.^2 .+ hyy.^2 .+ hzz.^2 .+ 2 .*(hxy.^2 .+ hxz.^2 .+ hyz.^2)))
        Re = wj / (ν * s.kj^2)
        R  = Qj > 1e-30 ? Hj / Qj : 0.0
        v = sort(vec(wfield.^2); rev=true); tot = sum(v); m1 = max(1, round(Int, 0.01*length(v)))
        conc = tot > 1e-30 ? sum(@view v[1:m1]) / tot : 0.0
        push!(rows, (j=s.j, lo=s.lo, kj=s.kj, wj=wj, Qj=Qj, Hj=Hj, Re=Re, R=R, conc=conc, n=s.n))
    end
    rows
end

besov_norm(rows) = sum(r.wj for r in rows)                       # ‖ω‖_{Ḃ⁰_{∞,1}}
jstar(rows)      = (idx = findlast(r -> r.Re >= 1.0, rows); idx === nothing ? -1 : rows[idx].j)
rspread(rows)    = (rs = [r.R for r in rows if r.Qj > 1e-12]; isempty(rs) ? (0.0,0.0) : (minimum(rs), maximum(rs)))

function run_besov(label, U, N, ν, T, dt, op, shells, pr; sample=1.0)
    pr(@sprintf("# %s  N=%d  nu=%.5e  T=%.1f  shells=%d (dyadic, |k|≤%d)", label, N, ν, T, length(shells), op.cut))
    pr("# t      winf      Besov     Bes/inf  j*(Re>=1)  Re_tail   R[min..max]   (Besov=‖ω‖_Ḃ⁰_∞1; R=‖Δ∇²p‖∞/‖ΔQ‖∞)")
    t = 0.0; nexts = 0.0; peak = (-1.0, nothing, 0.0)            # (winf, rows, t) at the most intense sample
    while t <= T + 1e-9
        if t >= nexts - 1e-9
            d = diagnose(U, op, N); rows = besov_budget(U, op, ν, shells)
            bn = besov_norm(rows); js = jstar(rows); rmin, rmax = rspread(rows)
            retail = rows[end].Re
            pr(@sprintf("%.2f   %8.3f  %8.3f  %6.3f   %2d         %8.2e  %.2f..%.2f",
                        t, d.winf, bn, bn/max(d.winf,1e-30), js, retail, rmin, rmax))
            if d.winf > peak[1]; peak = (d.winf, rows, t); end
            nexts += sample
        end
        U = rk4(U, dt, ν, op); t += dt
    end
    # shell detail at the most intense sample (where the budget is most stressed)
    rows = peak[2]
    pr(@sprintf("# shell detail @ t=%.2f (peak ‖ω‖∞=%.3f):", peak[3], peak[1]))
    pr("#  j  k∈[lo,hi)   k_j      ‖Δ_jω‖∞    Re_j        R_j=‖Δ∇²p‖/‖ΔQ‖   conc1%   modes")
    for r in rows
        pr(@sprintf("  %2d  [%5.0f,%5.0f) %6.2f  %9.4e  %9.3e   %12.4f    %6.4f   %d",
                    r.j, r.lo, 2.0^(r.j+1), r.kj, r.wj, r.Re, r.R, r.conc, r.n))
    end
    (peak_t=peak[3], peak_winf=peak[1], peak_besov=besov_norm(rows),
     peak_jstar=jstar(rows), peak_rspread=rspread(rows), peak_retail=rows[end].Re)
end

# ── N=1 correctness gate (SMOKE=1) ───────────────────────────────────────────
function smoke()
    println("── SMOKE (N=16): Besov-probe correctness gate ──")
    N=16; op=make_ops(N); shells=dyadic_shells(op); ν=1/1600
    println("  dyadic shells: ", [(s.j, Int(s.lo), s.n) for s in shells])
    U = taylor_green_ic(N, op)
    for _ in 1:5; U = rk4(U, 0.01, ν, op); end                   # a few steps to populate small scales
    d = diagnose(U, op, N); rows = besov_budget(U, op, ν, shells)
    bn = besov_norm(rows)
    @printf("  ‖ω‖∞ = %.4f   ‖ω‖_Besov = %.4f\n", d.winf, bn)
    # invariant 1: triangle ineq ω=ΣΔ_jω ⇒ ‖ω‖∞ ≤ Σ‖Δ_jω‖∞ = Besov norm
    ok1 = bn >= d.winf - 1e-6
    @printf("  triangle ‖ω‖∞ ≤ ‖ω‖_Besov : %s\n", ok1 ? "✓" : "✗")
    # invariant 2: R_j (CZ ratio) finite & O(1) on every shell with content
    rs = [r.R for r in rows if r.Qj > 1e-12]
    ok2 = !isempty(rs) && all(isfinite, rs) && maximum(rs) < 10.0
    @printf("  R_j finite & O(1) (max=%.3f) : %s\n", isempty(rs) ? NaN : maximum(rs), ok2 ? "✓" : "✗")
    # invariant 3: Re_j positive, decreasing into the tail (viscous absorption)
    res = [r.Re for r in rows]
    ok3 = all(>(0), res) && res[end] < res[1]
    @printf("  Re_j > 0 and tail < head (%.2e < %.2e) : %s\n", res[end], res[1], ok3 ? "✓" : "✗")
    println(ok1 && ok2 && ok3 ? "  SMOKE PASS ✓" : "  SMOKE FAIL ✗")
end

function main()
    if get(ENV,"SMOKE","")=="1"; smoke(); return; end
    N   = parse(Int,     get(ENV,"NS_N","64"))
    T   = parse(Float64, get(ENV,"NS_T","6.0"))
    dt  = parse(Float64, get(ENV,"NS_DT","0.01"))
    ν   = parse(Float64, get(ENV,"NS_NU", string(1/1600)))
    smp = parse(Float64, get(ENV,"NS_SAMPLE","1.0"))
    icsel = get(ENV,"NS_IC","both")                             # both | tubes | tg
    op  = make_ops(N); shells = dyadic_shells(op)
    suffix = (N==64 ? "" : "_N$(N)") * (round(1/ν)==1600 ? "" : "_Re$(round(Int,1/ν))")
    out = joinpath(@__DIR__, "ns046_besov_smallness_probe$(suffix).out.txt")
    fout = open(out,"w"); pr(a...) = (println(stdout,a...); println(fout,a...); flush(fout); flush(stdout))
    pr("# NS-046/047 critical-Besov smallness probe — does the Ḃ⁰_{∞,1} budget show the local-Reynolds")
    pr("# smallness (C2) and the no-log CZ boundedness (C1)? Scope: resolved DNS truncation; NOT the PDE; :proved=0.")
    pr(@sprintf("# N=%d  Re=%.0f  dt=%.3f  T=%.1f  threads=%d  dyadic shells=%d  IC=%s", N, 1/ν, dt, T, Threads.nthreads(), length(shells), icsel))
    results = NamedTuple[]
    if icsel in ("both","tubes")
        UT = vortex_tube_ic(N, op); dT = diagnose(UT, op, N)
        pr(@sprintf("# tubes IC: E=%.4f Z=%.4f rhoH=%+.3f divmax=%.1e", dT.E, dT.Z, dT.H/(2*sqrt(dT.E*dT.Z)), dT.divmax))
        pr(""); rT = run_besov("TUBES (Kerr reconnection — worst case)", UT, N, ν, T, dt, op, shells, pr; sample=smp)
        push!(results, (lbl="TUBES", r=rT))
    end
    if icsel in ("both","tg")
        UG = taylor_green_ic(N, op)
        pr(""); rG = run_besov("TG (Brachet anchor — control)", UG, N, ν, T, dt, op, shells, pr; sample=smp)
        push!(results, (lbl="TG", r=rG))
    end
    pr("")
    pr("# ── SUMMARY (N=$N, Re=$(round(Int,1/ν))) ───────────────────────────────────")
    for x in results
        r = x.r; resolved = r.peak_retail < 1.0
        pr(@sprintf("# %-6s peak t=%.2f: winf=%.3f Besov=%.3f j*=%d Re_tail=%.2e R∈[%.2f,%.2f]  → tail %s",
                    x.lbl, r.peak_t, r.peak_winf, r.peak_besov, r.peak_jstar, r.peak_retail,
                    r.peak_rspread..., resolved ? "ABSORBED (dissipation resolved; smallness shown)" :
                                                  "INERTIAL (dissipation UNRESOLVED; frontier at grid edge)"))
    end
    pr("# Read: (C1) R∈[..] tight & flat across shells ⇒ Riesz/CZ is Ḃ⁰_{∞,1}-bounded with NO log (NS-047 C1).")
    pr("#       (C2) j* = smallness frontier; Re_tail<1 ⇒ the grid reached the dissipation scale and the")
    pr("#       small-scale tail is viscously absorbed (smallness EXHIBITED); Re_tail≫1 ⇒ tail still inertial")
    pr("#       (under-resolved — smallness is resolution-gated, the RWC-038 / Ryan-Class-II discipline).")
    pr("# DONE")
    close(fout); println(stdout, "wrote: $out")
end

if abspath(PROGRAM_FILE) == @__FILE__; main(); end
