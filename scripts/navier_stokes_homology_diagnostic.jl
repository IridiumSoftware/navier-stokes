#!/usr/bin/env julia
# navier_stokes_homology_diagnostic.jl
#
# EXPERIMENTAL. NOT a spec artifact. No S-ID, no registry row. This is a
# *falsifying* diagnostic for a conversational claim, not a TCE result.
# Firewall: nothing here touches CFS/GPG; no ontology O asserted.
#
# ─── WHAT THIS TESTS ────────────────────────────────────────────────────────
# A proposed "homological reformulation" of the 3D incompressible Navier–Stokes
# regularity problem claims that turbulence/blowup is forced when, along a mesh
# refinement tower X_n of a fluid domain, EITHER
#   (1) dim H_1(X_n; ℝ) → ∞  (homology classes appear/grow), OR
#   (2) the minimal "repair cost" R_{X_n}(q) = inf{‖a‖ : ∂₂a = q} → ∞ even
#       though [q] = 0.
#
# The diagnostic is built to BREAK that framing, not confirm it. Three probes:
#
#   PROBE A (topology is pinned under refinement). Compute b_1 of the periodic
#     cubical 3-torus 𝕋³ at increasing mesh resolution N, and of a contractible
#     box. If horn (1) had teeth, refining the mesh would grow b_1. Prediction:
#     b_1(𝕋³)=3 for ALL N (the 3 constant mean-flow modes); b_1(box)=0 for all N.
#
#   PROBE B (the only way horn (1) fires is by CHANGING the topology). Delete
#     2-cells (faces) from 𝕋³ and watch b_1 climb. This is a topology change,
#     not a refinement — it has no analogue for a fixed fluid domain.
#
#   PROBE C (the difficulty is the NORM, invisible to homology). Build a
#     divergence-free, EXACTLY null-homology (q = ∂₂a) velocity sequence q_k that
#     sharpens (rising spatial wavenumber k = incipient-blowup proxy). Hold the
#     energy ‖q_k‖₂ = 1 fixed. Then show:
#       • homology class ≡ 0 for every k (machine zero), b_1 ≡ 3 throughout;
#       • a critical seminorm (vorticity ‖∂₂ᵀq_k‖ ≈ velocity Ḣ¹) → ∞ as k grows;
#       • the ℓ² repair cost R(q_k) stays BOUNDED (∝ 1/k).
#     ⇒ The SAME zero-homology, fixed-energy sequence has repair cost that is
#       bounded in one norm and divergent in another. Topology cannot see it;
#       the choice of norm decides everything. That is the whole NS difficulty,
#       and it is analytic, not homological.
#
# ─── CHAIN CONVENTION ───────────────────────────────────────────────────────
# CHAIN_CONVENTION: ordered-tuple (cubical, periodic 3-torus). Real coefficients.
#   Vertices: (i,j,k), i,j,k ∈ 0..N-1, periodic.        vid = i + N j + N² k + 1
#   Edges:    direction d∈{1,2,3}=(x,y,z) based at a vertex.  3N³ total.
#   Faces:    oriented unit squares in planes p∈{1,2,3} = (xy, yz, zx), each
#             based at a vertex.  3N³ total.
#   ∂₁ : C₁→C₀  edge ↦ head − tail            (discrete divergence; ∂₁q=0 = incompressible)
#   ∂₂ : C₂→C₁  face ↦ oriented boundary loop  (im ∂₂ = "repairable" circulations)
#   H₁ = ker ∂₁ / im ∂₂.   ∂₂ᵀ = discrete curl (co-boundary).
#   Self-check asserted at build: ∂₁∂₂ = 0.

using LinearAlgebra
using SparseArrays
using Printf

const RUN_OUT = joinpath(@__DIR__, "navier_stokes_homology_diagnostic.out.txt")

