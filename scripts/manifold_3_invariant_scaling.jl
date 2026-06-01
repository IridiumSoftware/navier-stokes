#!/usr/bin/env julia
# manifold_3_invariant_scaling.jl — NS MANIFOLD STUDY, Slice 3: invariant coordinates
#                                    and the SCALING quotient
#
# EXPERIMENTAL. **Scope: geometry of a 3D pseudospectral truncation (exact algebra
# on a real divergence-free field).** NOT the 3D-NS PDE. This is the slice that
# directly tests Aaron's intuition: NS is bound to physics, so its invariants
# organize the state-space manifold — and "some scales are not meaningful."
#
# THE IDEA. Take a real state (a seeded divergence-free helical field on 𝕋³),
# embed it in invariant coordinates, then act with the NS SYMMETRY GROUP and
# observe how the invariants transform:
#   • ENERGY     E = ½⟨|u|²⟩
#   • HELICITY   H = ⟨u·ω⟩        (topological; the Casimir of Slice 1)
#   • ENSTROPHY  Ω = ½⟨|ω|²⟩
#   • PALINSTROPHY P = ½⟨|∇ω|²⟩
# under
#   • ROTATION (SO(3), COMPACT) — these are scalars/pseudoscalar ⇒ INVARIANT;
#   • SCALING  u↦λu(λx)  (NON-COMPACT, the NS-002 generator) — they are
#     SCALE-COVARIANT with exact exponents
#         E~λ⁻¹,  H~λ⁰ (invariant),  Ω~λ⁺¹,  P~λ⁺³.
# So under the scaling action, E,Ω,P are GAUGE (their absolute values carry no
# scale-free meaning); only SCALE-INVARIANT combinations descend to the quotient:
# H (topological) and EΩ (dimensionless). The scale-invariant quotient is exactly
# where the regularity question lives — the CRITICAL norm — and the fact that
# ENERGY is scale-covariant (E~λ⁻¹, vanishing as λ→∞) is SUPERCRITICALITY (NS-002)
# read geometrically: "the controlled invariant is meaningless at small scales."
#
# Reuses the validated 3D kernel from spectral_3d_control.jl (guarded include).

include(joinpath(@__DIR__, "spectral_3d_control.jl"))   # fft3/ifft3/make_ops/curl_hat/random_helical_ic/mean3
using Printf

k2idx(m,N) = m>=0 ? m+1 : m+N+1     # signed wavenumber → array index

function invariants(U, op, N)
    uh,vh,wh=U
    u=real.(ifft3(uh)); v=real.(ifft3(vh)); w=real.(ifft3(wh))
    ωxh,ωyh,ωzh=curl_hat(uh,vh,wh,op)
    ωx=real.(ifft3(ωxh)); ωy=real.(ifft3(ωyh)); ωz=real.(ifft3(ωzh))
    E=0.5*mean3(u.^2 .+ v.^2 .+ w.^2)
    H=mean3(u.*ωx .+ v.*ωy .+ w.*ωz)
    Ω=0.5*mean3(ωx.^2 .+ ωy.^2 .+ ωz.^2)
    P=0.0
    for ωh in (ωxh,ωyh,ωzh)
        gx=real.(ifft3(im.*op.kx.*ωh)); gy=real.(ifft3(im.*op.ky.*ωh)); gz=real.(ifft3(im.*op.kz.*ωh))
        P += 0.5*mean3(gx.^2 .+ gy.^2 .+ gz.^2)
    end
    (E=E,H=H,Ω=Ω,P=P)
end

# NS scaling u↦λu(λx), integer λ: in Fourier, mode k → λk with amplitude ×λ.
# Returns the scaled field and the number of source modes CLIPPED by the cutoff.
function scale_field(U, op, N, λ::Int)
    uh,vh,wh=U; cut=N÷2-1
    nu=zeros(ComplexF64,N,N,N); nv=zeros(ComplexF64,N,N,N); nw=zeros(ComplexF64,N,N,N)
    clipped=0
    for idx in CartesianIndices(uh)
        (abs(uh[idx])+abs(vh[idx])+abs(wh[idx])==0) && continue
        Kx=λ*Int(op.kx[idx]); Ky=λ*Int(op.ky[idx]); Kz=λ*Int(op.kz[idx])
        if abs(Kx)<=cut && abs(Ky)<=cut && abs(Kz)<=cut
            a=k2idx(Kx,N); b=k2idx(Ky,N); c=k2idx(Kz,N)
            nu[a,b,c]=λ*uh[idx]; nv[a,b,c]=λ*vh[idx]; nw[a,b,c]=λ*wh[idx]
        else
            clipped += 1
        end
    end
    (nu,nv,nw), clipped
