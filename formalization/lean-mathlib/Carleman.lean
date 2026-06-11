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


/-! #### Ladder-3b-i: the weighted Green identity (record-audit B8/B9 INTEGRATED)

The spatial core of Tao's master differential identity: for the weighted pairing
`⟨u,v⟩_g = ∫ u·v·e^g`, integration by parts gives

    `∫ (Δu + ⟪∇g,∇u⟫)·v·e^g = −∫ ⟪∇u,∇v⟫·e^g`,

whose right-hand side is SYMMETRIC in `u,v` — so the spatial operator
`S_g = Δ + ∇g·∇` is `⟨·,·⟩_g`-self-adjoint on test functions (B9 integrated). Factored
through the unweighted Green identity `∫ Δu·w = −∫ ⟪∇u,∇w⟫` (itself a Mathlib gap for
the pointwise `Δ`), which rests on Mathlib's n-dimensional directional integration by
parts (`integral_mul_fderiv_eq_neg_fderiv_mul_of_integrable`, Gouëzel 2024) — for
compactly supported smooth functions every integrability hypothesis is automatic. -/

section WeightedGreen

open MeasureTheory Real Laplacian InnerProductSpace
open scoped RealInnerProductSpace Gradient

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
  [FiniteDimensional ℝ E] [MeasurableSpace E] [BorelSpace E]

/-- **The Green identity for the pointwise Laplacian** (no boundary terms): `u` C²
    compactly supported, `w` C¹: `∫ Δu·w = −∫ ⟪∇u,∇w⟫`. -/
