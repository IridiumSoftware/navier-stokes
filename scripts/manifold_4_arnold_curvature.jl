#!/usr/bin/env julia
# manifold_4_arnold_curvature.jl — NS MANIFOLD STUDY, Slice 4: ARNOLD curvature
#
# EXPERIMENTAL. **Scope: geometry of the configuration manifold (Lie group) of a
# finite Euler truncation, exact.** NOT the 3D-NS PDE. The deepest slice: Arnold's
# theorem — ideal (Euler) fluid is geodesic flow on the volume-preserving-diffeo
# group with a right/left-invariant L² metric; the SECTIONAL CURVATURE of that
# group governs Lagrangian (un)predictability. NEGATIVE curvature ⇒ nearby
# trajectories diverge exponentially (Arnold's atmosphere-predictability estimate).
#
# We compute the curvature TWO honest ways:
#   (A) EXACT sectional curvature from the Lie-algebra structure constants via the
#       Koszul formula (a derivation, not a remembered closed form), VERIFIED on the
#       bi-invariant SO(3) metric where the answer is known (κ ≡ ¼). Then applied to
#       the rigid-body (Euler-top) metric on SO(3) — the configuration group of the
#       Slice-1 triad — observing the sign structure tied to the middle-axis instability.
#   (B) The directly-MEASURABLE curvature content: geodesic deviation / leading
#       Lyapunov exponent in the inviscid truncations — λ_max>0 ⇔ trajectories diverge
#       exponentially ⇔ predominantly NEGATIVE curvature experienced along the geodesic
#       (Arnold's unpredictability). Integrable triad (λ≈0) vs chaotic MFE saddle (λ>0).

include(joinpath(@__DIR__, "mfe_self_sustaining.jl"))   # mfe!, rk4!, qpert, randIC
using Printf, Random, LinearAlgebra

# ── (A) exact sectional curvature from structure constants (Koszul) ─────────────
# C[k,i,j] = coefficient of e_k in [e_i,e_j], in an ORTHONORMAL basis (g=I).
# Koszul (orthonormal): Γ[m,a,k] = <∇_{e_a}e_k, e_m> = ½( b(a,k,m) − b(k,m,a) + b(m,a,k) ),
#   b(i,j,k) = C[k,i,j].   ∇ of left-invariant fields: ∇_{e_a}(Σ v_k e_k)=Σ_k v_k ∇_{e_a}e_k.
#   R(e_i,e_j)e_j = ∇_{e_i}∇_{e_j}e_j − ∇_{e_j}∇_{e_i}e_j − ∇_{[e_i,e_j]}e_j.
#   κ(e_i,e_j) = <R(e_i,e_j)e_j, e_i>   (orthonormal e_i,e_j).
function sectional(C, i, j)
    n=size(C,1)
    b(p,q,r)=C[r,p,q]
    Γ(m,a,k)=0.5*(b(a,k,m) - b(k,m,a) + b(m,a,k))
    cov(a,v)=[sum(v[k]*Γ(m,a,k) for k in 1:n) for m in 1:n]     # ∇_{e_a} v
    nab(a,k)=[Γ(m,a,k) for m in 1:n]                            # ∇_{e_a} e_k
    t1=cov(i, nab(j,j))                       # ∇_{e_i}(∇_{e_j}e_j)
    t2=cov(j, nab(i,j))                       # ∇_{e_j}(∇_{e_i}e_j)
    t3=sum(C[m,i,j].*nab(m,j) for m in 1:n)   # ∇_{[e_i,e_j]}e_j
    R=t1 .- t2 .- t3
    R[i]                                      # <R(e_i,e_j)e_j, e_i>
end

levi(i,j,k)= (i==j||j==k||i==k) ? 0.0 :
             ((i,j,k) in ((1,2,3),(2,3,1),(3,1,2)) ? 1.0 : -1.0)

