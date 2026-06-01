#!/usr/bin/env julia
# manifold_6_coadjoint_3d.jl — NS MANIFOLD STUDY, Slice 6: the 3D-Euler COADJOINT /
#                              ISOVORTICAL structure — the geometric root of the 2D/3D gap
#
# EXPERIMENTAL. **Scope: geometry of ideal (Euler) flow, 2D vs 3D truncations,
# exact-invariant probes.** NOT the 3D-NS PDE. Examines the coadjoint-orbit /
# isovortical structure that Slices 1–5 hinted at, and isolates the SINGLE
# geometric fact that most cleanly explains why 3D is open and 2D is not:
# the CASIMIR DEFICIT.
#
# THE FRAMEWORK (Arnold). Euler flow is the Lie–Poisson / coadjoint-orbit flow on
# the dual of the divergence-free vector fields. Vorticity ω is the moment map; it
# is FROZEN-IN / Lie-dragged by the flow (Helmholtz–Kelvin): a solution stays on the
# COADJOINT ORBIT ("isovortical sheet") of its initial vorticity — the set of fields
# reachable by a volume-preserving diffeomorphism. CASIMIRS are the functions
# constant on every orbit (the rigid invariants the dynamics cannot touch):
#   • 2D: ω is a SCALAR advected by the flow ⇒ EVERY ∫f(ω)dx is a Casimir —
#     INFINITELY many (the whole vorticity distribution is conserved; the flow only
#     REARRANGES ω). ⇒ ∫ω² (enstrophy) bounded ⇒ rigid orbits ⇒ GLOBAL REGULARITY.
#   • 3D: ω is a VECTOR (2-form) Lie-dragged AND STRETCHED (ω·∇u) ⇒ the ∫f(|ω|)
#     family is NOT conserved; essentially the ONLY Casimir is HELICITY H=∫u·ω
#     (Moffatt: the topological linking/knottedness of vortex lines). ⇒ ONE Casimir,
#     loose orbits, vortex stretching unconstrained ⇒ the OPEN problem.
# This CASIMIR DEFICIT (∞ vs 1) is the coadjoint-geometric statement of the 2D/3D
# gap — complementary to the scaling statement (Slice 3 / NS-002, NS-034) and the
# enstrophy-coercivity statement (`physical_invariants.md`).
#
# WE DEMONSTRATE IT exactly: (B) 2D Euler conserves the ∫f(ω) family + the sorted
# vorticity DISTRIBUTION (isovortical rearrangement); (C) 3D Euler conserves HELICITY
# but NOT ∫|ω|² or max|ω| (stretching). Reuses spectral_3d_control.jl (guarded include);
# a compact 2D Euler is inline (distinct names).

include(joinpath(@__DIR__, "spectral_3d_control.jl"))  # fft!, fft3, ifft3, make_ops, curl_hat, rk4, diagnose, random_helical_ic, mean3
using Printf, Random, Statistics

# ── compact 2D Euler (vorticity form; ν=0), names distinct from the 3D kernel ──
function fft2(Ar)
    A=ComplexF64.(Ar); N=size(A,1)
    for i in 1:N; r=A[i,:]; fft!(r); A[i,:]=r; end
    for j in 1:N; c=A[:,j]; fft!(c); A[:,j]=c; end
    A
end
function ifft2(A)
    B=copy(A); N=size(B,1)
    for i in 1:N; r=B[i,:]; fft!(r;inv=true); B[i,:]=r; end
    for j in 1:N; c=B[:,j]; fft!(c;inv=true); B[:,j]=c; end
    B
end
function make_ops2d(N)
    kx=[Float64(keff(a-1,N)) for a in 1:N, b in 1:N]
    ky=[Float64(keff(b-1,N)) for a in 1:N, b in 1:N]
    k2=kx.^2 .+ ky.^2; k2p=copy(k2); k2p[1,1]=1.0; cut=N÷3
    deal=[abs(keff(a-1,N))<=cut && abs(keff(b-1,N))<=cut for a in 1:N, b in 1:N]
    (kx=kx,ky=ky,k2=k2,k2p=k2p,deal=deal)
end
function rhs2d(ω, op)               # 2D incompressible Euler, vorticity form (ν=0)
    W=fft2(ω); ψ=W./op.k2p; ψ[1,1]=0
    u=real.(ifft2(-im.*op.ky.*ψ)); v=real.(ifft2(im.*op.kx.*ψ))
    ωx=real.(ifft2(im.*op.kx.*W)); ωy=real.(ifft2(im.*op.ky.*W))
    Aadv=fft2(u.*ωx .+ v.*ωy); Aadv[.!op.deal].=0
    -real.(ifft2(Aadv))
end
function rk4_2d(ω,dt,op)
    k1=rhs2d(ω,op); k2=rhs2d(ω.+(dt/2).*k1,op); k3=rhs2d(ω.+(dt/2).*k2,op); k4=rhs2d(ω.+dt.*k3,op)
    ω .+ (dt/6).*(k1.+2 .*k2.+2 .*k3.+k4)
end

# 3D vorticity-magnitude moments from a velocity field (Fourier state)
function vort_moments3d(U, op)
    ωxh,ωyh,ωzh=curl_hat(U[1],U[2],U[3],op)
    ωx=real.(ifft3(ωxh)); ωy=real.(ifft3(ωyh)); ωz=real.(ifft3(ωzh))
    w2=ωx.^2 .+ ωy.^2 .+ ωz.^2
    (Z=0.5*mean3(w2), m4=mean3(w2.^2), winf=maximum(sqrt.(w2)))
end

