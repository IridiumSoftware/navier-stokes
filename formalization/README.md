# `formalization/` — the verification ladder (Python → Julia → Haskell → Lean)

Hardens the NS obstruction program's **definitions + algebraic skeleton** past the C5 social-verification
floor (see `docs/c5_adversarial_pass_2026-06-07.md`, `docs/c5_triad_witness_verdict.md`) by walking each
*algebraic/differential identity* back from exploration to machine verification. Scoped in
`docs/formalization_scope_2026-06-07.md`.

**Firewall (unchanged):** this machine-hardens the **scaling/structural DEFINITIONS and exact identities**,
**not** the PDE theorems. The load-bearing *inequalities* (anisotropic Hardy–Sobolev, Carleman) are
analysis — they do not fit the algebra→category rungs and have no Lean substrate (Rung 2+, multi-year).
**`:proved` = 0 for the PDE, and stays 0.**

## The ladder + evidence types
| Rung | Language | Evidence type | Role |
|---|---|---|---|
| explore | Python | computational | prototype / discover the identity |
| **algebraic** | **Julia** | `algebraic` (exact `Rational`/symbolic = proof) | the algebra must close *exactly* |
| **categorical** | **Haskell** | `type-checked` | the definitions-as-types; structure must type-check |
| **machine** | **Lean** | `lean-proved` | machine-verified — ✅ Rungs 0–1 core (`native_decide`, hermetic) + Rungs 0–1 **universal** (`∀`, Mathlib) |

Each rung is a **gate**: an identity that fails to close exactly (Julia) or type-check (Haskell) is caught
before the expensive Lean step.

## Status

### Rung 0 — scaling-criticality calculus (NS-034 / NS-002 skeleton) — ✅ Julia + Haskell + **Lean**
The exact scaling exponents `[X]` (defined by `‖u_λ‖_X = λ^[X]‖u‖_X` under `u_λ(x,t)=λ^f u(λx,λ²t)`) and
the criticality classification (`[X]=0` critical · `>0` sub · `<0` super):
- `L³` and `Ḣ^{1/2}` **critical** (`[X]=0`); `L²` (energy) **supercritical** (`[X]=−1/2`, the NS-002 wall);
  `L^∞` subcritical; the cross-family coherence `Ḣ⁰ = L²`; and the anisotropic `|x₃|^α` criticality
  **`[X]=0 ⇔ 2/q+3/p = 1−α`** (the WHWY condition), all verified as **exact rational identities**.
- `scaling/scaling_criticality.jl` — **algebraic** evidence (Julia Base only; derives every exponent from
  the change-of-variables bookkeeping, checks each criticality condition exactly).
- `scaling/Scaling.hs` — **type-checked** evidence (base only; the norm taxonomy as a total sum type, the
  exponent map total on it, criticality as the kernel-structured classification + the `Ḣ⁰=L²` coherence).
- `lean/Scaling.lean` — **lean-proved** (hermetic; `native_decide` at exemplar triples; bundled Std).
- `lean-mathlib/ScalingUniversal.lean` — **lean-proved, UNIVERSAL** (Mathlib): the criticality conditions
  proved for **all** `α,p,q : ℚ` — `lebExp_critical_iff` (`[X]=0 ⇔ 2/q+3/p=1−α`, ∀), `sobExp_critical_iff`
  (Ḣ^s critical ⇔ s=1/2, ∀), `energy_supercritical`. Via `linarith`/`norm_num`; verified against the TCE
  `lean4-cv` built Mathlib (a deliberately-false variant was correctly rejected). See its README.
- **All layers AGREE** (algebraic / type-checked / machine / universal-machine) — cross-verified.
- *Scope note:* this verifies the **scaling-exponent facts** that *underlie* NS-002/NS-034 (energy is
  supercritical; the critical spaces are scale-invariant). It does **not** verify the full obstruction
  *narrative* (that supercriticality kills energy-only methods — that is NS-008/Tao, an inequality).

