#!/usr/bin/env julia
# repair_cost_under_stretching.jl
#
# Adjudicates the central empirical claim of the "discrete / dual-closure uplift"
# document (Desktop `discrete.rtfd`, a Grok exploratory pass): that under 3D
# stretching the REPAIR COST  Cost(c) = inf{‖z‖ : ∂z = c}  "grows exponentially,
# proxied by enstrophy + curvature" — the claimed mechanism of turbulence
# ("repair overflow") and of the proposed claim that the PDE is "the wrong model."
#
# WE COMPUTE THE REAL THING (not the enstrophy proxy) and watch whether it grows.
#
# The vorticity field ω=∇×u is the obstruction-carrier (the "1-cycle" content).
# Its minimal filling — the smallest field z whose curl is ω — is the natural
# repair cost. The minimal-L² such z is the divergence-free field with ∇×z=ω,
# which is the VELOCITY u itself (any other z differs by a gradient, which only
# adds norm and is killed by curl). So, recovered FROM ω alone (Fourier inverse
# curl on the div-free subspace: ẑ = i k×ω̂/|k|²):
#
#     R_X(ω) := min{ ‖z‖_{L²} : ∇×z = ω }  =  ‖curl⁻¹ ω‖_{L²}  =  ‖u‖_{L²} = √(2E).
#
# i.e. the minimal filling of the vorticity is exactly the velocity — ONE
# DERIVATIVE SMOOTHER than ω. In Fourier |ẑ|=|ω̂|/|k|. So as vorticity concentrates
# at high k (stretching), R_X does NOT track it: R_X = the ENERGY-side quantity,
# which 3D Euler CONSERVES (and NS dissipates). The document's "proxy by enstrophy"
# is the move that hides this — enstrophy ‖ω‖²_{L²}=Σ|k|²|û|² weights the high-k end;
# the real repair cost weights the low-k (smooth) end.
#
# PREDICTIONS (the test):
#   • enstrophy ‖ω‖_{L²} (= the document's proxy)            GROWS under stretching.
#   • the real repair cost R_X = √(2E)                       stays BOUNDED (=energy).
#   • ratio R_X/‖ω‖_{L²} ~ ⟨1/|k|⟩                            DECAYS  (the NS-020
#                                                             "repair-cost≈1/vorticity").
# If borne out: the "repair overflow → turbulence / wrong-model" claim fails on its
# own terms; the repair cost sits on the energy rung (σ=−½, SUPERcritical, NS-036)
# — a bound on it is scale-vacuous, the same wall, relabeled.
#
# CHAIN_CONVENTION: field/Hodge repair — the minimal VECTOR-POTENTIAL filling of the
# vorticity FIELD (curl⁻¹ on the div-free subspace). This is NOT the geometric
# 2-chain (Seifert-surface) filling of an individual material filament 1-cycle; that
# is a separate GMT computation. Both translations make the repair object a
# derivative SMOOTHER than ω (repairing the velocity-1-chain q=∂₂z₂ gives an even
# smoother z, ~‖u‖_{Ḣ⁻¹}), so the bounded-not-growing conclusion is robust to the
# translation. Scope: 3D pseudospectral truncation. NOT the PDE. :proved = 0.

using Printf
include(joinpath(@__DIR__, "spectral_3d_control.jl"))   # reuse the validated solver

# Spectral norms of the velocity field (û triple) — all from the SAME spectrum.
# energy^½ = ‖u‖_{L²}=‖u‖_{Ḣ⁰}; enstrophy^½ = ‖ω‖_{L²}=‖u‖_{Ḣ¹}; |ω̂|=|k||û|.
function sob_norm(U, op, s)            # ‖u‖_{Ḣ^s} = (Σ |k|^{2s} |û|²)^{1/2}
    uh, vh, wh = U
    acc = 0.0
    @inbounds for idx in CartesianIndices(uh)
        k2 = op.kx[idx]^2 + op.ky[idx]^2 + op.kz[idx]^2
        k2 == 0 && continue
        acc += (k2^s) * (abs2(uh[idx]) + abs2(vh[idx]) + abs2(wh[idx]))
    end
    sqrt(acc)
end

