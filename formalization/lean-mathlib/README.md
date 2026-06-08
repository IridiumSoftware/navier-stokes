# `formalization/lean-mathlib/` — universal Lean theorems (Mathlib-backed)

The Mathlib upgrade of Rung 0: the scaling-criticality calculus proved for **ALL**
parameters (`∀ α p q : ℚ`), not just at exemplar triples. Complements — does not
replace — the hermetic, zero-dependency `../lean/Scaling.lean` (which proves the
concrete instances by `native_decide`, no Mathlib).

`:proved` = 0 for the PDE, and stays 0: these are theorems about the **scaling
exponents** (criticality bookkeeping), the algebra the analysis stands on — not the
inequalities/theorems.

## What is proved (`ScalingUniversal.lean`)
- **`lebExp_critical_iff (α p q : ℚ)`** — the norm `‖|x₃|^α u^θ‖_{L^q_t L^p_x}` is
  scale-invariant iff `2/q + 3/p = 1 − α` (the WHWY criticality), for **all** α,p,q.
- **`sobExp_critical_iff (s : ℚ)`** — Ḣ^s critical iff `s = 1/2`, for all s.
- **`energy_supercritical`** — `[L²] < 0` (NS-002), and `lebExp_eq` / `energy_gap`
  give the exact algebraic form and the σ=−1 vs σ=0 gap.
Proofs: `linarith` / `norm_num` over ℚ (the criticality iff is a linear rearrangement
in the atoms {α, 3/p, 2/q}).

## Verification status
**Verified** by `lake env lean ScalingUniversal.lean` against the built Mathlib of the
TCE `src/lean4-cv` project (Mathlib rev `5d69f04…`, toolchain `v4.30.0-rc2`). A
deliberately-false variant (`= 2−α` in place of `1−α`) was correctly **rejected** by
`linarith` — confirming Mathlib genuinely loaded and the checker is sound, not
rubber-stamping.

## Reproduce standalone
```
cd formalization/lean-mathlib
lake exe cache get      # fetch the prebuilt Mathlib oleans for the pinned rev (no rebuild)
lake build              # exits 0 iff ScalingUniversal type-checks
```
Pinned (lockfile discipline): `lean-toolchain` (v4.30.0-rc2) + `lake-manifest.json`
(Mathlib `5d69f04…` + transitive deps), mirroring TCE `src/lean4-cv` so the populated
global Mathlib cache (`~/.cache/mathlib`) is reused.

## Rung 1?
Universal (∀-quantified) Lean theorems for the Rung-1 differential identities would
need Mathlib's `MvPolynomial`/`Finsupp` + derivation machinery (a larger formalization
than this linear-arithmetic upgrade). The Rung-1 *core* is already machine-verified by
`native_decide` in `../lean/Axisym.lean`; a universal Mathlib version is the next
heavier step if wanted.
