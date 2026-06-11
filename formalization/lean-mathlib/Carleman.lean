/-
  Carleman.lean — the abstract commutator-method core of Carleman inequalities
  (Tao arXiv:1908.04958 §4, Lemma 4.1's operator-algebra skeleton).

  Ladder-1 of the Carleman plan (see docs/carleman_ladder0_tao_sec4_audit.md and
  changelog v0.15.3): Tao's chain

      ∂t⟨Su,u⟩ = ⟨[L,S]u,u⟩ + ½⟨Lu,Lu⟩ − ½⟨(L−2S)u,(L−2S)u⟩
              ≤ ⟨[L,S]u,u⟩ + ½⟨Lu,Lu⟩

  as pure operator algebra over an abstract time-dependent symmetric bilinear
  pairing. The analytic instantiation — `P t = ∫ ··e^{g(t)} dx` on test-function
  curves, the master differential identity via IBP + differentiation under the
  integral (record-audit B8/B9), and the concrete commutator
  `⟨[L,S]u,u⟩ = ∫(−2D²g(∇u,∇u) − ½(LF)|u|²)e^g` — is later rungs.

  CONVENTIONS:
  * Curves: a time-dependent state is `a : ℝ → M`; the admissible class
    `A : Set (ℝ → M)` plays the role of `C_c^∞` slab test functions.
  * The evolution operator `L : (ℝ → M) → (ℝ → M)` acts on CURVES and may
    consume the time derivative (for Tao, `L = ∂t + Δ`); `S : ℝ → M →ₗ[ℝ] M`
    is time-dependent but involves no time derivative.
  * The commutator `[L,S]` is the curve-level expression
    `L (fun τ => S τ (a τ)) − fun τ => S τ (L a τ)` — at this abstraction it is
    a *definition*; its concrete second-order form is the weight calculus rung.
  * `deriv_pair` is the DEFINING property of `S` as the self-adjoint part of
    `L` w.r.t. the pairing: in the L² instantiation it is exactly Tao's first
    display (proved there by IBP — audit identity B8).

  Firewall: `:proved` = 0 for the PDE, and stays 0 — this is library
  infrastructure (the algebra a Carleman estimate stands on), not an NS theorem.
-/
import Mathlib

namespace NSCarleman

/-! #### The bilinear expansion (record-audit B10)

Pure bilinearity — no symmetry, no positivity, no analysis. This is the exact
algebraic pivot of Tao's chain. -/

theorem bilinear_expansion {M : Type*} [AddCommGroup M] [Module ℝ M]
    (B : M →ₗ[ℝ] M →ₗ[ℝ] ℝ) (Lu Su Lv Sv : M) :
    B Lu Sv + B Su Lv - 2 * B Su Sv
      = (1/2) * B Lu Lv
        - (1/2) * B (Lu - (2:ℝ) • Su) (Lv - (2:ℝ) • Sv) := by
  simp only [map_sub, map_smul, LinearMap.sub_apply, LinearMap.smul_apply,
    smul_eq_mul]
  ring

/-! #### The commutator method -/

variable {M : Type*} [AddCommGroup M] [Module ℝ M]

/-- **The commutator-method data** (Tao 1908.04958 §4, abstracted): a
    time-dependent symmetric positive-semidefinite pairing `P t`, an evolution
    operator `L` on curves, a time-dependent operator family `S`, and an
    admissible curve class `A`, such that

    * `S t` is `P t`-self-adjoint,
    * `A` is stable under `S`,
    * the **master differential identity** holds: for admissible curves `a, b`,
      `∂t (P t (a t) (b t)) = P(La,b) + P(a,Lb) − 2·P(Sa,b)`.

    In the weighted-L² instantiation the master identity is Tao's first display
    (proved by integration by parts — audit identity B8) and self-adjointness
    is audit identity B9. -/
structure CommutatorMethod (P : ℝ → M →ₗ[ℝ] M →ₗ[ℝ] ℝ)
    (L : (ℝ → M) → ℝ → M) (S : ℝ → M →ₗ[ℝ] M) (A : Set (ℝ → M)) : Prop where
  symm : ∀ t x y, P t x y = P t y x
  selfAdj : ∀ t x y, P t (S t x) y = P t x (S t y)
  nonneg : ∀ t x, 0 ≤ P t x x
  mem_S : ∀ a ∈ A, (fun τ => S τ (a τ)) ∈ A
  deriv_pair : ∀ a ∈ A, ∀ b ∈ A, ∀ t : ℝ,
    HasDerivAt (fun τ => P τ (a τ) (b τ))
      (P t (L a t) (b t) + P t (a t) (L b t) - 2 * P t (S t (a t)) (b t)) t

namespace CommutatorMethod

variable {P : ℝ → M →ₗ[ℝ] M →ₗ[ℝ] ℝ} {L : (ℝ → M) → ℝ → M}
  {S : ℝ → M →ₗ[ℝ] M} {A : Set (ℝ → M)}

/-- **Tao's commutator chain** (1908.04958 §4, Lemma 4.1's operator-algebra
    core): for an admissible curve `u`,

    `∂t⟨Su,u⟩ = ⟨[L,S]u,u⟩ + ½⟨Lu,Lu⟩ − ½⟨(L−2S)u,(L−2S)u⟩`

    where `[L,S]u` is the curve `L(S∘u) − S∘(Lu)`. -/
