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

/-- **Membership in weak-Lᵖ (`L^{p,∞}`):** AE-strongly-measurable with finite weak-Lᵖ quasinorm —
    mirrors Mathlib's `MemLp`. -/
def MemWLp (f : α → E) (p : ℝ≥0∞) (μ : Measure α) : Prop :=
  AEStronglyMeasurable f μ ∧ wnorm f p μ < ∞

/-- **Monotonicity** of the weak-Lᵖ quasinorm in the pointwise enorm. -/
theorem wnorm_mono {f g : α → E} (h : ∀ x, ‖f x‖ₑ ≤ ‖g x‖ₑ) :
    wnorm f p μ ≤ wnorm g p μ := by
  simp only [wnorm]
  refine iSup_le fun t => le_iSup_of_le t ?_
  gcongr
  exact h _

/-- **Quasi-triangle inequality** for weak-Lᵖ (`1 ≤ p < ∞`): `‖f+g‖_{p,∞} ≤ 2(‖f‖_{p,∞}+‖g‖_{p,∞})`.
    Weak-Lᵖ is a *quasi*-normed space — the triangle inequality holds only up to the constant `2`. -/
theorem wnorm_add_le (hp1 : 1 ≤ p) (hp_top : p ≠ ∞) (f g : α → E) :
    wnorm (f + g) p μ ≤ 2 * (wnorm f p μ + wnorm g p μ) := by
  have hp0 : p ≠ 0 := fun h => by simp [h] at hp1
  have h1 : (1 : ℝ) ≤ p.toReal := by simpa using ENNReal.toReal_mono hp_top hp1
  have hpr : 0 < p.toReal := lt_of_lt_of_le one_pos h1
  have hinv0 : (0 : ℝ) ≤ (p.toReal)⁻¹ := by positivity
  have hinv1 : (p.toReal)⁻¹ ≤ 1 := by rw [inv_le_one₀ hpr]; exact h1
  simp only [wnorm]
  refine iSup_le fun t => ?_
  -- per-summand bound: t · μ{t/2 ≤ ‖h‖ₑ}^{1/p} ≤ 2 · ‖h‖_{p,∞}
  have bound : ∀ h : α → E, t * μ {x | t / 2 ≤ ‖h x‖ₑ} ^ (p.toReal)⁻¹
      ≤ 2 * ⨆ s : ℝ≥0∞, s * μ {x | s ≤ ‖h x‖ₑ} ^ (p.toReal)⁻¹ := fun h => by
    calc t * μ {x | t / 2 ≤ ‖h x‖ₑ} ^ (p.toReal)⁻¹
        = 2 * ((t / 2) * μ {x | t / 2 ≤ ‖h x‖ₑ} ^ (p.toReal)⁻¹) := by
          rw [← mul_assoc, two_mul, ENNReal.add_halves]
      _ ≤ 2 * ⨆ s : ℝ≥0∞, s * μ {x | s ≤ ‖h x‖ₑ} ^ (p.toReal)⁻¹ := by
          gcongr
          exact le_iSup (fun s : ℝ≥0∞ => s * μ {x | s ≤ ‖h x‖ₑ} ^ (p.toReal)⁻¹) (t / 2)
  -- the superlevel set of f+g at t splits into the half-level sets of f and g
  have hsub : {x | t ≤ ‖(f + g) x‖ₑ} ⊆ {x | t / 2 ≤ ‖f x‖ₑ} ∪ {x | t / 2 ≤ ‖g x‖ₑ} := by
    intro x hx
    simp only [Set.mem_setOf_eq, Pi.add_apply] at hx
    simp only [Set.mem_union, Set.mem_setOf_eq]
    by_contra hcon
    simp only [not_or, not_le] at hcon
    obtain ⟨hf, hg⟩ := hcon
    refine absurd hx (not_le.mpr ?_)
    calc ‖f x + g x‖ₑ ≤ ‖f x‖ₑ + ‖g x‖ₑ := enorm_add_le (f x) (g x)
      _ < t / 2 + t / 2 := ENNReal.add_lt_add hf hg
      _ = t := ENNReal.add_halves t
  have hmeas : μ {x | t ≤ ‖(f + g) x‖ₑ}
      ≤ μ {x | t / 2 ≤ ‖f x‖ₑ} + μ {x | t / 2 ≤ ‖g x‖ₑ} :=
    (measure_mono hsub).trans (measure_union_le _ _)
  calc t * μ {x | t ≤ ‖(f + g) x‖ₑ} ^ (p.toReal)⁻¹
      ≤ t * (μ {x | t / 2 ≤ ‖f x‖ₑ} + μ {x | t / 2 ≤ ‖g x‖ₑ}) ^ (p.toReal)⁻¹ := by gcongr
    _ ≤ t * (μ {x | t / 2 ≤ ‖f x‖ₑ} ^ (p.toReal)⁻¹ + μ {x | t / 2 ≤ ‖g x‖ₑ} ^ (p.toReal)⁻¹) := by
        gcongr; exact ENNReal.rpow_add_le_add_rpow _ _ hinv0 hinv1
    _ = t * μ {x | t / 2 ≤ ‖f x‖ₑ} ^ (p.toReal)⁻¹ + t * μ {x | t / 2 ≤ ‖g x‖ₑ} ^ (p.toReal)⁻¹ := by
        rw [mul_add]
    _ ≤ 2 * (⨆ s : ℝ≥0∞, s * μ {x | s ≤ ‖f x‖ₑ} ^ (p.toReal)⁻¹)
          + 2 * ⨆ s : ℝ≥0∞, s * μ {x | s ≤ ‖g x‖ₑ} ^ (p.toReal)⁻¹ := add_le_add (bound f) (bound g)
    _ = 2 * ((⨆ s : ℝ≥0∞, s * μ {x | s ≤ ‖f x‖ₑ} ^ (p.toReal)⁻¹)
          + ⨆ s : ℝ≥0∞, s * μ {x | s ≤ ‖g x‖ₑ} ^ (p.toReal)⁻¹) := by rw [mul_add]

#eval "Rung 2 (first bite): weak-Lᵖ quasinorm + Lᵖ ⊆ L^{p,∞} embedding + props — machine-verified."

end NSWeakLp
