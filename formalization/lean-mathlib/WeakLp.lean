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

/-- **Distribution-function bound from the weak-Lᵖ quasinorm:** the superlevel-set measure obeys
    `μ {x | s ≤ ‖f x‖ₑ} ≤ (‖f‖_{p,∞} / s)^p` — the Chebyshev-type inequality that defines weak-Lᵖ. -/
theorem meas_le_wnorm_div_rpow (hp0 : p ≠ 0) (hp_top : p ≠ ∞)
    (f : α → E) {s : ℝ≥0∞} (hs0 : s ≠ 0) (hs_top : s ≠ ∞) :
    μ {x | s ≤ ‖f x‖ₑ} ≤ (wnorm f p μ / s) ^ p.toReal := by
  have hpr : 0 < p.toReal := ENNReal.toReal_pos hp0 hp_top
  have h1 : s * μ {x | s ≤ ‖f x‖ₑ} ^ (p.toReal)⁻¹ ≤ wnorm f p μ :=
    le_iSup (fun t : ℝ≥0∞ => t * μ {x | t ≤ ‖f x‖ₑ} ^ (p.toReal)⁻¹) s
  have h2 : μ {x | s ≤ ‖f x‖ₑ} ^ (p.toReal)⁻¹ ≤ wnorm f p μ / s :=
    (ENNReal.le_div_iff_mul_le (Or.inl hs0) (Or.inl hs_top)).mpr (by rwa [mul_comm])
  calc μ {x | s ≤ ‖f x‖ₑ}
      = (μ {x | s ≤ ‖f x‖ₑ} ^ (p.toReal)⁻¹) ^ p.toReal := by
        rw [← ENNReal.rpow_mul, inv_mul_cancel₀ hpr.ne', ENNReal.rpow_one]
    _ ≤ (wnorm f p μ / s) ^ p.toReal := by gcongr

/-- **Weak-Lᵖ interpolation (the Marcinkiewicz core), function form:** if `f` lies in weak-Lᵖ and
    weak-L^q with `0 < p < r < q < ∞`, then `f ∈ Lʳ`. Proof: layer-cake + the two-tail split — the
    `p`-tail controls small `t` (since `r > p`), the `q`-tail controls large `t` (since `r < q`). -/
theorem eLpNorm_lt_top_of_wnorm {q r : ℝ≥0∞} (hp0 : p ≠ 0) (hpr : p < r) (hrq : r < q)
    (hq_top : q ≠ ∞) {f : α → E} (hf : AEStronglyMeasurable f μ)
    (hfp : wnorm f p μ < ∞) (hfq : wnorm f q μ < ∞) :
    eLpNorm f r μ < ∞ := by
  -- exponent bookkeeping
  have hq_lt : q < ∞ := hq_top.lt_top
  have hr_top : r ≠ ∞ := (hrq.trans hq_lt).ne
  have hp_top : p ≠ ∞ := ((hpr.trans hrq).trans hq_lt).ne
  have hr0 : r ≠ 0 := fun h => absurd hpr (by simp [h])
  have hq0 : q ≠ 0 := fun h => absurd hrq (by simp [h])
  have hpr_pos : 0 < p.toReal := ENNReal.toReal_pos hp0 hp_top
  have hrr_pos : 0 < r.toReal := ENNReal.toReal_pos hr0 hr_top
  have hqr_pos : 0 < q.toReal := ENNReal.toReal_pos hq0 hq_top
  have h_pr_rr : p.toReal < r.toReal := ENNReal.toReal_strict_mono hr_top hpr
  have h_rr_qr : r.toReal < q.toReal := ENNReal.toReal_strict_mono hq_top hrq
  -- reduce to the lintegral
  rw [eLpNorm_eq_lintegral_rpow_enorm_toReal hr0 hr_top]
  refine ENNReal.rpow_lt_top_of_nonneg (by positivity) ?_
  -- layer-cake on the real-valued ‖f ·‖ (the enorm is never ∞, so the bridge is exact)
  have key := lintegral_rpow_eq_lintegral_meas_lt_mul μ
    (f := fun x => ‖f x‖) (.of_forall fun x => norm_nonneg _) hf.norm.aemeasurable hrr_pos
  have lhs_eq : ∫⁻ x, ‖f x‖ₑ ^ r.toReal ∂μ = ∫⁻ x, ENNReal.ofReal (‖f x‖ ^ r.toReal) ∂μ :=
    lintegral_congr fun x => by
      rw [← ENNReal.ofReal_rpow_of_nonneg (norm_nonneg _) hrr_pos.le, ofReal_norm_eq_enorm]
  rw [lhs_eq, key]
  -- split the t-integral:  Ioi 0 = Ioc 0 1 ∪ Ioi 1
  rw [← Set.Ioc_union_Ioi_eq_Ioi (zero_le_one (α := ℝ)),
      lintegral_union measurableSet_Ioi
        (Set.disjoint_left.mpr fun t ht ht' => absurd ht.2 (not_le.mpr ht'))]
  -- pointwise tail bound (t > 0):  μ{t<‖f‖}·t^{r-1} ≤ ‖f‖_{e,∞}^e · t^{r-e-1}
  have ptwise : ∀ e : ℝ≥0∞, e ≠ 0 → e ≠ ∞ → ∀ t : ℝ, 0 < t →
      μ {a | t < ‖f a‖} * ENNReal.ofReal (t ^ (r.toReal - 1))
        ≤ wnorm f e μ ^ e.toReal * ENNReal.ofReal (t ^ (r.toReal - e.toReal - 1)) := by
    intro e he0 he_top t ht0
    have her_pos : 0 < e.toReal := ENNReal.toReal_pos he0 he_top
    have hofR0 : ENNReal.ofReal t ≠ 0 := by
      simpa [ENNReal.ofReal_eq_zero, not_le] using ht0
    have hmeas : μ {a | t < ‖f a‖} ≤ (wnorm f e μ / ENNReal.ofReal t) ^ e.toReal := by
      refine le_trans (measure_mono fun x hx => ?_)
        (meas_le_wnorm_div_rpow he0 he_top f hofR0 ENNReal.ofReal_ne_top)
      rw [Set.mem_setOf_eq, ← ofReal_norm_eq_enorm]
      exact ENNReal.ofReal_le_ofReal hx.le
    calc μ {a | t < ‖f a‖} * ENNReal.ofReal (t ^ (r.toReal - 1))
        ≤ (wnorm f e μ / ENNReal.ofReal t) ^ e.toReal * ENNReal.ofReal (t ^ (r.toReal - 1)) := by
          gcongr
      _ = wnorm f e μ ^ e.toReal * ENNReal.ofReal (t ^ (r.toReal - e.toReal - 1)) := by
          rw [ENNReal.div_rpow_of_nonneg _ _ her_pos.le, div_eq_mul_inv,
              ← ENNReal.rpow_neg, ENNReal.ofReal_rpow_of_pos ht0, mul_assoc,
              ← ENNReal.ofReal_mul (Real.rpow_nonneg ht0.le _), ← Real.rpow_add ht0]
          congr 2
          ring
  -- the two tail constants are finite
  have hAp_top : wnorm f p μ ^ p.toReal ≠ ∞ :=
    (ENNReal.rpow_lt_top_of_nonneg hpr_pos.le hfp.ne).ne
  have hBq_top : wnorm f q μ ^ q.toReal ≠ ∞ :=
    (ENNReal.rpow_lt_top_of_nonneg hqr_pos.le hfq.ne).ne
  -- piece 1: the p-tail on (0,1]
  have bound1 : ∫⁻ t in Set.Ioc (0:ℝ) 1, μ {a | t < ‖f a‖} * ENNReal.ofReal (t ^ (r.toReal - 1))
      ≤ wnorm f p μ ^ p.toReal
          * ∫⁻ t in Set.Ioc (0:ℝ) 1, ENNReal.ofReal (t ^ (r.toReal - p.toReal - 1)) := by
    rw [← lintegral_const_mul' _ _ hAp_top]
    exact lintegral_mono_ae ((ae_restrict_iff' measurableSet_Ioc).mpr
      (ae_of_all _ fun t ht => ptwise p hp0 hp_top t ht.1))
  -- piece 2: the q-tail on (1,∞)
  have bound2 : ∫⁻ t in Set.Ioi (1:ℝ), μ {a | t < ‖f a‖} * ENNReal.ofReal (t ^ (r.toReal - 1))
      ≤ wnorm f q μ ^ q.toReal
          * ∫⁻ t in Set.Ioi (1:ℝ), ENNReal.ofReal (t ^ (r.toReal - q.toReal - 1)) := by
    rw [← lintegral_const_mul' _ _ hBq_top]
    exact lintegral_mono_ae ((ae_restrict_iff' measurableSet_Ioi).mpr
      (ae_of_all _ fun t ht => ptwise q hq0 hq_top t (lt_trans one_pos ht)))
  -- the two model integrals are finite:  r−p−1 > −1 at 0;  r−q−1 < −1 at ∞
  have int1 : ∫⁻ t in Set.Ioc (0:ℝ) 1, ENNReal.ofReal (t ^ (r.toReal - p.toReal - 1)) ≠ ∞ := by
    have hint : MeasureTheory.IntegrableOn (fun t : ℝ => t ^ (r.toReal - p.toReal - 1))
        (Set.Ioc 0 1) := by
      have h := intervalIntegral.intervalIntegrable_rpow' (a := (0:ℝ)) (b := 1)
        (r := r.toReal - p.toReal - 1) (by linarith)
      rwa [intervalIntegrable_iff, Set.uIoc_of_le zero_le_one] at h
    rw [← MeasureTheory.ofReal_integral_eq_lintegral_ofReal hint
      ((ae_restrict_iff' measurableSet_Ioc).mpr
        (ae_of_all _ fun t ht => Real.rpow_nonneg ht.1.le _))]
    exact ENNReal.ofReal_ne_top
  have int2 : ∫⁻ t in Set.Ioi (1:ℝ), ENNReal.ofReal (t ^ (r.toReal - q.toReal - 1)) ≠ ∞ := by
    have hint : MeasureTheory.IntegrableOn (fun t : ℝ => t ^ (r.toReal - q.toReal - 1))
        (Set.Ioi 1) := integrableOn_Ioi_rpow_of_lt (by linarith) one_pos
    rw [← MeasureTheory.ofReal_integral_eq_lintegral_ofReal hint
      ((ae_restrict_iff' measurableSet_Ioi).mpr
        (ae_of_all _ fun t ht => Real.rpow_nonneg (lt_trans one_pos ht).le _))]
    exact ENNReal.ofReal_ne_top
  -- assemble
  exact ENNReal.mul_ne_top ENNReal.ofReal_ne_top (ENNReal.add_ne_top.mpr
    ⟨ne_top_of_le_ne_top (ENNReal.mul_ne_top hAp_top int1) bound1,
     ne_top_of_le_ne_top (ENNReal.mul_ne_top hBq_top int2) bound2⟩)

/-- **Marcinkiewicz core, membership form:** `f` in weak-Lᵖ ∩ weak-L^q (`0<p<r<q<∞`) lies in `Lʳ`. -/
theorem MemWLp.memLp {q r : ℝ≥0∞} (hp0 : p ≠ 0) (hpr : p < r) (hrq : r < q) (hq_top : q ≠ ∞)
    {f : α → E} (hfp : MemWLp f p μ) (hfq : MemWLp f q μ) : MemLp f r μ :=
  ⟨hfp.1, eLpNorm_lt_top_of_wnorm hp0 hpr hrq hq_top hfp.1 hfp.2 hfq.2⟩

variable {α' F : Type*} {m' : MeasurableSpace α'} [NormedAddCommGroup F]

/-- An operator `T` has **weak type `(p, p)`** with constant `C`: it maps every `Lᵖ` function to an
    AE-strongly-measurable function whose weak-Lᵖ quasinorm is bounded by `C · ‖f‖_{Lᵖ}`. -/
def HasWeakType (T : (α → E) → α' → F) (p : ℝ≥0∞) (μ : Measure α) (ν : Measure α')
    (C : ℝ≥0∞) : Prop :=
  ∀ f, MemLp f p μ → AEStronglyMeasurable (T f) ν ∧ wnorm (T f) p ν ≤ C * eLpNorm f p μ

/-- **Marcinkiewicz interpolation, operator form (qualitative):** if `T` has weak type `(p,p)` and
    `(q,q)` with finite constants, then `T` maps `Lᵖ ∩ L^q` into `Lʳ` for every `p < r < q`.

    Note the honest scope: this is the *qualitative* statement available as a direct wrapper over
    `eLpNorm_lt_top_of_wnorm` — no sublinearity of `T` is even needed. The *strong-type* `(r,r)`
    bound (`‖Tf‖_{Lʳ} ≲ ‖f‖_{Lʳ}` from `f ∈ Lʳ` alone) requires sublinearity and the level-dependent
    truncation `f = f·1_{|f|>s} + f·1_{|f|≤s}` inside the layer-cake — a further formalization step. -/
theorem HasWeakType.memLp_interpolate {q r : ℝ≥0∞} {T : (α → E) → α' → F} {ν : Measure α'}
    {Cp Cq : ℝ≥0∞} (hp0 : p ≠ 0) (hpr : p < r) (hrq : r < q) (hq_top : q ≠ ∞)
    (hCp : Cp ≠ ∞) (hCq : Cq ≠ ∞)
    (hTp : HasWeakType T p μ ν Cp) (hTq : HasWeakType T q μ ν Cq)
    {f : α → E} (hfp : MemLp f p μ) (hfq : MemLp f q μ) :
    MemLp (T f) r ν := by
  obtain ⟨hTf_meas, hTfp⟩ := hTp f hfp
  obtain ⟨-, hTfq⟩ := hTq f hfq
  exact ⟨hTf_meas, eLpNorm_lt_top_of_wnorm hp0 hpr hrq hq_top hTf_meas
    (lt_of_le_of_lt hTfp (ENNReal.mul_lt_top hCp.lt_top hfp.2))
    (lt_of_le_of_lt hTfq (ENNReal.mul_lt_top hCq.lt_top hfq.2))⟩

/-! ### Level truncations (for the strong-type Marcinkiewicz argument)

The split `f = truncGT f t + truncLE f t` is EXACT (pointwise, by cases) — not merely a.e. -/

/-- The "large part" of `f` at level `t`: keeps `f x` where `‖f x‖ > t`, else `0`. -/
noncomputable def truncGT (f : α → E) (t : ℝ) : α → E := fun x => if t < ‖f x‖ then f x else 0

/-- The "small part" of `f` at level `t`: keeps `f x` where `‖f x‖ ≤ t`, else `0`. -/
noncomputable def truncLE (f : α → E) (t : ℝ) : α → E := fun x => if t < ‖f x‖ then 0 else f x

theorem truncGT_add_truncLE (f : α → E) (t : ℝ) : truncGT f t + truncLE f t = f := by
  funext x
  simp only [truncGT, truncLE, Pi.add_apply]
  split <;> simp

theorem enorm_truncGT (f : α → E) (t : ℝ) (x : α) :
    ‖truncGT f t x‖ₑ = if t < ‖f x‖ then ‖f x‖ₑ else 0 := by
  simp only [truncGT]; split <;> simp

theorem enorm_truncLE (f : α → E) (t : ℝ) (x : α) :
    ‖truncLE f t x‖ₑ = if t < ‖f x‖ then 0 else ‖f x‖ₑ := by
  simp only [truncLE]; split <;> simp

theorem aestronglyMeasurable_truncGT {f : α → E} (hf : AEStronglyMeasurable f μ) (t : ℝ) :
    AEStronglyMeasurable (truncGT f t) μ := by
  obtain ⟨g, hg, hfg⟩ := hf
  refine ⟨truncGT g t,
    StronglyMeasurable.ite (measurableSet_lt measurable_const hg.norm.measurable)
      hg stronglyMeasurable_const, ?_⟩
  filter_upwards [hfg] with x hx
  simp only [truncGT, hx]

theorem aestronglyMeasurable_truncLE {f : α → E} (hf : AEStronglyMeasurable f μ) (t : ℝ) :
    AEStronglyMeasurable (truncLE f t) μ := by
  obtain ⟨g, hg, hfg⟩ := hf
  refine ⟨truncLE g t,
    StronglyMeasurable.ite (measurableSet_lt measurable_const hg.norm.measurable)
      stronglyMeasurable_const hg, ?_⟩
  filter_upwards [hfg] with x hx
  simp only [truncLE, hx]

/-- From `f ∈ Lʳ`: the lintegral `∫⁻ ‖f‖ₑ^{r.toReal}` is finite. -/
theorem lintegral_enorm_rpow_ne_top_of_memLp {r : ℝ≥0∞} (hr0 : r ≠ 0) (hr_top : r ≠ ∞)
    {f : α → E} (hf : MemLp f r μ) : ∫⁻ x, ‖f x‖ₑ ^ r.toReal ∂μ ≠ ∞ := by
  have h := hf.2
  rw [eLpNorm_eq_lintegral_rpow_enorm_toReal hr0 hr_top] at h
  have hrr : (0:ℝ) < 1 / r.toReal := by
    have := ENNReal.toReal_pos hr0 hr_top; positivity
  exact ((ENNReal.rpow_lt_top_iff_of_pos hrr).mp h).ne

/-- The large part of an `Lʳ` function is in `Lᵖ` for `p < r` (at any positive level `t`):
    on `{‖f‖>t}` one has `‖f‖^p ≤ t^{p−r}‖f‖^r`. -/
theorem memLp_truncGT {r : ℝ≥0∞} (hp0 : p ≠ 0) (hpr : p < r) (hr_top : r ≠ ∞)
    {f : α → E} (hf : MemLp f r μ) {t : ℝ} (ht : 0 < t) : MemLp (truncGT f t) p μ := by
  have hp_top : p ≠ ∞ := (hpr.trans_le le_top).ne
  have hr0 : r ≠ 0 := fun h0 => absurd hpr (by simp [h0])
  have hpp : 0 < p.toReal := ENNReal.toReal_pos hp0 hp_top
  have hrr : 0 < r.toReal := ENNReal.toReal_pos hr0 hr_top
  have hprr : p.toReal < r.toReal := ENNReal.toReal_strict_mono hr_top hpr
  refine ⟨aestronglyMeasurable_truncGT hf.1 t, ?_⟩
  rw [eLpNorm_eq_lintegral_rpow_enorm_toReal hp0 hp_top]
  refine ENNReal.rpow_lt_top_of_nonneg (by positivity) ?_
  have hb : ∀ x, ‖truncGT f t x‖ₑ ^ p.toReal
      ≤ ENNReal.ofReal (t ^ (p.toReal - r.toReal)) * ‖f x‖ₑ ^ r.toReal := by
    intro x
    rw [enorm_truncGT]
    split
    case isTrue h =>
      have hfx : (0:ℝ) < ‖f x‖ := ht.trans h
      have hc0 : ‖f x‖ₑ ≠ 0 := by
        rw [ne_eq, enorm_eq_zero]
        exact norm_pos_iff.mp hfx
      have hctop : ‖f x‖ₑ ≠ ∞ := enorm_ne_top
      have hsplit : ‖f x‖ₑ ^ p.toReal = ‖f x‖ₑ ^ (p.toReal - r.toReal) * ‖f x‖ₑ ^ r.toReal := by
        rw [← ENNReal.rpow_add _ _ hc0 hctop]; congr 1; ring
      rw [hsplit]
      gcongr ?_ * _
      -- ‖f x‖ₑ^(p−r) ≤ ofReal(t^(p−r)): negative exponent is antitone, ofReal t ≤ ‖f x‖ₑ
      rw [← ENNReal.ofReal_rpow_of_pos ht,
          show p.toReal - r.toReal = -(r.toReal - p.toReal) by ring,
          ENNReal.rpow_neg, ENNReal.rpow_neg]
      refine ENNReal.inv_le_inv.mpr (ENNReal.rpow_le_rpow ?_ (by linarith))
      rw [← ofReal_norm_eq_enorm]
      exact ENNReal.ofReal_le_ofReal h.le
    case isFalse h =>
      rw [ENNReal.zero_rpow_of_pos hpp]
      exact zero_le
  have hle : ∫⁻ x, ‖truncGT f t x‖ₑ ^ p.toReal ∂μ
      ≤ ENNReal.ofReal (t ^ (p.toReal - r.toReal)) * ∫⁻ x, ‖f x‖ₑ ^ r.toReal ∂μ :=
    le_of_le_of_eq (lintegral_mono hb) (lintegral_const_mul' _ _ ENNReal.ofReal_ne_top)
  exact ne_top_of_le_ne_top (ENNReal.mul_ne_top ENNReal.ofReal_ne_top
    (lintegral_enorm_rpow_ne_top_of_memLp hr0 hr_top hf)) hle

/-- The small part of an `Lʳ` function is in `L^q` for `r < q < ∞` (at any positive level `t`):
    on `{‖f‖≤t}` one has `‖f‖^q ≤ t^{q−r}‖f‖^r`. -/
theorem memLp_truncLE {q r : ℝ≥0∞} (hrq : r < q) (hq_top : q ≠ ∞) (hr0 : r ≠ 0)
    {f : α → E} (hf : MemLp f r μ) {t : ℝ} (ht : 0 < t) : MemLp (truncLE f t) q μ := by
  have hq0 : q ≠ 0 := fun h0 => absurd hrq (by simp [h0])
  have hr_top : r ≠ ∞ := (hrq.trans_le le_top).ne
  have hqq : 0 < q.toReal := ENNReal.toReal_pos hq0 hq_top
  have hrr : 0 < r.toReal := ENNReal.toReal_pos hr0 hr_top
  have hrqq : r.toReal < q.toReal := ENNReal.toReal_strict_mono hq_top hrq
  refine ⟨aestronglyMeasurable_truncLE hf.1 t, ?_⟩
  rw [eLpNorm_eq_lintegral_rpow_enorm_toReal hq0 hq_top]
  refine ENNReal.rpow_lt_top_of_nonneg (by positivity) ?_
  have hb : ∀ x, ‖truncLE f t x‖ₑ ^ q.toReal
      ≤ ENNReal.ofReal (t ^ (q.toReal - r.toReal)) * ‖f x‖ₑ ^ r.toReal := by
    intro x
    rw [enorm_truncLE]
    split
    case isTrue h =>
      rw [ENNReal.zero_rpow_of_pos hqq]
      exact zero_le
    case isFalse h =>
      rcases eq_or_ne ‖f x‖ₑ 0 with hc0 | hc0
      · rw [hc0, ENNReal.zero_rpow_of_pos hqq]
        exact zero_le
      have hctop : ‖f x‖ₑ ≠ ∞ := enorm_ne_top
      have hsplit : ‖f x‖ₑ ^ q.toReal = ‖f x‖ₑ ^ (q.toReal - r.toReal) * ‖f x‖ₑ ^ r.toReal := by
        rw [← ENNReal.rpow_add _ _ hc0 hctop]; congr 1; ring
      rw [hsplit]
      gcongr ?_ * _
      -- ‖f x‖ₑ ≤ ofReal t, positive exponent q−r: monotone
      rw [← ENNReal.ofReal_rpow_of_pos ht, ← ofReal_norm_eq_enorm]
      exact ENNReal.rpow_le_rpow (ENNReal.ofReal_le_ofReal (not_lt.mp h)) (by linarith)
  have hle : ∫⁻ x, ‖truncLE f t x‖ₑ ^ q.toReal ∂μ
      ≤ ENNReal.ofReal (t ^ (q.toReal - r.toReal)) * ∫⁻ x, ‖f x‖ₑ ^ r.toReal ∂μ :=
    le_of_le_of_eq (lintegral_mono hb) (lintegral_const_mul' _ _ ENNReal.ofReal_ne_top)
  exact ne_top_of_le_ne_top (ENNReal.mul_ne_top ENNReal.ofReal_ne_top
    (lintegral_enorm_rpow_ne_top_of_memLp hr0 hr_top hf)) hle

/-! ### The two model `t`-integrals -/

/-- `∫₀^c t^a dt = c^{a+1}/(a+1)` for `a > −1`, `c ≥ 0` (lintegral-of-ofReal form). -/
theorem lintegral_Ioo_rpow_ofReal {a : ℝ} (ha : -1 < a) {c : ℝ} (hc : 0 ≤ c) :
    ∫⁻ t in Set.Ioo (0:ℝ) c, ENNReal.ofReal (t ^ a)
      = ENNReal.ofReal (c ^ (a + 1) / (a + 1)) := by
  rcases eq_or_lt_of_le hc with rfl | hc'
  · simp [Real.zero_rpow (by linarith : a + 1 ≠ 0)]
  · have hint : MeasureTheory.IntegrableOn (fun t : ℝ => t ^ a) (Set.Ioo 0 c) := by
      have h := intervalIntegral.intervalIntegrable_rpow' (a := (0:ℝ)) (b := c) ha
      rw [intervalIntegrable_iff, Set.uIoc_of_le hc'.le] at h
      exact h.mono_set Set.Ioo_subset_Ioc_self
    rw [← MeasureTheory.ofReal_integral_eq_lintegral_ofReal hint
      ((ae_restrict_iff' measurableSet_Ioo).mpr
        (ae_of_all _ fun t htx => Real.rpow_nonneg htx.1.le _))]
    congr 1
    rw [← MeasureTheory.integral_Ioc_eq_integral_Ioo, ← intervalIntegral.integral_of_le hc'.le,
        integral_rpow (Or.inl ha),
        Real.zero_rpow (by linarith : a + 1 ≠ 0)]
    ring

/-- `∫_c^∞ t^a dt = −c^{a+1}/(a+1)` for `a < −1`, `c > 0` (lintegral-of-ofReal form). -/
theorem lintegral_Ioi_rpow_ofReal {a : ℝ} (ha : a < -1) {c : ℝ} (hc : 0 < c) :
    ∫⁻ t in Set.Ioi c, ENNReal.ofReal (t ^ a)
      = ENNReal.ofReal (-c ^ (a + 1) / (a + 1)) := by
  have hint := integrableOn_Ioi_rpow_of_lt ha hc
  rw [← MeasureTheory.ofReal_integral_eq_lintegral_ofReal hint
    ((ae_restrict_iff' measurableSet_Ioi).mpr
      (ae_of_all _ fun t htx => Real.rpow_nonneg (hc.trans htx).le _)),
    integral_Ioi_rpow_of_lt ha hc]

/-! ### The Tonelli swap + inner-integral evaluation (the heart of strong-type Marcinkiewicz) -/

/-- The low tail: `∫_{t>0} t^{r−e−1}·(∫_x 1_{t<‖g‖}‖g‖ₑ^e) = (r−e)⁻¹·∫_x ‖g‖ₑ^r` for `0 < e < r`. -/
theorem swap_eval_low [SFinite μ] {g : α → E} (hg : StronglyMeasurable g)
    {ee rr : ℝ} (hee : 0 < ee) (hlt : ee < rr) :
    (∫⁻ t in Set.Ioi (0:ℝ), ENNReal.ofReal (t ^ (rr - ee - 1)) *
        ∫⁻ x, (if t < ‖g x‖ then ‖g x‖ₑ ^ ee else 0) ∂μ)
      = ENNReal.ofReal (1 / (rr - ee)) * ∫⁻ x, ‖g x‖ₑ ^ rr ∂μ := by
  have step1 : ∀ t : ℝ, (ENNReal.ofReal (t ^ (rr - ee - 1)) *
      ∫⁻ x, (if t < ‖g x‖ then ‖g x‖ₑ ^ ee else 0) ∂μ)
      = ∫⁻ x, ENNReal.ofReal (t ^ (rr - ee - 1)) * (if t < ‖g x‖ then ‖g x‖ₑ ^ ee else 0) ∂μ :=
    fun t => (lintegral_const_mul' _ _ ENNReal.ofReal_ne_top).symm
  simp only [step1]
  rw [lintegral_lintegral_swap]
  case hf =>
    have hset : MeasurableSet {z : ℝ × α | z.1 < ‖g z.2‖} :=
      measurableSet_lt measurable_fst (hg.norm.measurable.comp measurable_snd)
    have hm1 : Measurable fun z : ℝ × α => ENNReal.ofReal (z.1 ^ (rr - ee - 1)) := by fun_prop
    have hm2 : Measurable fun z : ℝ × α =>
        (if z.1 < ‖g z.2‖ then ‖g z.2‖ₑ ^ ee else 0 : ℝ≥0∞) := by
      refine Measurable.ite hset ?_ measurable_const
      fun_prop
    exact (hm1.mul hm2).aemeasurable
  have inner : ∀ x : α, (∫⁻ t in Set.Ioi (0:ℝ),
      ENNReal.ofReal (t ^ (rr - ee - 1)) * (if t < ‖g x‖ then ‖g x‖ₑ ^ ee else 0))
      = ‖g x‖ₑ ^ ee * ENNReal.ofReal (‖g x‖ ^ (rr - ee) / (rr - ee)) := by
    intro x
    have hind : ∀ t : ℝ, ENNReal.ofReal (t ^ (rr - ee - 1)) * (if t < ‖g x‖ then ‖g x‖ₑ ^ ee else 0)
        = (Set.Iio ‖g x‖).indicator
            (fun t => ENNReal.ofReal (t ^ (rr - ee - 1)) * ‖g x‖ₑ ^ ee) t := by
      intro t
      simp only [Set.indicator_apply, Set.mem_Iio, mul_ite, mul_zero]
    simp only [hind]
    rw [lintegral_indicator measurableSet_Iio, Measure.restrict_restrict measurableSet_Iio,
        Set.inter_comm, Set.Ioi_inter_Iio,
        lintegral_mul_const' _ _ (ENNReal.rpow_ne_top_of_nonneg hee.le enorm_ne_top),
        lintegral_Ioo_rpow_ofReal (by linarith) (norm_nonneg _),
        show rr - ee - 1 + 1 = rr - ee by ring, mul_comm]
  simp only [inner]
  have hpt : ∀ x : α, ‖g x‖ₑ ^ ee * ENNReal.ofReal (‖g x‖ ^ (rr - ee) / (rr - ee))
      = ENNReal.ofReal (1 / (rr - ee)) * ‖g x‖ₑ ^ rr := by
    intro x
    rcases eq_or_ne (g x) 0 with hgx | hgx
    · simp [hgx, ENNReal.zero_rpow_of_pos hee,
        ENNReal.zero_rpow_of_pos (lt_trans hee hlt),
        Real.zero_rpow (by linarith : rr - ee ≠ 0)]
    · have hc : (0:ℝ) < ‖g x‖ := norm_pos_iff.mpr hgx
      have hA0 : ‖g x‖ₑ ≠ 0 := by rw [ne_eq, enorm_eq_zero]; exact hgx
      rw [div_eq_mul_one_div, ENNReal.ofReal_mul (Real.rpow_nonneg (norm_nonneg _) _),
          ← ENNReal.ofReal_rpow_of_pos hc, ofReal_norm_eq_enorm, ← mul_assoc,
          ← ENNReal.rpow_add _ _ hA0 enorm_ne_top, show ee + (rr - ee) = rr by ring, mul_comm]
  rw [lintegral_congr hpt, lintegral_const_mul' _ _ ENNReal.ofReal_ne_top]

/-- The high tail: `∫_{t>0} t^{r−e−1}·(∫_x 1_{t≥‖g‖}‖g‖ₑ^e) = (e−r)⁻¹·∫_x ‖g‖ₑ^r` for `0 < r < e`. -/
theorem swap_eval_high [SFinite μ] {g : α → E} (hg : StronglyMeasurable g)
    {ee rr : ℝ} (hrr : 0 < rr) (hlt : rr < ee) :
    (∫⁻ t in Set.Ioi (0:ℝ), ENNReal.ofReal (t ^ (rr - ee - 1)) *
        ∫⁻ x, (if t < ‖g x‖ then 0 else ‖g x‖ₑ ^ ee) ∂μ)
      = ENNReal.ofReal (1 / (ee - rr)) * ∫⁻ x, ‖g x‖ₑ ^ rr ∂μ := by
  have hee : 0 < ee := lt_trans hrr hlt
  have step1 : ∀ t : ℝ, (ENNReal.ofReal (t ^ (rr - ee - 1)) *
      ∫⁻ x, (if t < ‖g x‖ then 0 else ‖g x‖ₑ ^ ee) ∂μ)
      = ∫⁻ x, ENNReal.ofReal (t ^ (rr - ee - 1)) * (if t < ‖g x‖ then 0 else ‖g x‖ₑ ^ ee) ∂μ :=
    fun t => (lintegral_const_mul' _ _ ENNReal.ofReal_ne_top).symm
  simp only [step1]
  rw [lintegral_lintegral_swap]
  case hf =>
    have hset : MeasurableSet {z : ℝ × α | z.1 < ‖g z.2‖} :=
      measurableSet_lt measurable_fst (hg.norm.measurable.comp measurable_snd)
    have hm1 : Measurable fun z : ℝ × α => ENNReal.ofReal (z.1 ^ (rr - ee - 1)) := by fun_prop
    have hm2 : Measurable fun z : ℝ × α =>
        (if z.1 < ‖g z.2‖ then 0 else ‖g z.2‖ₑ ^ ee : ℝ≥0∞) := by
      refine Measurable.ite hset measurable_const ?_
      fun_prop
    exact (hm1.mul hm2).aemeasurable
  have inner : ∀ x : α, (∫⁻ t in Set.Ioi (0:ℝ),
      ENNReal.ofReal (t ^ (rr - ee - 1)) * (if t < ‖g x‖ then 0 else ‖g x‖ₑ ^ ee))
      = ‖g x‖ₑ ^ ee * ENNReal.ofReal (‖g x‖ ^ (rr - ee) / (ee - rr)) := by
    intro x
    rcases eq_or_ne (g x) 0 with hgx | hgx
    · simp [hgx, ENNReal.zero_rpow_of_pos hee]
    · have hc : (0:ℝ) < ‖g x‖ := norm_pos_iff.mpr hgx
      have hind : ∀ t : ℝ,
          ENNReal.ofReal (t ^ (rr - ee - 1)) * (if t < ‖g x‖ then 0 else ‖g x‖ₑ ^ ee)
          = (Set.Ici ‖g x‖).indicator
              (fun t => ENNReal.ofReal (t ^ (rr - ee - 1)) * ‖g x‖ₑ ^ ee) t := by
        intro t
        simp only [Set.indicator_apply, Set.mem_Ici]
        by_cases h : t < ‖g x‖
        · simp [h, not_le.mpr h]
        · simp [h, not_lt.mp h]
      have heq : Set.Ici ‖g x‖ ∩ Set.Ioi (0:ℝ) = Set.Ici ‖g x‖ :=
        Set.inter_eq_left.mpr fun y hy => lt_of_lt_of_le hc hy
      simp only [hind]
      rw [lintegral_indicator measurableSet_Ici, Measure.restrict_restrict measurableSet_Ici,
          heq, setLIntegral_congr (Ioi_ae_eq_Ici' (measure_singleton _)).symm,
          lintegral_mul_const' _ _ (ENNReal.rpow_ne_top_of_nonneg hee.le enorm_ne_top),
          lintegral_Ioi_rpow_ofReal (by linarith) hc,
          show rr - ee - 1 + 1 = rr - ee by ring, mul_comm,
          show ee - rr = -(rr - ee) by ring, div_neg, neg_div]
  simp only [inner]
  have hpt : ∀ x : α, ‖g x‖ₑ ^ ee * ENNReal.ofReal (‖g x‖ ^ (rr - ee) / (ee - rr))
      = ENNReal.ofReal (1 / (ee - rr)) * ‖g x‖ₑ ^ rr := by
    intro x
    rcases eq_or_ne (g x) 0 with hgx | hgx
    · simp [hgx, ENNReal.zero_rpow_of_pos hee, ENNReal.zero_rpow_of_pos hrr,
        Real.zero_rpow (by linarith : rr - ee ≠ 0)]
    · have hc : (0:ℝ) < ‖g x‖ := norm_pos_iff.mpr hgx
      have hA0 : ‖g x‖ₑ ≠ 0 := by rw [ne_eq, enorm_eq_zero]; exact hgx
      rw [div_eq_mul_one_div, ENNReal.ofReal_mul (Real.rpow_nonneg (norm_nonneg _) _),
          ← ENNReal.ofReal_rpow_of_pos hc, ofReal_norm_eq_enorm, ← mul_assoc,
          ← ENNReal.rpow_add _ _ hA0 enorm_ne_top, show ee + (rr - ee) = rr by ring, mul_comm]
  rw [lintegral_congr hpt, lintegral_const_mul' _ _ ENNReal.ofReal_ne_top]

/-- **Strong-type Marcinkiewicz interpolation (diagonal case, quantitative core):** a sublinear `T`
    of weak types `(p,p)` and `(q,q)` (finite constants) satisfies, for `0 < p < r < q < ∞` and
    `f ∈ Lʳ`, the bound `∫‖Tf‖ₑ^r ≤ K·∫‖f‖ₑ^r` with the explicit constant
    `K = r·(Cp^p·2^p/(r−p) + Cq^q·2^q/(q−r))`. Proof: layer-cake on `Tf`; for each level `t` split
    `f` exactly at level `t` (`truncGT`/`truncLE`), apply sublinearity and the two weak-type bounds
    at threshold `t/2`, then Tonelli-swap and evaluate the inner `t`-integrals. Measurability of
    `T f` is a hypothesis — it does not follow from sublinearity. -/
theorem lintegral_rpow_le_of_hasWeakType [SFinite μ] {q r : ℝ≥0∞}
    {T : (α → E) → α' → F} {ν : Measure α'} {Cp Cq : ℝ≥0∞}
    (hp0 : p ≠ 0) (hpr : p < r) (hrq : r < q) (hq_top : q ≠ ∞) (hCp : Cp ≠ ∞) (hCq : Cq ≠ ∞)
    (hTp : HasWeakType T p μ ν Cp) (hTq : HasWeakType T q μ ν Cq)
    (hT_sub : ∀ g h : α → E, MemLp g p μ → MemLp h q μ →
      ∀ᵐ y ∂ν, ‖T (g + h) y‖ₑ ≤ ‖T g y‖ₑ + ‖T h y‖ₑ)
    {f : α → E} (hf : MemLp f r μ) (hTf : AEStronglyMeasurable (T f) ν) :
    ∫⁻ y, ‖T f y‖ₑ ^ r.toReal ∂ν
      ≤ (ENNReal.ofReal r.toReal *
          (Cp ^ p.toReal * ENNReal.ofReal (2 ^ p.toReal) * ENNReal.ofReal (1/(r.toReal - p.toReal))
            + Cq ^ q.toReal * ENNReal.ofReal (2 ^ q.toReal)
                * ENNReal.ofReal (1/(q.toReal - r.toReal))))
        * ∫⁻ x, ‖f x‖ₑ ^ r.toReal ∂μ := by
  -- bookkeeping
  have hq_lt : q < ∞ := hq_top.lt_top
  have hr_top : r ≠ ∞ := (hrq.trans hq_lt).ne
  have hp_top : p ≠ ∞ := ((hpr.trans hrq).trans hq_lt).ne
  have hr0 : r ≠ 0 := fun h0 => absurd hpr (by simp [h0])
  have hq0 : q ≠ 0 := fun h0 => absurd hrq (by simp [h0])
  have hpp : 0 < p.toReal := ENNReal.toReal_pos hp0 hp_top
  have hrr : 0 < r.toReal := ENNReal.toReal_pos hr0 hr_top
  have hqq : 0 < q.toReal := ENNReal.toReal_pos hq0 hq_top
  have h_pr : p.toReal < r.toReal := ENNReal.toReal_strict_mono hr_top hpr
  have h_rq : r.toReal < q.toReal := ENNReal.toReal_strict_mono hq_top hrq
  obtain ⟨g, hg, hfg⟩ := hf.1
  set Np : ℝ → ℝ≥0∞ := fun t => ∫⁻ x, (if t < ‖f x‖ then ‖f x‖ₑ ^ p.toReal else 0) ∂μ with hNp_def
  set Nq : ℝ → ℝ≥0∞ := fun t => ∫⁻ x, (if t < ‖f x‖ then 0 else ‖f x‖ₑ ^ q.toReal) ∂μ with hNq_def
  -- step 1: layer-cake on T f
  have key : ∫⁻ y, ‖T f y‖ₑ ^ r.toReal ∂ν
      = ENNReal.ofReal r.toReal * ∫⁻ t in Set.Ioi (0:ℝ),
          ν {a | t < ‖T f a‖} * ENNReal.ofReal (t ^ (r.toReal - 1)) := by
    have k1 := lintegral_rpow_eq_lintegral_meas_lt_mul ν
      (f := fun y => ‖T f y‖) (ae_of_all _ fun y => norm_nonneg _) hTf.norm.aemeasurable hrr
    rw [← k1]
    exact lintegral_congr fun y => by
      rw [← ENNReal.ofReal_rpow_of_nonneg (norm_nonneg _) hrr.le, ofReal_norm_eq_enorm]
  -- the real-arithmetic identity absorbing the threshold 1/2
  have hreal : ∀ ee : ℝ, 0 < ee → ∀ t : ℝ, 0 < t →
      t ^ (r.toReal - 1) / (t/2) ^ ee = 2 ^ ee * t ^ (r.toReal - ee - 1) := by
    intro ee hee t ht
    rw [Real.div_rpow ht.le (by norm_num : (0:ℝ) ≤ 2), div_div_eq_mul_div,
        mul_comm (t ^ (r.toReal - 1)) ((2:ℝ) ^ ee), mul_div_assoc, ← Real.rpow_sub ht,
        show r.toReal - 1 - ee = r.toReal - ee - 1 by ring]
  -- step 2: the per-level bound
  have hsplit_t : ∀ t : ℝ, 0 < t →
      ν {a | t < ‖T f a‖} * ENNReal.ofReal (t ^ (r.toReal - 1))
        ≤ Cp ^ p.toReal * ENNReal.ofReal (2 ^ p.toReal)
            * (ENNReal.ofReal (t ^ (r.toReal - p.toReal - 1)) * Np t)
          + Cq ^ q.toReal * ENNReal.ofReal (2 ^ q.toReal)
            * (ENNReal.ofReal (t ^ (r.toReal - q.toReal - 1)) * Nq t) := by
    intro t ht
    have hBig : MemLp (truncGT f t) p μ := memLp_truncGT hp0 hpr hr_top hf ht
    have hSml : MemLp (truncLE f t) q μ := memLp_truncLE hrq hq_top hr0 hf ht
    have hsub := hT_sub _ _ hBig hSml
    rw [truncGT_add_truncLE] at hsub
    have hhalf : (0:ℝ) < t/2 := by linarith
    have hs0 : ENNReal.ofReal (t/2) ≠ 0 := by
      simpa [ENNReal.ofReal_eq_zero, not_le] using hhalf
    have hmeasure : ν {a | t < ‖T f a‖}
        ≤ ν {a | ENNReal.ofReal (t/2) ≤ ‖T (truncGT f t) a‖ₑ}
          + ν {a | ENNReal.ofReal (t/2) ≤ ‖T (truncLE f t) a‖ₑ} := by
      refine le_trans (measure_mono_ae ?_) (measure_union_le _ _)
      filter_upwards [hsub] with y hy
      intro hmem
      rcases le_or_gt (ENNReal.ofReal (t/2)) ‖T (truncGT f t) y‖ₑ with h1 | h1
      · exact Set.mem_union_left _ h1
      rcases le_or_gt (ENNReal.ofReal (t/2)) ‖T (truncLE f t) y‖ₑ with h2 | h2
      · exact Set.mem_union_right _ h2
      exfalso
      have hlt : ‖T f y‖ₑ < ENNReal.ofReal t := by
        calc ‖T f y‖ₑ ≤ ‖T (truncGT f t) y‖ₑ + ‖T (truncLE f t) y‖ₑ := hy
          _ < ENNReal.ofReal (t/2) + ENNReal.ofReal (t/2) := ENNReal.add_lt_add h1 h2
          _ = ENNReal.ofReal t := by
              rw [← ENNReal.ofReal_add (by linarith) (by linarith)]
              norm_num
      have hgt : ENNReal.ofReal t < ‖T f y‖ₑ := by
        rw [← ofReal_norm_eq_enorm]
        exact (ENNReal.ofReal_lt_ofReal_iff_of_nonneg ht.le).mpr hmem
      exact absurd hgt (not_lt.mpr hlt.le)
    have hNp_eq : eLpNorm (truncGT f t) p μ ^ p.toReal = Np t := by
      rw [eLpNorm_eq_lintegral_rpow_enorm_toReal hp0 hp_top, ← ENNReal.rpow_mul, one_div,
          inv_mul_cancel₀ hpp.ne', ENNReal.rpow_one]
      refine lintegral_congr fun x => ?_
      rw [enorm_truncGT]
      split <;> simp [ENNReal.zero_rpow_of_pos hpp]
    have hNq_eq : eLpNorm (truncLE f t) q μ ^ q.toReal = Nq t := by
      rw [eLpNorm_eq_lintegral_rpow_enorm_toReal hq0 hq_top, ← ENNReal.rpow_mul, one_div,
          inv_mul_cancel₀ hqq.ne', ENNReal.rpow_one]
      refine lintegral_congr fun x => ?_
      rw [enorm_truncLE]
      split <;> simp [ENNReal.zero_rpow_of_pos hqq]
    have hwp : ν {a | ENNReal.ofReal (t/2) ≤ ‖T (truncGT f t) a‖ₑ}
        ≤ Cp ^ p.toReal * Np t / ENNReal.ofReal ((t/2) ^ p.toReal) := by
      refine le_trans (meas_le_wnorm_div_rpow hp0 hp_top _ hs0 ENNReal.ofReal_ne_top) ?_
      rw [ENNReal.div_rpow_of_nonneg _ _ hpp.le, ENNReal.ofReal_rpow_of_pos hhalf]
      gcongr
      calc wnorm (T (truncGT f t)) p ν ^ p.toReal
          ≤ (Cp * eLpNorm (truncGT f t) p μ) ^ p.toReal := by
            gcongr
            exact (hTp _ hBig).2
        _ = Cp ^ p.toReal * Np t := by
            rw [ENNReal.mul_rpow_of_nonneg _ _ hpp.le, hNp_eq]
    have hwq : ν {a | ENNReal.ofReal (t/2) ≤ ‖T (truncLE f t) a‖ₑ}
        ≤ Cq ^ q.toReal * Nq t / ENNReal.ofReal ((t/2) ^ q.toReal) := by
      refine le_trans (meas_le_wnorm_div_rpow hq0 hq_top _ hs0 ENNReal.ofReal_ne_top) ?_
      rw [ENNReal.div_rpow_of_nonneg _ _ hqq.le, ENNReal.ofReal_rpow_of_pos hhalf]
      gcongr
      calc wnorm (T (truncLE f t)) q ν ^ q.toReal
          ≤ (Cq * eLpNorm (truncLE f t) q μ) ^ q.toReal := by
            gcongr
            exact (hTq _ hSml).2
        _ = Cq ^ q.toReal * Nq t := by
            rw [ENNReal.mul_rpow_of_nonneg _ _ hqq.le, hNq_eq]
    have habsorb : ∀ ee : ℝ, 0 < ee → ∀ X : ℝ≥0∞,
        (X / ENNReal.ofReal ((t/2) ^ ee)) * ENNReal.ofReal (t ^ (r.toReal - 1))
          = ENNReal.ofReal (2 ^ ee) * (ENNReal.ofReal (t ^ (r.toReal - ee - 1)) * X) := by
      intro ee hee X
      rw [div_eq_mul_inv, mul_assoc, mul_comm (ENNReal.ofReal ((t/2) ^ ee))⁻¹,
          ← div_eq_mul_inv, ← ENNReal.ofReal_div_of_pos (Real.rpow_pos_of_pos hhalf _),
          hreal ee hee t ht, ENNReal.ofReal_mul (by positivity)]
      ring
    calc ν {a | t < ‖T f a‖} * ENNReal.ofReal (t ^ (r.toReal - 1))
        ≤ (ν {a | ENNReal.ofReal (t/2) ≤ ‖T (truncGT f t) a‖ₑ}
            + ν {a | ENNReal.ofReal (t/2) ≤ ‖T (truncLE f t) a‖ₑ})
              * ENNReal.ofReal (t ^ (r.toReal - 1)) := by gcongr
      _ ≤ (Cp ^ p.toReal * Np t / ENNReal.ofReal ((t/2) ^ p.toReal)
            + Cq ^ q.toReal * Nq t / ENNReal.ofReal ((t/2) ^ q.toReal))
              * ENNReal.ofReal (t ^ (r.toReal - 1)) := by gcongr
      _ = Cp ^ p.toReal * ENNReal.ofReal (2 ^ p.toReal)
            * (ENNReal.ofReal (t ^ (r.toReal - p.toReal - 1)) * Np t)
          + Cq ^ q.toReal * ENNReal.ofReal (2 ^ q.toReal)
            * (ENNReal.ofReal (t ^ (r.toReal - q.toReal - 1)) * Nq t) := by
          rw [add_mul, habsorb p.toReal hpp (Cp ^ p.toReal * Np t),
              habsorb q.toReal hqq (Cq ^ q.toReal * Nq t)]
          ring
  -- step 3: integrate, split the sum (Np is antitone hence measurable)
  have hNp_anti : Antitone Np := fun t₁ t₂ h12 => lintegral_mono fun x => by
    dsimp only
    split
    case isTrue h => rw [if_pos (lt_of_le_of_lt h12 h)]
    case isFalse h => exact zero_le
  have hmono : ∫⁻ t in Set.Ioi (0:ℝ), ν {a | t < ‖T f a‖} * ENNReal.ofReal (t ^ (r.toReal - 1))
      ≤ ∫⁻ t in Set.Ioi (0:ℝ),
          (Cp ^ p.toReal * ENNReal.ofReal (2 ^ p.toReal)
            * (ENNReal.ofReal (t ^ (r.toReal - p.toReal - 1)) * Np t)
          + Cq ^ q.toReal * ENNReal.ofReal (2 ^ q.toReal)
            * (ENNReal.ofReal (t ^ (r.toReal - q.toReal - 1)) * Nq t)) :=
    lintegral_mono_ae ((ae_restrict_iff' measurableSet_Ioi).mpr
      (ae_of_all _ fun t ht => hsplit_t t ht))
  have hmeas_p : AEMeasurable (fun t : ℝ => Cp ^ p.toReal * ENNReal.ofReal (2 ^ p.toReal)
      * (ENNReal.ofReal (t ^ (r.toReal - p.toReal - 1)) * Np t))
      (volume.restrict (Set.Ioi (0:ℝ))) := by
    refine (measurable_const.mul (Measurable.mul ?_ hNp_anti.measurable)).aemeasurable
    fun_prop
  have hadd : ∫⁻ t in Set.Ioi (0:ℝ),
      (Cp ^ p.toReal * ENNReal.ofReal (2 ^ p.toReal)
        * (ENNReal.ofReal (t ^ (r.toReal - p.toReal - 1)) * Np t)
      + Cq ^ q.toReal * ENNReal.ofReal (2 ^ q.toReal)
        * (ENNReal.ofReal (t ^ (r.toReal - q.toReal - 1)) * Nq t))
      = Cp ^ p.toReal * ENNReal.ofReal (2 ^ p.toReal)
          * (∫⁻ t in Set.Ioi (0:ℝ), ENNReal.ofReal (t ^ (r.toReal - p.toReal - 1)) * Np t)
        + Cq ^ q.toReal * ENNReal.ofReal (2 ^ q.toReal)
          * (∫⁻ t in Set.Ioi (0:ℝ), ENNReal.ofReal (t ^ (r.toReal - q.toReal - 1)) * Nq t) := by
    rw [lintegral_add_left' hmeas_p, lintegral_const_mul' _ _
        (ENNReal.mul_ne_top (ENNReal.rpow_ne_top_of_nonneg hpp.le hCp) ENNReal.ofReal_ne_top),
      lintegral_const_mul' _ _
        (ENNReal.mul_ne_top (ENNReal.rpow_ne_top_of_nonneg hqq.le hCq) ENNReal.ofReal_ne_top)]
  -- step 4: pass to the measurable mate, swap, evaluate
  have hNp_g : ∀ t : ℝ, Np t = ∫⁻ x, (if t < ‖g x‖ then ‖g x‖ₑ ^ p.toReal else 0) ∂μ :=
    fun t => lintegral_congr_ae (hfg.mono fun x hx => by simp only [hx])
  have hNq_g : ∀ t : ℝ, Nq t = ∫⁻ x, (if t < ‖g x‖ then 0 else ‖g x‖ₑ ^ q.toReal) ∂μ :=
    fun t => lintegral_congr_ae (hfg.mono fun x hx => by simp only [hx])
  have hJ_g : ∫⁻ x, ‖g x‖ₑ ^ r.toReal ∂μ = ∫⁻ x, ‖f x‖ₑ ^ r.toReal ∂μ :=
    lintegral_congr_ae (hfg.mono fun x hx => by simp only [hx])
  have hswap_p : (∫⁻ t in Set.Ioi (0:ℝ), ENNReal.ofReal (t ^ (r.toReal - p.toReal - 1)) * Np t)
      = ENNReal.ofReal (1 / (r.toReal - p.toReal)) * ∫⁻ x, ‖f x‖ₑ ^ r.toReal ∂μ := by
    simp_rw [hNp_g]
    rw [swap_eval_low hg hpp h_pr, hJ_g]
  have hswap_q : (∫⁻ t in Set.Ioi (0:ℝ), ENNReal.ofReal (t ^ (r.toReal - q.toReal - 1)) * Nq t)
      = ENNReal.ofReal (1 / (q.toReal - r.toReal)) * ∫⁻ x, ‖f x‖ₑ ^ r.toReal ∂μ := by
    simp_rw [hNq_g]
    rw [swap_eval_high hg hrr h_rq, hJ_g]
  -- final assembly
  calc ∫⁻ y, ‖T f y‖ₑ ^ r.toReal ∂ν
      = ENNReal.ofReal r.toReal * ∫⁻ t in Set.Ioi (0:ℝ),
          ν {a | t < ‖T f a‖} * ENNReal.ofReal (t ^ (r.toReal - 1)) := key
    _ ≤ ENNReal.ofReal r.toReal * (Cp ^ p.toReal * ENNReal.ofReal (2 ^ p.toReal)
          * (∫⁻ t in Set.Ioi (0:ℝ), ENNReal.ofReal (t ^ (r.toReal - p.toReal - 1)) * Np t)
        + Cq ^ q.toReal * ENNReal.ofReal (2 ^ q.toReal)
          * (∫⁻ t in Set.Ioi (0:ℝ), ENNReal.ofReal (t ^ (r.toReal - q.toReal - 1)) * Nq t)) := by
        rw [← hadd]
        gcongr
    _ = (ENNReal.ofReal r.toReal *
          (Cp ^ p.toReal * ENNReal.ofReal (2 ^ p.toReal)
              * ENNReal.ofReal (1/(r.toReal - p.toReal))
            + Cq ^ q.toReal * ENNReal.ofReal (2 ^ q.toReal)
              * ENNReal.ofReal (1/(q.toReal - r.toReal))))
        * ∫⁻ x, ‖f x‖ₑ ^ r.toReal ∂μ := by
        rw [hswap_p, hswap_q]
        ring

/-- **Strong-type Marcinkiewicz, membership form:** a sublinear `T` of weak types `(p,p)` and
    `(q,q)` maps `Lʳ` into `Lʳ` for every `p < r < q` (quantitative bound in
    `lintegral_rpow_le_of_hasWeakType`). -/
theorem memLp_of_hasWeakType [SFinite μ] {q r : ℝ≥0∞}
    {T : (α → E) → α' → F} {ν : Measure α'} {Cp Cq : ℝ≥0∞}
    (hp0 : p ≠ 0) (hpr : p < r) (hrq : r < q) (hq_top : q ≠ ∞) (hCp : Cp ≠ ∞) (hCq : Cq ≠ ∞)
    (hTp : HasWeakType T p μ ν Cp) (hTq : HasWeakType T q μ ν Cq)
    (hT_sub : ∀ g h : α → E, MemLp g p μ → MemLp h q μ →
      ∀ᵐ y ∂ν, ‖T (g + h) y‖ₑ ≤ ‖T g y‖ₑ + ‖T h y‖ₑ)
    {f : α → E} (hf : MemLp f r μ) (hTf : AEStronglyMeasurable (T f) ν) :
    MemLp (T f) r ν := by
  have hr_top : r ≠ ∞ := (hrq.trans_le le_top).ne
  have hr0 : r ≠ 0 := fun h0 => absurd hpr (by simp [h0])
  have hpp : 0 < p.toReal := ENNReal.toReal_pos hp0 ((hpr.trans_le le_top).ne)
  have hqq : 0 < q.toReal := ENNReal.toReal_pos (fun h0 => absurd hrq (by simp [h0])) hq_top
  refine ⟨hTf, ?_⟩
  rw [eLpNorm_eq_lintegral_rpow_enorm_toReal hr0 hr_top]
  refine ENNReal.rpow_lt_top_of_nonneg (by positivity) ?_
  refine ne_top_of_le_ne_top (ENNReal.mul_ne_top ?_
    (lintegral_enorm_rpow_ne_top_of_memLp hr0 hr_top hf))
    (lintegral_rpow_le_of_hasWeakType hp0 hpr hrq hq_top hCp hCq hTp hTq hT_sub hf hTf)
  exact ENNReal.mul_ne_top ENNReal.ofReal_ne_top (ENNReal.add_ne_top.mpr
    ⟨ENNReal.mul_ne_top (ENNReal.mul_ne_top (ENNReal.rpow_ne_top_of_nonneg hpp.le hCp)
        ENNReal.ofReal_ne_top) ENNReal.ofReal_ne_top,
      ENNReal.mul_ne_top (ENNReal.mul_ne_top (ENNReal.rpow_ne_top_of_nonneg hqq.le hCq)
        ENNReal.ofReal_ne_top) ENNReal.ofReal_ne_top⟩)

#eval "Rung 2 (first bite): weak-Lᵖ quasinorm + Lᵖ ⊆ L^{p,∞} embedding + props — machine-verified."

end NSWeakLp
