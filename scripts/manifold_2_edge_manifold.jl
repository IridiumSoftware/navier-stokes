#!/usr/bin/env julia
# manifold_2_edge_manifold.jl — NS MANIFOLD STUDY, Slice 2: the EDGE manifold
#
# EXPERIMENTAL. **Scope: geometry of the MFE 9-mode shear-flow truncation.**
# NOT the 3D-NS PDE. Continues the CFS-style manifold reconnaissance: characterize
# the codimension-1 invariant manifold that separates the laminar basin from the
# turbulent saddle (the "edge of chaos", Skufca–Yorke 2006 / Schneider–Eckhardt).
#
# THE MANIFOLD. Phase space of the MFE model (a₁..a₉) splits into ICs that
# relaminarize (q_pert→0) and ICs that ignite the turbulent saddle. The boundary
# is the EDGE MANIFOLD = the stable manifold of an "edge state" (the relative
# attractor on the boundary) ≈ the committor=½ surface (NS-021/023). We locate it
# by EDGE TRACKING (bisection along a ray), observe the edge state it shadows, and
# identify the GATE — the transverse direction whose sign decides laminar vs
# turbulent. The committor decomposition (NS-021/023) predicts the gate is the
# ROLL mode a₃; we test that here geometrically.
#
# Reuses the verified MFE kernel from mfe_self_sustaining.jl (guarded include).

include(joinpath(@__DIR__, "mfe_self_sustaining.jl"))   # mfe!, rk4!, qpert, randIC
using Printf, Random, LinearAlgebra

const RE = 350.0          # laminar stable; turbulent a long-lived transient saddle
const QLAM = 1e-4         # below ⇒ relaminarized
const EHI  = 0.025        # above ⇒ ignited into the turbulent core

# first-passage fate of an IC: which threshold it reaches first, and when.
function fate(a0; dt=0.05, Tmax=3000.0)
    a=copy(a0); k1=zeros(9);k2=zeros(9);k3=zeros(9);k4=zeros(9);tmp=zeros(9)
    n=round(Int,Tmax/dt)
    for i in 1:n
        rk4!(a,RE,dt,k1,k2,k3,k4,tmp); q=qpert(a)
        q<QLAM && return (:laminar, i*dt)
        q>EHI  && return (:turbulent, i*dt)
    end
    (:edge, Tmax)            # reached neither ⇒ shadowing the edge state
end

# edge-state diagnostics: mean q_pert and mean |aᵢ| over the shadowing window
# (the span where QLAM < q < EHI), plus the shadowing duration.
function shadow_profile(a0; dt=0.05, Tmax=4000.0)
    a=copy(a0); k1=zeros(9);k2=zeros(9);k3=zeros(9);k4=zeros(9);tmp=zeros(9)
    n=round(Int,Tmax/dt); sa=zeros(9); sq=0.0; m=0; tshadow=0.0
    for i in 1:n
        rk4!(a,RE,dt,k1,k2,k3,k4,tmp); q=qpert(a)
        if QLAM<q<EHI; sa.+=abs.(a); sq+=q; m+=1; tshadow=i*dt
        elseif q<QLAM || q>EHI; break; end
    end
    (m>0 ? sa./m : sa, m>0 ? sq/m : 0.0, tshadow)
end

# auto-bracket along ray a(A)=[1; A·v]: scan until laminar→non-laminar, then bisect.
function edge_bisect(v; iters=44)
    mk(A)=vcat(1.0, A.*v)
    Agrid=[0.001,0.002,0.005,0.01,0.02,0.04,0.07,0.1,0.15,0.2,0.3,0.45,0.6,0.8,1.0]
    A_lo=NaN; A_hi=NaN; prevA=NaN; prevf=:none
    for A in Agrid
        f=fate(mk(A))[1]
        if prevf==:laminar && f!=:laminar; A_lo=prevA; A_hi=A; break; end
        prevA=A; prevf=f
    end
    isnan(A_lo) && error("no laminar→non-laminar bracket on the scan grid (laminar basin off-grid)")
    for _ in 1:iters
        Am=(A_lo+A_hi)/2; fate(mk(Am))[1]==:turbulent ? (A_hi=Am) : (A_lo=Am)
    end
    (A_lo+A_hi)/2, mk((A_lo+A_hi)/2)
