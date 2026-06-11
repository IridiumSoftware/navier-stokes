/-
  NormCalculus.lean — the norm-calculus substrate: derivative, Hessian and Laplacian
  of radial functions `y ↦ φ(‖y‖)` on a real inner product space.

  Ladder-3a of the Carleman plan (see docs/carleman_ladder0_tao_sec4_audit.md):
  the 3D identification that upgrades the ladder-2 RADIAL weight calculus to genuine
  vector calculus —

    * `hasFDerivAt_norm`  : `D‖·‖(x) = ‖x‖⁻¹ ⟪x, ·⟫`            (`x ≠ 0`)
    * `iteratedFDeriv_two_radial_apply` :
        `D²(φ∘‖·‖)(x)[v,w] = (φ'/r)⟪v,w⟫ + (φ''/r² − φ'/r³)⟪x,v⟫⟪x,w⟫`
        — in particular `Hess‖·‖ = (I − x̂x̂ᵀ)/‖x‖` (record-audit B11c)
    * `laplacian_radial`  : `Δ(φ∘‖·‖)(x) = φ''(r) + ((d−1)/r)·φ'(r)`

  These are generic inner-product-space facts (a verified Mathlib gap at the pinned
  rev: Mathlib has the pointwise `Laplacian` and `contDiffAt_norm`, but no
  computation lemmas for radial functions) — upstreamable.

  Firewall: `:proved` = 0 for the PDE, and stays 0 — library infrastructure.
-/
import Mathlib

open scoped RealInnerProductSpace

namespace NSCarleman
namespace NormCalculus

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]

/-! #### First derivative of the norm -/

/-- The Fréchet derivative of the norm on a real inner product space:
    `D‖·‖(x) = ‖x‖⁻¹ • ⟪x, ·⟫` away from the origin. -/
theorem hasFDerivAt_norm {x : E} (hx : x ≠ 0) :
    HasFDerivAt (fun y : E => ‖y‖) (‖x‖⁻¹ • innerSL ℝ x) x := by
  have h0 : ‖x‖ ^ 2 ≠ 0 := pow_ne_zero 2 (norm_ne_zero_iff.mpr hx)
  have h := (hasStrictFDerivAt_norm_sq x).hasFDerivAt.sqrt h0
  have hfun : (fun y : E => Real.sqrt (‖y‖ ^ 2)) = fun y : E => ‖y‖ := by
    funext y
    exact Real.sqrt_sq (norm_nonneg y)
  rw [hfun] at h
  convert h using 1
  rw [Real.sqrt_sq (norm_nonneg x)]
  ext v
  simp only [ContinuousLinearMap.coe_smul', Pi.smul_apply, two_smul,
    ContinuousLinearMap.add_apply, innerSL_apply_apply, smul_eq_mul]
  have hr : ‖x‖ ≠ 0 := norm_ne_zero_iff.mpr hx
  field_simp
  ring

/-- The gradient of the norm is the unit radial vector: `∇‖·‖(x) = x̂`. -/
theorem hasGradientAt_norm [CompleteSpace E] {x : E} (hx : x ≠ 0) :
    HasGradientAt (fun y : E => ‖y‖) (‖x‖⁻¹ • x) x := by
  have h := hasFDerivAt_norm hx
  rw [hasGradientAt_iff_hasFDerivAt]
  convert h using 1
  ext v
  simp [real_inner_smul_left]

/-- The radial chain rule: for `φ` differentiable at `‖y‖ ≠ 0` with derivative `d1`,
    `D(φ∘‖·‖)(y) = (d1·‖y‖⁻¹) • ⟪y, ·⟫`. -/
theorem hasFDerivAt_radial {φ : ℝ → ℝ} {d1 : ℝ} {y : E} (hy : y ≠ 0)
    (hφ : HasDerivAt φ d1 ‖y‖) :
    HasFDerivAt (fun z : E => φ ‖z‖) ((d1 * ‖y‖⁻¹) • innerSL ℝ y) y := by
  have h := hφ.comp_hasFDerivAt y (hasFDerivAt_norm hy)
  convert h using 1
  rw [smul_smul]

/-! #### Second derivative of radial functions -/

/-- **The radial Hessian** (record-audit B11c in vector form): for a radial function
    `f = φ∘‖·‖` with `φ` differentiable away from `0` (derivative function `d1`) and
    `d1` differentiable at `r = ‖x‖` (value `L2`),

    `D²f(x)[v,w] = (d1(r)/r)·⟪v,w⟫ + (L2/r² − d1(r)/r³)·⟪x,v⟫⟪x,w⟫`. -/
