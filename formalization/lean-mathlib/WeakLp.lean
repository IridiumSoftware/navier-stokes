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

#eval "Rung 2 (first bite): weak-Lᵖ quasinorm + Lᵖ ⊆ L^{p,∞} embedding + props — machine-verified."

end NSWeakLp