theorem hasDerivAt_pair_S (h : CommutatorMethod P L S A) {u : ℝ → M}
    (hu : u ∈ A) (t : ℝ) :
    HasDerivAt (fun τ => P τ (S τ (u τ)) (u τ))
      (P t (L (fun τ => S τ (u τ)) t - S t (L u t)) (u t)
        + (1/2) * P t (L u t) (L u t)
        - (1/2) * P t (L u t - (2:ℝ) • S t (u t))
            (L u t - (2:ℝ) • S t (u t))) t := by
  have hd := h.deriv_pair _ (h.mem_S u hu) u hu t
  convert hd using 1
  -- the derivative values agree, by self-adjointness, symmetry and B10
  have hSL : P t (S t (L u t)) (u t) = P t (L u t) (S t (u t)) :=
    h.selfAdj t (L u t) (u t)
  have hSS : P t (S t (S t (u t))) (u t) = P t (S t (u t)) (S t (u t)) :=
    h.selfAdj t (S t (u t)) (u t)
  have hflip : P t (S t (u t)) (L u t) = P t (L u t) (S t (u t)) :=
    h.symm t (S t (u t)) (L u t)
  have hB10 := bilinear_expansion (P t) (L u t) (S t (u t)) (L u t) (S t (u t))
  simp only [map_sub, LinearMap.sub_apply] at *
  linarith

/-- **The commutator inequality** (drop the square — the driving differential
    inequality of Lemma 4.1): the derivative of `⟨Su,u⟩` is bounded by
    `⟨[L,S]u,u⟩ + ½⟨Lu,Lu⟩`. -/
theorem deriv_pair_S_le (h : CommutatorMethod P L S A) {u : ℝ → M}
    (hu : u ∈ A) (t : ℝ) :
    deriv (fun τ => P τ (S τ (u τ)) (u τ)) t
      ≤ P t (L (fun τ => S τ (u τ)) t - S t (L u t)) (u t)
        + (1/2) * P t (L u t) (L u t) := by
  rw [(h.hasDerivAt_pair_S hu t).deriv]
  have hpos := h.nonneg t (L u t - (2:ℝ) • S t (u t))
  linarith

end CommutatorMethod

/-! #### Ladder-2: the radial weight calculus (record-audit B11/B12, lean-proved)

Tao's two Carleman weights are radial: `g(t,x) = φ(t,‖x‖)`. For radial functions in
`d = 3` the Lemma-4.1 quantities reduce to the radial forms
`F = ∂tφ − (∂rrφ + (2/r)∂rφ) − (∂rφ)²` and `LF = ∂tF + ∂rrF + (2/r)∂rF`, and the
Hessian of `x ↦ φ(‖x‖)` has eigenvalues `∂rrφ` (radial, simple) and `(∂rφ)/r`
(tangential, double). This section machine-verifies Tao's pp. 30/33 displays and the
Hessian facts AT THE RADIAL LEVEL: every partial derivative is pinned by an explicit
`HasDerivAt` witness, and every display is an exact field identity. The 3D
identification `Δ(φ∘‖·‖) = ∂rrφ + (2/r)∂rφ` (the gradient/Hessian-of-norm substrate —
currently a Mathlib gap) is the next rung. -/

namespace WeightCalculus

/-! ##### The first weight (Prop 4.2): `φ(t,r) = α(T₀−t)r + r²/(C₀T)` -/

section FirstWeight

variable (α C₀ T T₀ : ℝ)

/-- Tao Prop 4.2's weight, radial profile. -/
noncomputable def g42 (t r : ℝ) : ℝ := α * (T₀ - t) * r + r ^ 2 / (C₀ * T)

/-- `∂t g42`. -/
noncomputable def g42t (r : ℝ) : ℝ := -(α * r)

