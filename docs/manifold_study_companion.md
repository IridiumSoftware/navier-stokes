# Companion — the NS state-space manifold study (4 slices)

**2026-06-01.** A CFS-style geometric reconnaissance of the NS state-space
manifold: instead of time-stepping toward a (resolution-limited) singularity, we
characterize the **geometry** of the state space and its invariant foliation —
**exactly, with no resolution wall** (the thing the Step-2 blowup hunt kept
hitting). Four slices, in order: the coadjoint orbit, the edge manifold, the
invariant/scaling quotient, and the Arnold curvature. **Scope: geometry of
finite truncations / exact algebra — NOT the 3D-NS PDE, NOT a regularity claim.
Distance to the prize: UNTOUCHED; `:proved` = 0.**

The framing (Arnold): incompressible Euler is geodesic flow on the
volume-preserving-diffeomorphism group with the L² metric — a Lie–Poisson system
whose state space is **foliated by the `physical_invariants.md` Tier-1 invariants**
(energy = metric/Hamiltonian; helicity = Casimir; etc.) with the symmetry group
(rotation, scaling) acting. The CFS *method* (study an invariant-foliated state
space by its Casimirs + symmetry decomposition, slice it, observe) transfers; the
invariants themselves are NS's own physical ones. The CFS↔NS structural rhyme is
treated as a **probe, not a claim** (NS-024 discipline).

---

## §1 — Computational basis

All scripts std-lib Julia; reuse the validated kernels (guarded `include`s).

| Slice | Script | Reuses |
|---|---|---|
| 1 coadjoint orbit | `scripts/manifold_1_coadjoint_triad.jl` | NS-022 triad (rigid body) |
| 2 edge manifold | `scripts/manifold_2_edge_manifold.jl` | `mfe_self_sustaining.jl` (NS-021) |
| 3 invariant/scaling | `scripts/manifold_3_invariant_scaling.jl` | `spectral_3d_control.jl` (NS-010 3D) |
| 4 Arnold curvature | `scripts/manifold_4_arnold_curvature.jl` | `mfe_self_sustaining.jl`; inline triad |

Each writes a `.out.txt` beside it. Curvature (Slice 4) is computed from
structure constants via the **Koszul formula** (a derivation, not a remembered
closed form), **verified** on the bi-invariant SO(3) metric (κ≡¼).

---

## §2 — Results

### Slice 1 — the coadjoint orbit (EXACT)
The Waleffe helical triad (NS-022) is exactly the Euler rigid body, a Lie–Poisson
system on so(3)\*: the **Casimir = energy** labels the symplectic leaf (a 2-sphere
= **the manifold**); the **helicity Hamiltonian** foliates it into polhodes.
- **Critical structure (exact):** 3 axis-pole pairs — the middle signed leg is a
  **saddle** (λ²=+2.31, growth σ=1.52); the two extremes are **centers**
  (ω=1.67, 3.63). The middle = the cascade donor (NS-022).
- A **homoclinic separatrix** at H=w₁E partitions the orbit into two basins
  (72.5% / 27.5% of sphere area); period **diverges** into it (≈4.95 at the
  separatrix vs ~1 generic) — critical slowing.
- Invariants held to **~1e-13** along every polhode; analytic λ² match the
  numeric Jacobian. The cascade-donor mechanism *is* the orbit's geometry.

### Slice 2 — the edge manifold (MFE 9-mode)
The codim-1 boundary between laminar basin and turbulent saddle, located by edge
tracking (bisection), Re=350.
- **Located:** A_edge=0.0135; first-passage time grows **logarithmically** toward
  it, T≈5.3·ln(1/d), giving the edge state's transverse rate **σ≈0.188** — the 9D
  analog of Slice-1's separatrix slowing.
- **Edge state:** SSP structure in balance, **shear+streak dominated**
  (a1=0.99, a2=0.09); the roll a3 is **small** (0.0027).