theorem iteratedFDeriv_two_radial_apply {φ d1 : ℝ → ℝ} {L2 : ℝ} {x : E} (hx : x ≠ 0)
    (hd1 : ∀ s : ℝ, s ≠ 0 → HasDerivAt φ (d1 s) s)
    (hd2 : HasDerivAt d1 L2 ‖x‖) (v w : E) :
    iteratedFDeriv ℝ 2 (fun y : E => φ ‖y‖) x ![v, w]
      = (d1 ‖x‖ / ‖x‖) * ⟪v, w⟫
        + (L2 / ‖x‖ ^ 2 - d1 ‖x‖ / ‖x‖ ^ 3) * (⟪x, v⟫ * ⟪x, w⟫) := by
  have hr : ‖x‖ ≠ 0 := norm_ne_zero_iff.mpr hx
  have hnorm := hasFDerivAt_norm hx
  -- the scalar coefficient `c y = d1‖y‖·‖y‖⁻¹` and its derivative at `x`
  have hnum : HasFDerivAt (fun y : E => d1 ‖y‖)
      (L2 • (‖x‖⁻¹ • innerSL ℝ x)) x := hd2.comp_hasFDerivAt x hnorm
  have hinv : HasFDerivAt (fun y : E => ‖y‖⁻¹)
      (-(‖x‖ ^ 2)⁻¹ • (‖x‖⁻¹ • innerSL ℝ x)) x :=
    (hasDerivAt_inv hr).comp_hasFDerivAt x hnorm
  have hc := HasFDerivAt.mul hnum hinv
  -- the CLM-valued first-derivative field `H y = c y • ⟪y, ·⟫` and its derivative
  have hH : HasFDerivAt (fun y : E => (d1 ‖y‖ * ‖y‖⁻¹) • innerSL ℝ y) _ x :=
    HasFDerivAt.smul hc (innerSL ℝ (E := E)).hasFDerivAt
  -- the first-derivative field of `f` agrees with `H` near `x`
  have heve : (fderiv ℝ fun y : E => φ ‖y‖)
      =ᶠ[nhds x] (fun y : E => (d1 ‖y‖ * ‖y‖⁻¹) • innerSL ℝ y) := by
    filter_upwards [isOpen_compl_singleton.mem_nhds
      (Set.mem_compl_singleton_iff.mpr hx)] with y hy
    have hy0 : y ≠ 0 := hy
    exact (hasFDerivAt_radial hy0 (hd1 ‖y‖ (norm_ne_zero_iff.mpr hy0))).fderiv
  rw [iteratedFDeriv_two_apply, Filter.EventuallyEq.fderiv_eq heve, hH.fderiv]
  simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons,
    ContinuousLinearMap.add_apply, ContinuousLinearMap.coe_smul', Pi.smul_apply,
    ContinuousLinearMap.smulRight_apply, ContinuousLinearMap.smul_apply,
    innerSL_apply_apply, smul_eq_mul, neg_smul, ContinuousLinearMap.neg_apply,
    Pi.mul_apply]
  show (d1 ‖x‖ * ‖x‖⁻¹) * ⟪v, w⟫
      + (d1 ‖x‖ * -((‖x‖ ^ 2)⁻¹ * (‖x‖⁻¹ * ⟪x, v⟫)) + ‖x‖⁻¹ * (L2 * (‖x‖⁻¹ * ⟪x, v⟫)))
        * ⟪x, w⟫
    = d1 ‖x‖ / ‖x‖ * ⟪v, w⟫ + (L2 / ‖x‖ ^ 2 - d1 ‖x‖ / ‖x‖ ^ 3) * (⟪x, v⟫ * ⟪x, w⟫)
  field_simp
  ring

/-- **The Hessian of the norm** (`φ = id`): `D²‖·‖(x)[v,w] = ⟪v,w⟫/‖x‖ − ⟪x,v⟫⟪x,w⟫/‖x‖³`
    — the matrix `(I − x̂x̂ᵀ)/‖x‖`, record-audit B11c. -/