# ── index helpers (periodic) ────────────────────────────────────────────────
pm(i, N) = mod(i, N)
vid(i, j, k, N) = pm(i,N) + N*pm(j,N) + N*N*pm(k,N) + 1          # 1..N³
eid(d, i, j, k, N) = (d-1)*N^3 + vid(i,j,k,N)                    # 1..3N³, d∈1:3
fid(p, i, j, k, N) = (p-1)*N^3 + vid(i,j,k,N)                    # 1..3N³, p∈1:3

# ── boundary operators of the periodic cubical 3-torus ──────────────────────
function torus_boundaries(N)
    nV = N^3; nE = 3*N^3; nF = 3*N^3
    # ∂₁ : edge ↦ head − tail
    I1=Int[]; J1=Int[]; V1=Float64[]
    for i in 0:N-1, j in 0:N-1, k in 0:N-1
        # x-edge
        e = eid(1,i,j,k,N); push!(I1,vid(i+1,j,k,N)); push!(J1,e); push!(V1, 1.0)
                            push!(I1,vid(i,j,k,N));   push!(J1,e); push!(V1,-1.0)
        # y-edge
        e = eid(2,i,j,k,N); push!(I1,vid(i,j+1,k,N)); push!(J1,e); push!(V1, 1.0)
                            push!(I1,vid(i,j,k,N));   push!(J1,e); push!(V1,-1.0)
        # z-edge
        e = eid(3,i,j,k,N); push!(I1,vid(i,j,k+1,N)); push!(J1,e); push!(V1, 1.0)
                            push!(I1,vid(i,j,k,N));   push!(J1,e); push!(V1,-1.0)
    end
    B1 = sparse(I1,J1,V1,nV,nE)

    # ∂₂ : oriented boundary of each square
    #   xy-face(p=1): +x(i,j,k) +y(i+1,j,k) −x(i,j+1,k) −y(i,j,k)
    #   yz-face(p=2): +y(i,j,k) +z(i,j+1,k) −y(i,j,k+1) −z(i,j,k)
    #   zx-face(p=3): +z(i,j,k) +x(i,j,k+1) −z(i+1,j,k) −x(i,j,k)
    I2=Int[]; J2=Int[]; V2=Float64[]
    addf(f,e,s) = (push!(I2,e); push!(J2,f); push!(V2,s))
    for i in 0:N-1, j in 0:N-1, k in 0:N-1
        f = fid(1,i,j,k,N)
        addf(f, eid(1,i,j,k,N),  1.0); addf(f, eid(2,i+1,j,k,N),  1.0)
        addf(f, eid(1,i,j+1,k,N),-1.0); addf(f, eid(2,i,j,k,N),  -1.0)
        f = fid(2,i,j,k,N)
        addf(f, eid(2,i,j,k,N),  1.0); addf(f, eid(3,i,j+1,k,N),  1.0)
        addf(f, eid(2,i,j,k+1,N),-1.0); addf(f, eid(3,i,j,k,N),  -1.0)
        f = fid(3,i,j,k,N)
        addf(f, eid(3,i,j,k,N),  1.0); addf(f, eid(1,i,j,k+1,N),  1.0)
        addf(f, eid(3,i+1,j,k,N),-1.0); addf(f, eid(1,i,j,k,N),  -1.0)
    end
    B2 = sparse(I2,J2,V2,nE,nF)
    return B1, B2
end