theorem integral_laplacian_mul {u w : E → ℝ}
    (hu : ContDiff ℝ 2 u) (hcu : HasCompactSupport u) (hw : ContDiff ℝ 1 w) :
    ∫ x, Δ u x * w x = - ∫ x, ⟪∇ u x, ∇ w x⟫ := by
  classical
  set b := stdOrthonormalBasis ℝ E with hb
  set U : Fin (Module.finrank ℝ E) → E → ℝ := fun i y => fderiv ℝ u y (b i) with hU
  -- smoothness package
  have hfd1 : ContDiff ℝ 1 (fderiv ℝ u) := hu.fderiv_right (by norm_num)
  have hUc1 : ∀ i, ContDiff ℝ 1 (U i) := fun i =>
    (ContinuousLinearMap.apply ℝ ℝ (b i)).contDiff.comp hfd1
  -- support package
  have htsU : ∀ i, tsupport (U i) ⊆ tsupport u := by
    intro i
    refine closure_minimal ?_ (isClosed_tsupport u)
    intro y hy
    have h1 : fderiv ℝ u y ≠ 0 := by
      intro h0
      exact hy (by simp [hU, h0])
    exact support_fderiv_subset ℝ (Function.mem_support.mpr h1)
  have htsdU : ∀ i, Function.support (fun x => fderiv ℝ (U i) x (b i))
      ⊆ tsupport u := by
    intro i y hy
    have h1 : fderiv ℝ (U i) y ≠ 0 := by
      intro h0
      exact hy (by simp [h0])
    exact (htsU i) (support_fderiv_subset ℝ (Function.mem_support.mpr h1))
  -- continuity package
  have hcontU : ∀ i, Continuous (U i) := fun i => (hUc1 i).continuous
  have hcontdU : ∀ i, Continuous fun x => fderiv ℝ (U i) x (b i) := fun i =>
    (ContinuousLinearMap.apply ℝ ℝ (b i)).continuous.comp
      ((hUc1 i).continuous_fderiv one_ne_zero)
  have hcontw : Continuous w := hw.continuous
  have hcontdw : ∀ i, Continuous fun x => fderiv ℝ w x (b i) := fun i =>
    (ContinuousLinearMap.apply ℝ ℝ (b i)).continuous.comp
      (hw.continuous_fderiv one_ne_zero)
  -- generic integrability discharge
  have hInt : ∀ h : E → ℝ, Continuous h → Function.support h ⊆ tsupport u →
      Integrable h (volume : Measure E) := fun h hc hs =>
    hc.integrable_of_hasCompactSupport (hcu.mono' hs)
  -- pointwise: Δu = Σᵢ ∂ᵢUᵢ
  have hΔ : ∀ x, Δ u x = ∑ i, fderiv ℝ (U i) x (b i) := by
    intro x
    rw [congrFun (laplacian_eq_iteratedFDeriv_orthonormalBasis u b) x]
    refine Finset.sum_congr rfl fun i _ => ?_
    rw [iteratedFDeriv_two_apply]
    have hdf : DifferentiableAt ℝ (fderiv ℝ u) x := hfd1.differentiable one_ne_zero x
    have hcomp : HasFDerivAt (U i)
        ((ContinuousLinearMap.apply ℝ ℝ (b i)).comp (fderiv ℝ (fderiv ℝ u) x)) x :=
      (ContinuousLinearMap.apply ℝ ℝ (b i)).hasFDerivAt.comp x hdf.hasFDerivAt
    rw [hcomp.fderiv]
    rfl
  -- per-direction integration by parts
  have hibp : ∀ i, ∫ x, fderiv ℝ (U i) x (b i) * w x
      = - ∫ x, U i x * fderiv ℝ w x (b i) := by
    intro i
    have h := integral_mul_fderiv_eq_neg_fderiv_mul_of_integrable
      (μ := (volume : Measure E)) (f := U i) (g := w) (v := b i)
      (hInt _ ((hcontdU i).mul hcontw)
        ((Function.support_mul_subset_left _ _).trans (htsdU i)))
      (hInt _ ((hcontU i).mul (hcontdw i))
        ((Function.support_mul_subset_left _ _).trans
          (subset_trans subset_closure (htsU i))))
      (hInt _ ((hcontU i).mul hcontw)
        ((Function.support_mul_subset_left _ _).trans
          (subset_trans subset_closure (htsU i))))
      (fun x _ => (hUc1 i).differentiable one_ne_zero x)
      (fun x _ => hw.differentiable one_ne_zero x)
    linarith [h]
  -- pointwise Parseval
  have hpar : ∀ x, ∑ i, U i x * fderiv ℝ w x (b i) = ⟪∇ u x, ∇ w x⟫ := by
    intro x
    rw [← OrthonormalBasis.sum_inner_mul_inner b (∇ u x) (∇ w x)]
    refine Finset.sum_congr rfl fun i _ => ?_
    show fderiv ℝ u x (b i) * fderiv ℝ w x (b i) = ⟪∇ u x, b i⟫ * ⟪b i, ∇ w x⟫
    rw [← inner_gradient_left (hu.differentiable (by norm_num) x),
        ← inner_gradient_left (hw.differentiable one_ne_zero x),
        real_inner_comm (∇ w x) (b i)]
  -- assemble
  calc ∫ x, Δ u x * w x
      = ∫ x, ∑ i, fderiv ℝ (U i) x (b i) * w x := by
        refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
        show Δ u x * w x = ∑ i, fderiv ℝ (U i) x (b i) * w x
        rw [hΔ x, Finset.sum_mul]
    _ = ∑ i, ∫ x, fderiv ℝ (U i) x (b i) * w x := by
        refine integral_finset_sum _ fun i _ => ?_
        exact hInt _ ((hcontdU i).mul hcontw)
          ((Function.support_mul_subset_left _ _).trans (htsdU i))
    _ = ∑ i, - ∫ x, U i x * fderiv ℝ w x (b i) :=
        Finset.sum_congr rfl fun i _ => hibp i
    _ = - ∑ i, ∫ x, U i x * fderiv ℝ w x (b i) := by
        rw [Finset.sum_neg_distrib]
    _ = - ∫ x, ∑ i, U i x * fderiv ℝ w x (b i) := by
        rw [integral_finset_sum]
        exact fun i _ => hInt _ ((hcontU i).mul (hcontdw i))
          ((Function.support_mul_subset_left _ _).trans
            (subset_trans subset_closure (htsU i)))
    _ = - ∫ x, ⟪∇ u x, ∇ w x⟫ := by
        refine congrArg Neg.neg (integral_congr_ae
          (Filter.Eventually.of_forall fun x => ?_))
        exact hpar x

/-- The gradient of `v·e^g`: `∇(v·e^g) = e^g•∇v + (v·e^g)•∇g`. -/
theorem gradient_mul_exp {v g : E → ℝ} [CompleteSpace E]
    (hv : ContDiff ℝ 1 v) (hg : ContDiff ℝ 1 g) (x : E) :
    ∇ (fun y => v y * exp (g y)) x
      = exp (g x) • ∇ v x + (v x * exp (g x)) • ∇ g x := by
  have hgd : HasFDerivAt (fun y : E => exp (g y)) (exp (g x) • fderiv ℝ g x) x :=
    (Real.hasDerivAt_exp (g x)).comp_hasFDerivAt x
      (hg.differentiable one_ne_zero x).hasFDerivAt
  have hWfd : HasFDerivAt (fun y => v y * exp (g y))
      (v x • (exp (g x) • fderiv ℝ g x) + exp (g x) • fderiv ℝ v x) x :=
    HasFDerivAt.mul (hv.differentiable one_ne_zero x).hasFDerivAt hgd
  rw [_root_.gradient, hWfd.fderiv]
  simp only [map_add, map_smul, smul_smul]
  rw [_root_.gradient, _root_.gradient]
  module

/-- **The weighted Green identity** (B8/B9 integrated): `u` C² compactly supported,
    `v` C¹, `g` C¹: `∫ (Δu + ⟪∇g,∇u⟫)·(v·e^g) = −∫ ⟪∇u,∇v⟫·e^g`. -/
theorem integral_weighted_green {u v g : E → ℝ} [CompleteSpace E]
    (hu : ContDiff ℝ 2 u) (hcu : HasCompactSupport u)
    (hv : ContDiff ℝ 1 v) (hg : ContDiff ℝ 1 g) :
    ∫ x, (Δ u x + ⟪∇ g x, ∇ u x⟫) * (v x * exp (g x))
      = - ∫ x, ⟪∇ u x, ∇ v x⟫ * exp (g x) := by
  classical
  have hgexp : ContDiff ℝ 1 fun y : E => exp (g y) := Real.contDiff_exp.comp hg
  have hWc1 : ContDiff ℝ 1 fun y : E => v y * exp (g y) := hv.mul hgexp
  have hgm := integral_laplacian_mul hu hcu hWc1
  -- continuity/support helpers
  have hcontgradu : Continuous (∇ u) :=
    (LinearIsometryEquiv.continuous _).comp (hu.continuous_fderiv (by norm_num))
  have hcontgradv : Continuous (∇ v) :=
    (LinearIsometryEquiv.continuous _).comp (hv.continuous_fderiv one_ne_zero)
  have hcontgradg : Continuous (∇ g) :=
    (LinearIsometryEquiv.continuous _).comp (hg.continuous_fderiv one_ne_zero)
  have hsuppgradu : ∀ {h : E → ℝ},
      (∀ x, ∇ u x = 0 → h x = 0) → Function.support h ⊆ tsupport u := by
    intro h hh y hy
    by_contra hyn
    have hfd0 : fderiv ℝ u y = 0 := by
      have := support_fderiv_subset ℝ (f := u)
      by_contra hne
      exact hyn (this (Function.mem_support.mpr hne))
    have hgrad0 : ∇ u y = 0 := by
      rw [_root_.gradient, hfd0, map_zero]
    exact hy (hh y hgrad0)
  have hInt : ∀ h : E → ℝ, Continuous h → Function.support h ⊆ tsupport u →
      Integrable h (volume : Measure E) := fun h hc hs =>
    hc.integrable_of_hasCompactSupport (hcu.mono' hs)
  have hcontΔ : Continuous (Δ u) := by
    rw [laplacian_eq_iteratedFDeriv_orthonormalBasis u (stdOrthonormalBasis ℝ E)]
    refine continuous_finset_sum _ fun i _ => ?_
    exact (continuous_eval_const _).comp
      (hu.continuous_iteratedFDeriv (by norm_num))
  have hcontW : Continuous fun y : E => v y * exp (g y) := hWc1.continuous
  -- expand ⟪∇u, ∇(v·e^g)⟫ pointwise
  have hexpand : ∀ x, ⟪∇ u x, ∇ (fun y => v y * exp (g y)) x⟫
      = ⟪∇ u x, ∇ v x⟫ * exp (g x) + ⟪∇ g x, ∇ u x⟫ * (v x * exp (g x)) := by
    intro x
    rw [gradient_mul_exp hv hg x, inner_add_right, real_inner_smul_right,
        real_inner_smul_right, real_inner_comm (∇ g x) (∇ u x)]
    ring
  -- split the left side
  have hsplit : ∫ x, (Δ u x + ⟪∇ g x, ∇ u x⟫) * (v x * exp (g x))
      = (∫ x, Δ u x * (v x * exp (g x)))
        + ∫ x, ⟪∇ g x, ∇ u x⟫ * (v x * exp (g x)) := by
    rw [← integral_add]
    · refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
      ring
    · refine hInt _ (hcontΔ.mul hcontW) ?_
      intro y hy
      have h1 : Δ u y ≠ 0 := by
        intro h0
        exact hy (by simp [h0])
      -- Δu vanishes off tsupport u
      by_contra hyn
      have hloc : ∀ᶠ z in nhds y, u z = 0 := by
        have : (tsupport u)ᶜ ∈ nhds y :=
          (isClosed_tsupport u).isOpen_compl.mem_nhds hyn
        filter_upwards [this] with z hz
        exact image_eq_zero_of_notMem_tsupport hz
      have hev : u =ᶠ[nhds y] fun _ : E => (0:ℝ) := by
        filter_upwards [hloc] with z hz
        exact hz
      have heq : Δ u y = Δ (fun _ : E => (0:ℝ)) y :=
        (laplacian_congr_nhds hev).eq_of_nhds
      rw [heq] at h1
      simp at h1
    · refine hInt _ ((hcontgradg.inner hcontgradu).mul hcontW) ?_
      refine hsuppgradu fun x h0 => ?_
      rw [h0, inner_zero_right, zero_mul]
  -- split the right side of the unweighted identity
  have hsplit2 : ∫ x, ⟪∇ u x, ∇ (fun y => v y * exp (g y)) x⟫
      = (∫ x, ⟪∇ u x, ∇ v x⟫ * exp (g x))
        + ∫ x, ⟪∇ g x, ∇ u x⟫ * (v x * exp (g x)) := by
    rw [← integral_add]
    · refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
      exact hexpand x
    · refine hInt _ ((hcontgradu.inner hcontgradv).mul (hgexp.continuous)) ?_
      refine hsuppgradu fun x h0 => ?_
      rw [h0, inner_zero_left, zero_mul]
    · refine hInt _ ((hcontgradg.inner hcontgradu).mul hcontW) ?_
      refine hsuppgradu fun x h0 => ?_
      rw [h0, inner_zero_right, zero_mul]
  rw [hsplit, hgm, hsplit2]
  ring

/-- **`S_g = Δ + ∇g·∇` is self-adjoint for the weighted pairing** (record-audit B9,
    integrated form): for `u, v` C² compactly supported and `g` C¹,
    `⟨S_g u, v⟩_g = ⟨u, S_g v⟩_g`. -/
theorem integral_Sg_symm {u v g : E → ℝ} [CompleteSpace E]
    (hu : ContDiff ℝ 2 u) (hcu : HasCompactSupport u)
    (hv : ContDiff ℝ 2 v) (hcv : HasCompactSupport v) (hg : ContDiff ℝ 1 g) :
    ∫ x, (Δ u x + ⟪∇ g x, ∇ u x⟫) * (v x * exp (g x))
      = ∫ x, (Δ v x + ⟪∇ g x, ∇ v x⟫) * (u x * exp (g x)) := by
  rw [integral_weighted_green hu hcu (hv.of_le (by norm_num)) hg,
      integral_weighted_green hv hcv (hu.of_le (by norm_num)) hg]
  refine congrArg Neg.neg (integral_congr_ae
    (Filter.Eventually.of_forall fun x => ?_))
  show ⟪∇ u x, ∇ v x⟫ * exp (g x) = ⟪∇ v x, ∇ u x⟫ * exp (g x)
  rw [real_inner_comm]

end WeightedGreen



/-! #### Ladder-3b-ii (spatial half): the weight calculus under the integral

The remaining spatial content of Tao's master identity: the swapped-support Green
variant, the pointwise chain/product rules `Δ(e^g) = (Δg+|∇g|²)e^g` and
`∇(uv) = u∇v + v∇u` (both Mathlib gaps), the weight-Laplacian integral identity, and
the **spatial master identity**
`∫(Δu·v + u·Δv)e^g = ∫((Δg+|∇g|²)uv − 2⟪∇u,∇v⟫)e^g` — the exact space half of
`∂t⟨u,v⟩ = ⟨Lu,v⟩+⟨u,Lv⟩−2⟨Su,v⟩`. -/

namespace WeightedGreenAux

open MeasureTheory Real Laplacian InnerProductSpace
open scoped RealInnerProductSpace Gradient

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
  [FiniteDimensional ℝ E] [MeasurableSpace E] [BorelSpace E]

/-- The Laplacian vanishes off the (closed) support — no smoothness needed. -/
theorem support_laplacian_subset (u : E → ℝ) :
    Function.support (Δ u) ⊆ tsupport u := by
  intro y hy
  by_contra hyn
  have hloc : ∀ᶠ z in nhds y, u z = 0 := by
    have : (tsupport u)ᶜ ∈ nhds y :=
      (isClosed_tsupport u).isOpen_compl.mem_nhds hyn
    filter_upwards [this] with z hz
    exact image_eq_zero_of_notMem_tsupport hz
  have hev : u =ᶠ[nhds y] fun _ : E => (0:ℝ) := by
    filter_upwards [hloc] with z hz
    exact hz
  have heq : Δ u y = Δ (fun _ : E => (0:ℝ)) y :=
    (laplacian_congr_nhds hev).eq_of_nhds
  refine hy ?_
  rw [heq]
  simp

/-- C² functions have continuous Laplacian. -/
theorem continuous_laplacian {u : E → ℝ} (hu : ContDiff ℝ 2 u) :
    Continuous (Δ u) := by
  rw [laplacian_eq_iteratedFDeriv_orthonormalBasis u (stdOrthonormalBasis ℝ E)]
  refine continuous_finset_sum _ fun i _ => ?_
  exact (continuous_eval_const _).comp (hu.continuous_iteratedFDeriv (by norm_num))

/-- C¹ functions have continuous gradient. -/
theorem continuous_gradient {u : E → ℝ} (hu : ContDiff ℝ 1 u) :
    Continuous (∇ u) :=
  (LinearIsometryEquiv.continuous _).comp (hu.continuous_fderiv one_ne_zero)

/-- The gradient vanishes off the (closed) support. -/
theorem support_gradient_subset (u : E → ℝ) :
    Function.support (∇ u) ⊆ tsupport u := by
  intro y hy
  have h1 : fderiv ℝ u y ≠ 0 := by
    intro h0
    refine hy ?_
    rw [_root_.gradient, h0, map_zero]
  exact support_fderiv_subset ℝ (Function.mem_support.mpr h1)

/-- The gradient of the exponential weight: `∇(e^g) = e^g • ∇g`. -/
theorem gradient_exp_comp {g : E → ℝ} [CompleteSpace E]
    (hg : ContDiff ℝ 1 g) (x : E) :
    ∇ (fun y => exp (g y)) x = exp (g x) • ∇ g x := by
  have hgd : HasFDerivAt (fun y : E => exp (g y)) (exp (g x) • fderiv ℝ g x) x :=
    (Real.hasDerivAt_exp (g x)).comp_hasFDerivAt x
      (hg.differentiable one_ne_zero x).hasFDerivAt
  rw [_root_.gradient, hgd.fderiv, map_smul, _root_.gradient]

/-- The gradient product rule: `∇(uv) = u•∇v + v•∇u`. -/
theorem gradient_mul {u v : E → ℝ} [CompleteSpace E]
    (hu : ContDiff ℝ 1 u) (hv : ContDiff ℝ 1 v) (x : E) :
    ∇ (fun y => u y * v y) x = u x • ∇ v x + v x • ∇ u x := by
  have h : HasFDerivAt (fun y => u y * v y)
      (u x • fderiv ℝ v x + v x • fderiv ℝ u x) x :=
    HasFDerivAt.mul (hu.differentiable one_ne_zero x).hasFDerivAt
      (hv.differentiable one_ne_zero x).hasFDerivAt
  rw [_root_.gradient, h.fderiv]
  simp only [map_add, map_smul]
  rw [_root_.gradient, _root_.gradient]

/-- **The Laplacian chain rule for the exponential weight** (pointwise, a Mathlib gap):
    `Δ(e^g) = (Δg + ‖∇g‖²)·e^g` for `g` C². -/
theorem laplacian_exp_comp {g : E → ℝ} (hg : ContDiff ℝ 2 g) (x : E) :
    Δ (fun y => exp (g y)) x = (Δ g x + ⟪∇ g x, ∇ g x⟫) * exp (g x) := by
  classical
  set b := stdOrthonormalBasis ℝ E with hb
  have hgd : ∀ y : E, HasFDerivAt (fun z : E => exp (g z))
      (exp (g y) • fderiv ℝ g y) y := fun y =>
    (Real.hasDerivAt_exp (g y)).comp_hasFDerivAt y
      (hg.differentiable (by norm_num) y).hasFDerivAt
  have hfg1 : ContDiff ℝ 1 (fderiv ℝ g) := hg.fderiv_right (by norm_num)
  have hexpc : HasFDerivAt (fun y : E => exp (g y))
      (exp (g x) • fderiv ℝ g x) x := hgd x
  have hH : HasFDerivAt (fun y : E => exp (g y) • fderiv ℝ g y) _ x :=
    HasFDerivAt.smul hexpc (hfg1.differentiable one_ne_zero x).hasFDerivAt
  have heq : (fderiv ℝ fun y : E => exp (g y))
      = fun y : E => exp (g y) • fderiv ℝ g y :=
    funext fun y => (hgd y).fderiv
  rw [congrFun (laplacian_eq_iteratedFDeriv_orthonormalBasis _ b) x]
  have hterm : ∀ i, iteratedFDeriv ℝ 2 (fun y : E => exp (g y)) x ![b i, b i]
      = exp (g x) * (fderiv ℝ g x (b i) * fderiv ℝ g x (b i))
        + exp (g x) * fderiv ℝ (fderiv ℝ g) x (b i) (b i) := by
    intro i
    rw [iteratedFDeriv_two_apply, heq, hH.fderiv]
    simp only [ContinuousLinearMap.add_apply, ContinuousLinearMap.coe_smul',
      Pi.smul_apply, ContinuousLinearMap.smulRight_apply,
      ContinuousLinearMap.smul_apply, smul_eq_mul, Matrix.cons_val_zero,
      Matrix.cons_val_one, Matrix.head_cons]
    ring
  rw [Finset.sum_congr rfl fun i _ => hterm i, Finset.sum_add_distrib,
      ← Finset.mul_sum, ← Finset.mul_sum]
  have hpar : ∑ i, fderiv ℝ g x (b i) * fderiv ℝ g x (b i) = ⟪∇ g x, ∇ g x⟫ := by
    rw [← OrthonormalBasis.sum_inner_mul_inner b (∇ g x) (∇ g x)]
    refine Finset.sum_congr rfl fun i _ => ?_
    rw [← inner_gradient_left (hg.differentiable (by norm_num) x),
        real_inner_comm (∇ g x) (b i)]
  have hlap : Δ g x = ∑ i, fderiv ℝ (fderiv ℝ g) x (b i) (b i) := by
    rw [congrFun (laplacian_eq_iteratedFDeriv_orthonormalBasis g b) x]
    refine Finset.sum_congr rfl fun i _ => ?_
    rw [iteratedFDeriv_two_apply]
    rfl
  rw [hpar, ← hlap]
  ring

/-- Variant of the Green identity with compact support on the MULTIPLIER:
    `∫ Δh·w = −∫ ⟪∇h,∇w⟫` for `h` C² (arbitrary growth), `w` C¹ compactly supported. -/
theorem integral_laplacian_mul' {h w : E → ℝ}
    (hh : ContDiff ℝ 2 h) (hw : ContDiff ℝ 1 w) (hcw : HasCompactSupport w) :
    ∫ x, Δ h x * w x = - ∫ x, ⟪∇ h x, ∇ w x⟫ := by
  classical
  set b := stdOrthonormalBasis ℝ E with hb
  set U : Fin (Module.finrank ℝ E) → E → ℝ := fun i y => fderiv ℝ h y (b i) with hU
  have hfd1 : ContDiff ℝ 1 (fderiv ℝ h) := hh.fderiv_right (by norm_num)
  have hUc1 : ∀ i, ContDiff ℝ 1 (U i) := fun i =>
    (ContinuousLinearMap.apply ℝ ℝ (b i)).contDiff.comp hfd1
  -- support package (everything routes through `w`)
  have htsdw : ∀ i, Function.support (fun x => fderiv ℝ w x (b i)) ⊆ tsupport w := by
    intro i y hy
    have h1 : fderiv ℝ w y ≠ 0 := by
      intro h0
      exact hy (by simp [h0])
    exact support_fderiv_subset ℝ (Function.mem_support.mpr h1)
  -- continuity package
  have hcontU : ∀ i, Continuous (U i) := fun i => (hUc1 i).continuous
  have hcontdU : ∀ i, Continuous fun x => fderiv ℝ (U i) x (b i) := fun i =>
    (ContinuousLinearMap.apply ℝ ℝ (b i)).continuous.comp
      ((hUc1 i).continuous_fderiv one_ne_zero)
  have hcontw : Continuous w := hw.continuous
  have hcontdw : ∀ i, Continuous fun x => fderiv ℝ w x (b i) := fun i =>
    (ContinuousLinearMap.apply ℝ ℝ (b i)).continuous.comp
      (hw.continuous_fderiv one_ne_zero)
  have hInt : ∀ p : E → ℝ, Continuous p → Function.support p ⊆ tsupport w →
      Integrable p (volume : Measure E) := fun p hc hs =>
    hc.integrable_of_hasCompactSupport (hcw.mono' hs)
  -- pointwise: Δh = Σᵢ ∂ᵢUᵢ
  have hΔ : ∀ x, Δ h x = ∑ i, fderiv ℝ (U i) x (b i) := by
    intro x
    rw [congrFun (laplacian_eq_iteratedFDeriv_orthonormalBasis h b) x]
    refine Finset.sum_congr rfl fun i _ => ?_
    rw [iteratedFDeriv_two_apply]
    have hdf : DifferentiableAt ℝ (fderiv ℝ h) x := hfd1.differentiable one_ne_zero x
    have hcomp : HasFDerivAt (U i)
        ((ContinuousLinearMap.apply ℝ ℝ (b i)).comp (fderiv ℝ (fderiv ℝ h) x)) x :=
      (ContinuousLinearMap.apply ℝ ℝ (b i)).hasFDerivAt.comp x hdf.hasFDerivAt
    rw [hcomp.fderiv]
    rfl
  -- per-direction IBP (supports route through `w`)
  have hibp : ∀ i, ∫ x, fderiv ℝ (U i) x (b i) * w x
      = - ∫ x, U i x * fderiv ℝ w x (b i) := by
    intro i
    have h := integral_mul_fderiv_eq_neg_fderiv_mul_of_integrable
      (μ := (volume : Measure E)) (f := U i) (g := w) (v := b i)
      (hInt _ ((hcontdU i).mul hcontw)
        ((Function.support_mul_subset_right _ _).trans subset_closure))
      (hInt _ ((hcontU i).mul (hcontdw i))
        ((Function.support_mul_subset_right _ _).trans (htsdw i)))
      (hInt _ ((hcontU i).mul hcontw)
        ((Function.support_mul_subset_right _ _).trans subset_closure))
      (fun x _ => (hUc1 i).differentiable one_ne_zero x)
      (fun x _ => hw.differentiable one_ne_zero x)
    linarith [h]
  have hpar : ∀ x, ∑ i, U i x * fderiv ℝ w x (b i) = ⟪∇ h x, ∇ w x⟫ := by
    intro x
    rw [← OrthonormalBasis.sum_inner_mul_inner b (∇ h x) (∇ w x)]
    refine Finset.sum_congr rfl fun i _ => ?_
    show fderiv ℝ h x (b i) * fderiv ℝ w x (b i) = ⟪∇ h x, b i⟫ * ⟪b i, ∇ w x⟫
    rw [← inner_gradient_left (hh.differentiable (by norm_num) x),
        ← inner_gradient_left (hw.differentiable one_ne_zero x),
        real_inner_comm (∇ w x) (b i)]
  calc ∫ x, Δ h x * w x
      = ∫ x, ∑ i, fderiv ℝ (U i) x (b i) * w x := by
        refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
        show Δ h x * w x = ∑ i, fderiv ℝ (U i) x (b i) * w x
        rw [hΔ x, Finset.sum_mul]
    _ = ∑ i, ∫ x, fderiv ℝ (U i) x (b i) * w x := by
        refine integral_finset_sum _ fun i _ => ?_
        exact hInt _ ((hcontdU i).mul hcontw)
          ((Function.support_mul_subset_right _ _).trans subset_closure)
    _ = ∑ i, - ∫ x, U i x * fderiv ℝ w x (b i) :=
        Finset.sum_congr rfl fun i _ => hibp i
    _ = - ∑ i, ∫ x, U i x * fderiv ℝ w x (b i) := by
        rw [Finset.sum_neg_distrib]
    _ = - ∫ x, ∑ i, U i x * fderiv ℝ w x (b i) := by
        rw [integral_finset_sum]
        exact fun i _ => hInt _ ((hcontU i).mul (hcontdw i))
          ((Function.support_mul_subset_right _ _).trans (htsdw i))
    _ = - ∫ x, ⟪∇ h x, ∇ w x⟫ := by
        refine congrArg Neg.neg (integral_congr_ae
          (Filter.Eventually.of_forall fun x => ?_))
        exact hpar x

/-- **The weight-Laplacian integral identity** (the B8 "double-IBP" half):
    `∫ (Δg + ‖∇g‖²)·w·e^g = −∫ ⟪∇g,∇w⟫·e^g` for `g` C², `w` C¹ compactly supported. -/
theorem integral_weight_laplacian {g w : E → ℝ} [CompleteSpace E]
    (hg : ContDiff ℝ 2 g) (hw : ContDiff ℝ 1 w) (hcw : HasCompactSupport w) :
    ∫ x, (Δ g x + ⟪∇ g x, ∇ g x⟫) * w x * exp (g x)
      = - ∫ x, ⟪∇ g x, ∇ w x⟫ * exp (g x) := by
  have hexp2 : ContDiff ℝ 2 fun y : E => exp (g y) :=
    Real.contDiff_exp.comp hg
  have h := integral_laplacian_mul' hexp2 hw hcw
  calc ∫ x, (Δ g x + ⟪∇ g x, ∇ g x⟫) * w x * exp (g x)
      = ∫ x, Δ (fun y : E => exp (g y)) x * w x := by
        refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
        show (Δ g x + ⟪∇ g x, ∇ g x⟫) * w x * exp (g x)
            = Δ (fun y : E => exp (g y)) x * w x
        rw [laplacian_exp_comp hg x]
        ring
    _ = - ∫ x, ⟪∇ (fun y : E => exp (g y)) x, ∇ w x⟫ := h
    _ = - ∫ x, ⟪∇ g x, ∇ w x⟫ * exp (g x) := by
        refine congrArg Neg.neg (integral_congr_ae
          (Filter.Eventually.of_forall fun x => ?_))
        show ⟪∇ (fun y : E => exp (g y)) x, ∇ w x⟫ = ⟪∇ g x, ∇ w x⟫ * exp (g x)
        rw [gradient_exp_comp (hg.of_le (by norm_num)) x, real_inner_smul_left]
        ring

/-- **The spatial master identity** (the space half of Tao's Lemma 4.1 display):
    for `u, v` C² compactly supported and `g` C²,
    `∫ (Δu·v + u·Δv)·e^g = ∫ ((Δg + ‖∇g‖²)·uv − 2⟪∇u,∇v⟫)·e^g`. -/
theorem integral_laplacian_pair {u v g : E → ℝ} [CompleteSpace E]
    (hu : ContDiff ℝ 2 u) (hcu : HasCompactSupport u)
    (hv : ContDiff ℝ 2 v) (hcv : HasCompactSupport v) (hg : ContDiff ℝ 2 g) :
    ∫ x, (Δ u x * v x + u x * Δ v x) * exp (g x)
      = ∫ x, ((Δ g x + ⟪∇ g x, ∇ g x⟫) * (u x * v x)
          - 2 * ⟪∇ u x, ∇ v x⟫) * exp (g x) := by
  classical
  have hg1 : ContDiff ℝ 1 g := hg.of_le (by norm_num)
  have hu1 : ContDiff ℝ 1 u := hu.of_le (by norm_num)
  have hv1 : ContDiff ℝ 1 v := hv.of_le (by norm_num)
  have hgexp : Continuous fun x : E => exp (g x) :=
    Real.continuous_exp.comp hg.continuous
  -- integrability discharges, all routed through `u` or `v`
  have hIntu : ∀ p : E → ℝ, Continuous p → Function.support p ⊆ tsupport u →
      Integrable p (volume : Measure E) := fun p hc hs =>
    hc.integrable_of_hasCompactSupport (hcu.mono' hs)
  have hIntv : ∀ p : E → ℝ, Continuous p → Function.support p ⊆ tsupport v →
      Integrable p (volume : Measure E) := fun p hc hs =>
    hc.integrable_of_hasCompactSupport (hcv.mono' hs)
  -- the six atoms
  set A1 := ∫ x, Δ u x * (v x * exp (g x)) with hA1
  set A2 := ∫ x, ⟪∇ g x, ∇ u x⟫ * (v x * exp (g x)) with hA2
  set A3 := ∫ x, ⟪∇ u x, ∇ v x⟫ * exp (g x) with hA3
  set B1 := ∫ x, Δ v x * (u x * exp (g x)) with hB1
  set B2 := ∫ x, ⟪∇ g x, ∇ v x⟫ * (u x * exp (g x)) with hB2
  set C1 := ∫ x, (Δ g x + ⟪∇ g x, ∇ g x⟫) * (u x * v x) * exp (g x) with hC1
  -- R1: Green for u against v·e^g
  have hR1 : A1 + A2 = - A3 := by
    rw [hA1, hA2, ← integral_add
      (hIntu (fun x => Δ u x * (v x * exp (g x)))
        ((continuous_laplacian hu).mul (hv.continuous.mul hgexp))
        ((Function.support_mul_subset_left _ _).trans (support_laplacian_subset u)))
      (hIntu (fun x => ⟪∇ g x, ∇ u x⟫ * (v x * exp (g x)))
        (((continuous_gradient hg1).inner (continuous_gradient hu1)).mul
          (hv.continuous.mul hgexp))
        ((Function.support_mul_subset_left _ _).trans (fun x hx => by
          refine support_gradient_subset u ?_
          intro h0
          exact hx (by simp [h0]))))]
    rw [hA3, ← integral_weighted_green hu hcu hv1 hg1]
    refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
    show Δ u x * (v x * exp (g x)) + ⟪∇ g x, ∇ u x⟫ * (v x * exp (g x))
        = (Δ u x + ⟪∇ g x, ∇ u x⟫) * (v x * exp (g x))
    ring
  -- R2: Green for v against u·e^g
  have hR2 : B1 + B2 = - A3 := by
    rw [hB1, hB2, ← integral_add
      (hIntv (fun x => Δ v x * (u x * exp (g x)))
        ((continuous_laplacian hv).mul (hu.continuous.mul hgexp))
        ((Function.support_mul_subset_left _ _).trans (support_laplacian_subset v)))
      (hIntv (fun x => ⟪∇ g x, ∇ v x⟫ * (u x * exp (g x)))
        (((continuous_gradient hg1).inner (continuous_gradient hv1)).mul
          (hu.continuous.mul hgexp))
        ((Function.support_mul_subset_left _ _).trans (fun x hx => by
          refine support_gradient_subset v ?_
          intro h0
          exact hx (by simp [h0]))))]
    have hgr := integral_weighted_green hv hcv hu1 hg1
    rw [hA3]
    have hflip : ∫ x, ⟪∇ v x, ∇ u x⟫ * exp (g x) = ∫ x, ⟪∇ u x, ∇ v x⟫ * exp (g x) := by
      refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
      show ⟪∇ v x, ∇ u x⟫ * exp (g x) = ⟪∇ u x, ∇ v x⟫ * exp (g x)
      rw [real_inner_comm]
    rw [← hflip, ← hgr]
    refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
    show Δ v x * (u x * exp (g x)) + ⟪∇ g x, ∇ v x⟫ * (u x * exp (g x))
        = (Δ v x + ⟪∇ g x, ∇ v x⟫) * (u x * exp (g x))
    ring
  -- R3: the weight-Laplacian identity for w := u·v, gradient product rule expanded
  have hR3 : C1 = - (B2 + A2) := by
    have huv2 : ContDiff ℝ 1 fun y : E => u y * v y := hu1.mul hv1
    have hcuv : HasCompactSupport fun y : E => u y * v y :=
      hcu.mono' ((Function.support_mul_subset_left _ _).trans subset_closure)
    have h := integral_weight_laplacian hg huv2 hcuv
    rw [hC1]
    have hL : ∫ x, (Δ g x + ⟪∇ g x, ∇ g x⟫) * (u x * v x) * exp (g x)
        = ∫ x, (Δ g x + ⟪∇ g x, ∇ g x⟫) * (fun y : E => u y * v y) x * exp (g x) := by
      exact integral_congr_ae (Filter.Eventually.of_forall fun x => rfl)
    rw [hL, h]
    rw [hB2, hA2, ← integral_add
      (hIntu (fun x => ⟪∇ g x, ∇ v x⟫ * (u x * exp (g x)))
        (((continuous_gradient hg1).inner (continuous_gradient hv1)).mul
          (hu.continuous.mul hgexp))
        ((Function.support_mul_subset_right _ _).trans
          ((Function.support_mul_subset_left _ _).trans subset_closure)))
      (hIntu (fun x => ⟪∇ g x, ∇ u x⟫ * (v x * exp (g x)))
        (((continuous_gradient hg1).inner (continuous_gradient hu1)).mul
          (hv.continuous.mul hgexp))
        ((Function.support_mul_subset_left _ _).trans (fun x hx => by
          refine support_gradient_subset u ?_
          intro h0
          exact hx (by simp [h0]))))]
    refine congrArg Neg.neg (integral_congr_ae
      (Filter.Eventually.of_forall fun x => ?_))
    show ⟪∇ g x, ∇ (fun y : E => u y * v y) x⟫ * exp (g x)
        = ⟪∇ g x, ∇ v x⟫ * (u x * exp (g x)) + ⟪∇ g x, ∇ u x⟫ * (v x * exp (g x))
    rw [gradient_mul hu1 hv1 x, inner_add_right, real_inner_smul_right,
        real_inner_smul_right]
    ring
  -- assemble: LHS = A1 + B1, RHS = C1 − 2·A3; from R1,R2,R3: A1+B1 = −2A3 − A2 − B2 = C1 − 2A3
  have hLHS : ∫ x, (Δ u x * v x + u x * Δ v x) * exp (g x) = A1 + B1 := by
    rw [hA1, hB1, ← integral_add
      (hIntu (fun x => Δ u x * (v x * exp (g x)))
        ((continuous_laplacian hu).mul (hv.continuous.mul hgexp))
        ((Function.support_mul_subset_left _ _).trans (support_laplacian_subset u)))
      (hIntv (fun x => Δ v x * (u x * exp (g x)))
        ((continuous_laplacian hv).mul (hu.continuous.mul hgexp))
        ((Function.support_mul_subset_left _ _).trans (support_laplacian_subset v)))]
    refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
    show (Δ u x * v x + u x * Δ v x) * exp (g x)
        = Δ u x * (v x * exp (g x)) + Δ v x * (u x * exp (g x))
    ring
  have hRHS : ∫ x, ((Δ g x + ⟪∇ g x, ∇ g x⟫) * (u x * v x)
      - 2 * ⟪∇ u x, ∇ v x⟫) * exp (g x) = C1 - 2 * A3 := by
    rw [hC1, hA3]
    have hsub : ∫ x, ((Δ g x + ⟪∇ g x, ∇ g x⟫) * (u x * v x)
        - 2 * ⟪∇ u x, ∇ v x⟫) * exp (g x)
        = (∫ x, (Δ g x + ⟪∇ g x, ∇ g x⟫) * (u x * v x) * exp (g x))
          - ∫ x, 2 * ⟪∇ u x, ∇ v x⟫ * exp (g x) := by
      rw [← integral_sub
        (hIntu (fun x => (Δ g x + ⟪∇ g x, ∇ g x⟫) * (u x * v x) * exp (g x))
          (((((continuous_laplacian hg).add
            ((continuous_gradient hg1).inner (continuous_gradient hg1)))).mul
            (hu.continuous.mul hv.continuous)).mul hgexp)
          (((Function.support_mul_subset_left _ _).trans
            (Function.support_mul_subset_right _ _)).trans
            ((Function.support_mul_subset_left _ _).trans subset_closure)))
        (hIntu (fun x => 2 * ⟪∇ u x, ∇ v x⟫ * exp (g x))
          ((continuous_const.mul
            ((continuous_gradient hu1).inner (continuous_gradient hv1))).mul hgexp)
          (((Function.support_mul_subset_left _ _).trans
            (Function.support_mul_subset_right _ _)).trans (fun x hx => by
            refine support_gradient_subset u ?_
            intro h0
            exact hx (by simp [h0]))))]
      refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
      show ((Δ g x + ⟪∇ g x, ∇ g x⟫) * (u x * v x) - 2 * ⟪∇ u x, ∇ v x⟫) * exp (g x)
          = (Δ g x + ⟪∇ g x, ∇ g x⟫) * (u x * v x) * exp (g x)
            - 2 * ⟪∇ u x, ∇ v x⟫ * exp (g x)
      ring
    rw [hsub]
    congr 1
    rw [← integral_const_mul]
    refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
    show 2 * ⟪∇ u x, ∇ v x⟫ * exp (g x) = 2 * (⟪∇ u x, ∇ v x⟫ * exp (g x))
    ring
  rw [hLHS, hRHS]
  linarith [hR1, hR2, hR3]

end WeightedGreenAux




/-! #### Ladder-3b-iii: the time layer — Tao's MASTER DIFFERENTIAL IDENTITY

Differentiation under the integral for `t ↦ ∫ u(t)·v(t)·e^{g(t)}` plus the spatial
identities yield the first display of Tao 1908.04958 §4 Lemma 4.1:

    `∂t⟨u,v⟩_g = ⟨Lu,v⟩_g + ⟨u,Lv⟩_g − 2⟨Su,v⟩_g`

with `L = ∂t + Δ`, `S = Δ + ∇g·∇ − F/2`, `F = ∂tg − Δg − ‖∇g‖²` — the `deriv_pair`
field of the ladder-1 `CommutatorMethod`, realized for the weighted-L² pairing on
test-function curves with uniform spatial support in a compact `K`. -/

section TimeLayer

open MeasureTheory Real Laplacian InnerProductSpace WeightedGreenAux
open scoped RealInnerProductSpace Gradient

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
  [FiniteDimensional ℝ E] [MeasurableSpace E] [BorelSpace E]

/-- Split form of the weighted Green identity:
    `∫Δu·(v·e^g) = −∫⟪∇u,∇v⟫·e^g − ∫⟪∇g,∇u⟫·(v·e^g)`. -/
theorem integral_green_split {u v g : E → ℝ} [CompleteSpace E]
    (hu : ContDiff ℝ 2 u) (hcu : HasCompactSupport u)
    (hv : ContDiff ℝ 1 v) (hg : ContDiff ℝ 1 g) :
    ∫ x, Δ u x * (v x * exp (g x))
      = - (∫ x, ⟪∇ u x, ∇ v x⟫ * exp (g x))
        - ∫ x, ⟪∇ g x, ∇ u x⟫ * (v x * exp (g x)) := by
  have hgexp : Continuous fun x : E => exp (g x) :=
    Real.continuous_exp.comp hg.continuous
  have hIntu : ∀ p : E → ℝ, Continuous p → Function.support p ⊆ tsupport u →
      Integrable p (volume : Measure E) := fun p hc hs =>
    hc.integrable_of_hasCompactSupport (hcu.mono' hs)
  have hsplit : ∫ x, (Δ u x + ⟪∇ g x, ∇ u x⟫) * (v x * exp (g x))
      = (∫ x, Δ u x * (v x * exp (g x)))
        + ∫ x, ⟪∇ g x, ∇ u x⟫ * (v x * exp (g x)) := by
    rw [← integral_add
      (hIntu (fun x => Δ u x * (v x * exp (g x)))
        ((continuous_laplacian hu).mul (hv.continuous.mul hgexp))
        ((Function.support_mul_subset_left _ _).trans (support_laplacian_subset u)))
      (hIntu (fun x => ⟪∇ g x, ∇ u x⟫ * (v x * exp (g x)))
        (((continuous_gradient hg).inner
            (continuous_gradient (hu.of_le (by norm_num)))).mul
          (hv.continuous.mul hgexp))
        ((Function.support_mul_subset_left _ _).trans (fun x hx => by
          refine support_gradient_subset u ?_
          intro h0
          exact hx (by simp [h0]))))]
    refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
    show (Δ u x + ⟪∇ g x, ∇ u x⟫) * (v x * exp (g x))
        = Δ u x * (v x * exp (g x)) + ⟪∇ g x, ∇ u x⟫ * (v x * exp (g x))
    ring
  have hG := integral_weighted_green hu hcu hv hg
  linarith [hsplit, hG]

/-- Split form of the weight-Laplacian identity on a product:
    `∫(Δg+‖∇g‖²)·(u·v)·e^g = −∫⟪∇g,∇v⟫·(u·e^g) − ∫⟪∇g,∇u⟫·(v·e^g)`. -/
theorem integral_weight_split {u v g : E → ℝ} [CompleteSpace E]
    (hu : ContDiff ℝ 1 u) (hcu : HasCompactSupport u)
    (hv : ContDiff ℝ 1 v) (hg : ContDiff ℝ 2 g) :
    ∫ x, (Δ g x + ⟪∇ g x, ∇ g x⟫) * (u x * v x) * exp (g x)
      = - (∫ x, ⟪∇ g x, ∇ v x⟫ * (u x * exp (g x)))
        - ∫ x, ⟪∇ g x, ∇ u x⟫ * (v x * exp (g x)) := by
  have hg1 : ContDiff ℝ 1 g := hg.of_le (by norm_num)
  have hgexp : Continuous fun x : E => exp (g x) :=
    Real.continuous_exp.comp hg1.continuous
  have hIntu : ∀ p : E → ℝ, Continuous p → Function.support p ⊆ tsupport u →
      Integrable p (volume : Measure E) := fun p hc hs =>
    hc.integrable_of_hasCompactSupport (hcu.mono' hs)
  have huv1 : ContDiff ℝ 1 fun y : E => u y * v y := hu.mul hv
  have hcuv : HasCompactSupport fun y : E => u y * v y :=
    hcu.mono' ((Function.support_mul_subset_left _ _).trans subset_closure)
  have h := integral_weight_laplacian hg huv1 hcuv
  have hL : ∫ x, (Δ g x + ⟪∇ g x, ∇ g x⟫) * (fun y : E => u y * v y) x * exp (g x)
      = ∫ x, (Δ g x + ⟪∇ g x, ∇ g x⟫) * (u x * v x) * exp (g x) :=
    integral_congr_ae (Filter.Eventually.of_forall fun x => rfl)
  rw [← hL, h]
  have hsplit : ∫ x, ⟪∇ g x, ∇ (fun y : E => u y * v y) x⟫ * exp (g x)
      = (∫ x, ⟪∇ g x, ∇ v x⟫ * (u x * exp (g x)))
        + ∫ x, ⟪∇ g x, ∇ u x⟫ * (v x * exp (g x)) := by
    rw [← integral_add
      (hIntu (fun x => ⟪∇ g x, ∇ v x⟫ * (u x * exp (g x)))
        (((continuous_gradient hg1).inner (continuous_gradient hv)).mul
          (hu.continuous.mul hgexp))
        ((Function.support_mul_subset_right _ _).trans
          ((Function.support_mul_subset_left _ _).trans subset_closure)))
      (hIntu (fun x => ⟪∇ g x, ∇ u x⟫ * (v x * exp (g x)))
        (((continuous_gradient hg1).inner (continuous_gradient hu)).mul
          (hv.continuous.mul hgexp))
        ((Function.support_mul_subset_left _ _).trans (fun x hx => by
          refine support_gradient_subset u ?_
          intro h0
          exact hx (by simp [h0]))))]
    refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
    show ⟪∇ g x, ∇ (fun y : E => u y * v y) x⟫ * exp (g x)
        = ⟪∇ g x, ∇ v x⟫ * (u x * exp (g x)) + ⟪∇ g x, ∇ u x⟫ * (v x * exp (g x))
    rw [gradient_mul hu hv x, inner_add_right, real_inner_smul_right,
        real_inner_smul_right]
    ring
  rw [hsplit]
  ring

/-- **Differentiation under the weighted pairing**: for curves with uniform spatial
    support in a compact `K` and jointly continuous data,
    `∂t ∫ u·v·e^g = ∫ (∂tu·v + u·∂tv + u·v·∂tg)·e^g`. -/
theorem hasDerivAt_integral_weighted_pair
    {u v g ut vt gt : ℝ → E → ℝ} {K : Set E} (hK : IsCompact K) (t₀ : ℝ)
    (hsu : ∀ t x, x ∉ K → u t x = 0)
    (hut : ∀ t x, HasDerivAt (fun τ => u τ x) (ut t x) t)
    (hvt : ∀ t x, HasDerivAt (fun τ => v τ x) (vt t x) t)
    (hgt : ∀ t x, HasDerivAt (fun τ => g τ x) (gt t x) t)
    (hcu : Continuous ↿u) (hcv : Continuous ↿v) (hcg : Continuous ↿g)
    (hcut : Continuous ↿ut) (hcvt : Continuous ↿vt) (hcgt : Continuous ↿gt) :
    HasDerivAt (fun t => ∫ x, u t x * v t x * exp (g t x))
      (∫ x, (ut t₀ x * v t₀ x + u t₀ x * vt t₀ x
        + u t₀ x * v t₀ x * gt t₀ x) * exp (g t₀ x)) t₀ := by
  classical
  -- time derivative of `ut` vanishes off K (since `u(·,x) ≡ 0` there)
  have hut0 : ∀ t x, x ∉ K → ut t x = 0 := by
    intro t x hx
    have h1 : (fun τ => u τ x) = fun _ => (0:ℝ) := funext fun τ => hsu τ x hx
    have h2 := hut t x
    rw [h1] at h2
    exact h2.unique (hasDerivAt_const _ _)
  -- fixed-time continuity slices
  have hslice : ∀ (w : ℝ → E → ℝ), Continuous ↿w → ∀ t, Continuous (w t) := by
    intro w hw t
    exact hw.comp (Continuous.prodMk continuous_const continuous_id)
  -- the pointwise derivative
  set F' : ℝ → E → ℝ := fun t x => (ut t x * v t x + u t x * vt t x
    + u t x * v t x * gt t x) * exp (g t x) with hF'
  have hdiff : ∀ t x, HasDerivAt (fun τ => u τ x * v τ x * exp (g τ x)) (F' t x) t := by
    intro t x
    have h1 := (hut t x).mul (hvt t x)
    have h2 := (hgt t x).exp
    have h := h1.mul h2
    convert h using 1
    rw [hF']
    simp only [Pi.mul_apply]
    ring
  -- the uniform bound on the slab
  have hF'c : Continuous ↿F' := by
    rw [hF']
    apply Continuous.mul
    · exact ((hcut.mul hcv).add (hcu.mul hcvt)).add ((hcu.mul hcv).mul hcgt)
    · exact Real.continuous_exp.comp hcg
  obtain ⟨M, hM⟩ := (isCompact_Icc.prod hK).exists_bound_of_continuousOn
    (hF'c.continuousOn (s := Set.Icc (t₀ - 1) (t₀ + 1) ×ˢ K))
  set bound : E → ℝ := K.indicator fun _ => M with hbound
  have h := hasDerivAt_integral_of_dominated_loc_of_deriv_le
    (μ := (volume : Measure E)) (x₀ := t₀)
    (F := fun t x => u t x * v t x * exp (g t x)) (F' := F') (bound := bound)
    (s := Set.Icc (t₀ - 1) (t₀ + 1))
    (Icc_mem_nhds (by linarith) (by linarith))
    (Filter.Eventually.of_forall fun t =>
      (((hslice u hcu t).mul (hslice v hcv t)).mul
        (Real.continuous_exp.comp (hslice g hcg t))).aestronglyMeasurable)
    ?hint ?hmeas ?hb ?hbi ?hd
  · exact h.2
  case hint =>
    refine Continuous.integrable_of_hasCompactSupport
      (((hslice u hcu t₀).mul (hslice v hcv t₀)).mul
        (Real.continuous_exp.comp (hslice g hcg t₀))) ?_
    refine HasCompactSupport.intro hK fun x hx => ?_
    show u t₀ x * v t₀ x * exp (g t₀ x) = 0
    rw [hsu t₀ x hx]
    ring
  case hmeas =>
    exact (hslice F' hF'c t₀).aestronglyMeasurable
  case hb =>
    refine Filter.Eventually.of_forall fun x => fun t ht => ?_
    by_cases hx : x ∈ K
    · have hp : (t, x) ∈ Set.Icc (t₀ - 1) (t₀ + 1) ×ˢ K := ⟨ht, hx⟩
      have h2 := hM (t, x) hp
      rw [hbound, Set.indicator_of_mem hx]
      exact h2
    · rw [hbound, Set.indicator_of_notMem hx]
      show ‖(ut t x * v t x + u t x * vt t x + u t x * v t x * gt t x)
          * exp (g t x)‖ ≤ 0
      have h0 : ut t x = 0 := hut0 t x hx
      have h1 : u t x = 0 := hsu t x hx
      rw [h0, h1]
      simp
  case hbi =>
    rw [hbound, integrable_indicator_iff hK.measurableSet]
    exact integrableOn_const hK.measure_lt_top.ne
  case hd =>
    exact Filter.Eventually.of_forall fun x => fun t _ => hdiff t x

/-- **Tao's master differential identity** (1908.04958 §4 Lemma 4.1, first display —
    the `deriv_pair` field of the ladder-1 `CommutatorMethod`, realized):

    `∂t⟨u,v⟩_g = ⟨Lu,v⟩_g + ⟨u,Lv⟩_g − 2⟨Su,v⟩_g`

    with `L = ∂t + Δ`, `S = Δ + ∇g·∇ − F/2`, `F = ∂tg − Δg − ‖∇g‖²`, for test-function
    curves with uniform spatial support in a compact `K` and C² weight. -/
theorem hasDerivAt_weighted_pairing_master
    {u v g ut vt gt : ℝ → E → ℝ} {K : Set E} [CompleteSpace E]
    (hK : IsCompact K) (t₀ : ℝ)
    (hu2 : ∀ t, ContDiff ℝ 2 (u t)) (hv2 : ∀ t, ContDiff ℝ 2 (v t))
    (hg2 : ∀ t, ContDiff ℝ 2 (g t))
    (hsu : ∀ t x, x ∉ K → u t x = 0) (hsv : ∀ t x, x ∉ K → v t x = 0)
    (hut : ∀ t x, HasDerivAt (fun τ => u τ x) (ut t x) t)
    (hvt : ∀ t x, HasDerivAt (fun τ => v τ x) (vt t x) t)
    (hgt : ∀ t x, HasDerivAt (fun τ => g τ x) (gt t x) t)
    (hcu : Continuous ↿u) (hcv : Continuous ↿v) (hcg : Continuous ↿g)
    (hcut : Continuous ↿ut) (hcvt : Continuous ↿vt) (hcgt : Continuous ↿gt) :
    HasDerivAt (fun t => ∫ x, u t x * v t x * exp (g t x))
      (∫ x, ((ut t₀ x + Δ (u t₀) x) * v t₀ x
        + u t₀ x * (vt t₀ x + Δ (v t₀) x)
        - 2 * ((Δ (u t₀) x + ⟪∇ (g t₀) x, ∇ (u t₀) x⟫
            - (gt t₀ x - Δ (g t₀) x - ⟪∇ (g t₀) x, ∇ (g t₀) x⟫) / 2 * u t₀ x)
          * v t₀ x)) * exp (g t₀ x)) t₀ := by
  classical
  have hD := hasDerivAt_integral_weighted_pair hK t₀ hsu hut hvt hgt
    hcu hcv hcg hcut hcvt hcgt
  convert hD using 1
  -- equality of the two integrals via the spatial identities
  have hcuK : HasCompactSupport (u t₀) := HasCompactSupport.intro hK (hsu t₀)
  have hcvK : HasCompactSupport (v t₀) := HasCompactSupport.intro hK (hsv t₀)
  have hu1 : ContDiff ℝ 1 (u t₀) := (hu2 t₀).of_le (by norm_num)
  have hv1 : ContDiff ℝ 1 (v t₀) := (hv2 t₀).of_le (by norm_num)
  have hg1 : ContDiff ℝ 1 (g t₀) := (hg2 t₀).of_le (by norm_num)
  have hgexp : Continuous fun x : E => exp (g t₀ x) :=
    Real.continuous_exp.comp hg1.continuous
  have hslice : ∀ (w : ℝ → E → ℝ), Continuous ↿w → Continuous (w t₀) := by
    intro w hw
    exact hw.comp (Continuous.prodMk continuous_const continuous_id)
  have hIntu : ∀ p : E → ℝ, Continuous p → Function.support p ⊆ tsupport (u t₀) →
      Integrable p (volume : Measure E) := fun p hc hs =>
    hc.integrable_of_hasCompactSupport (hcuK.mono' hs)
  -- the three spatial relations
  have hR1 := integral_green_split (hu2 t₀) hcuK hv1 hg1
  have hR2 := integral_green_split (hv2 t₀) hcvK hu1 hg1
  have hR3 := integral_weight_split hu1 hcuK hv1 (hg2 t₀)
  have hflip : ∫ x, ⟪∇ (v t₀) x, ∇ (u t₀) x⟫ * exp (g t₀ x)
      = ∫ x, ⟪∇ (u t₀) x, ∇ (v t₀) x⟫ * exp (g t₀ x) := by
    refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
    show ⟪∇ (v t₀) x, ∇ (u t₀) x⟫ * exp (g t₀ x)
        = ⟪∇ (u t₀) x, ∇ (v t₀) x⟫ * exp (g t₀ x)
    rw [real_inner_comm]
  -- the time-derivative of `ut` vanishes off K
  have hut0 : ∀ x, x ∉ K → ut t₀ x = 0 := by
    intro x hx
    have h1 : (fun τ => u τ x) = fun _ => (0:ℝ) := funext fun τ => hsu τ x hx
    have h2 := hut t₀ x
    rw [h1] at h2
    exact h2.unique (hasDerivAt_const _ _)
  -- integrability of the atom families (everything supported in K)
  have hsuppK : ∀ p : E → ℝ, (∀ x, x ∉ K → p x = 0) → Continuous p →
      Integrable p (volume : Measure E) := fun p hp hc =>
    hc.integrable_of_hasCompactSupport (HasCompactSupport.intro hK hp)
  have hI1 : Integrable (fun x => (ut t₀ x * v t₀ x + u t₀ x * vt t₀ x
      + u t₀ x * v t₀ x * gt t₀ x) * exp (g t₀ x)) (volume : Measure E) := by
    refine hsuppK _ (fun x hx => ?_)
      (((((hslice ut hcut).mul hv1.continuous).add
        (hu1.continuous.mul (hslice vt hcvt))).add
        ((hu1.continuous.mul hv1.continuous).mul (hslice gt hcgt))).mul hgexp)
    rw [hsu t₀ x hx, hut0 x hx]
    ring
  have hI2 : Integrable (fun x => Δ (v t₀) x * (u t₀ x * exp (g t₀ x)))
      (volume : Measure E) := by
    refine hsuppK _ (fun x hx => ?_)
      ((continuous_laplacian (hv2 t₀)).mul (hu1.continuous.mul hgexp))
    rw [hsu t₀ x hx]
    ring
  have hI3 : Integrable (fun x => Δ (u t₀) x * (v t₀ x * exp (g t₀ x)))
      (volume : Measure E) := by
    refine hsuppK _ (fun x hx => ?_)
      ((continuous_laplacian (hu2 t₀)).mul (hv1.continuous.mul hgexp))
    rw [hsv t₀ x hx]
    ring
  have hI4 : Integrable (fun x => ⟪∇ (g t₀) x, ∇ (u t₀) x⟫
      * (v t₀ x * exp (g t₀ x))) (volume : Measure E) := by
    refine hsuppK _ (fun x hx => ?_)
      (((continuous_gradient hg1).inner (continuous_gradient hu1)).mul
        (hv1.continuous.mul hgexp))
    rw [hsv t₀ x hx]
    ring
  have hI5 : Integrable (fun x => (Δ (g t₀) x + ⟪∇ (g t₀) x, ∇ (g t₀) x⟫)
      * (u t₀ x * v t₀ x) * exp (g t₀ x)) (volume : Measure E) := by
    refine hsuppK _ (fun x hx => ?_)
      ((((continuous_laplacian (hg2 t₀)).add
        ((continuous_gradient hg1).inner (continuous_gradient hg1))).mul
        (hu1.continuous.mul hv1.continuous)).mul hgexp)
    rw [hsu t₀ x hx]
    ring
  have hI4' : Integrable (fun x => 2 * (⟪∇ (g t₀) x, ∇ (u t₀) x⟫
      * (v t₀ x * exp (g t₀ x)))) (volume : Measure E) := hI4.const_mul 2
  have hIRa : Integrable (fun x => Δ (v t₀) x * (u t₀ x * exp (g t₀ x))
      - Δ (u t₀) x * (v t₀ x * exp (g t₀ x))) (volume : Measure E) := hI2.sub hI3
  have hIRb : Integrable (fun x => Δ (v t₀) x * (u t₀ x * exp (g t₀ x))
      - Δ (u t₀) x * (v t₀ x * exp (g t₀ x))
      - 2 * (⟪∇ (g t₀) x, ∇ (u t₀) x⟫ * (v t₀ x * exp (g t₀ x))))
      (volume : Measure E) := hIRa.sub hI4'
  have hIR : Integrable (fun x => Δ (v t₀) x * (u t₀ x * exp (g t₀ x))
      - Δ (u t₀) x * (v t₀ x * exp (g t₀ x))
      - 2 * (⟪∇ (g t₀) x, ∇ (u t₀) x⟫ * (v t₀ x * exp (g t₀ x)))
      - (Δ (g t₀) x + ⟪∇ (g t₀) x, ∇ (g t₀) x⟫) * (u t₀ x * v t₀ x) * exp (g t₀ x))
      (volume : Measure E) := hIRb.sub hI5
  -- the assembly
  calc ∫ x, ((ut t₀ x + Δ (u t₀) x) * v t₀ x
        + u t₀ x * (vt t₀ x + Δ (v t₀) x)
        - 2 * ((Δ (u t₀) x + ⟪∇ (g t₀) x, ∇ (u t₀) x⟫
            - (gt t₀ x - Δ (g t₀) x - ⟪∇ (g t₀) x, ∇ (g t₀) x⟫) / 2 * u t₀ x)
          * v t₀ x)) * exp (g t₀ x)
      = ∫ x, ((ut t₀ x * v t₀ x + u t₀ x * vt t₀ x
            + u t₀ x * v t₀ x * gt t₀ x) * exp (g t₀ x)
          + (Δ (v t₀) x * (u t₀ x * exp (g t₀ x))
            - Δ (u t₀) x * (v t₀ x * exp (g t₀ x))
            - 2 * (⟪∇ (g t₀) x, ∇ (u t₀) x⟫ * (v t₀ x * exp (g t₀ x)))
            - (Δ (g t₀) x + ⟪∇ (g t₀) x, ∇ (g t₀) x⟫)
                * (u t₀ x * v t₀ x) * exp (g t₀ x))) := by
        refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
        show ((ut t₀ x + Δ (u t₀) x) * v t₀ x
            + u t₀ x * (vt t₀ x + Δ (v t₀) x)
            - 2 * ((Δ (u t₀) x + ⟪∇ (g t₀) x, ∇ (u t₀) x⟫
                - (gt t₀ x - Δ (g t₀) x - ⟪∇ (g t₀) x, ∇ (g t₀) x⟫) / 2 * u t₀ x)
              * v t₀ x)) * exp (g t₀ x)
          = (ut t₀ x * v t₀ x + u t₀ x * vt t₀ x
              + u t₀ x * v t₀ x * gt t₀ x) * exp (g t₀ x)
            + (Δ (v t₀) x * (u t₀ x * exp (g t₀ x))
              - Δ (u t₀) x * (v t₀ x * exp (g t₀ x))
              - 2 * (⟪∇ (g t₀) x, ∇ (u t₀) x⟫ * (v t₀ x * exp (g t₀ x)))
              - (Δ (g t₀) x + ⟪∇ (g t₀) x, ∇ (g t₀) x⟫)
                  * (u t₀ x * v t₀ x) * exp (g t₀ x))
        ring
    _ = (∫ x, (ut t₀ x * v t₀ x + u t₀ x * vt t₀ x
          + u t₀ x * v t₀ x * gt t₀ x) * exp (g t₀ x))
        + ∫ x, (Δ (v t₀) x * (u t₀ x * exp (g t₀ x))
          - Δ (u t₀) x * (v t₀ x * exp (g t₀ x))
          - 2 * (⟪∇ (g t₀) x, ∇ (u t₀) x⟫ * (v t₀ x * exp (g t₀ x)))
          - (Δ (g t₀) x + ⟪∇ (g t₀) x, ∇ (g t₀) x⟫)
              * (u t₀ x * v t₀ x) * exp (g t₀ x)) := integral_add hI1 hIR
    _ = ∫ x, (ut t₀ x * v t₀ x + u t₀ x * vt t₀ x
          + u t₀ x * v t₀ x * gt t₀ x) * exp (g t₀ x) := by
        have hRsplit : ∫ x, (Δ (v t₀) x * (u t₀ x * exp (g t₀ x))
            - Δ (u t₀) x * (v t₀ x * exp (g t₀ x))
            - 2 * (⟪∇ (g t₀) x, ∇ (u t₀) x⟫ * (v t₀ x * exp (g t₀ x)))
            - (Δ (g t₀) x + ⟪∇ (g t₀) x, ∇ (g t₀) x⟫)
                * (u t₀ x * v t₀ x) * exp (g t₀ x))
            = (∫ x, Δ (v t₀) x * (u t₀ x * exp (g t₀ x)))
              - (∫ x, Δ (u t₀) x * (v t₀ x * exp (g t₀ x)))
              - 2 * (∫ x, ⟪∇ (g t₀) x, ∇ (u t₀) x⟫ * (v t₀ x * exp (g t₀ x)))
              - ∫ x, (Δ (g t₀) x + ⟪∇ (g t₀) x, ∇ (g t₀) x⟫)
                  * (u t₀ x * v t₀ x) * exp (g t₀ x) := by
          rw [integral_sub hIRb hI5, integral_sub hIRa hI4',
              integral_sub hI2 hI3, integral_const_mul]
        rw [hRsplit]
        have hzero : (∫ x, Δ (v t₀) x * (u t₀ x * exp (g t₀ x)))
            - (∫ x, Δ (u t₀) x * (v t₀ x * exp (g t₀ x)))
            - 2 * (∫ x, ⟪∇ (g t₀) x, ∇ (u t₀) x⟫ * (v t₀ x * exp (g t₀ x)))
            - (∫ x, (Δ (g t₀) x + ⟪∇ (g t₀) x, ∇ (g t₀) x⟫)
                * (u t₀ x * v t₀ x) * exp (g t₀ x)) = 0 := by
          linarith [hR1, hR2, hR3, hflip]
        linarith [hzero]

end TimeLayer


end NSCarleman

#eval "Carleman commutator-method core — machine-verified."