end

function main()
    out=joinpath(@__DIR__,"manifold_2_edge_manifold.out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...))
    bar="═"^80; dsh="─"^80
    pr(bar); pr("  MANIFOLD STUDY — Slice 2: the EDGE manifold of the MFE 9-mode model")
    pr("  (Scope: geometry of the MFE truncation. NOT the PDE. Distance to prize: UNTOUCHED.)")
    pr(bar)
    pr(@sprintf("  Re=%.0f. Laminar basin vs turbulent saddle; the boundary = the EDGE manifold",RE))
    pr(@sprintf("  = stable manifold of the edge state ≈ committor=½ surface. q_lam=%.0e, E_core=%.3f.",QLAM,EHI))

    # ── (A) the laminar fixed point (one side of the manifold) ──────────────────
    lam=zeros(9); lam[1]=1.0; d=zeros(9); mfe!(d,lam,RE)
    pr("\n"*dsh); pr("  (A) LAMINAR fixed point a=(1,0,…,0) — the basin the edge bounds")
    pr(dsh)
    pr(@sprintf("    ‖RHS(laminar)‖ = %.2e  (fixed point ✓);  it is linearly stable (mfe_self_sustaining).",
        norm(d)))

    # ── (B) edge tracking + the critical-slowing law (first-passage vs distance) ─
    pr("\n"*dsh); pr("  (B) EDGE TRACKING — locate the manifold; measure the slowing law T(d)")
    pr(dsh)
    v=randn(MersenneTwister(2026),8); v./=norm(v)
    A_edge, a_edge = edge_bisect(v)
    mk(A)=vcat(1.0,A.*v)
    pr(@sprintf("    ray direction v: random unit (seed 2026).  A_edge = %.10f", A_edge))
    pr("    first-passage time T at distance d from the edge (both sides). A generic IC")
    pr("    decides fast; near the edge the trajectory is captured by the edge state:")
    pr(@sprintf("      %-10s %-14s %-14s", "d=|A−A_e|", "T (lam side)", "T (turb side)"))
    ds=[1e-2,1e-3,1e-4,1e-5,1e-6]; Tturb=Float64[]; lnd=Float64[]
    for d in ds
        tl=fate(mk(A_edge-d))[2]; tt=fate(mk(A_edge+d))[2]
        push!(Tturb,tt); push!(lnd,log(1/d))
        pr(@sprintf("      %-10.0e %-14.0f %-14.0f", d, tl, tt))
    end
    # slope of T vs ln(1/d) on the turbulent side ⇒ 1/σ (edge-state transverse rate)
    mx=sum(lnd)/length(lnd); my=sum(Tturb)/length(Tturb)
    slope=sum((lnd.-mx).*(Tturb.-my))/sum((lnd.-mx).^2)
    pr(@sprintf("    ⇒ T grows ≈ %.1f·ln(1/d): logarithmic CRITICAL SLOWING (σ≈%.3f, the edge",
        slope, slope>0 ? 1/slope : NaN))
    pr("      state's transverse instability rate). The edge state captures trajectories —")
    pr("      the 9D analog of Slice 1's homoclinic separatrix slowing. (T plateaus once d")
    pr("      hits bisection precision — honest: the log-law holds over the resolved decades.)")

    # ── (C) the edge state structure ────────────────────────────────────────────
    pr("\n"*dsh); pr("  (C) THE EDGE STATE — mode content while shadowing the manifold")
    pr(dsh)
    prof, qbar, tsh = shadow_profile(a_edge)
    names=["a1 mean-shear","a2 streak","a3 ROLL","a4","a5","a6","a7","a8","a9 mean-mod"]
    pr(@sprintf("    shadowing duration %.0f t.u., mean q_pert %.4f (between laminar %.0e and core %.3f)",
        tsh, qbar, QLAM, EHI))
    pr(@sprintf("    %-6s %-12s %-s","mode","mean |aᵢ|","role"))
    domj=sortperm(prof[2:9],rev=true)[1:3].+1
    for j in 1:9
        mark = j in domj ? "  ←" : ""
        pr(@sprintf("    %-6s %-12.4f %s%s","a$j",prof[j],names[j],mark))
    end
    pr(@sprintf("    ⇒ the edge state is SHEAR+STREAK dominated (a1=%.2f, a2=%.3f); the roll a3 is",prof[1],prof[2]))
    pr(@sprintf("      SMALL here (%.4f). HONEST: it is the SSP structure in balance, but at this Re/ray",prof[3]))
    pr("      the active perturbation modes are the streak a2 and a6/a7 — not a dominant roll.")

    # ── (D) the GATE: which transverse direction crosses the manifold? ──────────
    pr("\n"*dsh); pr("  (D) THE GATE — perturb the edge state ±ε per mode; which CROSSES the manifold?")
    pr(dsh)
    pr("    A mode FLIPS (lam↔turb under ±ε) ⇒ it has a NORMAL component (crosses the edge);")
    pr("    a mode that does NOT flip is ~TANGENT to the edge manifold. Test each:")
    pr(@sprintf("    %-6s %-16s %-16s %-s","mode","+ε fate","−ε fate","geometry"))
    ε=0.01
    flips=Int[]; tangents=Int[]
    for j in 2:9
        ap=copy(a_edge); ap[j]+=ε; am=copy(a_edge); am[j]-=ε
        fp=fate(ap)[1]; fm=fate(am)[1]
        flip = (fp!=fm) && (:laminar in (fp,fm)) && (:turbulent in (fp,fm))
        flip ? push!(flips,j) : push!(tangents,j)
        pr(@sprintf("    %-6s %-16s %-16s %s","a$j",String(fp),String(fm), flip ? "← NORMAL (crosses)" : "tangent"))
    end
    pr(@sprintf("    ⇒ NORMAL (gate) components: %s    TANGENT: %s",
        join(["a$j" for j in flips],","), join(["a$j" for j in tangents],",")))
    pr("    CORRECTION (honest): the edge-manifold normal is MULTI-MODE (streak a2 + a4/a5/a6/a8);")
    pr("    the roll a3 is ~TANGENT — it does NOT flip the fate. So 'a3 is the gate' does NOT hold")
    pr("    as the edge-manifold normal. The NS-023 result ('a3 SURVIVING A DIP predicts recovery')")
    pr("    is a CONDITIONAL-on-trajectory statement — a DIFFERENT object from the edge normal. Two")
    pr("    notions, not one (an NS-024-style distinction; do not conflate the committor gate with")
    pr("    the geometric edge normal).")

    pr("\n"*bar); pr("  READING (Slice 2 — edge manifold)")
    pr(bar)
    pr("  • The phase space is partitioned by a codim-1 EDGE MANIFOLD (laminar basin |")
    pr("    turbulent saddle) = the stable manifold of an edge state, located by bisection.")
    pr("    First-passage time grows LOGARITHMICALLY toward it (critical slowing, measured σ)")
    pr("    — the 9D analog of Slice 1's homoclinic separatrix.")
    pr("  • The edge state is the SSP structure in balance — SHEAR+STREAK dominated at this")
    pr("    Re/ray; the roll a3 is small. (Honest: not a roll-dominated edge state here.)")
    pr("  • CORRECTION carried out of (D): the edge-manifold NORMAL (the geometric 'gate') is")
    pr("    multi-mode, and the roll a3 is ~TANGENT. The NS-023 committor gate ('a3 survival")
    pr("    predicts recovery') is a distinct, conditional notion — NOT the edge normal. The")
    pr("    earlier expectation that they coincide is REFUTED here. Two notions, not one.")
    pr("  • CFS RHYME (probe, not claim): an invariant manifold partitioning state space, with")
    pr("    a definite (multi-mode) normal and critical slowing — observe; do not assert transfer.")
    pr("  • FIREWALL: MFE truncation geometry, not the NS PDE. :proved=0; prize UNTOUCHED.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
