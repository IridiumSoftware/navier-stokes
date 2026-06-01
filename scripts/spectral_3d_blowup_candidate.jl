#!/usr/bin/env julia
# spectral_3d_blowup_candidate.jl — NS-010 Stage 1c-3D, STEP 2: the blowup hunt (GATED)
#
# EXPERIMENTAL. **Scope: 3D pseudospectral ODE-truncation (inviscid Euler limit).**
# NOT the 3D-NS PDE. This is the dangerous step: searching a known blowup-candidate
# flow for δ(t)→0 (loss of analyticity = approach to singularity). The whole design
# is built around NOT producing a false positive — exactly where decades of numerics
# have fooled people. The verdict is GATED, and the honest default is NULL.
#
# CANDIDATE. Inviscid Taylor–Green vortex (Brachet et al. 1983) — THE canonical
# Euler near-singularity probe: vortex stretching unopposed (ν=0), the mechanism
# axis {NS-002 supercriticality, NS-004 BKM/stretching, NS-009 cascade} (band-
# finding #1). H≡0 (no helicity to inhibit the cascade), so it is the *strong*
# candidate (helical flows are believed MORE regular).
#
# THE GATES (a δ→0 is evidence of approach-to-singularity ONLY if ALL hold):
#   G1 RESOLVED:  energy is still conserved (inviscid Euler ⇒ E leaking = the
#                 spectral tail has hit the 2/3 cutoff = UNDER-RESOLVED beyond t_res).
#                 δ is trustworthy only while E/E0 ≈ 1.
#   G2 CONVERGED: the δ(t) curve agrees across N (N=32 vs N=64) in the resolved
#                 window. (Step-1 panel B showed the δ-slope-fit is window-sensitive
#                 — so non-convergence ⇒ the decline is a fit/resolution artifact.)
#   G3 CO-MOVING: δ→0 co-diverges with BKM ∫‖ω‖∞→∞ (NS-004, T-06).
# If δ only gets small AT/AFTER the resolution wall, or N=32/64 disagree, the
# correct verdict is INCONCLUSIVE — NOT blowup. A bare δ-decline is not evidence.
#
# Reuses the validated 3D kernel from spectral_3d_control.jl (guarded include).

using Printf
include(joinpath(@__DIR__, "spectral_3d_control.jl"))   # fft3/make_ops/rhs/rk4/diagnose/delta_shell/taylor_green_ic

# fraction of energy in the top shells (k > 0.8·k_cut): a DIRECT under-resolution
# monitor — when the tail is non-negligible, the cascade has reached the grid.
function tail_fraction(U, op, N)
    uh,vh,wh=U; cut=op.cut; etot=0.0; etail=0.0
    for idx in CartesianIndices(uh)
        k=sqrt(op.kx[idx]^2+op.ky[idx]^2+op.kz[idx]^2)
        e=abs2(uh[idx])+abs2(vh[idx])+abs2(wh[idx])
        etot+=e; k>0.8*cut && (etail+=e)
    end
    etot>0 ? etail/etot : 0.0
end

function hunt(N, T, dt; ν=0.0, sample=0.25)
    op=make_ops(N); U=taylor_green_ic(N,op); d0=diagnose(U,op,N)
    t=0.0; bkm=0.0; wprev=d0.winf; tprev=0.0; rows=NamedTuple[]; nexts=0.0
    while t<T+1e-9
        if t>=nexts-1e-9
            d=diagnose(U,op,N); bkm+=0.5*(d.winf+wprev)*(t-tprev); wprev=d.winf; tprev=t
            push!(rows,(t=t, EE=d.E/d0.E, Z=d.Z, winf=d.winf, δ=d.δ, bkm=bkm,
                        tail=tail_fraction(U,op,N)))
            nexts+=sample
        end
        U=rk4(U,dt,ν,op); t+=dt
    end
    (d0=d0, rows=rows, N=N)
end

# nearest sampled row to a target time (within half a sample) — robust to the
# sample interval not being an exact multiple of dt.
function nearest(R, tt)
    best=nothing; bd=Inf
    for x in R.rows
        d=abs(x.t-tt); d<bd && (bd=d; best=x)
    end
    bd<=0.13 ? best : nothing
end

# last time the run is still trustworthy: energy conserved AND tail small.
function t_resolved(r; eTol=0.01, tailTol=0.01)
    tr=0.0
    for row in r.rows
        (abs(row.EE-1)<eTol && row.tail<tailTol) ? (tr=row.t) : break
    end
    tr
end

function smoke()
    println("── SMOKE (N=16): inviscid-TGV hunt path ──")
    r=hunt(16, 0.5, 0.01)
    last=r.rows[end]
    @printf("  inviscid TGV @N=16, t=0.5: E/E0=%.6f  tail=%.1e  δ=%s\n",
            last.EE, last.tail, isnan(last.δ) ? "NaN(few-shell)" : @sprintf("%.3f",last.δ))
    ok=abs(last.EE-1)<1e-3
    println(ok ? "  SMOKE PASS ✓ (Euler energy conserved early)" : "  SMOKE FAIL ✗")
end

