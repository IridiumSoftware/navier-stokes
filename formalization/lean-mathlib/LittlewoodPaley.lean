/-
  LittlewoodPaley.lean — Rung 2: the dyadic Littlewood–Paley partition of unity.

  THE foundational object of Littlewood–Paley theory / Besov spaces: a smooth `lpSymbol`
  supported in the annulus `{1/2 < ‖ξ‖ < 2}`, with values in `[0,1]`, whose dyadic dilates
  `lpSymbolAt j ξ = lpSymbol (2^{−j}·ξ)` form a **partition of unity on frequency space**:
      `∀ ξ ≠ 0, HasSum (fun j : ℤ => lpSymbolAt j ξ) 1`,
  with at most finitely many (≤ 3) nonzero terms at each `ξ` and supports pairwise disjoint
  beyond gap 2. Everything downstream (frequency projections `P_j`, Besov norms `Ḃ^s_{p,q}` —
  the space the NS-046 target is stated in; Tao's frequency-localized estimates) is built on
  this object. Construction: `ψ(ξ) = χ(ξ) − χ(2ξ)` for a bump `χ` (=1 on `‖ξ‖≤1`, =0 on
  `‖ξ‖≥2`); the dyadic sum telescopes, and only the window `j ∈ {L−1,L,L+1}`,
  `L = Int.log 2 ‖ξ‖`, survives.

  Purely real-analytic (no Fourier transform needed at this layer). Pin: v4.30.0-rc2 + Mathlib.
  `:proved` = 0 for the PDE — library infrastructure.
-/
import Mathlib
open Metric Function

namespace NSLittlewoodPaley

variable (E : Type*) [NormedAddCommGroup E] [NormedSpace ℝ E] [HasContDiffBump E]

/-- The canonical bump: `χ = 1` on `‖ξ‖ ≤ 1`, `supp χ = {‖ξ‖ < 2}`, values in `[0,1]`. -/
noncomputable def lpChi : ContDiffBump (0 : E) := ⟨1, 2, one_pos, one_lt_two⟩

@[simp] theorem lpChi_rIn : (lpChi E).rIn = 1 := rfl
@[simp] theorem lpChi_rOut : (lpChi E).rOut = 2 := rfl

/-- The Littlewood–Paley annulus symbol `ψ(ξ) = χ(ξ) − χ(2ξ)`. -/
noncomputable def lpSymbol (ξ : E) : ℝ := lpChi E ξ - lpChi E ((2:ℝ) • ξ)

/-- The dyadic family `ψ_j(ξ) = ψ(2^{−j} ξ)`, supported in `{2^{j−1} < ‖ξ‖ < 2^{j+1}}`. -/
noncomputable def lpSymbolAt (j : ℤ) (ξ : E) : ℝ := lpSymbol E ((2:ℝ) ^ (-j) • ξ)

variable {E}

/-- `ψ` is smooth (of every order). -/
theorem contDiff_lpSymbol {n : ℕ∞} : ContDiff ℝ n (lpSymbol E) := by
  refine ContDiff.sub (lpChi E).contDiff ?_
  exact (lpChi E).contDiff.comp (contDiff_const_smul _)

/-- `χ(2ξ) ≤ χ(ξ)`: where the inner bump is alive (`‖ξ‖<1`), the outer one is already `1`. -/
theorem lpChi_two_smul_le (ξ : E) : lpChi E ((2:ℝ) • ξ) ≤ lpChi E ξ := by
  rcases eq_or_ne (lpChi E ((2:ℝ) • ξ)) 0 with h | h
  · rw [h]; exact (lpChi E).nonneg
  · have hmem : (2:ℝ) • ξ ∈ ball (0:E) 2 := by
      have h' := mem_support.mpr h
      rwa [(lpChi E).support_eq, lpChi_rOut] at h'
    have hξ : ‖ξ‖ < 1 := by
      have h2 := mem_ball_zero_iff.mp hmem
      rw [norm_smul, Real.norm_ofNat] at h2
      linarith
    have h1 : lpChi E ξ = 1 := (lpChi E).one_of_mem_closedBall
      (by rw [mem_closedBall_zero_iff, lpChi_rIn]; exact hξ.le)
    rw [h1]
    exact (lpChi E).le_one

theorem lpSymbol_nonneg (ξ : E) : 0 ≤ lpSymbol E ξ :=
  sub_nonneg.mpr (lpChi_two_smul_le ξ)

theorem lpSymbol_le_one (ξ : E) : lpSymbol E ξ ≤ 1 :=
  le_trans (sub_le_self _ (lpChi E).nonneg) (lpChi E).le_one

/-- `ψ` vanishes on `‖ξ‖ ≤ 1/2` (the inner edge of the annulus). -/
theorem lpSymbol_eq_zero_of_le_half {ξ : E} (h : ‖ξ‖ ≤ 1/2) : lpSymbol E ξ = 0 := by
  rw [lpSymbol, (lpChi E).one_of_mem_closedBall
        (by rw [mem_closedBall_zero_iff]; simpa using h.trans (by norm_num)),
      (lpChi E).one_of_mem_closedBall
        (by rw [mem_closedBall_zero_iff, norm_smul, Real.norm_ofNat]; simpa using by linarith),
      sub_self]

/-- `ψ` vanishes on `2 ≤ ‖ξ‖` (the outer edge of the annulus). -/
theorem lpSymbol_eq_zero_of_two_le {ξ : E} (h : 2 ≤ ‖ξ‖) : lpSymbol E ξ = 0 := by
  rw [lpSymbol,
      (lpChi E).zero_of_le_dist (by rw [dist_zero_right]; simpa using h),
      (lpChi E).zero_of_le_dist
        (by rw [dist_zero_right, norm_smul, Real.norm_ofNat]; simpa using by linarith),
      sub_self]

omit [HasContDiffBump E] in
/-- The norm of the dyadic rescaling. -/
theorem norm_zpow_smul (j : ℤ) (ξ : E) : ‖(2:ℝ) ^ (-j) • ξ‖ = (2:ℝ) ^ (-j) * ‖ξ‖ := by
  rw [norm_smul, norm_zpow, Real.norm_ofNat]

theorem lpSymbolAt_nonneg (j : ℤ) (ξ : E) : 0 ≤ lpSymbolAt E j ξ := lpSymbol_nonneg _

theorem lpSymbolAt_le_one (j : ℤ) (ξ : E) : lpSymbolAt E j ξ ≤ 1 := lpSymbol_le_one _

/-- Support of `ψ_j`: nonvanishing forces `2^{j−1} < ‖ξ‖ < 2^{j+1}`. -/
theorem norm_mem_of_lpSymbolAt_ne_zero {j : ℤ} {ξ : E} (h : lpSymbolAt E j ξ ≠ 0) :
    (2:ℝ) ^ (j-1) < ‖ξ‖ ∧ ‖ξ‖ < (2:ℝ) ^ (j+1) := by
  have h1 : ¬ (‖(2:ℝ) ^ (-j) • ξ‖ ≤ 1/2) := fun hc => h (lpSymbol_eq_zero_of_le_half hc)
  have h2 : ¬ ((2:ℝ) ≤ ‖(2:ℝ) ^ (-j) • ξ‖) := fun hc => h (lpSymbol_eq_zero_of_two_le hc)
  rw [norm_zpow_smul, not_le] at h1 h2
  have hzp : (0:ℝ) < (2:ℝ) ^ j := zpow_pos (by norm_num) _
  constructor
  · have := h1
    calc (2:ℝ) ^ (j-1) = (2:ℝ) ^ j * (1/2) := by
          rw [show j - 1 = j + (-1) by ring, zpow_add₀ (by norm_num : (2:ℝ) ≠ 0)]
          norm_num
      _ < (2:ℝ) ^ j * ((2:ℝ) ^ (-j) * ‖ξ‖) := mul_lt_mul_of_pos_left this hzp
      _ = ‖ξ‖ := by
          rw [← mul_assoc, ← zpow_add₀ (by norm_num : (2:ℝ) ≠ 0)]
          simp
  · have := h2
    calc ‖ξ‖ = (2:ℝ) ^ j * ((2:ℝ) ^ (-j) * ‖ξ‖) := by
          rw [← mul_assoc, ← zpow_add₀ (by norm_num : (2:ℝ) ≠ 0)]
          simp
      _ < (2:ℝ) ^ j * 2 := mul_lt_mul_of_pos_left this hzp
      _ = (2:ℝ) ^ (j+1) := by
          rw [zpow_add₀ (by norm_num : (2:ℝ) ≠ 0)]
          norm_num

/-- Dyadic supports are disjoint beyond gap `2`: `ψ_j · ψ_k = 0` for `j + 2 ≤ k`. -/
theorem lpSymbolAt_mul_eq_zero {j k : ℤ} (hjk : j + 2 ≤ k) (ξ : E) :
    lpSymbolAt E j ξ * lpSymbolAt E k ξ = 0 := by
  rcases eq_or_ne (lpSymbolAt E j ξ) 0 with h | hj
  · rw [h, zero_mul]
  rcases eq_or_ne (lpSymbolAt E k ξ) 0 with h | hk
  · rw [h, mul_zero]
  exfalso
  have b1 := (norm_mem_of_lpSymbolAt_ne_zero hj).2
  have b2 := (norm_mem_of_lpSymbolAt_ne_zero hk).1
  have hle : (2:ℝ) ^ (j+1) ≤ (2:ℝ) ^ (k-1) :=
    zpow_le_zpow_right₀ (by norm_num) (by omega)
  linarith

/-- The telescoping representation: `ψ_j(ξ) = A j − A (j−1)` with `A j = χ(2^{−j} ξ)`. -/
theorem lpSymbolAt_eq_sub (j : ℤ) (ξ : E) :
    lpSymbolAt E j ξ
      = lpChi E ((2:ℝ) ^ (-j) • ξ) - lpChi E ((2:ℝ) ^ (-(j-1)) • ξ) := by
  rw [lpSymbolAt, lpSymbol, smul_smul,
      show (2:ℝ) * (2:ℝ) ^ (-j) = (2:ℝ) ^ (-(j-1)) by
        rw [show -(j-1) = (-j) + 1 by ring, zpow_add₀ (by norm_num : (2:ℝ) ≠ 0)]
        ring]

/-- **The dyadic Littlewood–Paley partition of unity:** for every `ξ ≠ 0`,
    `Σ_{j∈ℤ} ψ(2^{−j} ξ) = 1` — with at most three nonzero terms, located in the window
    `{L−1, L, L+1}`, `L = Int.log 2 ‖ξ‖`. -/
theorem hasSum_lpSymbolAt {ξ : E} (hξ : ξ ≠ 0) :
    HasSum (fun j : ℤ => lpSymbolAt E j ξ) 1 := by
  have hpos : (0:ℝ) < ‖ξ‖ := norm_pos_iff.mpr hξ
  set L : ℤ := Int.log 2 ‖ξ‖ with hL
  have hlow : (2:ℝ) ^ L ≤ ‖ξ‖ := by
    simpa using Int.zpow_log_le_self (b := 2) one_lt_two hpos
  have hhigh : ‖ξ‖ < (2:ℝ) ^ (L+1) := by
    simpa using Int.lt_zpow_succ_log_self (b := 2) one_lt_two ‖ξ‖
  -- the window
  set s : Finset ℤ := {L-1, L, L+1} with hs
  -- terms vanish outside the window
  have hvanish : ∀ j : ℤ, j ∉ s → lpSymbolAt E j ξ = 0 := by
    intro j hj
    simp only [hs, Finset.mem_insert, Finset.mem_singleton] at hj
    have hcase : j ≤ L - 2 ∨ L + 2 ≤ j := by omega
    rcases hcase with hc | hc
    · -- far low frequency: 2^{−j}‖ξ‖ ≥ 2^{L−j} ≥ 4 > 2
      refine lpSymbol_eq_zero_of_two_le ?_
      rw [norm_zpow_smul]
      calc (2:ℝ) ≤ (2:ℝ) ^ (L-j) := by
            calc (2:ℝ) = (2:ℝ) ^ (1:ℤ) := by norm_num
              _ ≤ (2:ℝ) ^ (L-j) := zpow_le_zpow_right₀ (by norm_num) (by omega)
        _ = (2:ℝ) ^ (-j) * (2:ℝ) ^ L := by
            rw [← zpow_add₀ (by norm_num : (2:ℝ) ≠ 0)]
            congr 1
            ring
        _ ≤ (2:ℝ) ^ (-j) * ‖ξ‖ :=
            mul_le_mul_of_nonneg_left hlow (zpow_pos (by norm_num) _).le
    · -- far high frequency: 2^{−j}‖ξ‖ < 2^{L+1−j} ≤ 1/2
      refine lpSymbol_eq_zero_of_le_half ?_
      rw [norm_zpow_smul]
      calc (2:ℝ) ^ (-j) * ‖ξ‖ ≤ (2:ℝ) ^ (-j) * (2:ℝ) ^ (L+1) :=
            mul_le_mul_of_nonneg_left hhigh.le (zpow_pos (by norm_num) _).le
        _ = (2:ℝ) ^ (L+1-j) := by
            rw [← zpow_add₀ (by norm_num : (2:ℝ) ≠ 0)]
            congr 1
            ring
        _ ≤ (2:ℝ) ^ (-1 : ℤ) := zpow_le_zpow_right₀ (by norm_num) (by omega)
        _ = 1/2 := by norm_num
  -- the windowed sum telescopes to 1
  have hA_top : lpChi E ((2:ℝ) ^ (-(L+1)) • ξ) = 1 := by
    refine (lpChi E).one_of_mem_closedBall ?_
    rw [mem_closedBall_zero_iff, norm_zpow_smul, lpChi_rIn]
    calc (2:ℝ) ^ (-(L+1)) * ‖ξ‖ ≤ (2:ℝ) ^ (-(L+1)) * (2:ℝ) ^ (L+1) :=
          mul_le_mul_of_nonneg_left hhigh.le (zpow_pos (by norm_num) _).le
      _ = 1 := by
          rw [← zpow_add₀ (by norm_num : (2:ℝ) ≠ 0)]
          norm_num
  have hA_bot : lpChi E ((2:ℝ) ^ (-(L-2)) • ξ) = 0 := by
    refine (lpChi E).zero_of_le_dist ?_
    rw [dist_zero_right, norm_zpow_smul, lpChi_rOut]
    calc (2:ℝ) ≤ (2:ℝ) ^ (2:ℤ) := by norm_num
      _ = (2:ℝ) ^ (-(L-2)) * (2:ℝ) ^ L := by
          rw [← zpow_add₀ (by norm_num : (2:ℝ) ≠ 0)]
          congr 1
          ring
      _ ≤ (2:ℝ) ^ (-(L-2)) * ‖ξ‖ :=
          mul_le_mul_of_nonneg_left hlow (zpow_pos (by norm_num) _).le
  have hsum : ∑ j ∈ s, lpSymbolAt E j ξ = 1 := by
    rw [hs, Finset.sum_insert (by simp only [Finset.mem_insert, Finset.mem_singleton]; omega),
        Finset.sum_insert (by simp only [Finset.mem_singleton]; omega),
        Finset.sum_singleton, lpSymbolAt_eq_sub, lpSymbolAt_eq_sub, lpSymbolAt_eq_sub,
        show L - 1 - 1 = L - 2 by ring, show L + 1 - 1 = L by ring, hA_top, hA_bot]
    ring
  have hfin : HasSum (fun j : ℤ => lpSymbolAt E j ξ) (∑ j ∈ s, lpSymbolAt E j ξ) :=
    hasSum_sum_of_ne_finset_zero hvanish
  rwa [hsum] at hfin

/-! ### Frequency projections `P_j` and the Besov seminorm

Built on Mathlib's `SchwartzMap.fourierMultiplierCLM` (Doll, 2025): `P_j` is the Fourier
multiplier with symbol `ψ_j`. The symbol is smooth with compact support, hence of temperate
growth, so `P_j : 𝓢(V,F) →L[ℂ] 𝓢(V,F)` — and the tempered-distribution version is available
from the same framework. The homogeneous Besov seminorm `‖f‖_{Ḃ^s_{p,q}}` is the `ℓ^q(ℤ)`
norm of `j ↦ 2^{js}·‖P_j f‖_{L^p}`. -/

section Projection

open MeasureTheory SchwartzMap
open scoped SchwartzMap ENNReal

variable (V F : Type*)
  [NormedAddCommGroup V] [InnerProductSpace ℝ V] [FiniteDimensional ℝ V]
  [MeasurableSpace V] [BorelSpace V]
  [NormedAddCommGroup F] [NormedSpace ℂ F] [CompleteSpace F]

/-- The complexified Littlewood–Paley symbol. -/
noncomputable def lpSymbolAtC (j : ℤ) : V → ℂ := fun ξ => (lpSymbolAt V j ξ : ℂ)

variable {V F}

theorem contDiff_lpSymbolAt {n : ℕ∞} (j : ℤ) : ContDiff ℝ n (lpSymbolAt V j) :=
  contDiff_lpSymbol.comp (contDiff_const_smul _)

theorem hasCompactSupport_lpSymbolAt (j : ℤ) : HasCompactSupport (lpSymbolAt V j) := by
  refine HasCompactSupport.intro (isCompact_closedBall (0:V) ((2:ℝ)^(j+1))) fun ξ hξ => ?_
  rw [Metric.mem_closedBall, dist_zero_right, not_le] at hξ
  by_contra h
  exact absurd (norm_mem_of_lpSymbolAt_ne_zero h).2 (not_lt.mpr hξ.le)

theorem hasTemperateGrowth_lpSymbolAtC (j : ℤ) :
    Function.HasTemperateGrowth (lpSymbolAtC V j) := by
  refine HasCompactSupport.hasTemperateGrowth ?_ ?_
  · exact (hasCompactSupport_lpSymbolAt j).comp_left Complex.ofReal_zero
  · exact Complex.ofRealCLM.contDiff.comp (contDiff_lpSymbolAt j)

variable (V F) in
/-- The **Littlewood–Paley frequency projection** `P_j = ψ_j(D)`: the Fourier multiplier with
    symbol `ψ_j`, as a continuous linear map on Schwartz space. -/
noncomputable def lpProj (j : ℤ) : 𝓢(V, F) →L[ℂ] 𝓢(V, F) :=
  fourierMultiplierCLM F (lpSymbolAtC V j)

/-- Projections with frequency gap `≥ 2` annihilate each other: `P_j ∘ P_k = 0`. -/
theorem lpProj_comp_eq_zero {j k : ℤ} (h : j + 2 ≤ k) :
    lpProj V F j ∘L lpProj V F k = 0 := by
  rw [lpProj, lpProj, fourierMultiplierCLM_compL_fourierMultiplierCLM
        (hasTemperateGrowth_lpSymbolAtC j) (hasTemperateGrowth_lpSymbolAtC k)]
  have hzero : lpSymbolAtC V j * lpSymbolAtC V k = fun _ : V => (0:ℂ) := by
    funext ξ
    rw [Pi.mul_apply, lpSymbolAtC, lpSymbolAtC, ← Complex.ofReal_mul,
        lpSymbolAt_mul_eq_zero h ξ, Complex.ofReal_zero]
  rw [hzero, fourierMultiplierCLM_const, zero_smul]

variable (F) in
/-- The **homogeneous Besov seminorm** `‖f‖_{Ḃ^s_{p,q}(μ)}`: the `ℓ^q(ℤ)` norm of the
    weighted frequency-block sizes `j ↦ 2^{js}·‖P_j f‖_{L^p(μ)}`, on Schwartz functions.
    (The full Besov *space* — tempered distributions modulo polynomials — is a later layer.) -/
noncomputable def besovSeminorm (s : ℝ) (p q : ℝ≥0∞) (μ : Measure V) (f : 𝓢(V, F)) : ℝ≥0∞ :=
  if q = ∞ then ⨆ j : ℤ, (2:ℝ≥0∞) ^ ((j:ℝ) * s) * eLpNorm (lpProj V F j f) p μ
  else (∑' j : ℤ, ((2:ℝ≥0∞) ^ ((j:ℝ) * s) * eLpNorm (lpProj V F j f) p μ) ^ q.toReal)
        ^ (1 / q.toReal)

theorem besovSeminorm_zero {s : ℝ} {p q : ℝ≥0∞} (hq : q ≠ 0) (μ : Measure V) :
    besovSeminorm F s p q μ (0 : 𝓢(V, F)) = 0 := by
  have hterm : ∀ j : ℤ,
      (2:ℝ≥0∞) ^ ((j:ℝ) * s) * eLpNorm ((lpProj V F j) (0 : 𝓢(V, F))) p μ = 0 := by
    intro j
    rw [map_zero]
    simp
  rw [besovSeminorm]
  split
  · simp only [hterm, iSup_const]
  case isFalse hq_top =>
    have hqr : 0 < q.toReal := ENNReal.toReal_pos hq hq_top
    have h2 : ∀ j : ℤ,
        ((2:ℝ≥0∞) ^ ((j:ℝ) * s)
            * eLpNorm (⇑((lpProj V F j) (0 : 𝓢(V, F)))) p μ) ^ q.toReal = 0 :=
      fun j => by rw [hterm j, ENNReal.zero_rpow_of_pos hqr]
    rw [tsum_congr h2, tsum_zero, ENNReal.zero_rpow_of_pos (one_div_pos.mpr hqr)]

end Projection





/-! ### Bernstein inequality (L² case)

Frequency localization makes a derivative cost only `2^j`:
`‖∂_m P_j f‖_{L²} ≤ 2π‖m‖·2^{j+1}·‖P_j f‖_{L²}`. Pure Plancherel — the symbol of `∂_m P_j` is
`2πi⟨ξ,m⟩ψ_j(ξ)`, and on `supp ψ_j` one has `‖ξ‖ < 2^{j+1}`. This is the load-bearing case for
NS (frequency-localized enstrophy estimates are L²); `Lᵖ` Bernstein needs the
multiplier-as-convolution bridge + Young and is a later bite. -/

section Bernstein

open MeasureTheory FourierTransform SchwartzMap Real
open scoped SchwartzMap ENNReal

variable {V W : Type*}
  [NormedAddCommGroup V] [MeasurableSpace V] [BorelSpace V]
  [InnerProductSpace ℝ V] [FiniteDimensional ℝ V]
  [NormedAddCommGroup W] [InnerProductSpace ℂ W] [CompleteSpace W]

/-- The `ℂ`- and `ℝ`-actions on a complex normed space commute (local instance: the
    symmetric form is not a global instance to avoid loops). -/
local instance : SMulCommClass ℂ ℝ W := SMulCommClass.symm ℝ ℂ W

theorem hasTemperateGrowth_lpSymbolAt (j : ℤ) :
    Function.HasTemperateGrowth (lpSymbolAt V j) :=
  (hasCompactSupport_lpSymbolAt j).hasTemperateGrowth (contDiff_lpSymbolAt j)

/-- Over a `ℂ`-module the `ℂ`- and `ℝ`-symbol Littlewood–Paley multipliers agree. -/
theorem lpProj_eq_realMultiplier (j : ℤ) (f : 𝓢(V, W)) :
    lpProj V W j f = fourierMultiplierCLM (𝕜 := ℝ) W (lpSymbolAt V j) f := by
  rw [lpProj, fourierMultiplierCLM_apply, fourierMultiplierCLM_apply]
  have hs : smulLeftCLM W (lpSymbolAtC V j) (𝓕 f)
      = smulLeftCLM (𝕜 := ℝ) W (lpSymbolAt V j) (𝓕 f) := by
    ext ξ
    rw [smulLeftCLM_apply_apply (hasTemperateGrowth_lpSymbolAtC j),
        smulLeftCLM_apply_apply (hasTemperateGrowth_lpSymbolAt j)]
    show ((lpSymbolAt V j ξ : ℝ) : ℂ) • (𝓕 f) ξ = lpSymbolAt V j ξ • (𝓕 f) ξ
    rfl
  rw [hs]

/-- Plancherel for the inverse transform, `eLpNorm` form, on Schwartz functions. -/
theorem eLpNorm_fourierInv_two (u : 𝓢(V, W)) :
    eLpNorm (⇑(𝓕⁻ u : 𝓢(V, W))) 2 volume = eLpNorm (⇑u) 2 volume := by
  have h1 : ‖((𝓕⁻ u : 𝓢(V, W)).toLp 2 (volume : Measure V))‖
      = ‖(u.toLp 2 (volume : Measure V))‖ := by
    rw [← SchwartzMap.toLp_fourierInv_eq]
    calc ‖𝓕⁻ (u.toLp 2 (volume : Measure V))‖
        = ‖𝓕 (𝓕⁻ (u.toLp 2 (volume : Measure V)))‖ :=
          (MeasureTheory.Lp.norm_fourier_eq _).symm
      _ = ‖(u.toLp 2 (volume : Measure V))‖ := by
          rw [FourierTransform.fourier_fourierInv_eq]
  rw [SchwartzMap.norm_toLp, SchwartzMap.norm_toLp] at h1
  exact (ENNReal.toReal_eq_toReal_iff' ((𝓕⁻ u : 𝓢(V, W)).memLp 2 volume).2.ne
    (u.memLp 2 volume).2.ne).mp h1

/-- **Bernstein inequality, L² case:** a directional derivative of the frequency-`2^j`
    block costs at most `2π‖m‖·2^{j+1}`. -/
theorem eLpNorm_lineDerivOp_lpProj_le (j : ℤ) (m : V) (f : 𝓢(V, W)) :
    eLpNorm (⇑(LineDeriv.lineDerivOp m (lpProj V W j f))) 2 volume
      ≤ ENNReal.ofReal (2 * π * ‖m‖ * 2 ^ (j+1))
          * eLpNorm (⇑(lpProj V W j f)) 2 volume := by
  have hσ : Function.HasTemperateGrowth (inner ℝ · m) := hasTemperateGrowth_inner_left m
  have hσψ : Function.HasTemperateGrowth ((inner ℝ · m) * lpSymbolAt V j) :=
    hσ.mul (hasTemperateGrowth_lpSymbolAt j)
  -- symbol composition: ∂_m P_j is the multiplier with symbol 2πi·⟨ξ,m⟩ψ_j(ξ), over ℝ
  rw [lineDeriv_eq_fourierMultiplierCLM m (lpProj V W j f), lpProj_eq_realMultiplier,
      fourierMultiplierCLM_fourierMultiplierCLM_apply hσ (hasTemperateGrowth_lpSymbolAt j)]
  -- Plancherel both sides
  have hP1 : eLpNorm (⇑(fourierMultiplierCLM (𝕜 := ℝ) W
        ((inner ℝ · m) * lpSymbolAt V j) f)) 2 volume
      = eLpNorm (⇑(smulLeftCLM (𝕜 := ℝ) W
          ((inner ℝ · m) * lpSymbolAt V j) (𝓕 f))) 2 volume := by
    rw [fourierMultiplierCLM_apply, eLpNorm_fourierInv_two]
  have hP2 : eLpNorm (⇑(fourierMultiplierCLM (𝕜 := ℝ) W (lpSymbolAt V j) f)) 2 volume
      = eLpNorm (⇑(smulLeftCLM (𝕜 := ℝ) W (lpSymbolAt V j) (𝓕 f))) 2 volume := by
    rw [fourierMultiplierCLM_apply, eLpNorm_fourierInv_two]
  -- the pointwise symbol bound on the Fourier side
  have hC : (0:ℝ) ≤ ‖m‖ * 2 ^ (j+1) := by positivity
  have hpt : ∀ ξ : V, ‖smulLeftCLM (𝕜 := ℝ) W
        ((inner ℝ · m) * lpSymbolAt V j) (𝓕 f) ξ‖
      ≤ ‖(‖m‖ * 2 ^ (j+1)) * ‖smulLeftCLM (𝕜 := ℝ) W (lpSymbolAt V j) (𝓕 f) ξ‖‖ := by
    intro ξ
    rw [smulLeftCLM_apply_apply hσψ, smulLeftCLM_apply_apply (hasTemperateGrowth_lpSymbolAt j),
        Real.norm_eq_abs ((‖m‖ * 2 ^ (j+1)) * _), abs_of_nonneg (by positivity),
        norm_smul, norm_smul, Pi.mul_apply]
    rcases eq_or_ne (lpSymbolAt V j ξ) 0 with h0 | h0
    · simp [h0]
    · have hb := (norm_mem_of_lpSymbolAt_ne_zero h0).2
      have hψ0 : 0 ≤ lpSymbolAt V j ξ := lpSymbolAt_nonneg j ξ
      have hin : |inner ℝ ξ m| ≤ (2:ℝ) ^ (j+1) * ‖m‖ := by
        calc |inner ℝ ξ m| ≤ ‖ξ‖ * ‖m‖ := abs_real_inner_le_norm ξ m
          _ ≤ (2:ℝ) ^ (j+1) * ‖m‖ := by
              have hm0 : (0:ℝ) ≤ ‖m‖ := norm_nonneg m
              nlinarith
      have hF0 : (0:ℝ) ≤ ‖(𝓕 f) ξ‖ := norm_nonneg _
      rw [Real.norm_eq_abs (inner ℝ ξ m * lpSymbolAt V j ξ), abs_mul,
          Real.norm_eq_abs (lpSymbolAt V j ξ), abs_of_nonneg hψ0]
      nlinarith [mul_le_mul_of_nonneg_right hin (mul_nonneg hψ0 hF0),
        abs_nonneg (inner ℝ ξ m)]
  -- assemble
  have hmono : eLpNorm (⇑(smulLeftCLM (𝕜 := ℝ) W
        ((inner ℝ · m) * lpSymbolAt V j) (𝓕 f))) 2 volume
      ≤ ENNReal.ofReal (‖m‖ * 2 ^ (j+1))
          * eLpNorm (⇑(smulLeftCLM (𝕜 := ℝ) W (lpSymbolAt V j) (𝓕 f))) 2 volume := by
    refine le_trans (eLpNorm_mono_ae (ae_of_all _ hpt)) ?_
    have heq : (fun ξ : V => (‖m‖ * 2 ^ (j+1))
          * ‖smulLeftCLM (𝕜 := ℝ) W (lpSymbolAt V j) (𝓕 f) ξ‖)
        = (‖m‖ * 2 ^ (j+1))
          • (fun ξ : V => ‖smulLeftCLM (𝕜 := ℝ) W (lpSymbolAt V j) (𝓕 f) ξ‖) := by
      funext ξ
      simp [smul_eq_mul]
    rw [heq, eLpNorm_const_smul, eLpNorm_norm, Real.enorm_eq_ofReal hC]
  have hsmul : eLpNorm (⇑((2 * ↑π * Complex.I : ℂ) • fourierMultiplierCLM (𝕜 := ℝ) W
        ((inner ℝ · m) * lpSymbolAt V j) f)) 2 volume
      = ‖(2 * ↑π * Complex.I : ℂ)‖ₑ * eLpNorm (⇑(fourierMultiplierCLM (𝕜 := ℝ) W
          ((inner ℝ · m) * lpSymbolAt V j) f)) 2 volume := by
    rw [show ⇑((2 * ↑π * Complex.I : ℂ) • fourierMultiplierCLM (𝕜 := ℝ) W
          ((inner ℝ · m) * lpSymbolAt V j) f)
        = (2 * ↑π * Complex.I : ℂ) • ⇑(fourierMultiplierCLM (𝕜 := ℝ) W
          ((inner ℝ · m) * lpSymbolAt V j) f) from rfl,
      eLpNorm_const_smul]
  rw [hsmul, hP1, hP2]
  refine le_trans (mul_le_mul_left' hmono _) ?_
  rw [← mul_assoc]
  refine mul_le_mul_right' (le_of_eq ?_) _
  have h2pi : ‖(2 * ↑π * Complex.I : ℂ)‖ₑ = ENNReal.ofReal (2 * π) := by
    rw [← ofReal_norm_eq_enorm]
    congr 1
    simp only [norm_mul, Complex.norm_I, mul_one, Complex.norm_ofNat, Complex.norm_real,
      Real.norm_eq_abs]
    rw [abs_of_pos pi_pos]
  rw [h2pi, ← ENNReal.ofReal_mul (by positivity)]
  congr 1
  ring

end Bernstein

/-! ### Young's inequality and the multiplier–convolution bridge (toward Lᵖ Bernstein)

`‖k ⋆ g‖_{Lᵖ} ≤ ‖k‖_{L¹}·‖g‖_{Lᵖ}` (Young, here for Schwartz inputs), and: a Fourier multiplier
with **Schwartz symbol** `σ` *is* convolution against the kernel `𝓕⁻σ` — hence bounded on every
`Lᵖ` with constant `‖𝓕⁻σ‖_{L¹}`. This is the structural content of `Lᵖ` Bernstein; the sharp
`2^j` for the Littlewood–Paley blocks is a kernel-scaling computation on top (next bite). -/

section Young

open MeasureTheory FourierTransform SchwartzMap Real
open scoped SchwartzMap ENNReal

variable {V W : Type*}
  [NormedAddCommGroup V] [MeasurableSpace V] [BorelSpace V]
  [InnerProductSpace ℝ V] [FiniteDimensional ℝ V]
  [NormedAddCommGroup W] [InnerProductSpace ℂ W] [CompleteSpace W]

/-- **Young's inequality** `‖k ⋆ g‖_{Lᵖ} ≤ ‖k‖_{L¹}·‖g‖_{Lᵖ}`, for Schwartz `k` (scalar) and
    `g`, `1 ≤ p < ∞`: Hölder against the measure `‖k‖dμ`, Tonelli, translation invariance. -/
theorem eLpNorm_convolution_le (k : 𝓢(V, ℂ)) (g : 𝓢(V, W)) {p : ℝ≥0∞}
    (h1p : 1 ≤ p) (hp_top : p ≠ ∞) :
    eLpNorm (MeasureTheory.convolution ⇑k ⇑g (ContinuousLinearMap.lsmul ℂ ℂ) volume) p volume
      ≤ eLpNorm (⇑k) 1 volume * eLpNorm (⇑g) p volume := by
  have hp0 : p ≠ 0 := (lt_of_lt_of_le one_pos h1p).ne'
  have hpr1 : (1:ℝ) ≤ p.toReal := by
    rw [show (1:ℝ) = (1:ℝ≥0∞).toReal by simp]
    exact ENNReal.toReal_mono hp_top h1p
  have hpr0 : 0 < p.toReal := lt_of_lt_of_le one_pos hpr1
  set φ : V → ℝ≥0∞ := fun t => ‖k t‖ₑ with hφdef
  set ψ : V → ℝ≥0∞ := fun t => ‖g t‖ₑ with hψdef
  have hφm : Measurable φ := k.continuous.enorm.measurable
  have hψm : Measurable ψ := g.continuous.enorm.measurable
  set A := ∫⁻ t, φ t with hAdef
  set B := ∫⁻ t, ψ t ^ p.toReal with hBdef
  have hA_top : A ≠ ∞ := (k.integrable (μ := volume)).2.ne
  -- pointwise domination by the positive convolution
  have hpt : ∀ x : V,
      ‖MeasureTheory.convolution ⇑k ⇑g (ContinuousLinearMap.lsmul ℂ ℂ) volume x‖ₑ
        ≤ ∫⁻ t, φ t * ψ (x - t) := by
    intro x
    refine le_trans (enorm_integral_le_lintegral_enorm _) (le_of_eq ?_)
    refine lintegral_congr fun t => ?_
    show ‖k t • g (x - t)‖ₑ = φ t * ψ (x - t)
    rw [enorm_smul]
  -- the per-x Hölder step
  have hkey : ∀ x : V, (∫⁻ t, φ t * ψ (x - t)) ^ p.toReal
      ≤ A ^ (p.toReal - 1) * ∫⁻ t, φ t * ψ (x - t) ^ p.toReal := by
    intro x
    rcases eq_or_lt_of_le hpr1 with h1 | h1
    · rw [← h1]
      simp
    · -- 1 < pr: Hölder with the conjugate pair (q, pr)
      set q := p.toReal.conjExponent with hqdef
      have hconj : p.toReal.HolderConjugate q := Real.HolderConjugate.conjExponent h1
      have hinv : p.toReal⁻¹ + q⁻¹ = 1 := hconj.inv_add_inv_eq_one
      have hpinv_lt : p.toReal⁻¹ < 1 := by
        rw [inv_lt_one₀ hpr0]
        exact h1
      have hq0 : 0 < q := inv_pos.mp (by linarith)
      have hsum : 1/q + 1/p.toReal = 1 := by
        rw [one_div, one_div]
        linarith
      have hquot : p.toReal / q = p.toReal - 1 := by
        have hq' : q⁻¹ = 1 - p.toReal⁻¹ := by linarith
        rw [div_eq_mul_inv, hq', mul_sub, mul_one, mul_inv_cancel₀ hpr0.ne']
      have hH := ENNReal.lintegral_mul_le_Lp_mul_Lq volume hconj.symm
        (f := fun t => φ t ^ (1/q)) (g := fun t => φ t ^ (1/p.toReal) * ψ (x - t))
        (by fun_prop) (by fun_prop)
      have hFG : ∀ t : V, ((fun t => φ t ^ (1/q)) * fun t => φ t ^ (1/p.toReal) * ψ (x - t)) t
          = φ t * ψ (x - t) := by
        intro t
        simp only [Pi.mul_apply]
        rw [← mul_assoc]
        congr 1
        rcases eq_or_ne (φ t) 0 with h0 | h0
        · rw [h0, ENNReal.zero_rpow_of_pos (by positivity),
              ENNReal.zero_rpow_of_pos (by positivity), mul_zero]
        · rw [← ENNReal.rpow_add _ _ h0 enorm_ne_top, hsum, ENNReal.rpow_one]
      have hF : (∫⁻ t, ((fun t => φ t ^ (1/q)) t) ^ q) = A := by
        refine lintegral_congr fun t => ?_
        rw [← ENNReal.rpow_mul, one_div, inv_mul_cancel₀ hq0.ne', ENNReal.rpow_one]
      have hG : (∫⁻ t, ((fun t => φ t ^ (1/p.toReal) * ψ (x - t)) t) ^ p.toReal)
          = ∫⁻ t, φ t * ψ (x - t) ^ p.toReal := by
        refine lintegral_congr fun t => ?_
        rw [ENNReal.mul_rpow_of_nonneg _ _ hpr0.le, ← ENNReal.rpow_mul, one_div,
            inv_mul_cancel₀ hpr0.ne', ENNReal.rpow_one]
      rw [lintegral_congr hFG, hF, hG] at hH
      calc (∫⁻ t, φ t * ψ (x - t)) ^ p.toReal
          ≤ (A ^ (1/q) * (∫⁻ t, φ t * ψ (x - t) ^ p.toReal) ^ (1/p.toReal)) ^ p.toReal := by
            gcongr
        _ = A ^ (p.toReal - 1) * ∫⁻ t, φ t * ψ (x - t) ^ p.toReal := by
            rw [ENNReal.mul_rpow_of_nonneg _ _ hpr0.le, ← ENNReal.rpow_mul,
                ← ENNReal.rpow_mul, one_div, one_div, inv_mul_cancel₀ hpr0.ne',
                ENNReal.rpow_one]
            congr 2
            rw [mul_comm, show p.toReal * q⁻¹ = p.toReal / q from (div_eq_mul_inv _ _).symm]
            exact hquot
  -- integrate, swap, translate
  have hAB : ∀ a : ℝ≥0∞, a ≠ ∞ → a ^ (p.toReal - 1) * a = a ^ p.toReal := by
    intro a ha
    rcases eq_or_ne a 0 with h0 | h0
    · rcases eq_or_lt_of_le hpr1 with h1 | h1
      · rw [h0, ← h1]
        simp
      · rw [h0, ENNReal.zero_rpow_of_pos (by linarith), zero_mul,
            ENNReal.zero_rpow_of_pos hpr0]
    · nth_rewrite 2 [show a = a ^ (1:ℝ) by rw [ENNReal.rpow_one]]
      rw [← ENNReal.rpow_add _ _ h0 ha]
      congr 1
      ring
  have htotal : (∫⁻ x, (∫⁻ t, φ t * ψ (x - t)) ^ p.toReal) ≤ A ^ p.toReal * B := by
    have hswap : (∫⁻ x, ∫⁻ t, φ t * ψ (x - t) ^ p.toReal)
        = ∫⁻ t, ∫⁻ x, φ t * ψ (x - t) ^ p.toReal := by
      rw [lintegral_lintegral_swap]
      fun_prop
    calc (∫⁻ x, (∫⁻ t, φ t * ψ (x - t)) ^ p.toReal)
        ≤ ∫⁻ x, A ^ (p.toReal - 1) * ∫⁻ t, φ t * ψ (x - t) ^ p.toReal :=
          lintegral_mono fun x => hkey x
      _ = A ^ (p.toReal - 1) * ∫⁻ x, ∫⁻ t, φ t * ψ (x - t) ^ p.toReal :=
          lintegral_const_mul' _ _
            (ENNReal.rpow_ne_top_of_nonneg (by linarith) hA_top)
      _ = A ^ (p.toReal - 1) * ∫⁻ t, ∫⁻ x, φ t * ψ (x - t) ^ p.toReal := by rw [hswap]
      _ = A ^ (p.toReal - 1) * ∫⁻ t, φ t * ∫⁻ x, ψ (x - t) ^ p.toReal := by
          congr 1
          refine lintegral_congr fun t => ?_
          rw [lintegral_const_mul' _ _ enorm_ne_top]
      _ = A ^ (p.toReal - 1) * ∫⁻ t, φ t * B := by
          congr 1
          refine lintegral_congr fun t => ?_
          congr 1
          calc (∫⁻ x, ψ (x - t) ^ p.toReal)
              = ∫⁻ x, ψ (x + (-t)) ^ p.toReal := by
                refine lintegral_congr fun x => ?_
                rw [sub_eq_add_neg]
            _ = ∫⁻ y, ψ y ^ p.toReal :=
                lintegral_add_right_eq_self (fun y => ψ y ^ p.toReal) (-t)
            _ = B := hBdef.symm
      _ = A ^ (p.toReal - 1) * (A * B) := by
          have hB_top : B ≠ ∞ := by
            have hg := (g.memLp p volume).2
            rw [eLpNorm_eq_lintegral_rpow_enorm_toReal hp0 hp_top] at hg
            exact ((ENNReal.rpow_lt_top_iff_of_pos (by positivity)).mp hg).ne
          rw [lintegral_mul_const' _ _ hB_top]
      _ = A ^ p.toReal * B := by rw [← mul_assoc, hAB A hA_top]
  -- final assembly
  rw [eLpNorm_eq_lintegral_rpow_enorm_toReal hp0 hp_top, eLpNorm_one_eq_lintegral_enorm,
      eLpNorm_eq_lintegral_rpow_enorm_toReal hp0 hp_top]
  have hmono1 : (∫⁻ x, ‖MeasureTheory.convolution ⇑k ⇑g (ContinuousLinearMap.lsmul ℂ ℂ)
        volume x‖ₑ ^ p.toReal)
      ≤ ∫⁻ x, (∫⁻ t, φ t * ψ (x - t)) ^ p.toReal :=
    lintegral_mono fun x => ENNReal.rpow_le_rpow (hpt x) hpr0.le
  calc (∫⁻ x, ‖MeasureTheory.convolution ⇑k ⇑g (ContinuousLinearMap.lsmul ℂ ℂ)
        volume x‖ₑ ^ p.toReal) ^ (1/p.toReal)
      ≤ (A ^ p.toReal * B) ^ (1/p.toReal) :=
        ENNReal.rpow_le_rpow (hmono1.trans htotal) (by positivity)
    _ = A * B ^ (1/p.toReal) := by
        rw [ENNReal.mul_rpow_of_nonneg _ _ (by positivity), ← ENNReal.rpow_mul,
            mul_one_div, div_self hpr0.ne', ENNReal.rpow_one]

/-- A Fourier multiplier with **Schwartz symbol** `σ` is convolution against the Schwartz
    kernel `𝓕⁻σ`. -/
theorem fourierMultiplierCLM_schwartz_eq_convolution (σ : 𝓢(V, ℂ)) (g : 𝓢(V, W)) :
    fourierMultiplierCLM W (⇑σ) g
      = SchwartzMap.convolution (ContinuousLinearMap.lsmul ℂ ℂ) (𝓕⁻ σ) g := by
  have h2 : smulLeftCLM W (⇑σ) (𝓕 g)
      = pairing (ContinuousLinearMap.lsmul ℂ ℂ) σ (𝓕 g) := by
    ext x
    rw [smulLeftCLM_apply_apply σ.hasTemperateGrowth]
    show σ x • (𝓕 g) x = pairing (ContinuousLinearMap.lsmul ℂ ℂ) σ (𝓕 g) x
    rw [show pairing (ContinuousLinearMap.lsmul ℂ ℂ) σ (𝓕 g) x
        = ContinuousLinearMap.lsmul ℂ ℂ (σ x) ((𝓕 g) x) from congrFun (pairing_apply _ _ _) x]
    rfl
  have h3 : SchwartzMap.convolution (ContinuousLinearMap.lsmul ℂ ℂ) (𝓕⁻ σ) g
      = 𝓕⁻ (pairing (ContinuousLinearMap.lsmul ℂ ℂ) (𝓕 (𝓕⁻ σ)) (𝓕 g)) := by
    have h4 : (𝓕⁻ (𝓕 (SchwartzMap.convolution (ContinuousLinearMap.lsmul ℂ ℂ) (𝓕⁻ σ) g)
          : 𝓢(V, W)) : 𝓢(V, W))
        = SchwartzMap.convolution (ContinuousLinearMap.lsmul ℂ ℂ) (𝓕⁻ σ) g :=
      FourierTransform.fourierInv_fourier_eq _
    conv_lhs => rw [← h4]
    rw [SchwartzMap.fourier_convolution]
  rw [fourierMultiplierCLM_apply, h3, FourierTransform.fourier_fourierInv_eq, h2]

/-- **Lᵖ-boundedness of Schwartz-symbol Fourier multipliers** (the structural `Lᵖ` Bernstein):
    `‖σ(D) g‖_{Lᵖ} ≤ ‖𝓕⁻σ‖_{L¹}·‖g‖_{Lᵖ}` for `1 ≤ p < ∞`. -/
theorem eLpNorm_fourierMultiplierCLM_le (σ : 𝓢(V, ℂ)) (g : 𝓢(V, W)) {p : ℝ≥0∞}
    (h1p : 1 ≤ p) (hp_top : p ≠ ∞) :
    eLpNorm (⇑(fourierMultiplierCLM W (⇑σ) g)) p volume
      ≤ eLpNorm (⇑(𝓕⁻ σ : 𝓢(V, ℂ))) 1 volume * eLpNorm (⇑g) p volume := by
  rw [fourierMultiplierCLM_schwartz_eq_convolution]
  have hcoe : ⇑(SchwartzMap.convolution (ContinuousLinearMap.lsmul ℂ ℂ) (𝓕⁻ σ) g)
      = MeasureTheory.convolution ⇑(𝓕⁻ σ : 𝓢(V, ℂ)) ⇑g (ContinuousLinearMap.lsmul ℂ ℂ)
          volume :=
    funext (SchwartzMap.convolution_apply _ _ _)
  rw [hcoe]
  exact eLpNorm_convolution_le _ _ h1p hp_top

end Young

/-! ### Sharp Lᵖ Bernstein: the kernel symbol family and the multiplier chain

The derivative symbol `⟨ξ,m⟩` agrees with `⟨ξ,m⟩·χ̃(2^{−j}ξ)` on `supp ψ_j`, where `χ̃` (`lpFat`)
is a fattened bump `≡ 1` on the annulus `1/2 ≤ ‖η‖ ≤ 2`. The latter is a **Schwartz** symbol, so
`∂_m P_j = 2πi·σ_j(D) ∘ P_j` and the `Lᵖ` multiplier theorem applies with constant `‖𝓕⁻σ_j‖_{L¹}`;
the dilation identity `σ_j = 2^j·σ₀(2^{−j}·)` then evaluates that constant as `2^j·‖𝓕⁻σ₀‖_{L¹}`. -/

section SharpBernstein

open MeasureTheory FourierTransform SchwartzMap Real Module
open scoped SchwartzMap ENNReal

variable {V W : Type*}
  [NormedAddCommGroup V] [MeasurableSpace V] [BorelSpace V]
  [InnerProductSpace ℝ V] [FiniteDimensional ℝ V]
  [NormedAddCommGroup W] [InnerProductSpace ℂ W] [CompleteSpace W]

local instance : SMulCommClass ℂ ℝ W := SMulCommClass.symm ℝ ℂ W

variable (V) in
/-- The fattened symbol `χ̃(η) = χ(η/2) − χ(4η)`: `= 1` on `1/2 ≤ ‖η‖ ≤ 2` (⊇ `supp ψ`),
    supported in `1/4 < ‖η‖ < 4`. -/
noncomputable def lpFat (η : V) : ℝ := lpChi V ((2:ℝ)⁻¹ • η) - lpChi V ((4:ℝ) • η)

theorem contDiff_lpFat {n : ℕ∞} : ContDiff ℝ n (lpFat V) :=
  ((lpChi V).contDiff.comp (contDiff_const_smul _)).sub
    ((lpChi V).contDiff.comp (contDiff_const_smul _))

theorem lpFat_eq_one {η : V} (h1 : 1/2 ≤ ‖η‖) (h2 : ‖η‖ ≤ 2) : lpFat V η = 1 := by
  rw [lpFat, (lpChi V).one_of_mem_closedBall (by
        rw [mem_closedBall_zero_iff, norm_smul, lpChi_rIn]
        simp only [norm_inv, Real.norm_ofNat]
        rw [inv_mul_le_iff₀ (by norm_num)]
        linarith),
      (lpChi V).zero_of_le_dist (by
        rw [dist_zero_right, norm_smul, lpChi_rOut, Real.norm_ofNat]
        linarith),
      sub_zero]

theorem lpFat_eq_zero_of_four_le {η : V} (h : 4 ≤ ‖η‖) : lpFat V η = 0 := by
  rw [lpFat, (lpChi V).zero_of_le_dist (by
        rw [dist_zero_right, norm_smul, lpChi_rOut]
        simp only [norm_inv, Real.norm_ofNat]
        rw [le_inv_mul_iff₀ (by norm_num)]
        linarith),
      (lpChi V).zero_of_le_dist (by
        rw [dist_zero_right, norm_smul, lpChi_rOut, Real.norm_ofNat]
        linarith),
      sub_zero]

theorem hasCompactSupport_lpFat : HasCompactSupport (lpFat V) := by
  refine HasCompactSupport.intro (isCompact_closedBall (0:V) 4) fun η hη => ?_
  rw [Metric.mem_closedBall, dist_zero_right, not_le] at hη
  exact lpFat_eq_zero_of_four_le hη.le

variable (V) in
/-- The Bernstein kernel symbol at scale `j`: `σ_j(ξ) = ⟨ξ,m⟩·χ̃(2^{−j}ξ)`, ℂ-valued. -/
noncomputable def bernSymbolFun (j : ℤ) (m : V) (ξ : V) : ℂ :=
  ((inner ℝ ξ m * lpFat V ((2:ℝ) ^ (-j) • ξ) : ℝ) : ℂ)

theorem contDiff_bernSymbolFun {n : ℕ∞} (j : ℤ) (m : V) :
    ContDiff ℝ n (bernSymbolFun V j m) := by
  refine Complex.ofRealCLM.contDiff.comp (ContDiff.mul ?_ ?_)
  · exact (innerSL ℝ (E := V)).flip m |>.contDiff
  · exact contDiff_lpFat.comp (contDiff_const_smul _)

theorem hasCompactSupport_bernSymbolFun (j : ℤ) (m : V) :
    HasCompactSupport (bernSymbolFun V j m) := by
  refine HasCompactSupport.intro (isCompact_closedBall (0:V) ((2:ℝ)^(j+2))) fun ξ hξ => ?_
  rw [Metric.mem_closedBall, dist_zero_right, not_le] at hξ
  have h4 : (4:ℝ) ≤ ‖(2:ℝ) ^ (-j) • ξ‖ := by
    rw [norm_zpow_smul]
    calc (4:ℝ) = (2:ℝ)^(-j) * (2:ℝ)^(j+2) := by
          rw [← zpow_add₀ (by norm_num : (2:ℝ) ≠ 0)]
          norm_num
      _ ≤ (2:ℝ)^(-j) * ‖ξ‖ :=
          mul_le_mul_of_nonneg_left hξ.le (zpow_pos (by norm_num) _).le
  rw [bernSymbolFun, lpFat_eq_zero_of_four_le h4, mul_zero, Complex.ofReal_zero]

variable (V) in
/-- The Bernstein kernel symbol as a Schwartz map. -/
noncomputable def bernSymbol (j : ℤ) (m : V) : 𝓢(V, ℂ) :=
  (hasCompactSupport_bernSymbolFun j m).toSchwartzMap (contDiff_bernSymbolFun j m)

theorem bernSymbol_coe (j : ℤ) (m : V) : ⇑(bernSymbol V j m) = bernSymbolFun V j m := rfl

theorem bernSymbolFunR_hasCompactSupport (j : ℤ) (m : V) :
    HasCompactSupport (fun ξ : V => inner ℝ ξ m * lpFat V ((2:ℝ) ^ (-j) • ξ)) := by
  refine HasCompactSupport.intro (isCompact_closedBall (0:V) ((2:ℝ)^(j+2))) fun ξ hξ => ?_
  rw [Metric.mem_closedBall, dist_zero_right, not_le] at hξ
  have h4 : (4:ℝ) ≤ ‖(2:ℝ) ^ (-j) • ξ‖ := by
    rw [norm_zpow_smul]
    calc (4:ℝ) = (2:ℝ)^(-j) * (2:ℝ)^(j+2) := by
          rw [← zpow_add₀ (by norm_num : (2:ℝ) ≠ 0)]
          norm_num
      _ ≤ (2:ℝ)^(-j) * ‖ξ‖ :=
          mul_le_mul_of_nonneg_left hξ.le (zpow_pos (by norm_num) _).le
  show inner ℝ ξ m * lpFat V ((2:ℝ) ^ (-j) • ξ) = 0
  rw [lpFat_eq_zero_of_four_le h4, mul_zero]

theorem bernSymbolFunR_contDiff {n : ℕ∞} (j : ℤ) (m : V) :
    ContDiff ℝ n (fun ξ : V => inner ℝ ξ m * lpFat V ((2:ℝ) ^ (-j) • ξ)) := by
  refine ContDiff.mul ?_ (contDiff_lpFat.comp (contDiff_const_smul _))
  exact ((innerSL ℝ (E := V)).flip m).contDiff

/-- The general ℝ/ℂ multiplier bridge for real symbols on a complex module. -/
theorem fourierMultiplierCLM_real_coe {σ : V → ℝ} (hσ : σ.HasTemperateGrowth)
    (hσC : Function.HasTemperateGrowth (fun ξ : V => ((σ ξ : ℝ) : ℂ))) (g : 𝓢(V, W)) :
    fourierMultiplierCLM (𝕜 := ℝ) W σ g
      = fourierMultiplierCLM W (fun ξ : V => ((σ ξ : ℝ) : ℂ)) g := by
  rw [fourierMultiplierCLM_apply, fourierMultiplierCLM_apply]
  have hs : smulLeftCLM W (fun ξ : V => ((σ ξ : ℝ) : ℂ)) (𝓕 g)
      = smulLeftCLM (𝕜 := ℝ) W σ (𝓕 g) := by
    ext ξ
    rw [smulLeftCLM_apply_apply hσC, smulLeftCLM_apply_apply hσ]
    show ((σ ξ : ℝ) : ℂ) • (𝓕 g) ξ = σ ξ • (𝓕 g) ξ
    rfl
  rw [hs]

/-- **Lᵖ Bernstein, kernel-constant form:** the derivative of the frequency-`2^j` block is
    `Lᵖ`-bounded with constant `2π·‖𝓕⁻σ_j‖_{L¹}` (evaluated as `2π·2^j·C(m)` by the dilation
    identity below). -/
theorem eLpNorm_lineDerivOp_lpProj_le_lp (j : ℤ) (m : V) (f : 𝓢(V, W)) {p : ℝ≥0∞}
    (h1p : 1 ≤ p) (hp_top : p ≠ ∞) :
    eLpNorm (⇑(LineDeriv.lineDerivOp m (lpProj V W j f))) p volume
      ≤ ENNReal.ofReal (2 * π)
          * eLpNorm (⇑(𝓕⁻ (bernSymbol V j m) : 𝓢(V, ℂ))) 1 volume
          * eLpNorm (⇑(lpProj V W j f)) p volume := by
  have hσR : Function.HasTemperateGrowth
      (fun ξ : V => inner ℝ ξ m * lpFat V ((2:ℝ) ^ (-j) • ξ)) :=
    (bernSymbolFunR_hasCompactSupport j m).hasTemperateGrowth (bernSymbolFunR_contDiff j m)
  have hσC : Function.HasTemperateGrowth (bernSymbolFun V j m) :=
    (hasCompactSupport_bernSymbolFun j m).hasTemperateGrowth (contDiff_bernSymbolFun j m)
  have hchain : LineDeriv.lineDerivOp m (lpProj V W j f)
      = (2 * ↑π * Complex.I : ℂ)
          • fourierMultiplierCLM W (⇑(bernSymbol V j m)) (lpProj V W j f) := by
    rw [lineDeriv_eq_fourierMultiplierCLM m (lpProj V W j f), lpProj_eq_realMultiplier,
        fourierMultiplierCLM_fourierMultiplierCLM_apply (hasTemperateGrowth_inner_left m)
          (hasTemperateGrowth_lpSymbolAt j)]
    congr 1
    have hF1 : (fun ξ : V => inner ℝ ξ m) * lpSymbolAt V j
        = (fun ξ : V => inner ℝ ξ m * lpFat V ((2:ℝ) ^ (-j) • ξ)) * lpSymbolAt V j := by
      funext ξ
      simp only [Pi.mul_apply]
      rcases eq_or_ne (lpSymbolAt V j ξ) 0 with h0 | h0
      · rw [h0, mul_zero, mul_zero]
      · have hb := norm_mem_of_lpSymbolAt_ne_zero h0
        have hzp : (0:ℝ) < (2:ℝ) ^ (-j) := zpow_pos (by norm_num) _
        have h1 : 1/2 ≤ ‖(2:ℝ) ^ (-j) • ξ‖ := by
          rw [norm_zpow_smul]
          calc (1:ℝ)/2 = (2:ℝ)^(-1:ℤ) := by norm_num
            _ = (2:ℝ)^(-j) * (2:ℝ)^(j-1) := by
                rw [← zpow_add₀ (by norm_num : (2:ℝ) ≠ 0)]
                congr 1
                ring
            _ ≤ (2:ℝ)^(-j) * ‖ξ‖ := mul_le_mul_of_nonneg_left hb.1.le hzp.le
        have h2 : ‖(2:ℝ) ^ (-j) • ξ‖ ≤ 2 := by
          rw [norm_zpow_smul]
          calc (2:ℝ)^(-j) * ‖ξ‖ ≤ (2:ℝ)^(-j) * (2:ℝ)^(j+1) :=
                mul_le_mul_of_nonneg_left hb.2.le hzp.le
            _ = 2 := by
                rw [← zpow_add₀ (by norm_num : (2:ℝ) ≠ 0)]
                norm_num
        rw [lpFat_eq_one h1 h2, mul_one]
    rw [hF1, ← fourierMultiplierCLM_fourierMultiplierCLM_apply hσR
          (hasTemperateGrowth_lpSymbolAt j),
        ← lpProj_eq_realMultiplier,
        fourierMultiplierCLM_real_coe hσR hσC]
    rfl
  rw [hchain,
      show ⇑((2 * ↑π * Complex.I : ℂ)
          • fourierMultiplierCLM W (⇑(bernSymbol V j m)) (lpProj V W j f))
        = (2 * ↑π * Complex.I : ℂ)
          • ⇑(fourierMultiplierCLM W (⇑(bernSymbol V j m)) (lpProj V W j f)) from rfl,
      eLpNorm_const_smul]
  have h2pi : ‖(2 * ↑π * Complex.I : ℂ)‖ₑ = ENNReal.ofReal (2 * π) := by
    rw [← ofReal_norm_eq_enorm]
    congr 1
    simp only [norm_mul, Complex.norm_I, mul_one, Complex.norm_ofNat, Complex.norm_real,
      Real.norm_eq_abs]
    rw [abs_of_pos pi_pos]
  rw [h2pi, mul_assoc]
  exact mul_le_mul_left'
    (eLpNorm_fourierMultiplierCLM_le (bernSymbol V j m) (lpProj V W j f) h1p hp_top) _

/-! #### The dilation: `‖𝓕⁻σ_j‖_{L¹} = 2^j·‖𝓕⁻σ₀‖_{L¹}` -/

/-- The symbol dilation identity: `σ_j(ξ) = 2^j·σ₀(2^{−j}ξ)`. -/
theorem bernSymbolFun_eq_smul (j : ℤ) (m : V) (ξ : V) :
    bernSymbolFun V j m ξ
      = (((2:ℝ) ^ j : ℝ) : ℂ) * bernSymbolFun V 0 m ((2:ℝ) ^ (-j) • ξ) := by
  rw [bernSymbolFun, bernSymbolFun]
  rw [show (2:ℝ) ^ (-(0:ℤ)) • ((2:ℝ) ^ (-j) • ξ) = (2:ℝ) ^ (-j) • ξ by
    rw [neg_zero, zpow_zero, one_smul]]
  rw [real_inner_smul_left, ← Complex.ofReal_mul]
  congr 1
  rw [← mul_assoc, ← mul_assoc, ← zpow_add₀ (by norm_num : (2:ℝ) ≠ 0)]
  rw [show j + -j = (0:ℤ) by ring, zpow_zero, one_mul]

/-- The kernel dilation: `(𝓕⁻σ_j)(x) = 2^{j(d+1)}·(𝓕⁻σ₀)(2^j x)`, `d = dim V`. -/
theorem fourierInv_bernSymbol_eq (j : ℤ) (m : V) (x : V) :
    (𝓕⁻ (bernSymbol V j m) : 𝓢(V, ℂ)) x
      = (((2:ℝ) ^ (j * ((finrank ℝ V : ℤ) + 1)) : ℝ) : ℂ)
          * (𝓕⁻ (bernSymbol V 0 m) : 𝓢(V, ℂ)) ((2:ℝ) ^ j • x) := by
  rw [show ⇑(𝓕⁻ (bernSymbol V j m) : 𝓢(V, ℂ)) = 𝓕⁻ ⇑(bernSymbol V j m) from
        fourierInv_coe _,
      show ⇑(𝓕⁻ (bernSymbol V 0 m) : 𝓢(V, ℂ)) = 𝓕⁻ ⇑(bernSymbol V 0 m) from
        fourierInv_coe _,
      Real.fourierInv_eq, Real.fourierInv_eq]
  have hsub : ∀ v : V, 𝐞 (inner ℝ v x) • (bernSymbol V j m) v
      = (fun η : V => 𝐞 (inner ℝ η ((2:ℝ) ^ j • x))
          • ((((2:ℝ) ^ j : ℝ) : ℂ) * (bernSymbol V 0 m) η)) ((2:ℝ) ^ (-j) • v) := by
    intro v
    simp only
    rw [bernSymbol_coe, bernSymbol_coe, bernSymbolFun_eq_smul j m v]
    congr 1
    rw [real_inner_smul_left, real_inner_smul_right, ← mul_assoc,
        ← zpow_add₀ (by norm_num : (2:ℝ) ≠ 0),
        show -j + j = (0:ℤ) by ring, zpow_zero, one_mul]
  calc (∫ v, 𝐞 (inner ℝ v x) • (bernSymbol V j m) v)
      = ∫ v, (fun η : V => 𝐞 (inner ℝ η ((2:ℝ) ^ j • x))
          • ((((2:ℝ) ^ j : ℝ) : ℂ) * (bernSymbol V 0 m) η)) ((2:ℝ) ^ (-j) • v) :=
        integral_congr_ae (Filter.Eventually.of_forall hsub)
    _ = |(((2:ℝ) ^ (-j)) ^ finrank ℝ V)⁻¹| • ∫ η, 𝐞 (inner ℝ η ((2:ℝ) ^ j • x))
          • ((((2:ℝ) ^ j : ℝ) : ℂ) * (bernSymbol V 0 m) η) :=
        Measure.integral_comp_smul volume
          (fun η : V => 𝐞 (inner ℝ η ((2:ℝ) ^ j • x))
            • ((((2:ℝ) ^ j : ℝ) : ℂ) * (bernSymbol V 0 m) η)) ((2:ℝ) ^ (-j))
    _ = ((2:ℝ) ^ (j * (finrank ℝ V : ℤ))) • ∫ η, 𝐞 (inner ℝ η ((2:ℝ) ^ j • x))
          • ((((2:ℝ) ^ j : ℝ) : ℂ) * (bernSymbol V 0 m) η) := by
        congr 1
        rw [← zpow_natCast ((2:ℝ) ^ (-j)), ← zpow_mul, ← zpow_neg,
            abs_of_pos (zpow_pos (by norm_num) _)]
        congr 1
        ring
    _ = ((2:ℝ) ^ (j * (finrank ℝ V : ℤ))) • ((((2:ℝ) ^ j : ℝ) : ℂ)
          * ∫ η, 𝐞 (inner ℝ η ((2:ℝ) ^ j • x)) • (bernSymbol V 0 m) η) := by
        congr 1
        rw [← smul_eq_mul, ← integral_smul]
        refine integral_congr_ae (Filter.Eventually.of_forall fun η => ?_)
        show 𝐞 (inner ℝ η ((2:ℝ) ^ j • x)) • ((((2:ℝ) ^ j : ℝ) : ℂ) * (bernSymbol V 0 m) η)
          = (((2:ℝ) ^ j : ℝ) : ℂ) • (𝐞 (inner ℝ η ((2:ℝ) ^ j • x)) • (bernSymbol V 0 m) η)
        rw [smul_eq_mul]
        exact (mul_smul_comm _ _ _).symm
    _ = (((2:ℝ) ^ (j * ((finrank ℝ V : ℤ) + 1)) : ℝ) : ℂ)
          * ∫ η, 𝐞 (inner ℝ η ((2:ℝ) ^ j • x)) • (bernSymbol V 0 m) η := by
        rw [Complex.real_smul, ← mul_assoc, ← Complex.ofReal_mul,
            ← zpow_add₀ (by norm_num : (2:ℝ) ≠ 0)]
        congr 3
        ring

/-- The `L¹` kernel-norm scaling: `‖𝓕⁻σ_j‖_{L¹} = 2^j·‖𝓕⁻σ₀‖_{L¹}`. -/
theorem eLpNorm_fourierInv_bernSymbol (j : ℤ) (m : V) :
    eLpNorm (⇑(𝓕⁻ (bernSymbol V j m) : 𝓢(V, ℂ))) 1 volume
      = ENNReal.ofReal ((2:ℝ) ^ j)
          * eLpNorm (⇑(𝓕⁻ (bernSymbol V 0 m) : 𝓢(V, ℂ))) 1 volume := by
  have hbridge : ∀ u : 𝓢(V, ℂ),
      eLpNorm (⇑u) 1 volume = ENNReal.ofReal (∫ x, ‖u x‖) := by
    intro u
    rw [eLpNorm_one_eq_lintegral_enorm,
        show (∫⁻ x, ‖u x‖ₑ ∂(volume : Measure V)) = ∫⁻ x, ENNReal.ofReal ‖u x‖ ∂volume from
          lintegral_congr fun x => (ofReal_norm_eq_enorm (u x)).symm,
        ← MeasureTheory.ofReal_integral_eq_lintegral_ofReal u.integrable.norm
          (ae_of_all _ fun x => norm_nonneg _)]
  rw [hbridge, hbridge]
  have hreal : (∫ x, ‖(𝓕⁻ (bernSymbol V j m) : 𝓢(V, ℂ)) x‖)
      = (2:ℝ) ^ j * ∫ x, ‖(𝓕⁻ (bernSymbol V 0 m) : 𝓢(V, ℂ)) x‖ := by
    calc (∫ x, ‖(𝓕⁻ (bernSymbol V j m) : 𝓢(V, ℂ)) x‖)
        = ∫ x, (2:ℝ) ^ (j * ((finrank ℝ V : ℤ) + 1))
            * ‖(𝓕⁻ (bernSymbol V 0 m) : 𝓢(V, ℂ)) ((2:ℝ) ^ j • x)‖ := by
          refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
          show ‖(𝓕⁻ (bernSymbol V j m) : 𝓢(V, ℂ)) x‖
            = (2:ℝ) ^ (j * ((finrank ℝ V : ℤ) + 1))
                * ‖(𝓕⁻ (bernSymbol V 0 m) : 𝓢(V, ℂ)) ((2:ℝ) ^ j • x)‖
          rw [fourierInv_bernSymbol_eq, norm_mul, Complex.norm_real, Real.norm_eq_abs,
              abs_of_pos (zpow_pos (by norm_num) _)]
      _ = (2:ℝ) ^ (j * ((finrank ℝ V : ℤ) + 1))
            * ∫ x, ‖(𝓕⁻ (bernSymbol V 0 m) : 𝓢(V, ℂ)) ((2:ℝ) ^ j • x)‖ :=
          integral_const_mul _ _
      _ = (2:ℝ) ^ (j * ((finrank ℝ V : ℤ) + 1)) * (|(((2:ℝ) ^ j) ^ finrank ℝ V)⁻¹|
            • ∫ x, ‖(𝓕⁻ (bernSymbol V 0 m) : 𝓢(V, ℂ)) x‖) := by
          congr 1
          exact Measure.integral_comp_smul volume
            (fun y : V => ‖(𝓕⁻ (bernSymbol V 0 m) : 𝓢(V, ℂ)) y‖) ((2:ℝ) ^ j)
      _ = (2:ℝ) ^ j * ∫ x, ‖(𝓕⁻ (bernSymbol V 0 m) : 𝓢(V, ℂ)) x‖ := by
          rw [smul_eq_mul, ← mul_assoc]
          congr 1
          rw [← zpow_natCast ((2:ℝ) ^ j), ← zpow_mul, ← zpow_neg,
              abs_of_pos (zpow_pos (by norm_num) _),
              ← zpow_add₀ (by norm_num : (2:ℝ) ≠ 0)]
          congr 1
          ring
  rw [hreal, ENNReal.ofReal_mul (zpow_pos (by norm_num : (0:ℝ) < 2) _).le]

/-- **Sharp `Lᵖ` Bernstein:** the derivative of the frequency-`2^j` block costs
    `2π·2^j·C(m)` on every `Lᵖ`, `1 ≤ p < ∞`, with `C(m) = ‖𝓕⁻σ₀‖_{L¹}` j-independent. -/
theorem eLpNorm_lineDerivOp_lpProj_le_lp_sharp (j : ℤ) (m : V) (f : 𝓢(V, W)) {p : ℝ≥0∞}
    (h1p : 1 ≤ p) (hp_top : p ≠ ∞) :
    eLpNorm (⇑(LineDeriv.lineDerivOp m (lpProj V W j f))) p volume
      ≤ ENNReal.ofReal (2 * π) * (ENNReal.ofReal ((2:ℝ) ^ j)
          * eLpNorm (⇑(𝓕⁻ (bernSymbol V 0 m) : 𝓢(V, ℂ))) 1 volume)
          * eLpNorm (⇑(lpProj V W j f)) p volume := by
  have h := eLpNorm_lineDerivOp_lpProj_le_lp j m f h1p hp_top
  rwa [eLpNorm_fourierInv_bernSymbol] at h

end SharpBernstein

/-! ### Toward the Besov space: the inhomogeneous structure

The inhomogeneous partition `χ(ξ) + Σ_{j≥1}ψ_j(ξ) = 1` holds for **every** `ξ` (including `0`),
so the inhomogeneous Besov norm needs no quotient by polynomials. We define it on Schwartz
functions and prove the structural theorem: **it is a genuine norm** (nondegeneracy, via Fourier
injectivity + the partition). The frequency projections are also defined at the
tempered-distribution level (`lpProjD`), opening the door to the full distribution space. -/

section BesovSpace

open MeasureTheory FourierTransform SchwartzMap Real
open scoped SchwartzMap ENNReal

variable {V W : Type*}
  [NormedAddCommGroup V] [MeasurableSpace V] [BorelSpace V]
  [InnerProductSpace ℝ V] [FiniteDimensional ℝ V]
  [NormedAddCommGroup W] [InnerProductSpace ℂ W] [CompleteSpace W]

/-- **The inhomogeneous partition of unity:** `Σ_{j≥1} ψ_j(ξ) = 1 − χ(ξ)` for EVERY `ξ`,
    including `ξ = 0` — the low-pass `χ` absorbs the origin, so no quotient is needed. -/
theorem hasSum_lpSymbolAt_nat (ξ : V) :
    HasSum (fun j : ℕ => lpSymbolAt V ((j : ℤ) + 1) ξ) (1 - lpChi V ξ) := by
  rcases eq_or_ne ξ 0 with rfl | hξ
  · have hzero : ∀ j : ℕ, lpSymbolAt V ((j : ℤ) + 1) (0 : V) = 0 := by
      intro j
      rw [lpSymbolAt, smul_zero, lpSymbol, smul_zero, sub_self]
    have hχ : lpChi V (0 : V) = 1 :=
      (lpChi V).one_of_mem_closedBall (by simp [mem_closedBall_zero_iff])
    rw [hχ, sub_self]
    simpa only [hzero] using hasSum_zero
  · have hpos : (0:ℝ) < ‖ξ‖ := norm_pos_iff.mpr hξ
    set L : ℤ := Int.log 2 ‖ξ‖ with hL
    have hhigh : ‖ξ‖ < (2:ℝ) ^ (L+1) := by
      exact_mod_cast Int.lt_zpow_succ_log_self (b := 2) one_lt_two ‖ξ‖
    set M : ℕ := (max L 0).toNat + 1 with hM
    have hML : L + 1 ≤ (M : ℤ) := by
      have h1 : (max L 0) ≤ ((max L 0).toNat : ℤ) := Int.self_le_toNat _
      have h2 : L ≤ max L 0 := le_max_left _ _
      push_cast [hM]
      omega
    have hvanish : ∀ j : ℕ, j ∉ Finset.range M → lpSymbolAt V ((j : ℤ) + 1) ξ = 0 := by
      intro j hj
      rw [Finset.mem_range, not_lt] at hj
      have hjL : L + 1 ≤ (j : ℤ) := le_trans hML (by exact_mod_cast hj)
      refine lpSymbol_eq_zero_of_le_half ?_
      rw [norm_zpow_smul]
      calc (2:ℝ) ^ (-((j:ℤ)+1)) * ‖ξ‖
          ≤ (2:ℝ) ^ (-((j:ℤ)+1)) * (2:ℝ) ^ (L+1) :=
            mul_le_mul_of_nonneg_left hhigh.le (zpow_pos (by norm_num) _).le
        _ = (2:ℝ) ^ (L + 1 - ((j:ℤ)+1)) := by
            rw [← zpow_add₀ (by norm_num : (2:ℝ) ≠ 0)]
            congr 1
            ring
        _ ≤ (2:ℝ) ^ (-1 : ℤ) := zpow_le_zpow_right₀ (by norm_num) (by omega)
        _ = 1/2 := by norm_num
    have htele : ∑ j ∈ Finset.range M, lpSymbolAt V ((j : ℤ) + 1) ξ = 1 - lpChi V ξ := by
      have hterm : ∀ j : ℕ, lpSymbolAt V ((j : ℤ) + 1) ξ
          = lpChi V ((2:ℝ) ^ (-(((j+1:ℕ)):ℤ)) • ξ) - lpChi V ((2:ℝ) ^ (-((j:ℕ):ℤ)) • ξ) := by
        intro j
        rw [lpSymbolAt_eq_sub,
            show -((j:ℤ) + 1) = -(((j+1:ℕ)):ℤ) by push_cast; ring,
            show -(((j:ℤ) + 1) - 1) = -(((j:ℕ)):ℤ) by push_cast; ring]
      have hAM : lpChi V ((2:ℝ) ^ (-((M:ℕ):ℤ)) • ξ) = 1 := by
        refine (lpChi V).one_of_mem_closedBall ?_
        rw [mem_closedBall_zero_iff, norm_zpow_smul, lpChi_rIn]
        calc (2:ℝ) ^ (-((M:ℕ):ℤ)) * ‖ξ‖
            ≤ (2:ℝ) ^ (-((M:ℕ):ℤ)) * (2:ℝ) ^ (L+1) :=
              mul_le_mul_of_nonneg_left hhigh.le (zpow_pos (by norm_num) _).le
          _ = (2:ℝ) ^ (L + 1 - (M:ℤ)) := by
              rw [← zpow_add₀ (by norm_num : (2:ℝ) ≠ 0)]
              congr 1
              ring
          _ ≤ (2:ℝ) ^ (0:ℤ) := zpow_le_zpow_right₀ (by norm_num) (by omega)
          _ = 1 := by norm_num
      calc ∑ j ∈ Finset.range M, lpSymbolAt V ((j : ℤ) + 1) ξ
          = ∑ j ∈ Finset.range M,
              ((fun n : ℕ => lpChi V ((2:ℝ) ^ (-(n:ℤ)) • ξ)) (j+1)
                - (fun n : ℕ => lpChi V ((2:ℝ) ^ (-(n:ℤ)) • ξ)) j) :=
            Finset.sum_congr rfl fun j _ => hterm j
        _ = (fun n : ℕ => lpChi V ((2:ℝ) ^ (-(n:ℤ)) • ξ)) M
              - (fun n : ℕ => lpChi V ((2:ℝ) ^ (-(n:ℤ)) • ξ)) 0 :=
            Finset.sum_range_sub (fun n : ℕ => lpChi V ((2:ℝ) ^ (-(n:ℤ)) • ξ)) M
        _ = 1 - lpChi V ξ := by
            show lpChi V ((2:ℝ) ^ (-((M:ℕ):ℤ)) • ξ)
                - lpChi V ((2:ℝ) ^ (-((0:ℕ):ℤ)) • ξ) = 1 - lpChi V ξ
            rw [hAM]
            norm_num
    have hfin : HasSum (fun j : ℕ => lpSymbolAt V ((j : ℤ) + 1) ξ)
        (∑ j ∈ Finset.range M, lpSymbolAt V ((j : ℤ) + 1) ξ) :=
      hasSum_sum_of_ne_finset_zero hvanish
    rwa [htele] at hfin

variable (V W) in
/-- The low-pass projection `S₀ = χ(D)`. -/
noncomputable def lpLowProj : 𝓢(V, W) →L[ℂ] 𝓢(V, W) :=
  fourierMultiplierCLM W (fun ξ : V => ((lpChi V ξ : ℝ) : ℂ))

theorem hasTemperateGrowth_lpChiC :
    Function.HasTemperateGrowth (fun ξ : V => ((lpChi V ξ : ℝ) : ℂ)) := by
  refine HasCompactSupport.hasTemperateGrowth ?_ ?_
  · exact ((lpChi V).hasCompactSupport).comp_left Complex.ofReal_zero
  · exact Complex.ofRealCLM.contDiff.comp (lpChi V).contDiff

variable (W) in
/-- **The inhomogeneous Besov norm** `‖f‖_{B^s_{p,q}}` on Schwartz functions: the low block plus
    the `ℓ^q(ℕ)` norm of the weighted high blocks. -/
noncomputable def besovNormI (s : ℝ) (p q : ℝ≥0∞) (f : 𝓢(V, W)) : ℝ≥0∞ :=
  eLpNorm (⇑(lpLowProj V W f)) p volume +
    (if q = ∞ then
      ⨆ j : ℕ, (2:ℝ≥0∞) ^ (((j:ℝ) + 1) * s) * eLpNorm (⇑(lpProj V W ((j:ℤ)+1) f)) p volume
    else (∑' j : ℕ, ((2:ℝ≥0∞) ^ (((j:ℝ) + 1) * s)
        * eLpNorm (⇑(lpProj V W ((j:ℤ)+1) f)) p volume) ^ q.toReal) ^ (1/q.toReal))

/-- A Schwartz function with vanishing `Lᵖ` norm is zero (volume is open-positive). -/
theorem schwartz_eq_zero_of_eLpNorm_eq_zero {p : ℝ≥0∞} (hp0 : p ≠ 0) {u : 𝓢(V, W)}
    (h : eLpNorm (⇑u) p volume = 0) : u = 0 := by
  have hae := (eLpNorm_eq_zero_iff u.continuous.aestronglyMeasurable hp0).mp h
  have heq : ⇑u = (fun _ => 0 : V → W) :=
    (Continuous.ae_eq_iff_eq volume u.continuous continuous_const).mp hae
  ext x
  exact congrFun heq x

/-- A vanishing Fourier multiplier kills the symbol-weighted Fourier transform pointwise. -/
theorem smul_fourier_eq_zero_of_multiplier_eq_zero {σ : V → ℂ}
    (hσ : Function.HasTemperateGrowth σ) {f : 𝓢(V, W)}
    (h : fourierMultiplierCLM W σ f = 0) (ξ : V) : σ ξ • (𝓕 f) ξ = 0 := by
  have h2 : (𝓕⁻ (smulLeftCLM W σ (𝓕 f)) : 𝓢(V, W)) = 0 := by
    rw [← fourierMultiplierCLM_apply]
    exact h
  have h1 : smulLeftCLM W σ (𝓕 f) = 0 := by
    calc smulLeftCLM W σ (𝓕 f)
        = 𝓕 (𝓕⁻ (smulLeftCLM W σ (𝓕 f)) : 𝓢(V, W)) :=
          (FourierTransform.fourier_fourierInv_eq _).symm
      _ = 𝓕 (0 : 𝓢(V, W)) := by rw [h2]
      _ = 0 := map_zero _
  have h3 : smulLeftCLM W σ (𝓕 f) ξ = 0 := by
    rw [h1]
    rfl
  rwa [smulLeftCLM_apply_apply hσ] at h3

/-- **Nondegeneracy: the inhomogeneous Besov expression is a NORM on Schwartz functions.**
    `‖f‖_{B^s_{p,q}} = 0 ↔ f = 0` — the structural theorem making `B^s_{p,q}` a normed space. -/
theorem besovNormI_eq_zero_iff (s : ℝ) {p q : ℝ≥0∞} (hp0 : p ≠ 0) (hq0 : q ≠ 0)
    (f : 𝓢(V, W)) : besovNormI W s p q f = 0 ↔ f = 0 := by
  have h2pos : ∀ x : ℝ, (0:ℝ≥0∞) < (2:ℝ≥0∞) ^ x :=
    fun x => ENNReal.rpow_pos (by norm_num) (by norm_num)
  constructor
  · intro h
    rw [besovNormI, add_eq_zero] at h
    obtain ⟨hlow, hhigh⟩ := h
    have hlow0 : lpLowProj V W f = 0 := schwartz_eq_zero_of_eLpNorm_eq_zero hp0 hlow
    have hblock : ∀ j : ℕ, lpProj V W ((j:ℤ)+1) f = 0 := by
      intro j
      refine schwartz_eq_zero_of_eLpNorm_eq_zero hp0 ?_
      have hterm : (2:ℝ≥0∞) ^ (((j:ℝ) + 1) * s)
          * eLpNorm (⇑(lpProj V W ((j:ℤ)+1) f)) p volume = 0 := by
        by_cases hq_top : q = ∞
        · rw [if_pos hq_top] at hhigh
          exact le_antisymm ((le_iSup (fun j : ℕ => (2:ℝ≥0∞) ^ (((j:ℝ) + 1) * s)
            * eLpNorm (⇑(lpProj V W ((j:ℤ)+1) f)) p volume) j).trans hhigh.le) zero_le
        · rw [if_neg hq_top] at hhigh
          have hqr : 0 < q.toReal := ENNReal.toReal_pos hq0 hq_top
          have hsum0 : (∑' j : ℕ, ((2:ℝ≥0∞) ^ (((j:ℝ) + 1) * s)
              * eLpNorm (⇑(lpProj V W ((j:ℤ)+1) f)) p volume) ^ q.toReal) = 0 := by
            by_contra hne
            have := ENNReal.rpow_eq_zero_iff.mp hhigh
            rcases this with ⟨h0, -⟩ | ⟨-, hneg⟩
            · exact hne h0
            · exact absurd hneg (not_lt.mpr (by positivity))
          have := ENNReal.tsum_eq_zero.mp hsum0 j
          rcases ENNReal.rpow_eq_zero_iff.mp this with ⟨h0, -⟩ | ⟨-, hneg⟩
          · exact h0
          · exact absurd hneg (not_lt.mpr hqr.le)
      rcases mul_eq_zero.mp hterm with h0 | h0
      · exact absurd h0 (h2pos _).ne'
      · exact h0
    -- the Fourier transform vanishes pointwise via the partition
    have hFf : ∀ ξ : V, (𝓕 f) ξ = 0 := by
      intro ξ
      have hχ : lpChi V ξ • (𝓕 f) ξ = 0 :=
        smul_fourier_eq_zero_of_multiplier_eq_zero hasTemperateGrowth_lpChiC hlow0 ξ
      have hψ : ∀ j : ℕ, lpSymbolAt V ((j:ℤ)+1) ξ • (𝓕 f) ξ = 0 := fun j =>
        smul_fourier_eq_zero_of_multiplier_eq_zero
          (hasTemperateGrowth_lpSymbolAtC ((j:ℤ)+1)) (hblock j) ξ
      have h1 : HasSum (fun j : ℕ => lpSymbolAt V ((j:ℤ)+1) ξ • (𝓕 f) ξ)
          ((1 - lpChi V ξ) • (𝓕 f) ξ) := (hasSum_lpSymbolAt_nat ξ).smul_const _
      simp only [hψ] at h1
      have h2 : (1 - lpChi V ξ) • (𝓕 f) ξ = 0 := h1.unique hasSum_zero
      have h3 : (𝓕 f) ξ = ((1 - lpChi V ξ) + lpChi V ξ) • (𝓕 f) ξ := by
        rw [show (1 - lpChi V ξ) + lpChi V ξ = (1:ℝ) by ring, one_smul]
      rw [h3, add_smul, h2, hχ, add_zero]
    have hFf0 : (𝓕 f : 𝓢(V, W)) = 0 := by
      ext ξ
      rw [hFf ξ]
      rfl
    calc f = 𝓕⁻ (𝓕 f : 𝓢(V, W)) := (FourierTransform.fourierInv_fourier_eq f).symm
      _ = 𝓕⁻ (0 : 𝓢(V, W)) := by rw [hFf0]
      _ = 0 := map_zero _
  · intro h
    subst h
    rw [besovNormI]
    have hblock0 : ∀ j : ℕ, (2:ℝ≥0∞) ^ (((j:ℝ) + 1) * s)
        * eLpNorm (⇑(lpProj V W ((j:ℤ)+1) (0 : 𝓢(V, W)))) p volume = 0 := by
      intro j
      rw [map_zero]
      simp
    have hlow0 : eLpNorm (⇑(lpLowProj V W (0 : 𝓢(V, W)))) p volume = 0 := by
      rw [map_zero]
      simp
    rw [hlow0, zero_add]
    by_cases hq_top : q = ∞
    · rw [if_pos hq_top]
      simp only [hblock0, iSup_const]
    · rw [if_neg hq_top]
      have hqr : 0 < q.toReal := ENNReal.toReal_pos hq0 hq_top
      have h2 : ∀ j : ℕ, ((2:ℝ≥0∞) ^ (((j:ℝ) + 1) * s)
          * eLpNorm (⇑(lpProj V W ((j:ℤ)+1) (0 : 𝓢(V, W)))) p volume) ^ q.toReal = 0 :=
        fun j => by rw [hblock0 j, ENNReal.zero_rpow_of_pos hqr]
      rw [tsum_congr h2, tsum_zero, ENNReal.zero_rpow_of_pos (one_div_pos.mpr hqr)]

/-! #### The projections at tempered-distribution level -/

variable (V W) in
/-- The Littlewood–Paley projection on **tempered distributions** (via Mathlib's
    `TemperedDistribution.fourierMultiplierCLM`) — the door to the full Besov space `B^s_{p,q}(𝓢')`. -/
noncomputable def lpProjD (j : ℤ) : 𝓢'(V, W) →L[ℂ] 𝓢'(V, W) :=
  TemperedDistribution.fourierMultiplierCLM W (lpSymbolAtC V j)

/-- Frequency-gap disjointness at the distribution level: `P_j ∘ P_k = 0` for `j + 2 ≤ k`. -/
theorem lpProjD_comp_eq_zero {j k : ℤ} (h : j + 2 ≤ k) :
    lpProjD V W j ∘L lpProjD V W k = 0 := by
  rw [lpProjD, lpProjD, TemperedDistribution.fourierMultiplierCLM_compL_fourierMultiplierCLM
        (hasTemperateGrowth_lpSymbolAtC k) (hasTemperateGrowth_lpSymbolAtC j)]
  have hzero : lpSymbolAtC V k * lpSymbolAtC V j = fun _ : V => (0:ℂ) := by
    funext ξ
    rw [Pi.mul_apply, lpSymbolAtC, lpSymbolAtC, ← Complex.ofReal_mul, mul_comm,
        lpSymbolAt_mul_eq_zero h ξ, Complex.ofReal_zero]
  rw [hzero, TemperedDistribution.fourierMultiplierCLM_const, zero_smul]

/-! #### The distributional Besov space `B^s_{p,q}(𝓢')` -/

/-- Finite telescoping of the dyadic symbols: `Σ_{j<M} ψ_{j+1}(ξ) = χ(2^{−M}ξ) − χ(ξ)`,
    exactly, for every `ξ` and every window `M`. -/
theorem sum_range_lpSymbolAt (M : ℕ) (ξ : V) :
    ∑ j ∈ Finset.range M, lpSymbolAt V ((j : ℤ) + 1) ξ
      = lpChi V ((2:ℝ) ^ (-(M:ℤ)) • ξ) - lpChi V ξ := by
  have hterm : ∀ j : ℕ, lpSymbolAt V ((j : ℤ) + 1) ξ
      = lpChi V ((2:ℝ) ^ (-(((j+1:ℕ)):ℤ)) • ξ) - lpChi V ((2:ℝ) ^ (-((j:ℕ):ℤ)) • ξ) := by
    intro j
    rw [lpSymbolAt_eq_sub,
        show -((j:ℤ) + 1) = -(((j+1:ℕ)):ℤ) by push_cast; ring,
        show -(((j:ℤ) + 1) - 1) = -(((j:ℕ)):ℤ) by push_cast; ring]
  calc ∑ j ∈ Finset.range M, lpSymbolAt V ((j : ℤ) + 1) ξ
      = ∑ j ∈ Finset.range M,
          ((fun n : ℕ => lpChi V ((2:ℝ) ^ (-(n:ℤ)) • ξ)) (j+1)
            - (fun n : ℕ => lpChi V ((2:ℝ) ^ (-(n:ℤ)) • ξ)) j) :=
        Finset.sum_congr rfl fun j _ => hterm j
    _ = (fun n : ℕ => lpChi V ((2:ℝ) ^ (-(n:ℤ)) • ξ)) M
          - (fun n : ℕ => lpChi V ((2:ℝ) ^ (-(n:ℤ)) • ξ)) 0 :=
        Finset.sum_range_sub (fun n : ℕ => lpChi V ((2:ℝ) ^ (-(n:ℤ)) • ξ)) M
    _ = lpChi V ((2:ℝ) ^ (-(M:ℤ)) • ξ) - lpChi V ξ := by
        show lpChi V ((2:ℝ) ^ (-((M:ℕ):ℤ)) • ξ) - lpChi V ((2:ℝ) ^ (-((0:ℕ):ℤ)) • ξ)
            = lpChi V ((2:ℝ) ^ (-(M:ℤ)) • ξ) - lpChi V ξ
        simp

variable (V W) in
/-- The low-pass projection `S₀ = χ(D)` on tempered distributions. -/
noncomputable def lpLowProjD : 𝓢'(V, W) →L[ℂ] 𝓢'(V, W) :=
  TemperedDistribution.fourierMultiplierCLM W (fun ξ : V => ((lpChi V ξ : ℝ) : ℂ))

variable (V) in
/-- The dilated bump `χ_M(ξ) = χ(2^{−M}ξ)` — the symbol of the partial-sum low-pass. -/
noncomputable def lpChiAt (M : ℕ) : V → ℝ := fun ξ => lpChi V ((2:ℝ) ^ (-(M:ℤ)) • ξ)

variable (V) in
/-- The complexified dilated bump. -/
noncomputable def lpChiAtC (M : ℕ) : V → ℂ := fun ξ => (lpChiAt V M ξ : ℂ)

variable (V W) in
/-- The dilated low-pass `S_M = χ(2^{−M}·)(D)` on tempered distributions: the partial sum
    of the Littlewood–Paley decomposition through frequency `2^M`. -/
noncomputable def lpLowProjDAt (M : ℕ) : 𝓢'(V, W) →L[ℂ] 𝓢'(V, W) :=
  TemperedDistribution.fourierMultiplierCLM W (lpChiAtC V M)

theorem contDiff_lpChiAt {n : ℕ∞} (M : ℕ) : ContDiff ℝ n (lpChiAt V M) :=
  (lpChi V).contDiff.comp (contDiff_const_smul _)

theorem hasCompactSupport_lpChiAt (M : ℕ) : HasCompactSupport (lpChiAt V M) := by
  refine HasCompactSupport.intro (isCompact_closedBall (0:V) ((2:ℝ) ^ ((M:ℤ)+1)))
    fun ξ hξ => ?_
  rw [Metric.mem_closedBall, dist_zero_right, not_le] at hξ
  rw [lpChiAt]
  refine (lpChi V).zero_of_le_dist ?_
  rw [dist_zero_right, norm_zpow_smul, lpChi_rOut]
  calc (2:ℝ) = (2:ℝ) ^ (1:ℤ) := by norm_num
    _ = (2:ℝ) ^ (-(M:ℤ) + ((M:ℤ)+1)) := by rw [show -(M:ℤ) + ((M:ℤ)+1) = 1 by ring]
    _ = (2:ℝ) ^ (-(M:ℤ)) * (2:ℝ) ^ ((M:ℤ)+1) := zpow_add₀ (by norm_num : (2:ℝ) ≠ 0) _ _
    _ ≤ (2:ℝ) ^ (-(M:ℤ)) * ‖ξ‖ :=
        mul_le_mul_of_nonneg_left hξ.le (zpow_pos (by norm_num) _).le

theorem hasTemperateGrowth_lpChiAtC (M : ℕ) :
    Function.HasTemperateGrowth (lpChiAtC V M) := by
  refine HasCompactSupport.hasTemperateGrowth ?_ ?_
  · exact (hasCompactSupport_lpChiAt M).comp_left Complex.ofReal_zero
  · exact Complex.ofRealCLM.contDiff.comp (contDiff_lpChiAt M)

/-- **The distributional projection EXTENDS the Schwartz-level one**: `P_j(ι f) = ι(P_j f)`
    through the canonical embedding `ι : 𝓢 ↪ 𝓢'`. -/
theorem lpProjD_coe (j : ℤ) (f : 𝓢(V, W)) :
    lpProjD V W j (f : 𝓢'(V, W)) = (lpProj V W j f : 𝓢'(V, W)) :=
  TemperedDistribution.fourierMultiplierCLM_toTemperedDistributionCLM_eq
    (hasTemperateGrowth_lpSymbolAtC j) f

/-- The distributional low-pass EXTENDS the Schwartz-level one. -/
theorem lpLowProjD_coe (f : 𝓢(V, W)) :
    lpLowProjD V W (f : 𝓢'(V, W)) = (lpLowProj V W f : 𝓢'(V, W)) :=
  TemperedDistribution.fourierMultiplierCLM_toTemperedDistributionCLM_eq
    hasTemperateGrowth_lpChiC f

/-- The distributional Fourier multiplier is subtractive in the symbol. -/
theorem fourierMultiplierCLM_sub {g₁ g₂ : V → ℂ}
    (hg₁ : Function.HasTemperateGrowth g₁) (hg₂ : Function.HasTemperateGrowth g₂) :
    TemperedDistribution.fourierMultiplierCLM W (g₁ - g₂)
      = TemperedDistribution.fourierMultiplierCLM W g₁
        - TemperedDistribution.fourierMultiplierCLM W g₂ := by
  simp only [TemperedDistribution.fourierMultiplierCLM]
  rw [TemperedDistribution.smulLeftCLM_sub hg₁ hg₂, ContinuousLinearMap.sub_comp,
      ContinuousLinearMap.comp_sub]

/-- `P_{j+1} = S_{j+1} − S_j`: each Littlewood–Paley block is a difference of adjacent
    partial low-passes, at the distribution level. -/
theorem lpProjD_eq_sub (j : ℕ) :
    lpProjD V W ((j:ℤ)+1) = lpLowProjDAt V W (j+1) - lpLowProjDAt V W j := by
  rw [lpProjD, lpLowProjDAt, lpLowProjDAt,
      ← fourierMultiplierCLM_sub (hasTemperateGrowth_lpChiAtC (j+1))
        (hasTemperateGrowth_lpChiAtC j)]
  congr 1
  funext ξ
  simp only [Pi.sub_apply]
  have hterm : lpSymbolAt V ((j:ℤ) + 1) ξ
      = lpChi V ((2:ℝ) ^ (-(((j+1:ℕ)):ℤ)) • ξ) - lpChi V ((2:ℝ) ^ (-((j:ℕ):ℤ)) • ξ) := by
    rw [lpSymbolAt_eq_sub,
        show -((j:ℤ) + 1) = -(((j+1:ℕ)):ℤ) by push_cast; ring,
        show -(((j:ℤ) + 1) - 1) = -(((j:ℕ)):ℤ) by push_cast; ring]
  rw [lpSymbolAtC, lpChiAtC, lpChiAtC, lpChiAt, lpChiAt, hterm, Complex.ofReal_sub]

theorem lpLowProjDAt_zero : lpLowProjDAt V W 0 = lpLowProjD V W := by
  rw [lpLowProjDAt, lpLowProjD]
  congr 1
  funext ξ
  simp [lpChiAtC, lpChiAt]

/-- **The exact finite Littlewood–Paley decomposition of `𝓢'`:** as operators on tempered
    distributions, `S_M = S₀ + Σ_{j<M} P_{j+1}` — every finite frequency window reassembles
    EXACTLY into the dilated low-pass; nothing is lost at any finite stage. -/
theorem lpLowProjDAt_eq_add_sum (M : ℕ) :
    lpLowProjDAt V W M
      = lpLowProjD V W + ∑ j ∈ Finset.range M, lpProjD V W ((j:ℤ)+1) := by
  have h : ∑ j ∈ Finset.range M, lpProjD V W ((j:ℤ)+1)
      = lpLowProjDAt V W M - lpLowProjDAt V W 0 := by
    calc ∑ j ∈ Finset.range M, lpProjD V W ((j:ℤ)+1)
        = ∑ j ∈ Finset.range M, (lpLowProjDAt V W (j+1) - lpLowProjDAt V W j) :=
          Finset.sum_congr rfl fun j _ => lpProjD_eq_sub j
      _ = lpLowProjDAt V W M - lpLowProjDAt V W 0 :=
          Finset.sum_range_sub (lpLowProjDAt V W) M
  rw [h, lpLowProjDAt_zero]
  abel

/-! #### `Lᵖ` representatives and the distributional Besov norm -/

variable (W) in
/-- A tempered distribution **is an `Lᵖ` function**: it lies in the range of the canonical
    embedding `Lp W p ↪ 𝓢'(V, W)`. -/
def HasLpRep (p : ℝ≥0∞) [Fact (1 ≤ p)] (u : 𝓢'(V, W)) : Prop :=
  ∃ g : Lp W p (volume : Measure V), u = MeasureTheory.Lp.toTemperedDistribution g

/-- The embedding `Lp W p → 𝓢'` is INJECTIVE (Mathlib's
    `ker_toTemperedDistributionCLM_eq_bot`): an `Lᵖ` representative is unique. -/
theorem lp_toTemperedDistribution_injective (p : ℝ≥0∞) [Fact (1 ≤ p)] :
    Function.Injective
      (fun g : Lp W p (volume : Measure V) => MeasureTheory.Lp.toTemperedDistribution g) := by
  intro g₁ g₂ hg
  have hker := MeasureTheory.Lp.ker_toTemperedDistributionCLM_eq_bot
    (F := W) (μ := (volume : Measure V)) (p := p)
  rw [LinearMap.ker_eq_bot', ContinuousLinearMap.coe_coe] at hker
  have hsub : MeasureTheory.Lp.toTemperedDistributionCLM W (volume : Measure V) p (g₁ - g₂)
      = 0 := by
    rw [map_sub]
    have h1 : MeasureTheory.Lp.toTemperedDistributionCLM W (volume : Measure V) p g₁
        = MeasureTheory.Lp.toTemperedDistribution g₁ := rfl
    have h2 : MeasureTheory.Lp.toTemperedDistributionCLM W (volume : Measure V) p g₂
        = MeasureTheory.Lp.toTemperedDistribution g₂ := rfl
    simp only at hg
    rw [h1, h2, hg, sub_self]
  exact sub_eq_zero.mp (hker _ hsub)

variable (W) in
/-- The `Lᵖ` size of a tempered distribution: the `eLpNorm` of its (unique) `Lᵖ`
    representative, or `∞` when no representative exists. -/
noncomputable def lpNormD (p : ℝ≥0∞) [Fact (1 ≤ p)] (u : 𝓢'(V, W)) : ℝ≥0∞ :=
  open scoped Classical in
  if h : HasLpRep W p u then eLpNorm (⇑h.choose) p (volume : Measure V) else ∞

/-- **Well-definedness:** `lpNormD` computes the norm of ANY representative — the
    representative is unique by injectivity of the embedding. -/
theorem lpNormD_eq_of_rep {p : ℝ≥0∞} [Fact (1 ≤ p)] {u : 𝓢'(V, W)}
    {g : Lp W p (volume : Measure V)}
    (hu : u = MeasureTheory.Lp.toTemperedDistribution g) :
    lpNormD W p u = eLpNorm (⇑g) p volume := by
  have hex : HasLpRep W p u := ⟨g, hu⟩
  rw [lpNormD, dif_pos hex]
  have hgg : hex.choose = g :=
    lp_toTemperedDistribution_injective p (hex.choose_spec.symm.trans hu)
  rw [hgg]

/-- On an embedded Schwartz function, `lpNormD` IS the `Lᵖ` norm of the function. -/
theorem lpNormD_coe (p : ℝ≥0∞) [Fact (1 ≤ p)] (f : 𝓢(V, W)) :
    lpNormD W p (f : 𝓢'(V, W)) = eLpNorm (⇑f) p volume := by
  have hrep : (f : 𝓢'(V, W))
      = MeasureTheory.Lp.toTemperedDistribution (f.toLp p volume) :=
    (MeasureTheory.Lp.toTemperedDistribution_toLp_eq f).symm
  rw [lpNormD_eq_of_rep hrep]
  exact eLpNorm_congr_ae (f.coeFn_toLp p volume)

variable (W) in
/-- **The inhomogeneous Besov norm on tempered distributions** `‖u‖_{B^s_{p,q}}`: the `Lᵖ`
    size of the low block plus the weighted `ℓ^q(ℕ)` size of the dyadic blocks, each block
    measured through its (unique) `Lᵖ` representative. -/
noncomputable def besovNormD (s : ℝ) (p q : ℝ≥0∞) [Fact (1 ≤ p)] (u : 𝓢'(V, W)) : ℝ≥0∞ :=
  lpNormD W p (lpLowProjD V W u) +
    (if q = ∞ then
      ⨆ j : ℕ, (2:ℝ≥0∞) ^ (((j:ℝ) + 1) * s) * lpNormD W p (lpProjD V W ((j:ℤ)+1) u)
    else (∑' j : ℕ, ((2:ℝ≥0∞) ^ (((j:ℝ) + 1) * s)
        * lpNormD W p (lpProjD V W ((j:ℤ)+1) u)) ^ q.toReal) ^ (1/q.toReal))

variable (W) in
/-- **Membership in the distributional Besov space** `B^s_{p,q}(V; W) ⊂ 𝓢'(V, W)`. -/
def MemBesovD (s : ℝ) (p q : ℝ≥0∞) [Fact (1 ≤ p)] (u : 𝓢'(V, W)) : Prop :=
  besovNormD W s p q u < ∞

/-- Membership forces the low block to BE an `Lᵖ` function. -/
theorem MemBesovD.hasLpRep_low {s : ℝ} {p q : ℝ≥0∞} [Fact (1 ≤ p)] {u : 𝓢'(V, W)}
    (h : MemBesovD W s p q u) : HasLpRep W p (lpLowProjD V W u) := by
  by_contra hno
  rw [MemBesovD, besovNormD, lpNormD, dif_neg hno, top_add] at h
  exact absurd h (lt_irrefl _)

/-- Membership forces every dyadic block to BE an `Lᵖ` function. -/
theorem MemBesovD.hasLpRep_block {s : ℝ} {p q : ℝ≥0∞} [Fact (1 ≤ p)] (hq0 : q ≠ 0)
    {u : 𝓢'(V, W)} (h : MemBesovD W s p q u) (j : ℕ) :
    HasLpRep W p (lpProjD V W ((j:ℤ)+1) u) := by
  by_contra hno
  rw [MemBesovD, besovNormD] at h
  have hterm : (2:ℝ≥0∞) ^ (((j:ℝ) + 1) * s)
      * lpNormD W p (lpProjD V W ((j:ℤ)+1) u) = ∞ := by
    rw [lpNormD, dif_neg hno]
    exact ENNReal.mul_top (ENNReal.rpow_pos (by norm_num) (by norm_num)).ne'
  by_cases hq : q = ∞
  · rw [if_pos hq] at h
    have hle : (∞:ℝ≥0∞) ≤ ⨆ j : ℕ, (2:ℝ≥0∞) ^ (((j:ℝ) + 1) * s)
        * lpNormD W p (lpProjD V W ((j:ℤ)+1) u) := by
      rw [← hterm]
      exact le_iSup (fun j : ℕ => (2:ℝ≥0∞) ^ (((j:ℝ) + 1) * s)
        * lpNormD W p (lpProjD V W ((j:ℤ)+1) u)) j
    rw [top_le_iff.mp hle, add_top] at h
    exact absurd h (lt_irrefl _)
  · rw [if_neg hq] at h
    have hqr : 0 < q.toReal := ENNReal.toReal_pos hq0 hq
    have hsum : (∑' j : ℕ, ((2:ℝ≥0∞) ^ (((j:ℝ) + 1) * s)
        * lpNormD W p (lpProjD V W ((j:ℤ)+1) u)) ^ q.toReal) = ∞ := by
      refine top_le_iff.mp (le_trans ?_ (ENNReal.le_tsum j))
      rw [hterm, ENNReal.top_rpow_of_pos hqr]
    rw [hsum, ENNReal.top_rpow_of_pos (one_div_pos.mpr hqr), add_top] at h
    exact absurd h (lt_irrefl _)

/-- **The distributional Besov norm EXTENDS the Schwartz one** through the canonical
    embedding `𝓢 ↪ 𝓢'` — `B^s_{p,q}(𝓢')` restricted to Schwartz functions is `besovNormI`. -/
theorem besovNormD_coe (s : ℝ) (p q : ℝ≥0∞) [Fact (1 ≤ p)] (f : 𝓢(V, W)) :
    besovNormD W s p q (f : 𝓢'(V, W)) = besovNormI W s p q f := by
  have hlow : lpNormD W p (lpLowProjD V W (f : 𝓢'(V, W)))
      = eLpNorm (⇑(lpLowProj V W f)) p volume := by
    rw [lpLowProjD_coe, lpNormD_coe]
  have hblock : ∀ j : ℕ, lpNormD W p (lpProjD V W ((j:ℤ)+1) (f : 𝓢'(V, W)))
      = eLpNorm (⇑(lpProj V W ((j:ℤ)+1) f)) p volume := by
    intro j
    rw [lpProjD_coe, lpNormD_coe]
  rw [besovNormD, besovNormI, hlow]
  congr 1
  by_cases hq : q = ∞
  · rw [if_pos hq, if_pos hq]
    exact iSup_congr fun j => by rw [hblock j]
  · rw [if_neg hq, if_neg hq]
    congr 1
    exact tsum_congr fun j => by rw [hblock j]

/-- Membership of an embedded Schwartz function reduces to finiteness of its
    Schwartz-level Besov norm. -/
theorem memBesovD_coe_iff (s : ℝ) (p q : ℝ≥0∞) [Fact (1 ≤ p)] (f : 𝓢(V, W)) :
    MemBesovD W s p q (f : 𝓢'(V, W)) ↔ besovNormI W s p q f < ∞ := by
  rw [MemBesovD, besovNormD_coe]

/-- Nondegeneracy transfers to the distributional norm on embedded Schwartz functions. -/
theorem besovNormD_coe_eq_zero_iff (s : ℝ) {p q : ℝ≥0∞} [Fact (1 ≤ p)] (hq0 : q ≠ 0)
    (f : 𝓢(V, W)) : besovNormD W s p q (f : 𝓢'(V, W)) = 0 ↔ f = 0 := by
  have hp0 : p ≠ 0 := (lt_of_lt_of_le zero_lt_one (Fact.out : 1 ≤ p)).ne'
  rw [besovNormD_coe]
  exact besovNormI_eq_zero_iff s hp0 hq0 f

/-- The zero distribution has Besov norm `0`. -/
theorem besovNormD_zero (s : ℝ) {p q : ℝ≥0∞} [Fact (1 ≤ p)] (hq0 : q ≠ 0) :
    besovNormD W s p q (0 : 𝓢'(V, W)) = 0 := by
  have hp0 : p ≠ 0 := (lt_of_lt_of_le zero_lt_one (Fact.out : 1 ≤ p)).ne'
  have h0 : ((0 : 𝓢(V, W)) : 𝓢'(V, W)) = 0 := map_zero _
  rw [← h0, besovNormD_coe]
  exact (besovNormI_eq_zero_iff s hp0 hq0 (0 : 𝓢(V, W))).mpr rfl

/-- The zero distribution is a member of every `B^s_{p,q}` (`q ≠ 0`). -/
theorem memBesovD_zero (s : ℝ) {p q : ℝ≥0∞} [Fact (1 ≤ p)] (hq0 : q ≠ 0) :
    MemBesovD W s p q (0 : 𝓢'(V, W)) := by
  rw [MemBesovD, besovNormD_zero s hq0]
  exact ENNReal.zero_lt_top

/-! #### The approximation of identity `S_M → id` and the Littlewood–Paley expansion of `𝓢′` -/

open Filter Topology

/-- The dilated bump is `1` on the ball of radius `2^M`. -/
theorem lpChiAt_eq_one_of_le {M : ℕ} {ξ : V} (h : ‖ξ‖ ≤ (2:ℝ) ^ M) :
    lpChiAt V M ξ = 1 := by
  rw [lpChiAt]
  refine (lpChi V).one_of_mem_closedBall ?_
  rw [mem_closedBall_zero_iff, norm_zpow_smul, lpChi_rIn]
  calc (2:ℝ) ^ (-(M:ℤ)) * ‖ξ‖
      ≤ (2:ℝ) ^ (-(M:ℤ)) * (2:ℝ) ^ M :=
        mul_le_mul_of_nonneg_left h (zpow_pos (by norm_num) _).le
    _ = 1 := by
        rw [← zpow_natCast (2:ℝ) M, ← zpow_add₀ (by norm_num : (2:ℝ) ≠ 0)]
        norm_num

/-- Each iterated derivative of the bump `χ` is globally bounded (continuous + compact
    support). -/
theorem exists_bound_iteratedFDeriv_lpChi (i : ℕ) :
    ∃ B : ℝ, 0 ≤ B ∧ ∀ y : V, ‖iteratedFDeriv ℝ i (lpChi V : V → ℝ) y‖ ≤ B := by
  obtain ⟨B, hB⟩ := Continuous.bounded_above_of_compact_support
    (ContDiff.continuous_iteratedFDeriv (mod_cast le_top) ((lpChi V).contDiff (n := (⊤ : ℕ∞))))
    (((lpChi V).hasCompactSupport).mono' (support_iteratedFDeriv_subset i))
  exact ⟨max B 0, le_max_right _ _, fun y => (hB y).trans (le_max_left _ _)⟩

/-- The iterated derivatives of the complexified dilated bumps `χ_M` are bounded
    **uniformly in `M`** — the dilation only shrinks them (`‖L_M‖ ≤ 1`). -/
theorem exists_uniform_bound_iteratedFDeriv_lpChiAtC (i : ℕ) :
    ∃ D : ℝ, 0 ≤ D ∧ ∀ (M : ℕ) (x : V), ‖iteratedFDeriv ℝ i (lpChiAtC V M) x‖ ≤ D := by
  obtain ⟨B, hB0, hB⟩ := exists_bound_iteratedFDeriv_lpChi (V := V) i
  refine ⟨B, hB0, fun M x => ?_⟩
  have hcoe : lpChiAtC V M = (Complex.ofRealLI : ℝ →ₗᵢ[ℝ] ℂ) ∘ lpChiAt V M := rfl
  rw [hcoe, Complex.ofRealLI.norm_iteratedFDeriv_comp_left
        ((contDiff_lpChiAt (n := (i:ℕ∞)) M).contDiffAt) (by exact_mod_cast le_rfl)]
  set L : V →L[ℝ] V := (2:ℝ) ^ (-(M:ℤ)) • ContinuousLinearMap.id ℝ V with hL
  have hLnorm : ‖L‖ ≤ 1 := by
    rw [hL]
    calc ‖(2:ℝ) ^ (-(M:ℤ)) • ContinuousLinearMap.id ℝ V‖
        = ‖(2:ℝ) ^ (-(M:ℤ))‖ * ‖ContinuousLinearMap.id ℝ V‖ := norm_smul _ _
      _ ≤ 1 * 1 := by
          refine mul_le_mul ?_ ContinuousLinearMap.norm_id_le (norm_nonneg _) zero_le_one
          rw [Real.norm_of_nonneg (zpow_pos (by norm_num) _).le]
          exact zpow_le_one_of_nonpos₀ (by norm_num) (by omega)
      _ = 1 := mul_one 1
  have hcomp : (lpChiAt V M : V → ℝ) = (lpChi V : V → ℝ) ∘ L := by
    funext ξ
    simp [lpChiAt, hL]
  rw [hcomp, L.iteratedFDeriv_comp_right ((lpChi V).contDiff (n := (i:ℕ∞))) x
        (by exact_mod_cast le_rfl)]
  calc ‖(iteratedFDeriv ℝ i (lpChi V : V → ℝ) (L x)).compContinuousLinearMap fun _ => L‖
      ≤ ‖iteratedFDeriv ℝ i (lpChi V : V → ℝ) (L x)‖ * ∏ _j : Fin i, ‖L‖ :=
        ContinuousMultilinearMap.norm_compContinuousLinearMap_le _ _
    _ ≤ B * 1 := by
        refine mul_le_mul (hB _) ?_ (Finset.prod_nonneg fun _ _ => norm_nonneg _) hB0
        exact Finset.prod_le_one (fun _ _ => norm_nonneg _) (fun _ _ => hLnorm)
    _ = B := mul_one B

/-- **The decay estimate (the analytic heart):** every Schwartz seminorm of
    `χ_M·ψ − ψ` is `≤ K·2^{−M}` — outside `‖ξ‖ ≤ 2^M` the cutoff difference is killed by
    one extra power of the Schwartz decay of `ψ`; inside, it vanishes identically. -/
theorem exists_seminorm_smulLeft_lpChiAtC_sub_le (k n : ℕ) (ψ : 𝓢(V, ℂ)) :
    ∃ K : ℝ, 0 ≤ K ∧ ∀ M : ℕ,
      SchwartzMap.seminorm ℂ k n (SchwartzMap.smulLeftCLM ℂ (lpChiAtC V M) ψ - ψ)
        ≤ K * ((1:ℝ)/2) ^ M := by
  choose D hD0 hD using fun i => exists_uniform_bound_iteratedFDeriv_lpChiAtC (V := V) i
  set Dm : ℕ → ℝ := fun i => max (D i) 2 with hDm
  have hDm0 : ∀ i, 0 ≤ Dm i := fun i => le_trans (by norm_num) (le_max_right _ _)
  set K : ℝ := ∑ i ∈ Finset.range (n+1),
      (n.choose i : ℝ) * Dm i * SchwartzMap.seminorm ℂ (k+1) (n-i) ψ with hK
  have hK0 : 0 ≤ K :=
    Finset.sum_nonneg fun i _ => by
      have := hDm0 i
      positivity
  refine ⟨K, hK0, fun M => ?_⟩
  refine SchwartzMap.seminorm_le_bound ℂ k n _ (by positivity) fun x => ?_
  have hfun : ⇑(SchwartzMap.smulLeftCLM ℂ (lpChiAtC V M) ψ - ψ)
      = fun ξ => (lpChiAtC V M ξ - 1) * ψ ξ := by
    funext ξ
    simp only [SchwartzMap.sub_apply,
      SchwartzMap.smulLeftCLM_apply (hasTemperateGrowth_lpChiAtC M)]
    rw [smul_eq_mul, sub_mul, one_mul]
  rw [hfun]
  by_cases hx : ‖x‖ < (2:ℝ) ^ M
  · -- inside the ball of radius `2^M` the cutoff difference vanishes identically
    have hsupp : Function.support (fun ξ : V => (lpChiAtC V M ξ - 1) * ψ ξ)
        ⊆ {ξ : V | (2:ℝ) ^ M ≤ ‖ξ‖} := by
      intro ξ hξ
      by_contra hc
      rw [Set.mem_setOf_eq, not_le] at hc
      apply hξ
      show (lpChiAtC V M ξ - 1) * ψ ξ = 0
      have h1 : lpChiAtC V M ξ = 1 := by
        rw [lpChiAtC, lpChiAt_eq_one_of_le hc.le, Complex.ofReal_one]
      rw [h1, sub_self, zero_mul]
    have hts : tsupport (fun ξ : V => (lpChiAtC V M ξ - 1) * ψ ξ)
        ⊆ {ξ : V | (2:ℝ) ^ M ≤ ‖ξ‖} :=
      closure_minimal hsupp (isClosed_le continuous_const continuous_norm)
    have hzero : iteratedFDeriv ℝ n (fun ξ : V => (lpChiAtC V M ξ - 1) * ψ ξ) x = 0 := by
      by_contra hne
      have hmem := support_iteratedFDeriv_subset (𝕜 := ℝ) n (Function.mem_support.mpr hne)
      exact absurd (hts hmem) (not_le.mpr hx)
    rw [hzero, norm_zero, mul_zero]
    positivity
  · -- outside: Leibniz + one extra power of Schwartz decay
    push_neg at hx
    have hx1 : (1:ℝ) ≤ ‖x‖ := le_trans (one_le_pow₀ (by norm_num)) hx
    have hxpos : (0:ℝ) < ‖x‖ := lt_of_lt_of_le one_pos hx1
    have hχC : ContDiff ℝ (n:ℕ∞) (lpChiAtC V M) :=
      Complex.ofRealCLM.contDiff.comp (contDiff_lpChiAt M)
    have hcd1 : ContDiff ℝ (n:ℕ∞) (fun ξ : V => lpChiAtC V M ξ - 1) :=
      hχC.sub contDiff_const
    have hcd2 : ContDiff ℝ (n:ℕ∞) (⇑ψ) := ψ.smooth n
    have hleib := norm_iteratedFDeriv_mul_le (𝕜 := ℝ) hcd1 hcd2 x
      (by exact_mod_cast le_rfl)
    have hterm : ∀ i ∈ Finset.range (n+1),
        ‖iteratedFDeriv ℝ i (fun ξ : V => lpChiAtC V M ξ - 1) x‖ ≤ Dm i := by
      intro i hir
      have hin : (i:ℕ∞) ≤ (n:ℕ∞) := by
        exact_mod_cast Nat.lt_succ_iff.mp (Finset.mem_range.mp hir)
      rcases Nat.eq_zero_or_pos i with rfl | hi
      · rw [norm_iteratedFDeriv_zero]
        refine le_trans (norm_sub_le _ _) (le_trans ?_ (le_max_right (D 0) 2))
        have h1 : ‖lpChiAtC V M x‖ ≤ 1 := by
          rw [lpChiAtC, lpChiAt, Complex.norm_real,
              Real.norm_of_nonneg ((lpChi V).nonneg)]
          exact (lpChi V).le_one
        rw [norm_one]
        linarith
      · have hsub : (fun ξ : V => lpChiAtC V M ξ - 1)
            = (lpChiAtC V M - fun _ : V => (1:ℂ)) := rfl
        rw [hsub, iteratedFDeriv_sub (hχC.of_le (by exact_mod_cast hin))
              (contDiff_const.of_le le_top), Pi.sub_apply,
            iteratedFDeriv_const_of_ne hi.ne', Pi.zero_apply, sub_zero]
        exact le_trans (hD i M x) (le_max_left _ _)
    calc ‖x‖ ^ k * ‖iteratedFDeriv ℝ n (fun ξ : V => (lpChiAtC V M ξ - 1) * ψ ξ) x‖
        ≤ ‖x‖ ^ k * ∑ i ∈ Finset.range (n+1), (n.choose i : ℝ)
            * ‖iteratedFDeriv ℝ i (fun ξ : V => lpChiAtC V M ξ - 1) x‖
            * ‖iteratedFDeriv ℝ (n-i) (⇑ψ) x‖ :=
          mul_le_mul_of_nonneg_left hleib (by positivity)
      _ = ∑ i ∈ Finset.range (n+1), (n.choose i : ℝ)
            * ‖iteratedFDeriv ℝ i (fun ξ : V => lpChiAtC V M ξ - 1) x‖
            * (‖x‖ ^ k * ‖iteratedFDeriv ℝ (n-i) (⇑ψ) x‖) := by
          rw [Finset.mul_sum]
          exact Finset.sum_congr rfl fun i _ => by ring
      _ ≤ ∑ i ∈ Finset.range (n+1), (n.choose i : ℝ) * Dm i
            * (SchwartzMap.seminorm ℂ (k+1) (n-i) ψ * ((1:ℝ)/2) ^ M) := by
          refine Finset.sum_le_sum fun i hi => ?_
          have hdecay : ‖x‖ ^ k * ‖iteratedFDeriv ℝ (n-i) (⇑ψ) x‖ * (2:ℝ) ^ M
              ≤ SchwartzMap.seminorm ℂ (k+1) (n-i) ψ := by
            calc ‖x‖ ^ k * ‖iteratedFDeriv ℝ (n-i) (⇑ψ) x‖ * (2:ℝ) ^ M
                ≤ ‖x‖ ^ k * ‖iteratedFDeriv ℝ (n-i) (⇑ψ) x‖ * ‖x‖ :=
                  mul_le_mul_of_nonneg_left hx (by positivity)
              _ = ‖x‖ ^ (k+1) * ‖iteratedFDeriv ℝ (n-i) (⇑ψ) x‖ := by ring
              _ ≤ SchwartzMap.seminorm ℂ (k+1) (n-i) ψ :=
                  SchwartzMap.le_seminorm ℂ (k+1) (n-i) ψ x
          have hdiv : ‖x‖ ^ k * ‖iteratedFDeriv ℝ (n-i) (⇑ψ) x‖
              ≤ SchwartzMap.seminorm ℂ (k+1) (n-i) ψ * ((1:ℝ)/2) ^ M := by
            rw [div_pow, one_pow, mul_one_div]
            exact (le_div_iff₀ (by positivity)).mpr hdecay
          refine mul_le_mul (mul_le_mul_of_nonneg_left (hterm i hi) (by positivity))
            hdiv (by positivity) (by positivity)
      _ = K * ((1:ℝ)/2) ^ M := by
          rw [hK, Finset.sum_mul]
          exact Finset.sum_congr rfl fun i _ => by ring

/-- **The approximation of identity on Schwartz space:** `χ_M·ψ → ψ` in the Schwartz
    topology. -/
theorem tendsto_smulLeftCLM_lpChiAtC (ψ : 𝓢(V, ℂ)) :
    Filter.Tendsto (fun M : ℕ => SchwartzMap.smulLeftCLM ℂ (lpChiAtC V M) ψ)
      Filter.atTop (𝓝 ψ) := by
  rw [(schwartz_withSeminorms ℂ V ℂ).tendsto_nhds _ ψ]
  rintro ⟨k, n⟩ ε hε
  obtain ⟨K, hK0, hK⟩ := exists_seminorm_smulLeft_lpChiAtC_sub_le k n ψ
  have hlim : Filter.Tendsto (fun M : ℕ => K * ((1:ℝ)/2) ^ M) Filter.atTop (𝓝 0) := by
    rw [show (0:ℝ) = K * 0 by ring]
    exact (tendsto_pow_atTop_nhds_zero_of_lt_one (by norm_num) (by norm_num)).const_mul K
  filter_upwards [hlim.eventually_lt_const hε] with M hM
  exact lt_of_le_of_lt (hK M) hM

/-- **The approximation of identity on tempered distributions:** `S_M u → u` in `𝓢′`
    (the topology of pointwise convergence — weak-*). -/
theorem tendsto_lpLowProjDAt (u : 𝓢'(V, W)) :
    Filter.Tendsto (fun M : ℕ => lpLowProjDAt V W M u) Filter.atTop (𝓝 u) := by
  rw [PointwiseConvergenceCLM.tendsto_iff_forall_tendsto]
  intro φ
  have h1 : Filter.Tendsto
      (fun M : ℕ => SchwartzMap.smulLeftCLM ℂ (lpChiAtC V M) (𝓕⁻ φ))
      Filter.atTop (𝓝 (𝓕⁻ φ)) := tendsto_smulLeftCLM_lpChiAtC (𝓕⁻ φ)
  have h2 : Filter.Tendsto
      (fun M : ℕ => (𝓕 (SchwartzMap.smulLeftCLM ℂ (lpChiAtC V M) (𝓕⁻ φ)) : 𝓢(V, ℂ)))
      Filter.atTop (𝓝 (𝓕 (𝓕⁻ φ) : 𝓢(V, ℂ))) :=
    ((fourierCLM ℂ 𝓢(V, ℂ)).continuous.tendsto _).comp h1
  rw [FourierTransform.fourier_fourierInv_eq] at h2
  exact (u.continuous.tendsto φ).comp h2

/-- **The Littlewood–Paley expansion of a tempered distribution:** the partial sums
    `S₀u + Σ_{j<M} P_{j+1}u` converge to `u` in `𝓢′` (weak-*). Every tempered
    distribution is the sum of its Littlewood–Paley series. -/
theorem tendsto_lowProjD_add_sum (u : 𝓢'(V, W)) :
    Filter.Tendsto
      (fun M : ℕ => lpLowProjD V W u + ∑ j ∈ Finset.range M, lpProjD V W ((j:ℤ)+1) u)
      Filter.atTop (𝓝 u) := by
  have h := tendsto_lpLowProjDAt u
  have heq : ∀ M : ℕ, lpLowProjDAt V W M u
      = lpLowProjD V W u + ∑ j ∈ Finset.range M, lpProjD V W ((j:ℤ)+1) u := by
    intro M
    rw [lpLowProjDAt_eq_add_sum]
    simp [ContinuousLinearMap.add_apply, ContinuousLinearMap.sum_apply]
  simpa only [heq] using h

/-- A tempered distribution with NO Littlewood–Paley content is zero. -/
theorem eq_zero_of_lp_blocks_eq_zero {u : 𝓢'(V, W)} (hlow : lpLowProjD V W u = 0)
    (hblocks : ∀ j : ℕ, lpProjD V W ((j:ℤ)+1) u = 0) : u = 0 := by
  have h := tendsto_lowProjD_add_sum u
  simp only [hlow, hblocks, Finset.sum_const_zero, add_zero] at h
  exact tendsto_nhds_unique h tendsto_const_nhds

/-- The zero `Lᵖ` element embeds to the zero distribution. -/
theorem lp_toTemperedDistribution_zero (p : ℝ≥0∞) [Fact (1 ≤ p)] :
    MeasureTheory.Lp.toTemperedDistribution (0 : Lp W p (volume : Measure V)) = 0 := by
  have h := map_zero (MeasureTheory.Lp.toTemperedDistributionCLM W (volume : Measure V) p)
  rwa [MeasureTheory.Lp.toTemperedDistributionCLM_apply] at h

/-- **Nondegeneracy on ALL of `𝓢′`: the distributional Besov norm vanishes only at
    zero.** With the extension theorem `besovNormD_coe`, `B^s_{p,q}(𝓢′)` is a genuine
    normed space of tempered distributions. -/
theorem besovNormD_eq_zero_iff (s : ℝ) {p q : ℝ≥0∞} [Fact (1 ≤ p)] (hq0 : q ≠ 0)
    {u : 𝓢'(V, W)} : besovNormD W s p q u = 0 ↔ u = 0 := by
  have hp0 : p ≠ 0 := (lt_of_lt_of_le zero_lt_one (Fact.out : 1 ≤ p)).ne'
  constructor
  · intro h
    have hmem : MemBesovD W s p q u := by
      rw [MemBesovD, h]
      exact ENNReal.zero_lt_top
    rw [besovNormD, add_eq_zero] at h
    obtain ⟨hlow, hhigh⟩ := h
    obtain ⟨g0, hg0⟩ := hmem.hasLpRep_low
    have hg0n : eLpNorm (⇑g0) p volume = 0 := by
      rw [← lpNormD_eq_of_rep hg0]
      exact hlow
    have hg00 : g0 = 0 := MeasureTheory.Lp.eq_zero_iff_ae_eq_zero.mpr
      ((eLpNorm_eq_zero_iff (MeasureTheory.Lp.aestronglyMeasurable g0) hp0).mp hg0n)
    have hlow0 : lpLowProjD V W u = 0 := by
      rw [hg0, hg00]
      exact lp_toTemperedDistribution_zero p
    have hblocks0 : ∀ j : ℕ, lpProjD V W ((j:ℤ)+1) u = 0 := by
      intro j
      obtain ⟨g, hg⟩ := hmem.hasLpRep_block hq0 j
      have hterm0 : lpNormD W p (lpProjD V W ((j:ℤ)+1) u) = 0 := by
        have hterm : (2:ℝ≥0∞) ^ (((j:ℝ) + 1) * s)
            * lpNormD W p (lpProjD V W ((j:ℤ)+1) u) = 0 := by
          by_cases hqt : q = ∞
          · rw [if_pos hqt] at hhigh
            exact le_antisymm ((le_iSup (fun j : ℕ => (2:ℝ≥0∞) ^ (((j:ℝ) + 1) * s)
              * lpNormD W p (lpProjD V W ((j:ℤ)+1) u)) j).trans hhigh.le) zero_le
          · rw [if_neg hqt] at hhigh
            have hqr : 0 < q.toReal := ENNReal.toReal_pos hq0 hqt
            have hsum0 : (∑' j : ℕ, ((2:ℝ≥0∞) ^ (((j:ℝ) + 1) * s)
                * lpNormD W p (lpProjD V W ((j:ℤ)+1) u)) ^ q.toReal) = 0 := by
              by_contra hne
              rcases ENNReal.rpow_eq_zero_iff.mp hhigh with ⟨h0, -⟩ | ⟨-, hneg⟩
              · exact hne h0
              · exact absurd hneg (not_lt.mpr (by positivity))
            have := ENNReal.tsum_eq_zero.mp hsum0 j
            rcases ENNReal.rpow_eq_zero_iff.mp this with ⟨h0, -⟩ | ⟨-, hneg⟩
            · exact h0
            · exact absurd hneg (not_lt.mpr hqr.le)
        rcases mul_eq_zero.mp hterm with h0 | h0
        · exact absurd h0 (ENNReal.rpow_pos (by norm_num) (by norm_num)).ne'
        · exact h0
      have hgn : eLpNorm (⇑g) p volume = 0 := by
        rw [← lpNormD_eq_of_rep hg]
        exact hterm0
      have hgz : g = 0 := MeasureTheory.Lp.eq_zero_iff_ae_eq_zero.mpr
        ((eLpNorm_eq_zero_iff (MeasureTheory.Lp.aestronglyMeasurable g) hp0).mp hgn)
      rw [hg, hgz]
      exact lp_toTemperedDistribution_zero p
    exact eq_zero_of_lp_blocks_eq_zero hlow0 hblocks0
  · rintro rfl
    exact besovNormD_zero s hq0

end BesovSpace

#eval "Littlewood–Paley dyadic partition of unity — machine-verified."

end NSLittlewoodPaley