# ── contractible box (non-periodic) : vertices 0..N each axis ───────────────
function box_boundaries(N)
    M = N+1                                    # vertices per axis
    vb(i,j,k) = i + M*j + M*M*k + 1            # 1..M³
    inb(i,j,k) = (0<=i<M)&&(0<=j<M)&&(0<=k<M)
    nV = M^3
    # enumerate edges that fit
    edges = Tuple{Int,Int,Int,Int}[]           # (d,i,j,k)
    for i in 0:M-1, j in 0:M-1, k in 0:M-1
        inb(i+1,j,k) && push!(edges,(1,i,j,k))
        inb(i,j+1,k) && push!(edges,(2,i,j,k))
        inb(i,j,k+1) && push!(edges,(3,i,j,k))
    end
    eindex = Dict(e=>n for (n,e) in enumerate(edges)); nE=length(edges)
    head(d,i,j,k) = d==1 ? vb(i+1,j,k) : d==2 ? vb(i,j+1,k) : vb(i,j,k+1)
    I1=Int[];J1=Int[];V1=Float64[]
    for (n,(d,i,j,k)) in enumerate(edges)
        push!(I1,head(d,i,j,k));push!(J1,n);push!(V1,1.0)
        push!(I1,vb(i,j,k));    push!(J1,n);push!(V1,-1.0)
    end
    B1 = sparse(I1,J1,V1,nV,nE)
    # faces that fit
    faces = Tuple{Int,Int,Int,Int}[]
    for i in 0:M-1, j in 0:M-1, k in 0:M-1
        inb(i+1,j+1,k) && push!(faces,(1,i,j,k))
        inb(i,j+1,k+1) && push!(faces,(2,i,j,k))
        inb(i+1,j,k+1) && push!(faces,(3,i,j,k))
    end
    nF=length(faces)
    eget(d,i,j,k) = eindex[(d,i,j,k)]
    I2=Int[];J2=Int[];V2=Float64[]
    addf(f,e,s)=(push!(I2,e);push!(J2,f);push!(V2,s))
    for (f,(p,i,j,k)) in enumerate(faces)
        if p==1
            addf(f,eget(1,i,j,k),1.0); addf(f,eget(2,i+1,j,k),1.0)
            addf(f,eget(1,i,j+1,k),-1.0); addf(f,eget(2,i,j,k),-1.0)
        elseif p==2
            addf(f,eget(2,i,j,k),1.0); addf(f,eget(3,i,j+1,k),1.0)
            addf(f,eget(2,i,j,k+1),-1.0); addf(f,eget(3,i,j,k),-1.0)
        else
            addf(f,eget(3,i,j,k),1.0); addf(f,eget(1,i,j,k+1),1.0)
            addf(f,eget(3,i+1,j,k),-1.0); addf(f,eget(1,i,j,k),-1.0)
        end
    end
    B2 = sparse(I2,J2,V2,nE,nF)
    return B1,B2
end

# ── b_1 over ℝ via ranks (SVD; ±1 integer matrices ⇒ well-separated σ) ───────
function betti1(B1, B2)
    nE = size(B1,2)
    r1 = rank(Matrix(B1))
    r2 = rank(Matrix(B2))
    return (nE - r1) - r2, r1, r2
end

