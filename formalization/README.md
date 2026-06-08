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
| **machine** | **Lean** | `lean-proved` | the machine-verified theorem (`native_decide`) — ✅ Rungs 0–1 core |

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
- **Both pass and AGREE** (identical exponents + classifications) — cross-language verified.
- *Scope note:* this verifies the **scaling-exponent facts** that *underlie* NS-002/NS-034 (energy is
  supercritical; the critical spaces are scale-invariant). It does **not** verify the full obstruction
  *narrative* (that supercriticality kills energy-only methods — that is NS-008/Tao, an inequality).

### Rung 1 — axisymmetric structural calculus (the NS-048 core) — ✅ Julia + Haskell + **Lean** (core identities)
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
- **Both pass and AGREE.** Rung 1 is **complete** at the algebraic/categorical level: the full operator
  structure of `∂_tΩ+b·∇Ω=ν(∂_r²+(3/r)∂_r+∂_z²)Ω+S` is exact. *Scope:* the structural
  *definitions/identities/operators* — the algebra the analysis stands on; NOT the inequalities/theorems.

### Rung 2+ — the inequalities — ⬜ long-horizon (flagged not-now)

## Run
```
julia formalization/scaling/scaling_criticality.jl      # Rung 0 algebraic (exact Rational)
runghc formalization/scaling/Scaling.hs                  # Rung 0 type-checked
julia formalization/axisym/axisym_structural.jl         # Rung 1 algebraic (Γ source-free, source S)
julia formalization/axisym/axisym_operators.jl          # Rung 1 algebraic (Ω-operator, Biot–Savart)
runghc formalization/axisym/AxisymStructural.hs         # Rung 1 type-checked (derivations)
runghc formalization/axisym/AxisymOperators.hs          # Rung 1 type-checked
lean   formalization/lean/Scaling.lean                  # Rung 0 lean-proved (native_decide)
lean   formalization/lean/Axisym.lean                   # Rung 1 lean-proved core (native_decide)
```
Both exit non-zero on any identity failing to close.

## Toolchain (the reproducibility pin for a zero-dependency track)
- **Julia 1.12.6** — Base only, no external packages (no `Manifest.toml` needed; nothing to pin beyond the
  version).
- **GHC / runghc 9.6.7** — `base` only (no Cabal deps).
- **Lean 4.30.0** — `import Std` (bundled with the toolchain; **no Mathlib, no external Batteries fetch**);
  facts proved by `native_decide`. Pin: `formalization/lean/lean-toolchain`. *(`ℚ` works as `Rat`; Lean's
  `Rat` convention `x/0=0` is exactly our `1/∞=0` ∞-sentinel.)*
- **Both rungs are zero-dependency** (Base/base only) — `Symbolics.jl` was deliberately *avoided* in favor
  of a tiny hermetic Laurent-polynomial engine, keeping the whole track dependency-free. (A future heavier
  symbolic derivation — e.g. the full `Ω`-evolution operator — may warrant `Symbolics.jl` under a pinned
  `Manifest.toml`; not needed yet.)