theorem iteratedFDeriv_two_norm_apply {x : E} (hx : x ≠ 0) (v w : E) :
    iteratedFDeriv ℝ 2 (fun y : E => ‖y‖) x ![v, w]
      = ⟪v, w⟫ / ‖x‖ - (⟪x, v⟫ * ⟪x, w⟫) / ‖x‖ ^ 3 := by
  have hr : ‖x‖ ≠ 0 := norm_ne_zero_iff.mpr hx
  have h := iteratedFDeriv_two_radial_apply (φ := fun s => s) (d1 := fun _ => 1)
    (L2 := 0) hx (fun s _ => hasDerivAt_id' s) (hasDerivAt_const _ _) v w
  rw [h]
  field_simp
  ring

/-! #### The radial Laplacian -/

variable [FiniteDimensional ℝ E]

open Laplacian InnerProductSpace

/-- **The radial Laplacian** (the ladder-2 → 3D identification):
    `Δ(φ∘‖·‖)(x) = φ''(r) + ((d−1)/r)·φ'(r)` at `x ≠ 0`, where `d = dim E`,
    `φ' = d1` on punctured neighbourhoods and `φ''(r) = L2`. -/
theorem laplacian_radial {φ d1 : ℝ → ℝ} {L2 : ℝ} {x : E} (hx : x ≠ 0)
    (hd1 : ∀ s : ℝ, s ≠ 0 → HasDerivAt φ (d1 s) s)
    (hd2 : HasDerivAt d1 L2 ‖x‖) :
    Δ (fun y : E => φ ‖y‖) x
      = L2 + ((Module.finrank ℝ E : ℝ) - 1) / ‖x‖ * d1 ‖x‖ := by
  have hr : ‖x‖ ≠ 0 := norm_ne_zero_iff.mpr hx
  have hform := congrFun
    (laplacian_eq_iteratedFDeriv_orthonormalBasis (fun y : E => φ ‖y‖)
      (stdOrthonormalBasis ℝ E)) x
  rw [hform]
  have hterm : ∀ i, iteratedFDeriv ℝ 2 (fun y : E => φ ‖y‖) x
      ![stdOrthonormalBasis ℝ E i, stdOrthonormalBasis ℝ E i]
      = (d1 ‖x‖ / ‖x‖) * ⟪stdOrthonormalBasis ℝ E i, stdOrthonormalBasis ℝ E i⟫
        + (L2 / ‖x‖ ^ 2 - d1 ‖x‖ / ‖x‖ ^ 3)
          * (⟪x, stdOrthonormalBasis ℝ E i⟫ * ⟪x, stdOrthonormalBasis ℝ E i⟫) :=
    fun i => iteratedFDeriv_two_radial_apply hx hd1 hd2 _ _
  rw [Finset.sum_congr rfl fun i _ => hterm i, Finset.sum_add_distrib,
      ← Finset.mul_sum, ← Finset.mul_sum]
  have hsum1 : ∑ _i : Fin (Module.finrank ℝ E),
      ⟪stdOrthonormalBasis ℝ E _i, stdOrthonormalBasis ℝ E _i⟫
      = (Module.finrank ℝ E : ℝ) := by
    have h1 : ∀ i, ⟪stdOrthonormalBasis ℝ E i, stdOrthonormalBasis ℝ E i⟫ = (1 : ℝ) := by
      intro i
      rw [real_inner_self_eq_norm_sq, (stdOrthonormalBasis ℝ E).orthonormal.1 i]
      norm_num
    rw [Finset.sum_congr rfl fun i _ => h1 i]
    simp
  have hsum2 : ∑ i, ⟪x, stdOrthonormalBasis ℝ E i⟫ * ⟪x, stdOrthonormalBasis ℝ E i⟫
      = ‖x‖ ^ 2 := by
    have h := OrthonormalBasis.sum_sq_inner_left (stdOrthonormalBasis ℝ E) x
    rw [← h]
    exact Finset.sum_congr rfl fun i _ => (sq _).symm
  rw [hsum1, hsum2]
  field_simp
  ring

/-- `Δ‖·‖(x) = (d−1)/‖x‖` away from the origin. -/
theorem laplacian_norm {x : E} (hx : x ≠ 0) :
    Δ (fun y : E => ‖y‖) x = ((Module.finrank ℝ E : ℝ) - 1) / ‖x‖ := by
  have h := laplacian_radial (φ := fun s => s) (d1 := fun _ => 1) (L2 := 0) hx
    (fun s _ => hasDerivAt_id' s) (hasDerivAt_const _ _)
  simpa using h

end NormCalculus
end NSCarleman

#eval "Norm-calculus substrate (radial gradient/Hessian/Laplacian) — machine-verified."