- **The gate — honest correction:** the ±ε flip test shows the edge-manifold
  **normal is multi-mode** (a2,a4,a5,a6,a8 cross it) while the **roll a3 is
  ~TANGENT** (does not flip the fate). So **"a3 is the gate" does NOT hold as the
  geometric edge normal.** The NS-023 committor result ("a3 *surviving a dip*
  predicts recovery") is a *conditional-on-trajectory* statement — a **different
  object** from the edge normal. **Two notions, not one** (an NS-024-style
  distinction; the earlier expectation that they coincide is refuted).

### Slice 3 — invariant coordinates + the scaling quotient
A real divergence-free helical state embedded in (E, H, Ω, P), acted on by the
symmetry group.
- **Rotation (compact SO(3)):** E, Ω, P (scalars) and H (pseudoscalar) all
  invariant to **1e-15**; H's sign preserved (proper rotation). Meaningful as-is.
- **Scaling (non-compact, NS-002) — honest correction:** the Fourier mode-shift
  on a fixed torus gives the **field-frame exponents** E~λ², H~λ³, Ω~λ⁴, P~λ⁶
  (verified exact). The NS scaling symmetry **also rescales the domain**
  (𝕋₂π→𝕋_{2π/λ}, a λ⁻³ volume factor); the **physical exponent = field − 3**:
  **E~λ⁻¹ (supercritical), H~λ⁰ (invariant), Ω~λ⁺¹, P~λ⁺³**. *Supercriticality
  lives in the measure/scale, not the amplitude — invisible from field-scaling on
  a fixed box.*
- **The scaling quotient:** physical exponent 0 ⇒ descends. **H** (q=0) and
  **E·Ω** (q=−1+1=0) and **H/√(E·Ω)** are scale-INVARIANT — the "meaningful"
  coordinates; absolute E, Ω, P are gauge. The scale-invariant quotient *is* the
  critical-norm class (NS-002/005) where regularity is decided. "Some scales are
  not meaningful" (Aaron) = the scaling-orbit directions, made exact.

### Slice 4 — Arnold curvature
Sectional curvature of the configuration group via Koszul, **verified κ≡¼** on
bi-invariant SO(3).
- **Rigid-body metric** (the Slice-1 triad's config group, moments
  I=(1, 0.588, 0.435)): κ(1,2)=+0.96, κ(1,3)=+0.95, **κ(2,3)=−0.91**. The
  anisotropy drives **one negatively-curved plane** (containing the middle axis)
  — the geometric origin of the rigid-body / cascade-donor instability. (The
  isotropic case gives κ≡+¼ everywhere; anisotropy bends one plane negative.)
- **Measured content (Lyapunov):** integrable triad **λ_max≈+0.002 (≈0)**;
  chaotic MFE saddle **λ_max≈+0.016 (>0)**. A positive Lyapunov exponent *is* the
  integrated negative curvature along the geodesic — Arnold's
  atmosphere-unpredictability mechanism, in our truncations.
- Slices 1 and 4 are the **same rigid-body object** from two sides — orbit
  structure (Casimir foliation) and metric geometry (curvature).

### Slice 3 — RIGOROUS follow-up (NS-034: the scaling-exponent calculus)
The Slice-3 reading ("supercriticality = the non-compact scaling quotient") was
the most load-bearing finding, so it was upgraded to an **exact calculus**
(`scripts/manifold_3b_criticality.jl`). The NS dilation `D_λ` assigns every
homogeneous norm an exact rational exponent `‖u_λ‖_X=λ^{σ_X}‖u‖_X`:
`σ(L^q)=1−3/q`, `σ(Ḣ^s)=s−½`, `σ(L^p_tL^q_x)=1−3/q−2/p`.
- **Classification:** CRITICAL (σ=0, scale-invariant, descends to the dilation
  quotient) = {L³, Ḣ^{1/2}, BMO⁻¹, **Prodi–Serrin–ESS 2/p+3/q=1**}; SUPERCRITICAL
  (σ<0) = the a-priori-controlled **energy (σ=−1)** and **dissipation (σ=−1)**.
- **Verified:** `σ(Ḣ^s)=s−½` recovered to quadrature precision for continuous
  λ (s=0→λ^{−½} decays; s=½→≡1 flat = critical; s=1→λ^{+½} grows); the PS borderline
  `2/p+3/q=1` ⟺ σ=0 exactly.
- **Supercriticality as a precise descent failure:** the regularity question is
  scale-invariant (lives on the quotient); the controlled quantities have σ<0 (a
  Leray bound `‖u‖_{L²}≤M` gives `‖u_λ‖_{L²}≤λ^{−½}M→0`, vacuous at small scales);
  the regularity-deciding norms have σ=0 (uncontrolled). **Controlled σ<0, deciding
  σ=0, no overlap — the wall, exactly. This unifies NS-002 with NS-005.**
- The analytic exponents are **exact (algebraic)**; the entry (NS-034) is `:argued`
  because it *frames* the obstruction (standard criticality theory, re-derived +
  verified) and proves no regularity. `:proved` unchanged (0).

### Slice 5 — Arnold curvature of SDiff(T²), the ∞-dim group (`manifold_5_sdiff_curvature.jl`)
The ∞-dim sibling of Slice 4: Arnold (1966) — 2D ideal flow is geodesic motion on
the area-preserving diffeomorphism group SDiff(T²) with the L² metric, and its
sectional curvature is mostly negative (the geometric root of weather
unpredictability). Built the algebra exactly: velocity modes `v_k=ik^⊥e^{ik·x}`,
bracket `[v_k,v_l]=−(k×l)v_{k+l}` (derived), energy metric `⟨v_k,v_k⟩∝|k|²`,
coadjoint `B(v_k,v_l)=(k×l)(|k|²/|k−l|²)v_{k−l}`, connection
`∇=½([,]−B−B)`. The sectional curvature `C(v_k,v_l)` is a finite computation
(Arnold: only modes within 2 brackets of {k,l}); computed on the closed set
`{a·k+b·l: a,b∈−3..3}`.
- **Verified:** parallel modes `k∥l` (k×l=0) ⇒ commuting flows ⇒ **C=0 (flat)**,
  exactly; curvature **symmetric** C(k,l)=C(l,k).
- **Sign census** (k,l ∈ [−3,3]², 2256 sections, DATA not assertion): **NEGATIVE
  84%** (Arnold — predominantly negatively curved) / **POSITIVE 9%** (Misiołek —
  genuine positive sections exist, e.g. C((2,2),(2,1))=+0.35) / flat 6% (incl. k∥l).
  **Both Arnold and Misiołek reproduced.**
- **Predictability:** negative κ ⇒ forecast error δ(t)≈δ₀e^{t/τ}, rate
  1/τ=|v|√(−κ) (Jacobi). Arnold's atmosphere figures ⇒ e-folding ~few days, ~10⁵
  amplification over 2 months = "5 more digits to forecast 2 months ahead" ⇒ ~2-week
  practical horizon. Our curvature has the right SIGN/structure; absolute rate is
  normalization-dependent (flagged). Slices 1+4+5 are one Lie-group object — orbit,
  finite curvature, ∞-dim curvature.

---

## §3 — Verification

- **Type:** `computed`, exact/deterministic. Slice 1 invariants to 1e-13;
  Slice 3 rotation to 1e-15 and scaling exponents exact; Slice 4 curvature
  **verified against the known bi-invariant value κ≡¼**. Slice 2 is a numerical
  edge-tracking with a measured slowing law.
- **Scope: geometry of finite truncations.** Not a PDE statement; `:proved`
  unchanged (0).
- **Honest corrections recorded** (not buried): (i) Slice 2 — a3 is *tangent* to
  the edge manifold, not its normal; committor-gate ≠ edge-normal (two notions);
  (ii) Slice 3 — field-frame vs physical scaling exponents differ by the λ⁻³
  domain factor (first pass conflated them); the supercritical exponents require
  the domain rescaling.

What is established: an **exact geometric characterization** of the NS
truncations' state-space manifold — coadjoint-orbit structure, a separating edge
manifold with measured slowing, the scaling quotient that makes supercriticality
geometric, and verified negative curvature. What is **not**: anything about the
3D-NS PDE.

---

## §4 — Spec impact

- **NS-033 — Geometric structure of the NS state-space manifold (4-slice study).**
  The Euler/NS truncations' state space is a Lie–Poisson manifold foliated by the
  physical invariants: (1) the triad's coadjoint orbit (Casimir=energy sphere,
  helicity-Hamiltonian polhodes, saddle=cascade donor, exact); (2) the MFE edge
  manifold (laminar|turbulent boundary, measured logarithmic slowing σ≈0.19, edge
  state shear+streak-dominated, **gate is multi-mode — a3 tangent, refuting the
  naive "a3=gate"**); (3) the symmetry quotient — rotation-invariant scalars vs
  the scaling (NS-002) non-compact direction where E,Ω,P are gauge and only
  scale-invariant H, E·Ω descend (supercriticality = energy's physical exponent
  −1, requiring the domain rescaling); (4) Arnold sectional curvature (Koszul,
  verified κ≡¼; anisotropic rigid body has a negative plane; Lyapunov λ>0 on the
  chaotic saddle vs ≈0 integrable triad).
  - Evidence: computed (exact where stated; curvature verified). **Status:
    :tested. Scope: geometry of finite truncations — NOT the PDE.**
  - Depends_on: NS-021 (MFE), NS-022 (triad), NS-010 (3D solver), NS-002 (scaling).
  - Source: `scripts/manifold_{1,2,3,4}_*.jl` (+ `.out.txt`), this companion.

**The takeaway.** The manifold study delivers what the blowup hunt could not: an
**exact** structural picture — and it independently re-derives the firewall's own
thesis. Supercriticality (NS-002) reappears as the non-compact scaling direction
of the invariant quotient (Slice 3); the cascade donor reappears as a coadjoint
saddle (Slice 1) and a negatively-curved plane (Slice 4); and the transition gate
turns out to be a *different object* from the edge-manifold normal (Slice 2). None
of it moves the PDE — but it maps the terrain exactly, and that is the honest
value of going geometric.
