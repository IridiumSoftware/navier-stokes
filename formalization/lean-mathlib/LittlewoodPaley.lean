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

#eval "Littlewood–Paley dyadic partition of unity — machine-verified."

end NSLittlewoodPaley