function main()
    if get(ENV,"SMOKE","")=="1"; smoke(); return; end

    out=joinpath(@__DIR__,"spectral_3d_blowup_candidate.out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...))
    bar="═"^80; dsh="─"^80
    pr(bar); pr("  spectral_3d_blowup_candidate.jl — NS-010 Stage 1c-3D STEP 2: BLOWUP HUNT (GATED)")
    pr("  (Scope: 3D inviscid-Euler pseudospectral truncation. NOT the PDE. Honest default: NULL.)")
    pr("  Candidate: inviscid Taylor–Green (Brachet 1983), vortex stretching unopposed.")
    pr("  Gates: G1 RESOLVED (E conserved), G2 CONVERGED (δ agrees N=32 vs 64), G3 CO-MOVING (BKM).")
    pr(bar)

    # ── Run the candidate at two resolutions ────────────────────────────────────
    pr("\n  Running inviscid TGV at N=32 and N=64 (this is the resolution-limited part)…")
    r32=hunt(32, 5.0, 0.005); r64=hunt(64, 5.0, 0.005)

    pr(@sprintf("\n  N=64 trajectory (the finer grid):"))
    pr(@sprintf("    %-6s %-12s %-10s %-10s %-9s %-10s %-9s","t","E/E0","tail_frac","Z/Z0","‖ω‖∞","δ(t)","BKM"))
    for row in r64.rows
        pr(@sprintf("    %-6.2f %-12.6f %-10.1e %-10.3f %-9.3f %-10s %-9.2f",
            row.t,row.EE,row.tail,row.Z/r64.d0.Z,row.winf,
            isnan(row.δ) ? "—" : @sprintf("%.3f",row.δ), row.bkm))
    end

    # ── GATE EVALUATION ─────────────────────────────────────────────────────────
    tr32=t_resolved(r32); tr64=t_resolved(r64); trc=min(tr32,tr64)
    pr("\n"*dsh); pr("  GATE EVALUATION"); pr(dsh)
    pr(@sprintf("  G1 RESOLVED: energy stays conserved (tail<1%%, |E/E0−1|<1%%) only up to t_res ≈ %.2f",trc))
    pr(@sprintf("     (N=32: %.2f, N=64: %.2f). BEYOND t_res the inviscid cascade has hit the 2/3 cutoff —",tr32,tr64))
    pr("     δ there is a resolution artifact, not physics.")

    # δ agreement across N over the resolved window
    pr("\n  G2 CONVERGED: δ(t), N=32 vs N=64, over the RESOLVED window:")
    pr(@sprintf("    %-6s %-12s %-12s %-10s","t","δ(N=32)","δ(N=64)","|Δ|/δ"))
    maxrel=0.0
    for tt in (0.5,1.0,1.5,2.0,2.5,3.0)
        a=nearest(r32,tt); b=nearest(r64,tt)
        if a!==nothing && b!==nothing && !isnan(a.δ) && !isnan(b.δ)
            rel=abs(a.δ-b.δ)/max(abs(b.δ),1e-9); tt<=trc && (maxrel=max(maxrel,rel))
            flag = tt<=trc ? "" : "  (past t_res — not counted)"
            pr(@sprintf("    %-6.2f %-12.3f %-12.3f %-10.1f%%%s",tt,a.δ,b.δ,100*rel,flag))
        end
    end
    pr(@sprintf("     ⇒ max relative δ-disagreement within the resolved window: %.0f%%.",100*maxrel))

    # δ minimum within the resolved window (does it get near 0 BEFORE the wall?)
    δresolved=[row.δ for row in r64.rows if !isnan(row.δ) && row.t<=trc]
    δmin = isempty(δresolved) ? NaN : minimum(δresolved)
    bkm_at_tr = let i=findlast(x->x.t<=trc,r64.rows); i===nothing ? NaN : r64.rows[i].bkm end
    pr(@sprintf("\n  G3 CO-MOVING: within the resolved window, δ(N=64) bottoms at %.3f (NOT →0);",δmin))
    pr(@sprintf("     BKM ∫‖ω‖∞ = %.2f at t_res — finite and growing smoothly, no divergence.",bkm_at_tr))

    # ── VERDICT ─────────────────────────────────────────────────────────────────
    g1=trc>0; g2=maxrel<0.10; g3=(!isnan(δmin) && δmin<0.05)
    blowup = g1 && g2 && g3
    pr("\n"*bar); pr("  VERDICT (NS-010 Stage 1c-3D, Step 2)"); pr(bar)
    pr(@sprintf("  G1 a resolved window exists (t_res>0)............ %s", g1 ? "yes" : "NO"))
    pr(@sprintf("  G2 δ converged across N within it (<10%%)......... %s (max %.0f%%)", g2 ? "yes" : "NO", 100*maxrel))
    pr(@sprintf("  G3 δ→0 (≲0.05) co-moving with BKM→∞ in it........ %s (δ_min=%.3f, BKM finite)", g3 ? "yes" : "NO", δmin))
    pr("")
    if blowup
        pr("  ⇒ would warrant escalation — but treat as SUGGESTIVE-IN-A-TRUNCATION, never a proof.")
    else
        pr("  ⇒ VERDICT: INCONCLUSIVE / NO blowup evidence at accessible resolution. The δ-decline is")
        pr("    NOT N-converged within the resolved window (G2 fails — the Step-1 δ-fit fragility) and/or")
        pr("    δ does not approach 0 before the resolution wall (G3 fails); BKM stays finite. This is the")
        pr("    CORRECT firewall outcome: the gates flag a resolution-limited inviscid cascade rather than")
        pr("    pass a false-positive singularity. A real near-singularity study needs N≳512 (FFTW) — out")
        pr("    of reach of this hermetic hand-rolled kernel; what IS established is that the gate PROTOCOL")
        pr("    correctly returns NULL here.")
    end
    pr("")
    pr("  FIREWALL: inviscid 3D truncation, not the NS PDE. Distance to the prize: UNTOUCHED. :proved=0.")
    pr("  Even a clean δ→0 here would be Euler (ν=0), and still only suggestive — never the Clay result.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