### Rung 1 — axisymmetric structural calculus (the NS-048 core) — ✅ Julia + Haskell + **Lean** (`native_decide` core + **universal** Mathlib)
The load-bearing differential identities the whole NS-048 arc rests on, verified EXACTLY via a tiny
**hermetic Laurent-polynomial engine** (no CAS dependency — `Symbolics.jl` was *not* needed; the
identities are formal differential-algebraic identities, exact on Laurent monomials/polynomials):
- **(I) the swirl `Γ=r u^θ` obeys a SOURCE-FREE transport–diffusion equation** (the maximum-principle
  basis) — via the operator identity `L_Γ(r u^θ) = r·lap_ang(u^θ)` (proved *monomial-by-monomial* ⇒ all
  fields, by linearity) + the transport identity `transport(Γ)=r·(D/Dt+Coriolis)u^θ`, closed by the `u^θ`
  momentum equation. So `∂_tΓ+b·∇Γ−ν L_Γ Γ = 0` (no production).
- **(II) the sole `Ω=ω^θ/r` source** `S=(1/r⁴)∂_z(Γ²)=(2Γ/r⁴)∂_zΓ=∂_z(u₁²)` (`u₁=Γ/r²`), and its
  **centrifugal origin** `(1/r)∂_z((u^θ)²/r)=(1/r⁴)∂_z((ru^θ)²)`.
- `axisym/axisym_structural.jl` — **algebraic** evidence (Julia Base only; the Laurent-poly engine +
  exact derivations).
- `axisym/AxisymStructural.hs` — **type-checked / categorical** evidence (base only; the same algebra,
  with `∂_r,∂_z,∂_t` verified to be **derivations** (Leibniz law) on the field-algebra — so the identities
  are equalities of algebra elements).
- **(III) the full `Ω`-evolution operator** (`axisym/axisym_operators.jl` + `axisym/AxisymOperators.hs`):
  the `ω^θ→Ω` transform cancels the stretching `(u^r/r)ω^θ`, turns `∂_r²+(1/r)∂_r−1/r²+∂_z²` into the
  `Ω`-operator `∂_r²+(3/r)∂_r+∂_z²` (the `(3/r)∂_r` *emerges*; the `1/r²` cancels), and turns the `ω^θ`
  swirl source `∂_z((u^θ)²/r)` into `S=(1/r⁴)∂_z(Γ²)`; the pressure drops because `∂_r,∂_z` commute (the curl
  kills `∇p`). **(IV) Biot–Savart:** with the Stokes stream function `ψ` (`u^r=−∂_zψ`, `u^z=(1/r)∂_r(rψ)`),
  `ω^θ=−(∂_r²+(1/r)∂_r−1/r²+∂_z²)ψ` and `∇·b=0` identically.
- `lean/Axisym.lean` — **lean-proved** core (hermetic; `native_decide` over the Laurent engine on a
  monomial grid: the Γ source-free operator, the `(3/r)∂_r` emergence, the source identities).
- `lean-mathlib/AxisymUniversal.lean` — **lean-proved, UNIVERSAL** (Mathlib): the **full** operator set
  for **all** `u : MvPolynomial (Fin 3) ℚ` — `gamma_source_free_operator`, `gamma_transport`,
  `omega_operator_transform` (the `(3/r)∂_r` emergence), `source_chain` + `z_indep_r_power`, `pderiv_comm`
  + `pressure_elimination`, and `biot_savart`. Stated in denominator-cleared (`×rᵏ`) polynomial form (≡ the
  `1/r` identity for `r≠0`); proved by `pderiv`+`ring` (`pderiv_comm` by induction); verified against
  Mathlib (a false `2/r`-for-`3/r` variant was correctly rejected). See its README.
- **All layers AGREE.** Rung 1 is **complete** across all four layers (algebraic / type-checked / machine /
  universal-machine), the universal layer now covering the full operator set incl. pressure elimination +
  Biot–Savart. The full operator structure of `∂_tΩ+b·∇Ω=ν(∂_r²+(3/r)∂_r+∂_z²)Ω+S` is exact. *Scope:* the
  structural definitions/identities/operators — the algebra the analysis stands on; NOT the inequalities.