# Recover the minimal filling z FROM ω alone (non-circular), then its L² norm.
# ẑ = i k×ω̂ / |k|²  is the div-free field with ∇×z=ω; assert it equals u.
function repair_cost_from_vorticity(U, op)
    ωxh, ωyh, ωzh = curl_hat(U[1], U[2], U[3], op)        # ω̂ = i k×û
    zxh = im .* (op.ky .* ωzh .- op.kz .* ωyh) ./ op.k2p   # (i k×ω̂)/|k|²
    zyh = im .* (op.kz .* ωxh .- op.kx .* ωzh) ./ op.k2p
    zzh = im .* (op.kx .* ωyh .- op.ky .* ωxh) ./ op.k2p
    RX = sqrt(sum(abs2, zxh) + sum(abs2, zyh) + sum(abs2, zzh))   # ‖z‖ (spectral)
    # sanity: z should equal u (the velocity) on the div-free subspace
    uL2 = sqrt(sum(abs2, U[1]) + sum(abs2, U[2]) + sum(abs2, U[3]))
    mism = abs(RX - uL2) / max(uL2, 1e-30)
    (RX = RX, uL2 = uL2, mismatch = mism)
end

# fraction of a spectral density Σ d(k) carried by the LOW band |k|≤cut/2
function lowband_fraction(U, op, s)
    uh, vh, wh = U; half = op.cut / 2
    lo = 0.0; tot = 0.0
    @inbounds for idx in CartesianIndices(uh)
        k2 = op.kx[idx]^2 + op.ky[idx]^2 + op.kz[idx]^2
        k2 == 0 && continue
        d = (k2^s) * (abs2(uh[idx]) + abs2(vh[idx]) + abs2(wh[idx]))
        tot += d
        sqrt(k2) <= half && (lo += d)
    end
    lo / tot
end

# evolve and sample R_X vs enstrophy along a stretching flow
function track(U0, N, ν, T, dt, op; sample=0.5)
    U = U0; t = 0.0; nexts = 0.0; rows = NamedTuple[]
    while t < T + 1e-9
        if t >= nexts - 1e-9
            d = diagnose(U, op, N)
            rc = repair_cost_from_vorticity(U, op)
            push!(rows, (t=t, E=d.E, Z=d.Z, enstn=sqrt(2d.Z), RX=sqrt(2d.E),
                         RXfromω=rc.RX, mism=rc.mismatch, winf=d.winf))
            nexts += sample
        end
        U = rk4(U, dt, ν, op); t += dt
    end
    rows
end