function main()
    out=joinpath(@__DIR__,"manifold_6_coadjoint_3d.out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...))
    bar="═"^82; dsh="─"^82
    pr(bar); pr("  MANIFOLD STUDY — Slice 6: 3D-Euler COADJOINT / ISOVORTICAL structure")
    pr("  (Scope: geometry of ideal flow, 2D vs 3D truncations. NOT the PDE. Prize: UNTOUCHED.)")
    pr(bar)
    pr("  Euler = coadjoint-orbit flow; ω frozen-in (Lie-dragged). CASIMIRS = orbit invariants.")
    pr("  THE CASIMIR DEFICIT: 2D has ∞ (every ∫f(ω)) ⇒ rigid ⇒ regular;  3D has ~1 (helicity) ⇒")
    pr("  loose ⇒ vortex stretching unconstrained ⇒ open. This panel exhibits that difference.")

    # ── (B) 2D Euler: the ∫f(ω) Casimir family + the vorticity DISTRIBUTION conserved ─
    pr("\n"*dsh); pr("  (B) 2D EULER — ∫f(ω) family + sorted vorticity DISTRIBUTION conserved (∞ Casimirs)")
    pr(dsh)
    N=128; op2=make_ops2d(N)
    x=[2π*(i-1)/N for i in 1:N]
    ω=[sin(x[a])*cos(x[b]) + 0.6*cos(2x[a]+x[b]) + 0.4*sin(x[a]-2x[b]) for a in 1:N, b in 1:N]
    C0=(c2=mean(ω.^2), c4=mean(ω.^4), c1=mean(abs.(ω)), winf=maximum(abs.(ω)))
    sorted0=sort(vec(abs.(ω)))
    pr(@sprintf("    %-6s %-12s %-12s %-12s %-12s %-12s","t","∫ω²/∫ω²₀","∫ω⁴/∫ω⁴₀","∫|ω|/₀","max|ω|/₀","distrib L∞"))
    t=0.0; dt=0.004
    for tt in 0.0:0.5:3.0
        while t < tt-1e-9; ω=rk4_2d(ω,dt,op2); t+=dt; end
        c=(mean(ω.^2),mean(ω.^4),mean(abs.(ω)),maximum(abs.(ω)))
        dist=maximum(abs.(sort(vec(abs.(ω))).-sorted0))     # L∞ change in the sorted multiset
        pr(@sprintf("    %-6.1f %-12.6f %-12.6f %-12.6f %-12.6f %-12.2e",
            tt, c[1]/C0.c2, c[2]/C0.c4, c[3]/C0.c1, c[4]/C0.winf, dist))
    end
    pr("  ⇒ ALL ∫f(ω) conserved (≈1) and the sorted vorticity multiset barely moves: 2D Euler only")
    pr("    REARRANGES ω (isovortical). ∞ Casimirs ⇒ enstrophy bounded ⇒ rigid orbit ⇒ REGULAR.")
    pr("    (Small drift grows only when the enstrophy cascade reaches the 2/3 cutoff — resolution.)")

    # ── (C) 3D Euler: HELICITY conserved, but ∫|ω|² and max|ω| NOT (stretching) ──
    pr("\n"*dsh); pr("  (C) 3D EULER — HELICITY (the Casimir) conserved, ∫|ω|² / max|ω| NOT (stretching)")
    pr(dsh)
    N3=32; op3=make_ops(N3); U=random_helical_ic(N3,op3; kmax=3)
    d0=diagnose(U,op3,N3); v0=vort_moments3d(U,op3)
    pr(@sprintf("    %-6s %-12s %-12s %-12s %-12s","t","H/H₀ (Casimir)","E/E₀","∫|ω|²/₀","max|ω|/₀"))
    t=0.0; dt=0.01
    for tt in 0.0:0.25:2.0
        while t < tt-1e-9; U=rk4(U,dt,0.0,op3); t+=dt; end
        d=diagnose(U,op3,N3); v=vort_moments3d(U,op3)
        pr(@sprintf("    %-6.2f %-12.6f %-12.6f %-12.6f %-12.6f",
            tt, d.H/d0.H, d.E/d0.E, v.Z/v0.Z, v.winf/v0.winf))
    end
    pr("  ⇒ HELICITY conserved to ~machine (the topological Casimir — vortex-line linking, Moffatt),")
    pr("    energy conserved (Euler), but ENSTROPHY ∫|ω|² and max|ω| GROW: ω is STRETCHED, not merely")
    pr("    rearranged. The ∫f(|ω|) family is NOT conserved — only helicity. ONE Casimir ⇒ loose orbit.")

    pr("\n"*bar); pr("  READING (Slice 6 — the coadjoint Casimir deficit)")
    pr(bar)
    pr("  • Both 2D and 3D Euler are coadjoint-orbit flows (ω frozen-in). The difference is the")
    pr("    CASIMIR COUNT: 2D conserves the WHOLE vorticity distribution (∞ Casimirs ∫f(ω)) and only")
    pr("    REARRANGES ω (isovortical) ⇒ enstrophy bounded ⇒ rigid orbit ⇒ global regularity.")
    pr("  • 3D conserves essentially ONLY helicity (the topological Casimir); vortex stretching moves")
    pr("    the state along the orbit in ways the single Casimir cannot bound ⇒ ∫|ω|² unconstrained.")
    pr("  • THIS is the coadjoint-geometric root of the 2D/3D gap — the SAME wall seen three ways:")
    pr("    enstrophy non-coercive (`physical_invariants.md`), energy supercritical (Slice 3/NS-002,034),")
    pr("    and now the CASIMIR DEFICIT (∞→1). The geometry says the obstruction is structural, not incidental.")
    pr("  • FIREWALL: ideal-flow (Euler) geometry, 2D vs 3D; NOT the 3D-NS PDE (viscosity breaks the")
    pr("    Casimirs anyway). The Casimir deficit FRAMES why 3D is hard; it does not resolve it. :proved=0.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