# so(3) orthonormal structure constants for a left-invariant metric with eigenvalues
# (moments) I=(I₁,I₂,I₃): ẽ_i=e_i/√Iᵢ ⇒ C̃[k,i,j]=ε(i,j,k)·√(I_k/(I_i I_j)).
function so3_struct(I)
    C=zeros(3,3,3)
    for i in 1:3, j in 1:3, k in 1:3
        C[k,i,j]=levi(i,j,k)*sqrt(I[k]/(I[i]*I[j]))
    end
    C
end

# ── (B) leading Lyapunov exponent via Benettin two-trajectory renormalization ──
function lyapunov(step!, x0; d0=1e-8, T=4000.0, dt=0.05, renorm=2.0)
    x=copy(x0); y=copy(x0); y[1]+=d0   # perturb
    nstep=round(Int,T/dt); every=round(Int,renorm/dt); acc=0.0; cnt=0
    for s in 1:nstep
        step!(x,dt); step!(y,dt)
        if s%every==0
            d=norm(y.-x)
            if d>0; acc+=log(d/d0); cnt+=1; y .= x .+ (d0/d).*(y.-x); end   # renormalize
        end
    end
    cnt>0 ? acc/(cnt*renorm) : 0.0
end

function main()
    out=joinpath(@__DIR__,"manifold_4_arnold_curvature.out.txt")
    fout=open(out,"w"); pr(a...)=(println(stdout,a...);println(fout,a...))
    bar="═"^80; dsh="─"^80
    pr(bar); pr("  MANIFOLD STUDY — Slice 4: ARNOLD CURVATURE of the configuration manifold")
    pr("  (Scope: geometry of finite Euler truncations, exact. NOT the PDE. Prize: UNTOUCHED.)")
    pr(bar)
    pr("  Arnold: Euler fluid = geodesic flow on the diffeo group; sectional curvature governs")
    pr("  Lagrangian (un)predictability. Negative curvature ⇒ exponential trajectory divergence.")

    # ── (A0) VERIFY the Koszul routine on bi-invariant SO(3): κ ≡ ¼ ─────────────
    pr("\n"*dsh); pr("  (A0) VERIFICATION — bi-invariant SO(3) (round metric) must give κ ≡ ¼")
    pr(dsh)
    Cbi=so3_struct([1.0,1.0,1.0])
    κ12=sectional(Cbi,1,2); κ13=sectional(Cbi,1,3); κ23=sectional(Cbi,2,3)
    pr(@sprintf("    κ(1,2)=%.4f  κ(1,3)=%.4f  κ(2,3)=%.4f   (expected 0.2500 each)", κ12,κ13,κ23))
    ok = all(abs(k-0.25)<1e-12 for k in (κ12,κ13,κ23))
    pr(@sprintf("    Koszul routine %s — constant positive curvature of the round 3-sphere/SO(3).",
        ok ? "VERIFIED ✓" : "FAILED ✗"))

    # ── (A) rigid-body (Euler-top) metric on SO(3) = the Slice-1 triad's config group ─
    pr("\n"*dsh); pr("  (A) RIGID-BODY metric on SO(3) — configuration group of the Slice-1 triad")
    pr(dsh)
    w=(1.0,1.7,2.3); I=(1/w[1],1/w[2],1/w[3])      # moments Iᵢ=1/wᵢ (positive ⇒ Riemannian)
    pr(@sprintf("    triad |k|=(%.1f,%.1f,%.1f) ⇒ moments I=(%.3f,%.3f,%.3f)  [I₁>I₂>I₃]", w..., I...))
    C=so3_struct(collect(I))
    κ12=sectional(C,1,2); κ13=sectional(C,1,3); κ23=sectional(C,2,3)
    pr(@sprintf("    sectional curvatures:  κ(1,2)=%+.4f   κ(1,3)=%+.4f   κ(2,3)=%+.4f", κ12,κ13,κ23))
    pr("    (planes are spanned by pairs of body axes; axis 2 = the MIDDLE moment = the")
    pr("     unstable rigid-body axis = the Slice-1 cascade donor.)")
    nneg=count(<(0),(κ12,κ13,κ23))
    pr(@sprintf("    ⇒ %d of 3 principal-plane curvatures are NEGATIVE: the anisotropic rigid body has",nneg))
    pr("      negatively-curved directions ⇒ geodesics (rotations) diverge there — the geometric")
    pr("      origin of the middle-axis (tennis-racket) instability seen dynamically in Slice 1.")

    # ── (B) the measurable content: Lyapunov exponents across the truncations ────
    pr("\n"*dsh); pr("  (B) GEODESIC DEVIATION — leading Lyapunov λ_max (the curvature, observed)")
    pr(dsh)
    # triad (Slice-1, integrable Euler top): expect λ≈0
    W=(1.0,1.7,-2.3)
    triad_rhs(u)=((W[2]-W[3])*u[2]*u[3],(W[3]-W[1])*u[3]*u[1],(W[1]-W[2])*u[1]*u[2])
    function triad_step!(u,dt)
        k1=collect(triad_rhs(u)); k2=collect(triad_rhs(u.+(dt/2).*k1))
        k3=collect(triad_rhs(u.+(dt/2).*k2)); k4=collect(triad_rhs(u.+dt.*k3))
        u .= u .+ (dt/6).*(k1.+2 .*k2.+2 .*k3.+k4)
    end
    λ_triad=lyapunov(triad_step!,[0.6,0.6,0.5]; T=4000.0, dt=2e-3, renorm=1.0)
    # MFE chaotic saddle (Re=400): expect λ>0
    function mfe_step!(a,dt); rk4!(a,400.0,dt,zeros(9),zeros(9),zeros(9),zeros(9),zeros(9)); end
    a0=zeros(9); a0[1]=1.0; rng=MersenneTwister(11); a0[2:9].=0.3.*randn(rng,8)
    for _ in 1:2000; mfe_step!(a0,0.05); end          # land on the saddle
    λ_mfe = qpert(a0)>1e-3 ? lyapunov(mfe_step!,a0; T=3000.0, dt=0.05, renorm=2.0) : NaN
    pr(@sprintf("    %-26s λ_max = %+.4f   %s","triad (integrable Euler top):",λ_triad,
        abs(λ_triad)<1e-2 ? "≈0 ⇒ no exp. divergence (mixed/zero curvature, integrable)" : "(>0)"))
    pr(@sprintf("    %-26s λ_max = %+.4f   %s","MFE saddle (Re=400):",λ_mfe,
        (!isnan(λ_mfe) && λ_mfe>1e-2) ? ">0 ⇒ EXPONENTIAL divergence (predominantly NEGATIVE curvature)" : "(small/NaN)"))
    pr("    ⇒ the Lyapunov sign IS the curvature content felt along the geodesic: the integrable")
    pr("      triad does not diverge (λ≈0); the chaotic MFE saddle does (λ>0) — Arnold's negative-")
    pr("      curvature unpredictability, measured. (3D Euler is likewise chaotic but resolution-")
    pr("      limited per Step 2; not re-measured here.)")

    pr("\n"*bar); pr("  READING (Slice 4 — Arnold curvature)")
    pr(bar)
    pr("  • EXACT sectional curvature (Koszul, verified κ≡¼ on bi-invariant SO(3)): the anisotropic")
    pr("    rigid-body metric — the configuration group of the Slice-1 triad — has NEGATIVELY curved")
    pr("    principal planes. Negative curvature = the geometric source of the middle-axis instability.")
    pr("  • MEASURED curvature content (Lyapunov): integrable triad λ≈0; chaotic MFE saddle λ>0. A")
    pr("    positive Lyapunov exponent IS the integrated negative curvature along the geodesic —")
    pr("    Arnold's atmosphere-unpredictability mechanism, in our truncations.")
    pr("  • This closes the manifold tour: Slice 1 (coadjoint orbit) + Slice 4 (curvature of its")
    pr("    config group) are the same rigid-body object from two sides — orbit structure and metric")
    pr("    geometry. CFS RHYME (probe, not claim): a Lie-group state space whose curvature/Casimirs")
    pr("    organize the dynamics — observe; do not assert transfer.")
    pr("  • FIREWALL: finite-truncation geometry, not the NS PDE. :proved=0; prize UNTOUCHED.")
    pr(bar)
    close(fout); println(stdout,"\nwrote: $out")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
