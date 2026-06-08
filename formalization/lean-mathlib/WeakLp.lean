/-
  WeakLp.lean — Rung 2, FIRST BITE: weak-Lᵖ (Lorentz L^{p,∞}) quasinorm + the Lᵖ ⊆ L^{p,∞} embedding.

  A confirmed gap in Mathlib (no `wnorm`/`weakLp`/`MemWLp`), but the foundation is present:
  `mul_meas_ge_le_pow_eLpNorm'` (Chebyshev–Markov in Lᵖ form) gives
      tᵖ · μ{t ≤ ‖f‖ₑ} ≤ ‖f‖_{Lᵖ}ᵖ.
  Load-bearing for the NS program: the Ożański–Palasek double-log blow-up rate lives in weak-`L³` =
  `L^{3,∞}`; and weak-Lᵖ is bedrock harmonic analysis (Marcinkiewicz interpolation). Built directly on
  Mathlib measure theory. `:proved` = 0 for the PDE — this is reusable library infrastructure, not a
  Navier–Stokes theorem.

  Pin: leanprover/lean4 v4.30.0-rc2 + Mathlib (see lake-manifest.json).
-/
import Mathlib
open MeasureTheory ENNReal

namespace NSWeakLp

variable {α E : Type*} {m : MeasurableSpace α} {μ : Measure α} {p : ℝ≥0∞} [NormedAddCommGroup E]

/-- The **weak-Lᵖ (Lorentz `L^{p,∞}`) quasinorm**: the supremum over thresholds `t` of
    `t · (distribution function at t)^{1/p}`, where the distribution function is `μ {x | t ≤ ‖f x‖ₑ}`. -/
noncomputable def wnorm (f : α → E) (p : ℝ≥0∞) (μ : Measure α) : ℝ≥0∞ :=
  ⨆ t : ℝ≥0∞, t * μ {x | t ≤ ‖f x‖ₑ} ^ (p.toReal)⁻¹

/-- **`Lᵖ ⊆ L^{p,∞}` (the strong–weak embedding):** the weak-Lᵖ quasinorm is dominated by the
    Lᵖ seminorm, for `0 < p < ∞`. This is the foundational fact of Lorentz-space theory; here it follows
    directly from Chebyshev–Markov in Lᵖ form (`mul_meas_ge_le_pow_eLpNorm'`). -/
theorem wnorm_le_eLpNorm (hp0 : p ≠ 0) (hp_top : p ≠ ∞)
    {f : α → E} (hf : AEStronglyMeasurable f μ) :
    wnorm f p μ ≤ eLpNorm f p μ := by
  have hpr : 0 < p.toReal := ENNReal.toReal_pos hp0 hp_top
  refine iSup_le fun t => ?_
  have e1 : (t ^ p.toReal * μ {x | t ≤ ‖f x‖ₑ}) ^ (p.toReal)⁻¹
          = t * μ {x | t ≤ ‖f x‖ₑ} ^ (p.toReal)⁻¹ := by
    rw [ENNReal.mul_rpow_of_nonneg _ _ (by positivity), ← ENNReal.rpow_mul,
        mul_inv_cancel₀ hpr.ne', ENNReal.rpow_one]
  calc t * μ {x | t ≤ ‖f x‖ₑ} ^ (p.toReal)⁻¹
      = (t ^ p.toReal * μ {x | t ≤ ‖f x‖ₑ}) ^ (p.toReal)⁻¹ := e1.symm
    _ ≤ (eLpNorm f p μ ^ p.toReal) ^ (p.toReal)⁻¹ := by
        gcongr
        exact mul_meas_ge_le_pow_eLpNorm' μ hp0 hp_top hf t
    _ = eLpNorm f p μ := by
        rw [← ENNReal.rpow_mul, mul_inv_cancel₀ hpr.ne', ENNReal.rpow_one]

#eval "Rung 2 (first bite): weak-Lᵖ quasinorm + Lᵖ ⊆ L^{p,∞} embedding — machine-verified."

end NSWeakLp