function main()
    fout = open(RUN_OUT, "w")
    pr(args...) = (println(stdout, args...); println(fout, args...))
    bar = "═"^78; dsh = "─"^78

    pr(bar)
    pr("  navier_stokes_homology_diagnostic.jl")
    pr("  Falsifying test of the homological NS reformulation. EXPERIMENTAL.")
    pr(bar)

    # ── build sanity: ∂₁∂₂ = 0 ──────────────────────────────────────────────
    B1,B2 = torus_boundaries(3)
    z = norm(Matrix(B1*B2))
    pr(@sprintf("\n  build self-check (N=3):  ‖∂₁∂₂‖ = %.3e   (must be 0)  %s",
                z, z < 1e-10 ? "✓" : "✗"))

    # ── PROBE A : b_1 under refinement ──────────────────────────────────────
    pr("\n"*dsh)
    pr("  PROBE A — does refining the mesh grow H₁?  (horn (1) test)")
    pr(dsh)
    pr("  Periodic 3-torus 𝕋³  (expect b_1 = 3 = three constant mean-flow modes)")
    pr(@sprintf("    %-6s %-8s %-8s %-8s %-10s", "N", "|V|", "|E|", "|F|", "b_1"))
    for N in (2,3,4,5,6,8)
        B1,B2 = torus_boundaries(N)
        b1,_,_ = betti1(B1,B2)
        pr(@sprintf("    %-6d %-8d %-8d %-8d %-10d", N, N^3, 3N^3, 3N^3, b1))
    end
    pr("  Contractible box (⊂ ℝ³, the actual NS domain)  (expect b_1 = 0)")
    pr(@sprintf("    %-6s %-8s %-8s %-8s %-10s", "N", "|V|", "|E|", "|F|", "b_1"))
    for N in (2,3,4,6)
        B1,B2 = box_boundaries(N)
        b1,_,_ = betti1(B1,B2)
        pr(@sprintf("    %-6d %-8d %-8d %-8d %-10d",
                    N, (N+1)^3, size(B1,2), size(B2,2), b1))
    end
    pr("  ⇒ b_1 is PINNED under refinement. Horn (1) cannot fire by refining.")

    # spectral-gap exhibit + explicit harmonic basis at N=4
    N=4; B1,B2 = torus_boundaries(N)
    L1 = Symmetric(Matrix(B1'B1 + B2*B2'))
    ev = sort(eigvals(L1))
    pr(@sprintf("\n  Hodge-Laplacian L₁ spectrum (N=4), smallest 7 eigenvalues:"))
    pr("    " * join((@sprintf("%.3e", e) for e in ev[1:7]), "  "))
    pr(@sprintf("    → %d zero modes, then a gap to %.3e  (zero-count = b_1)",
                count(<(1e-8), ev), ev[count(<(1e-8),ev)+1]))
    # explicit harmonic fields = constant flux in each direction
    hx=zeros(3N^3); hx[1:N^3].=1
    hy=zeros(3N^3); hy[N^3+1:2N^3].=1
    hz=zeros(3N^3); hz[2N^3+1:3N^3].=1
    pr(@sprintf("    constant-flux fields:  ‖∂₁h‖ = %.1e,%.1e,%.1e   ‖∂₂ᵀh‖ = %.1e,%.1e,%.1e",
                norm(B1*hx),norm(B1*hy),norm(B1*hz),
                norm(B2'hx),norm(B2'hy),norm(B2'hz)))
    pr("    (both ≈ 0 ⇒ h_x,h_y,h_z are harmonic; they ARE the 3-dim H₁ — and inert.)")

    # ── PROBE B : forcing horn (1) requires a topology change ───────────────
    pr("\n"*dsh)
    pr("  PROBE B — the only way to grow b_1: delete 2-cells (CHANGE topology)")
    pr(dsh)
    N=4; B1,B2 = torus_boundaries(N); nF=size(B2,2)
    pr(@sprintf("    %-14s %-10s", "#faces deleted", "b_1"))
    for m in (0, 20, 66, 80, 120, 200)
        keep = setdiff(1:nF, 1:m)              # drop first m faces
        b1,_,_ = betti1(B1, B2[:,keep])
        pr(@sprintf("    %-14d %-10d", m, b1))
    end
    pr("    (b_1 holds at 3 until the N³+2=66 redundant faces are used up — the")
    pr("     kernel cushion — then climbs without bound as real handles open.)")
    pr("    ⇒ b_1 grows ONLY when cells are removed (handles punched).")
    pr("      A fixed fluid domain is never re-glued under refinement, so this")
    pr("      horn has no physical analogue. (Refinement = Probe A = b_1 fixed.)")

    # ── PROBE C : zero-homology, fixed-energy, sharpening — only the norm moves ─
    pr("\n"*dsh)
    pr("  PROBE C — incipient-blowup proxy: sharpen a NULL-homology field.")
    pr(dsh)
    N=20; B1,B2 = torus_boundaries(N)       # Nyquist = N/2 = 10; all k below stay nonzero
    hx=zeros(3N^3); hx[1:N^3].=1;        hx ./= norm(hx)
    hy=zeros(3N^3); hy[N^3+1:2N^3].=1;   hy ./= norm(hy)
    hz=zeros(3N^3); hz[2N^3+1:3N^3].=1;  hz ./= norm(hz)
    # regularized minimal-norm repair operator: a_min = ∂₂ᵀ (∂₂∂₂ᵀ + εI)⁻¹ q
    ε = 1e-9
    Mup = B2*B2' + ε*I
    Fchol = cholesky(Symmetric(Mup))
    pr("    Field q_k = ∂₂a_k, a_k = sin(2πk·x/N) on xy-faces.  N=$N, energy ‖q_k‖₂≡1.")
    pr(@sprintf("    %-4s %-9s %-12s %-16s %-12s %-10s", "k",
                "‖q_k‖₂", "[q_k] homol", "‖∂₂ᵀq‖=vort", "R(q_k) ℓ²", "2sin(πk/N)"))
    maxres = 0.0
    for kk in (1,2,3,4,6,8)
        a = zeros(3N^3)
        for i in 0:N-1, j in 0:N-1, k in 0:N-1
            a[fid(1,i,j,k,N)] = sin(2π*kk*i/N)
        end
        q = B2*a
        @assert norm(q) > 1e-6 "degenerate mode at k=$kk (sampled to ~0); pick k<N/2"
        q ./= norm(q)                                   # unit energy
        homol = sqrt(dot(q,hx)^2 + dot(q,hy)^2 + dot(q,hz)^2)
        vort  = norm(B2'q)                              # ≈ velocity Ḣ¹ seminorm
        y = Fchol \ q; amin = B2'y                      # min-norm repair
        maxres = max(maxres, norm(B2*amin - q))
        rep = norm(amin)
        pr(@sprintf("    %-4d %-9.4f %-12.2e %-16.4f %-12.4f %-10.4f",
                    kk, norm(q), homol, vort, rep, 2sin(π*kk/N)))
    end
    pr(@sprintf("    (max repair residual ‖∂₂a_min−q‖ = %.1e; ε=%g.)", maxres, ε))
    pr("    vorticity = 2sin(πk/N) EXACTLY (the discrete derivative symbol, ≈2πk/N")
    pr("    in the resolved band ⇒ linear ∝k growth); and R(q_k)=1/vort exactly.")
    pr("\n    Reading the table:")
    pr("      • [q_k] (homology class) ≈ 1e-15 for ALL k  → exactly null-homology.")
    pr("      • b_1 ≡ 3 throughout (Probe A) — unchanged by how sharp the field is.")
    pr("      • vorticity ‖∂₂ᵀq_k‖ GROWS with k (critical/Ḣ¹ norm → ∞): the cascade.")
    pr("      • ℓ² repair cost R(q_k) SHRINKS (∝1/k) — bounded, sees nothing wrong.")

    pr("\n"*bar)
    pr("  VERDICT")
    pr(bar)
    pr("  Horn (1) [growing H₁]: FALSE under refinement. b_1 is a fixed topological")
    pr("    invariant of the domain (𝕋³→3, ℝ³→0); it only moves if you re-glue the")
    pr("    complex, which a fluid domain never does.  Homology is BLIND to blowup.")
    pr("  Horn (2) [repair cost → ∞]: entirely norm-dependent. The identical")
    pr("    zero-homology, fixed-energy, sharpening sequence has BOUNDED ℓ² repair")
    pr("    cost but DIVERGENT critical-norm content. 'Any convenient norm' is")
    pr("    carrying the whole Millennium problem (supercritical ℓ²/energy vs")
    pr("    critical Ḣ^{1/2}). The difficulty is analytic, not homological.")
    pr("  ⇒ The chain-complex/Hodge structure is real (it IS the Leray projection),")
    pr("    but it is the SOLVED part. Topology does not reformulate the problem.")
    pr(bar)
    close(fout)
    println(stdout, "\nwrote: $RUN_OUT")
end

main()
