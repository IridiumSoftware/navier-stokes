# Companion — the criticality–Casimir hinge (NS-036)

**2026-06-01.** Analytic, resolution-free tightening of the obstruction-program
write-up's §5 capstone ("three routes, one wall") from an asserted analogy into an
exact implication chain — the one move left on the program that *strengthens* a claim
rather than gating it on resolution. **Scope: NS scaling identities + an elementary
interpolation + the exact 2D/3D Euler Casimir algebra. NOT the 3D-NS PDE. `:proved` = 0;
distance to the prize UNTOUCHED.** Spec entry: **NS-036** (`:argued`).

## §1 — Computational basis

- **Source (new):** `scripts/criticality_casimir_hinge.jl` (+ `.out.txt`). Std-lib Julia
  (`Random`, `Printf`); no deps; runs in <1 s. Works directly on the integer-wavenumber
  grid with nonnegative spectral weights `w(k)=|û(k)|²` (the inequality is field-agnostic
  — div-free/real structure is irrelevant — so no FFT or projection is needed).
- **Inputs:** (1) 200 generic random spectra on `k∈[−6,6]³\{0}` with a mild `1/(1+k²)²`
  envelope; (2) scale-pure single-shell spectra (`|k|²∈{1,2,3,5,6,9,14}`).
- **Upstream (exact, established):** NS-034 (scaling exponents `σ(Ḣ^s)=s−½`); NS-033
  Slice 6 (the 2D `∫f(ω)` Casimir family vs. 3D helicity-only — verified to 1.000000).
- **Run:** `julia scripts/criticality_casimir_hinge.jl`.

## §2 — Results

The capstone is now a derivation. Put the controlled and the deciding quantities on one
homogeneous-Sobolev ladder (quadratic-quantity dilation exponent σ):

| quantity | norm | σ | role |
|---|---|---|---|
| energy | `‖u‖²_{L²}=‖u‖²_{Ḣ⁰}` | **−1** | a-priori controlled (SUPERcritical) |
| *critical* | `‖u‖²_{Ḣ^{1/2}}` (≅ `L³`, Prodi–Serrin) | **0** | regularity-deciding |
| enstrophy | `‖u‖²_{Ḣ¹}=‖ω‖²_{L²}` | **+1** | regularity-sufficient (SUBcritical) |

**(a) ≡ (b), joined at enstrophy.** Energy (σ=−1) and enstrophy (σ=+1) are symmetric
about the critical line σ=0, and the deciding quantity is *exactly* their geometric-mean
midpoint, by the elementary exact interpolation (Cauchy–Schwarz, splitting `|k|=|k|⁰·|k|¹`):

> `‖u‖²_{Ḣ^{1/2}} ≤ ‖u‖_{L²} · ‖u‖_{Ḣ¹}`.

So **bounded energy + bounded enstrophy ⇒ bounded critical norm ⇒ regular.** Energy is
always controlled; the whole 3D question collapses to **one rung**: *can enstrophy be
a-priori bounded?* — which **is** the Casimir question (Slice 6) verbatim:
- **2D.** Enstrophy `∫ω²` is a Casimir (stretching `(ω·∇)u≡0`) ⇒ σ=+1 rung controlled ⇒
  critical norm controlled ⇒ **regular**.
- **3D.** The Casimir family collapses to **helicity alone**, itself **σ=0 (critical) and
  sign-indefinite** (coercive over no norm); the σ=+1 rung loses its conservation law,
  enstrophy grows by stretching ⇒ no upper input on the subcritical side ⇒ **open**.

The common mechanism is the **vortex-stretching production** `P=∫ω·Sω`: the term that
breaks the enstrophy Casimir (b), the reason the σ=+1 rung is uncontrolled (a), and the
normalized object `S_ω` the diagnostic track found to be the right `σ=0`-robust detector.
"Enstrophy non-coercivity" is the **name of the joint** of (a) and (b), not a third fact.

**(c) is independent — and 2D proves it.** Arnold's negative-curvature result is on
SDiff(𝕋²), the **2D, globally regular** case. Negative curvature ⇒ Lagrangian
unpredictability in a setting with **no blowup**: curvature governs *sensitivity*
(geodesic spreading), not *singularity* (norm inflation). This **corrects** the earlier
"one fact, three costumes": the honest picture is **(a) ≡ (b)** (one structural fact) **with
(c) an independent companion** — the same "two notions" lesson Slice 2 taught.

**Numerical check (the load-bearing combining-step):**
- Generic multi-scale spectra (200 seeds): `max ratio (lhs/rhs) = 0.8710` ≤ 1 — strict.
- Scale-pure single shells: `ratio = 1.000000000000` (max `|ratio−1| = 5.6e−16`).
- ⇒ the interpolation is **sharp**, with equality **iff** the spectrum is scale-pure. The
  gap below 1 *is* the multi-scale (cascade) content; scale-purity is the laminar limit
  where the geometric-mean bound is tight.

## §3 — Verification

**Type — algebraic + example/property-tested (computational):**
- *Algebraic (exact, a proof of the sub-pieces):* the exponents are exact rationals
  (NS-034); the interpolation `‖u‖²_{Ḣ^{1/2}} ≤ ‖u‖_{L²}‖u‖_{Ḣ¹}` is elementary
  Cauchy–Schwarz on `∫|k||û|² = ∫(|û|²)^{1/2}(|k|²|û|²)^{1/2}`; the 2D/3D Casimir facts
  are the exact Euler structure verified in Slice 6.
- *Computed:* `criticality_casimir_hinge.jl` confirms the inequality (ratio ≤ 0.87 generic)
  and its **sharpness** (ratio = 1.000 iff single-shell). Generator: random complex
  Gaussian amplitudes with a `1/(1+k²)²` envelope; single-shell control for the equality
  case. Asserted outputs: `max ratio ≤ 1`; `|ratio−1| < 1e−10` on every shell.
- *Honest scope of the test:* it verifies the **interpolation sub-claim**, not the
  entry-level equivalence. Per the conjunctive-claim rule, the entry-level claim
  (the full (a)≡(b)+(c)-independent synthesis) stays **`:argued`** — the test does not
  upgrade it. And nothing here bears on the PDE: it sharpens *why* the controlled quantity
  (energy) sits on the wrong side of criticality and *why* the conservation-law route to
  the enstrophy bound is open in 3D; it does **not** close that inequality.

## §4 — Spec impact

- **S-ID:** NS-036.
- **Key:** "criticality–Casimir hinge — supercriticality ≡ Casimir deficit, joined at
  enstrophy; curvature independent."
- **Logic tier:** ANALYSIS / GEOMETRY (synthesis of NS-034 ⊕ NS-033 Slice 6).
- **Evidence type:** algebraic + computed.
- **Depends_on:** NS-034, NS-033 (Slice 6), NS-002, NS-005.
- **Status:** `:argued` (firewall: framing/synthesis, not a regularity proof; `:proved`=0).

*Firewall: NS scaling + elementary interpolation + ideal-flow Casimirs; not the 3D-NS PDE;
viscosity breaks the Casimirs anyway. `:proved` = 0; distance to the prize UNTOUCHED.
Metabolized by Claude, 2026-06-01.*
