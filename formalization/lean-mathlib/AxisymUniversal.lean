/-
  AxisymUniversal.lean — Rung 1, UNIVERSAL machine-verified theorems (`lean-proved`)

  The load-bearing axisymmetric structural identities proved for ALL fields
  (∀ u : MvPolynomial (Fin 3) ℚ), not on a finite monomial grid — the Mathlib
  upgrade of the hermetic `native_decide` Rung-1 file (`../lean/Axisym.lean`).

  Variables: X 0 = r, X 1 = z, X 2 = t;  pderiv 0 = ∂_r, pderiv 1 = ∂_z, pderiv 2 = ∂_t.
  Proofs: `pderiv`'s product/linearity simp lemmas + `ring`.

  DENOMINATOR-CLEARING. The structural identities carry 1/r, 1/r² factors; each is
  stated here in the form obtained by multiplying through by the relevant power of r
  — a POLYNOMIAL identity, EQUIVALENT to the 1/r form wherever r ≠ 0 (multiplying by
  rᵏ is reversible for r ≠ 0). Proving it `∀ u : MvPolynomial` is the formal
  differential-algebraic content (all polynomial fields); the native_decide file
  checks a monomial grid, this file is genuinely ∀-quantified.

  Pin: leanprover/lean4 v4.30.0-rc2 + Mathlib 5d69f04… (see lake-manifest.json).
  `:proved` = 0 for the PDE, stays 0 — these are the structural definitions/identities.
-/
import Mathlib
open MvPolynomial

namespace NSAxisym

abbrev P := MvPolynomial (Fin 3) ℚ          -- r = X 0, z = X 1, t = X 2

/-- **(I-op) Γ source-free operator identity** (cleared ×r), the maximum-principle basis:
    `r·L_Γ(r u) = r·(r·lap_ang u)`, i.e. `∂_r²−(1/r)∂_r+∂_z²` on `Γ=r u^θ` matches
    `r·(∂_r²+(1/r)∂_r−1/r²+∂_z²)` on `u^θ` — for ALL `u`. -/
theorem gamma_source_free_operator (u : P) :
    X 0 * pderiv 0 (pderiv 0 (X 0 * u)) - pderiv 0 (X 0 * u) + X 0 * pderiv 1 (pderiv 1 (X 0 * u))
      = (X 0)^2 * pderiv 0 (pderiv 0 u) + X 0 * pderiv 0 u - u + (X 0)^2 * pderiv 1 (pderiv 1 u) := by
  simp; ring

/-- **(I-tr) Γ transport identity** (no clearing needed — already polynomial):
    `transport(Γ) = r·(material + Coriolis) u^θ`, for ALL `u, uʳ, uᶻ`. With (I-op) and
    the `u^θ` momentum equation this gives `∂_tΓ + b·∇Γ − ν L_Γ Γ = 0` (source-free). -/
theorem gamma_transport (u ur uz : P) :
    pderiv 2 (X 0 * u) + ur * pderiv 0 (X 0 * u) + uz * pderiv 1 (X 0 * u)
      = X 0 * (pderiv 2 u + ur * pderiv 0 u + uz * pderiv 1 u) + ur * u := by
  simp; ring

/-- **(III-d) the Ω = ω^θ/r operator transform** (cleared ×r): the viscous operator
    `∂_r²+(1/r)∂_r−1/r²+∂_z²` becomes the Ω-operator `∂_r²+(3/r)∂_r+∂_z²` — **the `(3/r)∂_r`
    emerges and the `1/r²` cancels** — for ALL `w`. -/
theorem omega_operator_transform (w : P) :
    X 0 * pderiv 0 (pderiv 0 (X 0 * w)) + pderiv 0 (X 0 * w) - w + X 0 * pderiv 1 (pderiv 1 (X 0 * w))
      = (X 0)^2 * pderiv 0 (pderiv 0 w) + 3 * X 0 * pderiv 0 w + (X 0)^2 * pderiv 1 (pderiv 1 w) := by
  simp; ring

/-- **(II) the Ω source chain rule:** `∂_z(Γ²) = 2 Γ ∂_zΓ` (= the cleared
    `(1/r⁴)∂_z(Γ²) = (2Γ/r⁴)∂_zΓ`), for ALL `Γ`. -/
theorem source_chain (g : P) : pderiv 1 (g * g) = 2 * g * pderiv 1 g := by
  simp; ring

/-- **(II') z-independence of r-powers:** `∂_z(rᵏ · f) = rᵏ · ∂_z f`, for ALL `f`, ALL `k`.
    This is what lets `1/r²`, `1/r⁴` factor through `∂_z` — giving `S = ∂_z(u₁²)` with
    `u₁ = Γ/r²` from the chain rule above. -/
theorem z_indep_r_power (f : P) (k : ℕ) : pderiv 1 ((X 0)^k * f) = (X 0)^k * pderiv 1 f := by
  simp

#eval "Rung 1 (Lean/Mathlib): universal axisymmetric structural identities machine-verified."

end NSAxisym