/-- `∂r g42`. -/
noncomputable def g42r (t r : ℝ) : ℝ := α * (T₀ - t) + 2 * r / (C₀ * T)

/-- `∂rr g42`. -/
noncomputable def g42rr : ℝ := 2 / (C₀ * T)

theorem hasDerivAt_g42_t (r t : ℝ) :
    HasDerivAt (fun τ => g42 α C₀ T T₀ τ r) (g42t α r) t := by
  unfold g42 g42t
  have h := (((hasDerivAt_id' t).const_sub T₀).const_mul α).mul_const r
  convert h.add_const (r ^ 2 / (C₀ * T)) using 1
  ring

theorem hasDerivAt_g42_r (t r : ℝ) :
    HasDerivAt (fun ρ => g42 α C₀ T T₀ t ρ) (g42r α C₀ T T₀ t r) r := by
  unfold g42 g42r
  have h1 := (hasDerivAt_id' r).const_mul (α * (T₀ - t))
  have h2 := (hasDerivAt_pow 2 r).div_const (C₀ * T)
  convert h1.add h2 using 1
  ring

theorem hasDerivAt_g42r_r (t r : ℝ) :
    HasDerivAt (fun ρ => g42r α C₀ T T₀ t ρ) (g42rr C₀ T) r := by
  unfold g42r g42rr
  have h := ((hasDerivAt_id' r).const_mul 2).div_const (C₀ * T)
  convert h.const_add (α * (T₀ - t)) using 1
  ring

/-- Tao Prop 4.2's `F` (the p. 30 display), radial closed form. -/
noncomputable def F42 (t r : ℝ) : ℝ :=
  -(α * r) - 2 * α * (T₀ - t) / r - 6 / (C₀ * T) - α ^ 2 * (T₀ - t) ^ 2
    - 4 * α * (T₀ - t) * r / (C₀ * T) - 4 * r ^ 2 / (C₀ * T) ^ 2

/-- **B11a, lean-proved — Tao's `F` display for the first weight:**
    `∂tφ − (∂rrφ + (2/r)∂rφ) − (∂rφ)² = F42` for `r ≠ 0`. -/
theorem F42_eq (t r : ℝ) (hr : r ≠ 0) (hCT : C₀ * T ≠ 0) :
    g42t α r - (g42rr C₀ T + (2 / r) * g42r α C₀ T T₀ t r)
      - (g42r α C₀ T T₀ t r) ^ 2 = F42 α C₀ T T₀ t r := by
  unfold g42t g42r g42rr F42
  field_simp
  ring

/-- `∂t F42`. -/
noncomputable def F42t (t r : ℝ) : ℝ :=
  2 * α / r + 2 * α ^ 2 * (T₀ - t) + 4 * α * r / (C₀ * T)

/-- `∂r F42`. -/
noncomputable def F42r (t r : ℝ) : ℝ :=
  -(α * 1) + 2 * α * (T₀ - t) / r ^ 2 - 4 * α * (T₀ - t) / (C₀ * T)
    - 8 * r / (C₀ * T) ^ 2

/-- `∂rr F42`. -/
noncomputable def F42rr (t r : ℝ) : ℝ :=
  -(4 * α * (T₀ - t) / r ^ 3) - 8 / (C₀ * T) ^ 2

theorem hasDerivAt_F42_t (r t : ℝ) (hr : r ≠ 0) :
    HasDerivAt (fun τ => F42 α C₀ T T₀ τ r) (F42t α C₀ T T₀ t r) t := by
  unfold F42 F42t
  have hs := (hasDerivAt_id' t).const_sub T₀
  have h2 := (hs.const_mul (2 * α)).div_const r
  have h4 := (hs.pow 2).const_mul (α ^ 2)
  have h5 := ((hs.const_mul (4 * α)).mul_const r).div_const (C₀ * T)
  have h := (((((hasDerivAt_const t (-(α * r))).sub h2).sub
      (hasDerivAt_const t (6 / (C₀ * T)))).sub h4).sub h5).sub
      (hasDerivAt_const t (4 * r ^ 2 / (C₀ * T) ^ 2))
  convert h using 1
  field_simp
  ring

theorem hasDerivAt_F42_r (t r : ℝ) (hr : r ≠ 0) :
    HasDerivAt (fun ρ => F42 α C₀ T T₀ t ρ) (F42r α C₀ T T₀ t r) r := by
  unfold F42 F42r
  have h1 := ((hasDerivAt_id' r).const_mul α).neg
  have h2 := (hasDerivAt_const r (2 * α * (T₀ - t))).div (hasDerivAt_id' r) hr
  have h5 := ((hasDerivAt_id' r).const_mul (4 * α * (T₀ - t))).div_const (C₀ * T)
  have h6 := ((hasDerivAt_pow 2 r).const_mul 4).div_const ((C₀ * T) ^ 2)
  have h := ((((h1.sub h2).sub (hasDerivAt_const r (6 / (C₀ * T)))).sub
      (hasDerivAt_const r (α ^ 2 * (T₀ - t) ^ 2))).sub h5).sub h6
  convert h using 1
  field_simp
  ring

theorem hasDerivAt_F42r_r (t r : ℝ) (hr : r ≠ 0) :
    HasDerivAt (fun ρ => F42r α C₀ T T₀ t ρ) (F42rr α C₀ T T₀ t r) r := by
  unfold F42r F42rr
  have h2 := (hasDerivAt_const r (2 * α * (T₀ - t))).div (hasDerivAt_pow 2 r)
      (pow_ne_zero 2 hr)
  have h4 := ((hasDerivAt_id' r).const_mul 8).div_const ((C₀ * T) ^ 2)
  have h := (((hasDerivAt_const r (-(α * 1))).add h2).sub
      (hasDerivAt_const r (4 * α * (T₀ - t) / (C₀ * T)))).sub h4
  convert h using 1
  field_simp
  ring

/-- Tao Prop 4.2's `LF` (the p. 30 display), radial closed form. -/
noncomputable def LF42 (t r : ℝ) : ℝ :=
  2 * α ^ 2 * (T₀ - t) + 4 * α * r / (C₀ * T) - 8 * α * (T₀ - t) / (C₀ * T * r)
    - 24 / (C₀ * T) ^ 2

/-- **B11b, lean-proved — Tao's `LF` display for the first weight:**
    `∂tF + ∂rrF + (2/r)∂rF = LF42` for `r ≠ 0`. -/
theorem LF42_eq (t r : ℝ) (hr : r ≠ 0) (hCT : C₀ * T ≠ 0) :
    F42t α C₀ T T₀ t r + (F42rr α C₀ T T₀ t r + (2 / r) * F42r α C₀ T T₀ t r)
      = LF42 α C₀ T T₀ t r := by
  unfold F42t F42r F42rr LF42
  field_simp
  ring

/-- **B11c, radial form — the convexity input of Prop 4.2:** the radial Hessian
    eigenvalue of `g42` is exactly `2/(C₀T)` and the (double) tangential eigenvalue
    `(∂rφ)/r` dominates it whenever `α(T₀−t) ≥ 0 < r` — Tao's `D²g ≥ (2/C₀T)·I`. -/
theorem g42_radial_hess_lower (t r : ℝ) (hα : 0 ≤ α * (T₀ - t)) (hr : 0 < r)
    (hCT : 0 < C₀ * T) :
    g42rr C₀ T = 2 / (C₀ * T) ∧ 2 / (C₀ * T) ≤ g42r α C₀ T T₀ t r / r := by
  refine ⟨rfl, ?_⟩
  unfold g42r
  rw [add_div]
  have h1 : 0 ≤ α * (T₀ - t) / r := div_nonneg hα hr.le
  have h2 : 2 * r / (C₀ * T) / r = 2 / (C₀ * T) := by
    field_simp
  linarith

end FirstWeight

/-! ##### The second weight (Prop 4.3):
`φ(t,r) = −r²/4(t+t₁) − (3/2)log(t+t₁) − α·log((t+t₁)/(T₀+t₁)) + α(t+t₁)/(T₀+t₁)` -/

section SecondWeight

variable (α T₀ t₁ : ℝ)

/-- Tao Prop 4.3's weight (the modified log of the heat kernel), radial profile. -/
noncomputable def g43 (t r : ℝ) : ℝ :=
  -(r ^ 2 / (4 * (t + t₁))) - 3 / 2 * Real.log (t + t₁)
    - α * Real.log ((t + t₁) / (T₀ + t₁)) + α * (t + t₁) / (T₀ + t₁)

/-- `∂t g43`. -/
noncomputable def g43t (t r : ℝ) : ℝ :=
  r ^ 2 / (4 * (t + t₁) ^ 2) - 3 / (2 * (t + t₁)) - α / (t + t₁) + α / (T₀ + t₁)

/-- `∂r g43`. -/
noncomputable def g43r (t r : ℝ) : ℝ := -(r / (2 * (t + t₁)))

/-- `∂rr g43`. -/
noncomputable def g43rr (t : ℝ) : ℝ := -(1 / (2 * (t + t₁)))

theorem hasDerivAt_g43_t (r t : ℝ) (hτ : 0 < t + t₁) (hT : 0 < T₀ + t₁) :
    HasDerivAt (fun τ => g43 α T₀ t₁ τ r) (g43t α T₀ t₁ t r) t := by
  unfold g43 g43t
  have hτ' := (hasDerivAt_id' t).add_const t₁
  have h1 := ((hasDerivAt_const t (r ^ 2)).div (hτ'.const_mul 4)
      (by positivity)).neg
  have h2 := (hτ'.log hτ.ne').const_mul (3 / 2)
  have h3 := ((hτ'.div_const (T₀ + t₁)).log
      (by positivity : (t + t₁) / (T₀ + t₁) ≠ 0)).const_mul α
  have h4 := (hτ'.const_mul α).div_const (T₀ + t₁)
  have h := ((h1.sub h2).sub h3).add h4
  convert h using 1
  field_simp
  ring

theorem hasDerivAt_g43_r (t r : ℝ) (hτ : 0 < t + t₁) :
    HasDerivAt (fun ρ => g43 α T₀ t₁ t ρ) (g43r t₁ t r) r := by
  unfold g43 g43r
  have h1 := ((hasDerivAt_pow 2 r).div_const (4 * (t + t₁))).neg
  have h := ((h1.sub_const (3 / 2 * Real.log (t + t₁))).sub_const
      (α * Real.log ((t + t₁) / (T₀ + t₁)))).add_const (α * (t + t₁) / (T₀ + t₁))
  convert h using 1
  field_simp
  ring

theorem hasDerivAt_g43r_r (t r : ℝ) :
    HasDerivAt (fun ρ => g43r t₁ t ρ) (g43rr t₁ t) r := by
  unfold g43r g43rr
  exact ((hasDerivAt_id' r).div_const (2 * (t + t₁))).neg

/-- Tao Prop 4.3's `F` (the p. 33 display): `F = α/(T₀+t₁) − α/(t+t₁)` —
    in particular **independent of `r`**. -/
noncomputable def F43 (t : ℝ) : ℝ := α / (T₀ + t₁) - α / (t + t₁)

/-- **B12a, lean-proved — Tao's `F` display for the second weight:** the Gaussian and
    `3/(2τ)` contributions cancel exactly. -/
theorem F43_eq (t r : ℝ) (hr : r ≠ 0) (hτ : (t + t₁) ≠ 0) :
    g43t α T₀ t₁ t r - (g43rr t₁ t + (2 / r) * g43r t₁ t r)
      - (g43r t₁ t r) ^ 2 = F43 α T₀ t₁ t := by
  unfold g43t g43r g43rr F43
  field_simp
  ring

/-- `∂t F43`. -/
noncomputable def F43t (t : ℝ) : ℝ := α / (t + t₁) ^ 2

theorem hasDerivAt_F43_t (t : ℝ) (hτ : (t + t₁) ≠ 0) :
    HasDerivAt (fun τ => F43 α T₀ t₁ τ) (F43t α t₁ t) t := by
  unfold F43 F43t
  have h2 := (hasDerivAt_const t α).div ((hasDerivAt_id' t).add_const t₁) hτ
  convert (hasDerivAt_const t (α / (T₀ + t₁))).sub h2 using 1
  field_simp
  ring

theorem hasDerivAt_F43_r (t r : ℝ) :
    HasDerivAt (fun _ : ℝ => F43 α T₀ t₁ t) 0 r :=
  hasDerivAt_const r _

/-- **B12b, lean-proved — Tao's `LF` display for the second weight:**
    `LF = ∂tF + ∂rrF + (2/r)∂rF = α/(t+t₁)²` (the spatial part vanishes — `F43` is
    `r`-independent, so `LF` is the pure time derivative). -/
theorem LF43_eq (t r : ℝ) :
    F43t α t₁ t + (0 + (2 / r) * 0) = α / (t + t₁) ^ 2 := by
  unfold F43t
  ring

/-- **B12c, radial form:** the Hessian of `g43` is exactly `−I/(2(t+t₁))` — both the
    radial and the tangential eigenvalues equal `−1/(2(t+t₁))`. -/
theorem g43_radial_hess (t r : ℝ) (hr : r ≠ 0) :
    g43rr t₁ t = -(1 / (2 * (t + t₁))) ∧ g43r t₁ t r / r = -(1 / (2 * (t + t₁))) := by
  refine ⟨rfl, ?_⟩
  unfold g43r
  field_simp

end SecondWeight

end WeightCalculus

end NSCarleman

#eval "Carleman commutator-method core — machine-verified."