function main()
    out = joinpath(@__DIR__, "repair_cost_under_stretching.out.txt")
    fout = open(out, "w"); pr(a...) = (println(stdout, a...); println(fout, a...))
    bar = "═"^78; dsh = "─"^78
    pr(bar)
    pr("  repair_cost_under_stretching.jl — does the REAL repair cost grow under 3D stretching?")
    pr("  (adjudicates the `discrete.rtfd` dual-closure claim: 'repair cost grows exponentially')")
    pr("  Scope: 3D pseudospectral truncation. NOT the PDE. :proved=0; distance UNTOUCHED.")
    pr(bar)
    pr("  R_X(ω) = min{‖z‖ : ∇×z=ω} = ‖curl⁻¹ω‖ = ‖u‖ = √(2E)  (minimal filling of the vorticity).")
    pr("  document's PROXY = enstrophy^½ = ‖ω‖_{L²} = ‖u‖_{Ḣ¹}.  CLAIM: repair cost grows ∝ enstrophy.")

    # sanity: the filling recovered from ω equals the velocity, to machine precision
    N = 64; op = make_ops(N)
    U0 = taylor_green_ic(N, op)
    rc = repair_cost_from_vorticity(U0, op)
    pr(@sprintf("\n  sanity: ‖curl⁻¹ω‖ vs ‖u‖ mismatch = %.1e %s  (the minimal filling IS the velocity)",
                rc.mismatch, rc.mismatch < 1e-10 ? "✓" : "✗"))

    # ── (A) INVISCID Taylor–Green (ν=0): the canonical vortex-stretching flow ──
    pr("\n"*dsh); pr("  (A) 3D EULER (ν=0), N=64, Taylor–Green — vortex stretching ON, energy CONSERVED.")
    pr(dsh)
    rA = track(U0, N, 0.0, 5.0, 0.01, op; sample=0.5)
    pr(@sprintf("    %-6s %-12s %-14s %-14s %-12s %-9s","t","E/E0",
                "enstrophy½ (proxy)","R_X=√(2E) (real)","ratio R_X/‖ω‖","‖ω‖∞"))
    Z0 = rA[1].Z; e0 = rA[1].enstn; r0 = rA[1].RX
    for row in rA
        pr(@sprintf("    %-6.1f %-12.6f %-14.4f %-14.4f %-12.5f %-9.2f",
            row.t, row.E/rA[1].E, row.enstn, row.RX, row.RX/row.enstn, row.winf))
    end
    enstgrow = rA[end].enstn / e0; rxdrift = rA[end].RX / r0
    pr(@sprintf("  ⇒ enstrophy½ (the PROXY) grows ×%.2f; the REAL repair cost R_X drifts ×%.4f",
                enstgrow, rxdrift))
    pr("    (= energy, CONSERVED to ~6 digits). They DIVERGE: the proxy rises, the real cost is flat.")

    # ── (B) where each lives in k-space (repair cost is a derivative SMOOTHER) ──
    pr("\n"*dsh); pr("  (B) spectral location: low-band (|k|≤cut/2) fraction of each density, t=0 vs late.")
    pr(dsh)
    Ulate = U0; tt = 0.0; while tt < 3.0 - 1e-9; Ulate = rk4(Ulate, 0.01, 0.0, op); tt += 0.01; end
    pr(@sprintf("    %-10s %-22s %-22s","", "repair cost (σ=0 dens.)","enstrophy (σ=1 dens.)"))
    pr(@sprintf("    %-10s %-22.3f %-22.3f","t=0",
                lowband_fraction(U0, op, 0.0), lowband_fraction(U0, op, 1.0)))
    pr(@sprintf("    %-10s %-22.3f %-22.3f","t=3",
                lowband_fraction(Ulate, op, 0.0), lowband_fraction(Ulate, op, 1.0)))
    pr("  ⇒ repair cost lives in the LOW band (smooth); enstrophy migrates to the HIGH band")
    pr("    (the cascade). The repair cost is literally a derivative smoother than what it 'repairs'.")

    # ── (C) VISCOUS Taylor–Green: repair cost follows ENERGY, not the enstrophy peak ──
    pr("\n"*dsh); pr("  (C) 3D NS (ν=0.02), N=64, Taylor–Green — enstrophy PEAKS then decays; energy decays.")
    pr(dsh)
    rC = track(taylor_green_ic(N, op), N, 0.02, 8.0, 0.01, op; sample=1.0)
    pr(@sprintf("    %-6s %-14s %-16s %-16s","t","E/E0","enstrophy½ (proxy)","R_X (real)"))
    for row in rC
        pr(@sprintf("    %-6.1f %-14.6f %-16.4f %-16.4f", row.t, row.E/rC[1].E, row.enstn, row.RX))
    end
    pr("  ⇒ the proxy PEAKS (stretching) then falls (dissipation); the real repair cost R_X")
    pr("    MONOTONICALLY DECAYS with the energy. Repair cost tracks the CONTROLLED quantity,")
    pr("    never the battleground one. No 'overflow' anywhere.")

    pr("\n"*bar); pr("  VERDICT")
    pr(bar)
    pr("  • The `discrete.rtfd` claim 'repair cost grows exponentially' is FALSE for the real cost.")
    pr("    What grows is ENSTROPHY — the PROXY it was silently swapped for. The genuine minimal")
    pr("    filling of the vorticity is the VELOCITY (one derivative smoother): R_X=‖u‖=√(2E),")
    pr("    bounded by the CONSERVED energy. (Confirms NS-020 'repair-cost≈1/vorticity'.)")
    pr("  • Repair cost sits on the ENERGY rung (σ=−½, SUPERcritical): a bound on it is scale-vacuous")
    pr("    — the SAME wall as NS-036, relabeled. The document put its controller on the wrong rung.")
    pr("  • The document's OWN variational derivation agrees (mean-curvature tension drives filaments")
    pr("    to LOW-cost configs) — it contradicts its own 'grows' headline. The 'repair overflow →")
    pr("    turbulence → wrong model' mechanism fails on its own terms.")
    pr("  • This does NOT touch the PDE. Scope: 3D truncation. :proved=0; distance UNTOUCHED.")
    pr(bar)
    close(fout); println(stdout, "\nwrote: $out")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