end

# proper 90° rotation about z (det=+1): u'(x)=R u(R⁻¹x). Exact on the grid.
function rotate90z(U, op, N)
    uh,vh,wh=U
    u=real.(ifft3(uh)); v=real.(ifft3(vh)); w=real.(ifft3(wh))
    rg(A)=[A[j, N+1-i, k] for i in 1:N, j in 1:N, k in 1:N]   # sample at R⁻¹x (90° CCW)
    u1n=-rg(v); u2n=rg(u); u3n=rg(w)                          # apply R to the vector
    (fft3(u1n), fft3(u2n), fft3(u3n))
end

function main()
    out=joinpath(@__DIR__,"manifold_3_invariant_scaling.out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...))
    bar="═"^80; dsh="─"^80
    pr(bar); pr("  MANIFOLD STUDY — Slice 3: INVARIANT coordinates + the SCALING quotient")
    pr("  (Scope: geometry of a 3D truncation. NOT the PDE. Distance to prize: UNTOUCHED.)")
    pr(bar)
    pr("  Embed a real divergence-free state in (E,H,Ω,P); act with the symmetry group;")
    pr("  observe which invariants are scale-COVARIANT (gauge) vs scale-INVARIANT (meaningful).")

    N=32; op=make_ops(N)
    U=random_helical_ic(N,op; kmax=2, seed=20260601)     # low-mode ⇒ scaling stays resolved
    I0=invariants(U,op,N)
    pr(@sprintf("\n  state: seeded helical field (kmax=2), N=%d.  div-free; H≠0.",N))
    pr(@sprintf("    E=%.6f  H=%.6f  Ω=%.6f  P=%.6f", I0.E,I0.H,I0.Ω,I0.P))

    # ── (A) ROTATION (compact SO(3)) — invariants are genuine scalars ───────────
    pr("\n"*dsh); pr("  (A) ROTATION (90° about z; det=+1) — the COMPACT generator")
    pr(dsh)
    Ur=rotate90z(U,op,N); Ir=invariants(Ur,op,N)
    pr(@sprintf("    %-12s %-14s %-14s %-10s","invariant","original","rotated","Δrel"))
    for (nm,a,b) in (("E",I0.E,Ir.E),("H",I0.H,Ir.H),("Ω",I0.Ω,Ir.Ω),("P",I0.P,Ir.P))
        pr(@sprintf("    %-12s %-14.6f %-14.6f %.1e",nm,a,b,abs(b-a)/(abs(a)+1e-30)))
    end
    pr("    ⇒ E,Ω,P (scalars) and H (PSEUDOscalar) all INVARIANT to machine precision under a")
    pr("      proper rotation. Compact symmetry ⇒ the invariants live on its quotient already;")
    pr("      H's sign is preserved (a reflection would flip it). Rotation scales: meaningful as-is.")

    # ── (B) SCALING (non-compact, NS-002): field-frame exponents + the domain factor ─
    pr("\n"*dsh); pr("  (B) SCALING u↦λu(λx) — the NON-COMPACT generator (NS-002)")
    pr(dsh)
    pr("    Subtlety (got this right after a first wrong pass): the mode-shift k→λk on a FIXED")
    pr("    torus with a FIXED mean gives the FIELD-frame exponents E~λ², H~λ³, Ω~λ⁴, P~λ⁶.")
    pr("    Verify those are EXACT (ratio Iλ/(λ^p·I₀) → 1):")
    pr(@sprintf("    %-6s %-8s %-14s %-14s %-14s %-14s","λ","clipped",
        "E/(λ²E₀)","H/(λ³H₀)","Ω/(λ⁴Ω₀)","P/(λ⁶P₀)"))
    for λ in (2,3)
        Us,clip=scale_field(U,op,N,λ); Is=invariants(Us,op,N)
        pr(@sprintf("    %-6d %-8d %-14.6f %-14.6f %-14.6f %-14.6f",
            λ, clip, Is.E/(λ^2*I0.E), Is.H/(λ^3*I0.H), Is.Ω/(λ^4*I0.Ω), Is.P/(λ^6*I0.P)))
    end
    pr("    The NS scaling symmetry ALSO rescales the DOMAIN 𝕋_{2π}→𝕋_{2π/λ} — a λ⁻³ volume")
    pr("    factor in every integral. PHYSICAL exponent = field exponent − 3:")
    pr("        E ~ λ⁻¹   (SUPERCRITICAL: negative ⇒ →0 as λ→∞)")
    pr("        H ~ λ⁰    (SCALE-INVARIANT — the topological Casimir)")
    pr("        Ω ~ λ⁺¹ ,  P ~ λ⁺³   (scale-COVARIANT)")
    pr("    ⇒ the supercriticality lives in the DOMAIN/measure scaling, not the amplitude alone —")
    pr("      you cannot see it from field-scaling on a fixed box. Scale is a genuine coordinate.")

    # ── (C) the scale-INVARIANT quotient — the 'meaningful' coordinates ─────────
    pr("\n"*dsh); pr("  (C) THE SCALING QUOTIENT — physical exponent q of each combination (q=0 ⇒ descends)")
    pr(dsh)
    qE=-1; qH=0; qΩ=1; qP=3      # physical (domain-corrected) exponents
    pr(@sprintf("    %-16s %-14s %-s","combination","physical q","scale-invariant?"))
    combos=[("H", qH), ("E·Ω", qE+qΩ), ("E", qE), ("Ω", qΩ),
            ("E·√Ω", qE+qΩ/2), ("P/Ω²", qP-2qΩ), ("H/√(E·Ω)", qH-(qE+qΩ)/2)]
    for (nm,q) in combos
        pr(@sprintf("    %-16s %-14s %s", nm, @sprintf("λ^%g",q), q==0 ? "← YES (descends to quotient)" : "no (gauge)"))
    end
    pr("    ⇒ H (q=0) and E·Ω (q=−1+1=0) are SCALE-INVARIANT ⇒ the 'meaningful' coordinates of the")
    pr("      scaling quotient. The scale-invariant quotient is the CRITICAL level — exactly the norm")
    pr("      class (NS-002/NS-005) where regularity is decided; absolute E,Ω,P are pure gauge there.")

    pr("\n"*bar); pr("  READING (Slice 3 — invariant coordinates + scaling quotient)")
    pr(bar)
    pr("  • The symmetry group SPLITS the manifold's invariants two ways:")
    pr("    – ROTATION (compact): E,Ω,P,H are scalars/pseudoscalar ⇒ invariant. Meaningful as-is.")
    pr("    – SCALING (non-compact, NS-002): E~λ⁻¹, Ω~λ⁺¹, P~λ⁺³ are scale-COVARIANT (GAUGE);")
    pr("      only H~λ⁰ and E·Ω~λ⁰ are scale-INVARIANT and descend to the quotient.")
    pr("  • 'SOME SCALES ARE NOT MEANINGFUL' (Aaron) = the scaling-orbit directions: absolute E,Ω,P")
    pr("    are pure gauge; only scale-invariant combinations carry physics. Scale is a genuine")
    pr("    NON-COMPACT coordinate you must quotient — and the physical exponents need BOTH the")
    pr("    field-scaling AND the domain (measure) rescaling (the λ⁻³). Field-scaling alone misses it.")
    pr("  • SUPERCRITICALITY (NS-002), GEOMETRICALLY: the one Tier-1 coercive control, ENERGY, has")
    pr("    physical exponent −1 (E~λ⁻¹ → 0 as λ→∞) — gauge at small scales, so it cannot control the")
    pr("    scale-invariant (critical) quotient where blowup would live. The Step-2 resolution wall is")
    pr("    the SAME fact in numerical clothing: no finite grid resolves the scale-invariant tail.")
    pr("  • CFS RHYME (probe, not claim): invariant-coordinate + symmetry-quotient analysis is the")
    pr("    CFS method; here the invariants are NS's own physical ones. Observe; do not assert transfer.")
    pr("  • FIREWALL: 3D-truncation geometry, not the NS PDE. :proved=0; prize UNTOUCHED.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