### Rung 2 — the inequalities — 🟡 STARTED (bite-by-bite); substrate is further along than feared
A 2026-06-08 survey (web + grep of the actual Mathlib source) corrected an earlier "multi-year, field-wide"
over-estimate. **Already formalized:** Sobolev spaces (`Mathlib/Analysis/Distribution/Sobolev.lean`),
Gagliardo–Nirenberg–Sobolev (`Mathlib/Analysis/FunctionalSpaces/SobolevInequality.lean`), De Giorgi–Nash–
Moser regularity (Armstrong–Kempe 2026, `github.com/scottnarmstrong/DeGiorgi`), Fefferman's NS Millennium
statement (`lean-dojo/LeanMillenniumPrizeProblems`), and the distribution-function/Chebyshev machinery
(`mul_meas_ge_le_pow_eLpNorm'`). **Confirmed gaps** (each a discrete, load-bearing library addition):
Lorentz/weak-Lᵖ; Littlewood–Paley/Besov; Carleman estimates; full Leray–Hopf weak-solution theory.
- **First bite ✅ `lean-mathlib/WeakLp.lean`** — the **weak-Lᵖ (Lorentz `L^{p,∞}`) quasinorm** `wnorm`, the
  membership predicate `MemWLp`, and: the **`Lᵖ ⊆ L^{p,∞}` embedding** `wnorm_le_eLpNorm` (from
  `mul_meas_ge_le_pow_eLpNorm'`), **monotonicity** `wnorm_mono`, and the **quasi-triangle inequality**
  `wnorm_add_le` (`‖f+g‖_{p,∞} ≤ 2(‖f‖+‖g‖)`, `1≤p<∞` — weak-Lᵖ is a *quasi*-normed space). Load-bearing:
  weak-`L³` is where the Ożański–Palasek double-log rate lives; reusable across harmonic analysis. Verified
  against Mathlib. (Upstreamable — no existing `wnorm`/`weakLp`/`MemWLp`.)
- *Next bites (priority order):* Marcinkiewicz interpolation → Besov/Littlewood–Paley → Carleman.
  `:proved`=0 for the PDE throughout — these are library additions, not NS theorems.

## Run
```
julia formalization/scaling/scaling_criticality.jl      # Rung 0 algebraic (exact Rational)
runghc formalization/scaling/Scaling.hs                  # Rung 0 type-checked
julia formalization/axisym/axisym_structural.jl         # Rung 1 algebraic (Γ source-free, source S)
julia formalization/axisym/axisym_operators.jl          # Rung 1 algebraic (Ω-operator, Biot–Savart)
runghc formalization/axisym/AxisymStructural.hs         # Rung 1 type-checked (derivations)
runghc formalization/axisym/AxisymOperators.hs          # Rung 1 type-checked
lean   formalization/lean/Scaling.lean                  # Rung 0 lean-proved (native_decide, hermetic)
lean   formalization/lean/Axisym.lean                   # Rung 1 lean-proved core (native_decide, hermetic)
cd formalization/lean-mathlib && lake exe cache get && lake build   # universal Rungs 0–1 + Rung-2 WeakLp (Mathlib)
```
Both exit non-zero on any identity failing to close.

## Toolchain (the reproducibility pin for a zero-dependency track)
- **Julia 1.12.6** — Base only, no external packages (no `Manifest.toml` needed; nothing to pin beyond the
  version).
- **GHC / runghc 9.6.7** — `base` only (no Cabal deps).
- **Lean 4.30.0** (hermetic track, `lean/`) — `import Std` (bundled with the toolchain; **no Mathlib, no
  external Batteries fetch**); facts proved by `native_decide`. Pin: `formalization/lean/lean-toolchain`.
  *(`ℚ` works as `Rat`; Lean's `Rat` convention `x/0=0` is exactly our `1/∞=0` ∞-sentinel.)*
- **Lean 4.30.0-rc2 + Mathlib** (opt-in universal track, `lean-mathlib/`) — `∀`-quantified theorems via
  `linarith`/`norm_num`. Pinned in `lean-mathlib/{lean-toolchain,lake-manifest.json}` (Mathlib `5d69f04…`),
  mirroring TCE `src/lean4-cv` to reuse the populated Mathlib cache. Heavy; opt-in.
- **Both rungs are zero-dependency** (Base/base only) — `Symbolics.jl` was deliberately *avoided* in favor
  of a tiny hermetic Laurent-polynomial engine, keeping the whole track dependency-free. (A future heavier
  symbolic derivation — e.g. the full `Ω`-evolution operator — may warrant `Symbolics.jl` under a pinned
  `Manifest.toml`; not needed yet.)
