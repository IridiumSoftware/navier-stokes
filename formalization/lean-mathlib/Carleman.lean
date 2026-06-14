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



/-! #### Ladder-4: the CommutatorMethod instance for the weighted-L² pairing

The ladder-1 abstract chain, the ladder-2/3a weight calculus and the ladder-3b master
identity snap together: on the class of smooth test functions supported in a compact
`K`, the weighted pairing `P_g t u v = ∫ u·v·e^{g t}`, the backwards-heat evolution
`L = ∂t + Δ` and the self-adjoint part `S_g = Δ + ∇g·∇ − F/2` form a
`CommutatorMethod` — with ONE explicitly assumed input: stability of the admissible
curve class under `S` (`mem_S`), whose discharge requires commuting `∂t` with the
spatial operators (the Clairaut/mixed-derivative toll — next rung). Every other field
is proved: `symm`/`nonneg` directly, `selfAdj` from the weighted Green identity,
`deriv_pair` from the master differential identity. -/

section CommutatorInstance

open MeasureTheory Real Laplacian InnerProductSpace WeightedGreenAux
open scoped RealInnerProductSpace Gradient

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
  [FiniteDimensional ℝ E] [MeasurableSpace E] [BorelSpace E]

variable (K : Set E)

/-- The spatial test class: C^∞ functions vanishing off `K`, as a submodule of `E → ℝ`. -/
def smoothTestSubmodule : Submodule ℝ (E → ℝ) where
  carrier := {f | ContDiff ℝ (⊤ : ℕ∞) f ∧ ∀ x ∉ K, f x = 0}
  add_mem' := fun hf hg => ⟨hf.1.add hg.1, fun x hx => by
    show _ + _ = (0:ℝ)
    rw [hf.2 x hx, hg.2 x hx, add_zero]⟩
  zero_mem' := ⟨contDiff_const, fun _ _ => rfl⟩
  smul_mem' := fun c f hf => ⟨hf.1.const_smul c, fun x hx => by
    show c • _ = (0:ℝ)
    rw [hf.2 x hx, smul_zero]⟩

variable {K}

theorem mem_smoothTestSubmodule_iff {f : E → ℝ} :
    f ∈ smoothTestSubmodule K ↔ ContDiff ℝ (⊤ : ℕ∞) f ∧ ∀ x ∉ K, f x = 0 :=
  Iff.rfl

/-- C^∞ functions have C^∞ Laplacian. -/
theorem contDiff_laplacian {f : E → ℝ} (hf : ContDiff ℝ (⊤ : ℕ∞) f) :
    ContDiff ℝ (⊤ : ℕ∞) (Δ f) := by
  rw [laplacian_eq_iteratedFDeriv_orthonormalBasis f (stdOrthonormalBasis ℝ E)]
  refine ContDiff.sum fun i _ => ?_
  have h2 : ContDiff ℝ (⊤ : ℕ∞) (iteratedFDeriv ℝ 2 f) :=
    hf.iteratedFDeriv_right (by norm_cast)
  exact (ContinuousMultilinearMap.apply ℝ _ ℝ _).contDiff.comp h2

/-- C^∞ functions have C^∞ gradient. -/
theorem contDiff_gradient {f : E → ℝ} [CompleteSpace E]
    (hf : ContDiff ℝ (⊤ : ℕ∞) f) :
    ContDiff ℝ (⊤ : ℕ∞) (∇ f) := by
  have h : (∇ f) = fun x => (InnerProductSpace.toDual ℝ E).symm (fderiv ℝ f x) :=
    funext fun x => rfl
  rw [h]
  have h2 : ContDiff ℝ (⊤ : ℕ∞) (fderiv ℝ f) :=
    hf.fderiv_right (by exact_mod_cast le_top)
  exact (InnerProductSpace.toDual ℝ E).symm.toLinearIsometry.contDiff.comp h2

/-- Pointwise gradient additivity. -/
theorem gradient_add {f₁ f₂ : E → ℝ} [CompleteSpace E] {x : E}
    (h₁ : DifferentiableAt ℝ f₁ x) (h₂ : DifferentiableAt ℝ f₂ x) :
    ∇ (f₁ + f₂) x = ∇ f₁ x + ∇ f₂ x := by
  have h : fderiv ℝ (f₁ + f₂) x = fderiv ℝ f₁ x + fderiv ℝ f₂ x :=
    (h₁.hasFDerivAt.add h₂.hasFDerivAt).fderiv
  show (InnerProductSpace.toDual ℝ E).symm (fderiv ℝ (f₁ + f₂) x) = _
  rw [h, map_add]
  rfl

/-- Pointwise gradient homogeneity. -/
theorem gradient_smul {f : E → ℝ} [CompleteSpace E] {x : E} (c : ℝ)
    (h : DifferentiableAt ℝ f x) :
    ∇ (c • f) x = c • ∇ f x := by
  have h2 : fderiv ℝ (c • f) x = c • fderiv ℝ f x :=
    (h.hasFDerivAt.const_smul c).fderiv
  show (InnerProductSpace.toDual ℝ E).symm (fderiv ℝ (c • f) x) = _
  rw [h2, map_smul]
  rfl

variable [CompleteSpace E]

/-- The spatial Carleman operator `S_g(t) = Δ + ∇g(t)·∇ − F(t)/2` (with
    `F = ∂tg − Δg − ‖∇g‖²`), unbundled. -/
noncomputable def Sfun (g gt : ℝ → E → ℝ) (t : ℝ) (f : E → ℝ) : E → ℝ :=
  fun x => Δ f x + ⟪∇ (g t) x, ∇ f x⟫
    - (gt t x - Δ (g t) x - ⟪∇ (g t) x, ∇ (g t) x⟫) / 2 * f x

theorem Sfun_mem (hKc : IsClosed K) {g gt : ℝ → E → ℝ} {t : ℝ}
    (hg : ContDiff ℝ (⊤ : ℕ∞) (g t)) (hgt : ContDiff ℝ (⊤ : ℕ∞) (gt t))
    {f : E → ℝ} (hf : f ∈ smoothTestSubmodule K) :
    Sfun g gt t f ∈ smoothTestSubmodule K := by
  have hts : tsupport f ⊆ K :=
    closure_minimal (fun y hy => by
      by_contra hyn
      exact hy (hf.2 y hyn)) hKc
  refine ⟨?_, fun x hx => ?_⟩
  · refine ContDiff.sub (ContDiff.add (contDiff_laplacian hf.1) ?_) ?_
    · exact (contDiff_gradient hg).inner ℝ (contDiff_gradient hf.1)
    · refine ContDiff.mul (ContDiff.div_const ?_ 2) hf.1
      exact (hgt.sub (contDiff_laplacian hg)).sub
        ((contDiff_gradient hg).inner ℝ (contDiff_gradient hg))
  · have hxts : x ∉ tsupport f := fun hmem => hx (hts hmem)
    have h0 : f x = 0 := image_eq_zero_of_notMem_tsupport hxts
    have hΔ0 : Δ f x = 0 := by
      by_contra hne
      exact hxts (support_laplacian_subset f (Function.mem_support.mpr hne))
    have hg0 : ∇ f x = 0 := by
      by_contra hne
      exact hxts (support_gradient_subset f (Function.mem_support.mpr hne))
    show Δ f x + ⟪∇ (g t) x, ∇ f x⟫
        - (gt t x - Δ (g t) x - ⟪∇ (g t) x, ∇ (g t) x⟫) / 2 * f x = 0
    rw [hΔ0, hg0, inner_zero_right, h0]
    ring

/-- `S_g(t)` as a linear endomorphism of the test class. -/
noncomputable def Sop (hKc : IsClosed K) (g gt : ℝ → E → ℝ)
    (hg : ∀ t, ContDiff ℝ (⊤ : ℕ∞) (g t)) (hgt : ∀ t, ContDiff ℝ (⊤ : ℕ∞) (gt t))
    (t : ℝ) : smoothTestSubmodule K →ₗ[ℝ] smoothTestSubmodule K where
  toFun f := ⟨Sfun g gt t f, Sfun_mem hKc (hg t) (hgt t) f.2⟩
  map_add' f₁ f₂ := by
    ext x
    show Sfun g gt t (↑f₁ + ↑f₂) x = Sfun g gt t ↑f₁ x + Sfun g gt t ↑f₂ x
    unfold Sfun
    have hd₁ : DifferentiableAt ℝ (f₁ : E → ℝ) x :=
      f₁.2.1.differentiable (by norm_num) x
    have hd₂ : DifferentiableAt ℝ (f₂ : E → ℝ) x :=
      f₂.2.1.differentiable (by norm_num) x
    rw [ContDiffAt.laplacian_add (f₁.2.1.contDiffAt.of_le (by norm_cast))
          (f₂.2.1.contDiffAt.of_le (by norm_cast)),
        gradient_add hd₁ hd₂, inner_add_right]
    show _ = _
    rw [Pi.add_apply]
    ring
  map_smul' c f := by
    ext x
    show Sfun g gt t (c • ↑f) x = c • Sfun g gt t ↑f x
    unfold Sfun
    have hd : DifferentiableAt ℝ (f : E → ℝ) x :=
      f.2.1.differentiable (by norm_num) x
    rw [laplacian_smul c (f.2.1.contDiffAt.of_le (by norm_cast)),
        gradient_smul c hd, real_inner_smul_right]
    show _ = _
    rw [Pi.smul_apply]
    simp only [smul_eq_mul]
    ring

/-- The weighted pairing `P_g(t)(u,v) = ∫ u·v·e^{g t}` as a bilinear map on the test
    class (`K` compact for integrability). -/
noncomputable def weightedPairing (hK : IsCompact K) (g : ℝ → E → ℝ)
    (hg : ∀ t, ContDiff ℝ (⊤ : ℕ∞) (g t)) (t : ℝ) :
    smoothTestSubmodule K →ₗ[ℝ] smoothTestSubmodule K →ₗ[ℝ] ℝ := by
  classical
  have hint : ∀ u v : smoothTestSubmodule K,
      Integrable (fun x => (u : E → ℝ) x * (v : E → ℝ) x * exp (g t x))
        (volume : Measure E) := by
    intro u v
    refine Continuous.integrable_of_hasCompactSupport
      ((u.2.1.continuous.mul v.2.1.continuous).mul
        (Real.continuous_exp.comp (hg t).continuous)) ?_
    refine HasCompactSupport.intro hK fun x hx => ?_
    rw [u.2.2 x hx]
    ring
  exact LinearMap.mk₂ ℝ
    (fun u v => ∫ x, (u : E → ℝ) x * (v : E → ℝ) x * exp (g t x))
    (fun u₁ u₂ v => by
      rw [← integral_add (hint u₁ v) (hint u₂ v)]
      refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
      show ((u₁ : E → ℝ) + (u₂ : E → ℝ)) x * (v : E → ℝ) x * exp (g t x)
          = (u₁ : E → ℝ) x * (v : E → ℝ) x * exp (g t x)
            + (u₂ : E → ℝ) x * (v : E → ℝ) x * exp (g t x)
      rw [Pi.add_apply]
      ring)
    (fun c u v => by
      show (∫ x, ((c • u : smoothTestSubmodule K) : E → ℝ) x
            * (v : E → ℝ) x * exp (g t x))
          = c • ∫ x, (u : E → ℝ) x * (v : E → ℝ) x * exp (g t x)
      rw [smul_eq_mul, ← integral_const_mul]
      refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
      show ((c • u : smoothTestSubmodule K) : E → ℝ) x * (v : E → ℝ) x * exp (g t x)
          = c * ((u : E → ℝ) x * (v : E → ℝ) x * exp (g t x))
      rw [Submodule.coe_smul, Pi.smul_apply]
      simp only [smul_eq_mul]
      ring)
    (fun u v₁ v₂ => by
      rw [← integral_add (hint u v₁) (hint u v₂)]
      refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
      show (u : E → ℝ) x * ((v₁ : E → ℝ) + (v₂ : E → ℝ)) x * exp (g t x)
          = (u : E → ℝ) x * (v₁ : E → ℝ) x * exp (g t x)
            + (u : E → ℝ) x * (v₂ : E → ℝ) x * exp (g t x)
      rw [Pi.add_apply]
      ring)
    (fun c u v => by
      show (∫ x, (u : E → ℝ) x
            * ((c • v : smoothTestSubmodule K) : E → ℝ) x * exp (g t x))
          = c • ∫ x, (u : E → ℝ) x * (v : E → ℝ) x * exp (g t x)
      rw [smul_eq_mul, ← integral_const_mul]
      refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
      show (u : E → ℝ) x * ((c • v : smoothTestSubmodule K) : E → ℝ) x * exp (g t x)
          = c * ((u : E → ℝ) x * (v : E → ℝ) x * exp (g t x))
      rw [Submodule.coe_smul, Pi.smul_apply]
      simp only [smul_eq_mul]
      ring)


@[simp]
theorem weightedPairing_apply (hK : IsCompact K) (g : ℝ → E → ℝ)
    (hg : ∀ t, ContDiff ℝ (⊤ : ℕ∞) (g t)) (t : ℝ) (u v : smoothTestSubmodule K) :
    weightedPairing hK g hg t u v
      = ∫ x, (u : E → ℝ) x * (v : E → ℝ) x * exp (g t x) := rfl

theorem Sop_coe (hKc : IsClosed K) (g gt : ℝ → E → ℝ)
    (hg : ∀ t, ContDiff ℝ (⊤ : ℕ∞) (g t)) (hgt : ∀ t, ContDiff ℝ (⊤ : ℕ∞) (gt t))
    (t : ℝ) (f : smoothTestSubmodule K) :
    ((Sop hKc g gt hg hgt t f : smoothTestSubmodule K) : E → ℝ) = Sfun g gt t f := rfl

/-- Admissible curves: valued in the test class, with a spatially smooth
    time-derivative curve and jointly continuous data. -/
def Admissible : Set (ℝ → smoothTestSubmodule K) :=
  {a | ∃ a' : ℝ → E → ℝ,
    (∀ t x, HasDerivAt (fun τ => ((a τ : E → ℝ)) x) (a' t x) t)
    ∧ (∀ t, ContDiff ℝ (⊤ : ℕ∞) (a' t))
    ∧ Continuous (Function.uncurry fun t x => (a t : E → ℝ) x)
    ∧ Continuous ↿a'}

variable (K) in
/-- The backwards-heat evolution `L = ∂t + Δ` on curves (junk `0` off the class). -/
noncomputable def Lop (a : ℝ → smoothTestSubmodule K) (t : ℝ) :
    smoothTestSubmodule K := by
  classical
  exact if h : (fun x => deriv (fun τ => (a τ : E → ℝ) x) t + Δ (a t : E → ℝ) x)
      ∈ smoothTestSubmodule K
    then ⟨_, h⟩ else 0

/-- On admissible curves, `Lop` is genuinely `∂t + Δ`. -/
theorem Lop_coe (hKc : IsClosed K) {a : ℝ → smoothTestSubmodule K}
    {a' : ℝ → E → ℝ}
    (ha'd : ∀ t x, HasDerivAt (fun τ => ((a τ : E → ℝ)) x) (a' t x) t)
    (ha's : ∀ t, ContDiff ℝ (⊤ : ℕ∞) (a' t)) (t : ℝ) :
    ((Lop K a t : smoothTestSubmodule K) : E → ℝ)
      = fun x => a' t x + Δ (a t : E → ℝ) x := by
  classical
  have hts : tsupport ((a t : E → ℝ)) ⊆ K :=
    closure_minimal (fun y hy => by
      by_contra hyn
      exact hy ((a t).2.2 y hyn)) hKc
  have ha'0 : ∀ x, x ∉ K → a' t x = 0 := by
    intro x hx
    have h1 : (fun τ => ((a τ : E → ℝ)) x) = fun _ => (0:ℝ) :=
      funext fun τ => (a τ).2.2 x hx
    have h2 := ha'd t x
    rw [h1] at h2
    exact h2.unique (hasDerivAt_const _ _)
  have hfun : (fun x => deriv (fun τ => (a τ : E → ℝ) x) t + Δ (a t : E → ℝ) x)
      = fun x => a' t x + Δ (a t : E → ℝ) x := by
    funext x
    rw [(ha'd t x).deriv]
  have hmem : (fun x => deriv (fun τ => (a τ : E → ℝ) x) t + Δ (a t : E → ℝ) x)
      ∈ smoothTestSubmodule K := by
    rw [hfun]
    refine ⟨(ha's t).add (contDiff_laplacian (a t).2.1), fun x hx => ?_⟩
    have hΔ0 : Δ (a t : E → ℝ) x = 0 := by
      by_contra hne
      exact hx (hts (support_laplacian_subset _ (Function.mem_support.mpr hne)))
    show a' t x + Δ (a t : E → ℝ) x = 0
    rw [ha'0 x hx, hΔ0, add_zero]
  rw [Lop, dif_pos hmem]
  exact hfun

/-- **The `CommutatorMethod` instance for the weighted-L² pairing** — the ladder-1
    abstraction realized on test-function curves. The one assumed input is `mem_S`
    (stability of the admissible class under `S`): its discharge requires commuting
    `∂t` with the spatial operators — the Clairaut/mixed-derivative toll, next rung.
    Every other field is PROVED: `symm`/`nonneg` directly, `selfAdj` from the weighted
    Green identity (B9), `deriv_pair` from the master differential identity. -/
theorem commutatorMethod_weighted (hK : IsCompact K) {g gt : ℝ → E → ℝ}
    (hg : ∀ t, ContDiff ℝ (⊤ : ℕ∞) (g t)) (hgt : ∀ t, ContDiff ℝ (⊤ : ℕ∞) (gt t))
    (hgw : ∀ t x, HasDerivAt (fun τ => g τ x) (gt t x) t)
    (hcg : Continuous ↿g) (hcgt : Continuous ↿gt)
    {A : Set (ℝ → smoothTestSubmodule K)} (hsub : A ⊆ Admissible)
    (hmemS : ∀ a ∈ A,
      (fun τ => Sop hK.isClosed g gt hg hgt τ (a τ)) ∈ A) :
    CommutatorMethod (weightedPairing hK g hg) (Lop K)
      (Sop hK.isClosed g gt hg hgt) A := by
  classical
  have hsuppK : ∀ p : E → ℝ, (∀ x, x ∉ K → p x = 0) → Continuous p →
      Integrable p (volume : Measure E) := fun p hp hc =>
    hc.integrable_of_hasCompactSupport (HasCompactSupport.intro hK hp)
  have hgexp : ∀ t, Continuous fun x : E => exp (g t x) := fun t =>
    Real.continuous_exp.comp (hg t).continuous
  refine ⟨?_, ?_, ?_, hmemS, ?_⟩
  · -- symm
    intro t u v
    rw [weightedPairing_apply, weightedPairing_apply]
    refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
    show (u : E → ℝ) x * (v : E → ℝ) x * exp (g t x)
        = (v : E → ℝ) x * (u : E → ℝ) x * exp (g t x)
    ring
  · -- selfAdj: split off the F-part and use the weighted Green identity (B9)
    intro t u v
    rw [weightedPairing_apply, weightedPairing_apply]
    have hcu : HasCompactSupport (u : E → ℝ) := HasCompactSupport.intro hK u.2.2
    have hcv : HasCompactSupport (v : E → ℝ) := HasCompactSupport.intro hK v.2.2
    have hu2 : ContDiff ℝ 2 (u : E → ℝ) := u.2.1.of_le (by norm_cast <;> exact le_top)
    have hv2 : ContDiff ℝ 2 (v : E → ℝ) := v.2.1.of_le (by norm_cast <;> exact le_top)
    have hu1 : ContDiff ℝ 1 (u : E → ℝ) := hu2.of_le (by norm_num)
    have hv1 : ContDiff ℝ 1 (v : E → ℝ) := hv2.of_le (by norm_num)
    have hg2 : ContDiff ℝ 2 (g t) := (hg t).of_le (by norm_cast <;> exact le_top)
    have hg1 : ContDiff ℝ 1 (g t) := hg2.of_le (by norm_num)
    have hSg := integral_Sg_symm hu2 hcu hv2 hcv hg1
    have hcF : Continuous fun x =>
        (gt t x - Δ (g t) x - ⟪∇ (g t) x, ∇ (g t) x⟫) / 2 :=
      (((hgt t).continuous.sub (continuous_laplacian hg2)).sub
        ((continuous_gradient hg1).inner (continuous_gradient hg1))).div_const 2
    have hIA : Integrable (fun x => (Δ (u : E → ℝ) x + ⟪∇ (g t) x, ∇ (u : E → ℝ) x⟫)
        * ((v : E → ℝ) x * exp (g t x))) (volume : Measure E) := by
      refine hsuppK _ (fun x hx => ?_)
        (((continuous_laplacian hu2).add
          ((continuous_gradient hg1).inner (continuous_gradient hu1))).mul
          (hv1.continuous.mul (hgexp t)))
      rw [v.2.2 x hx]
      ring
    have hIB : Integrable (fun x => (Δ (v : E → ℝ) x + ⟪∇ (g t) x, ∇ (v : E → ℝ) x⟫)
        * ((u : E → ℝ) x * exp (g t x))) (volume : Measure E) := by
      refine hsuppK _ (fun x hx => ?_)
        (((continuous_laplacian hv2).add
          ((continuous_gradient hg1).inner (continuous_gradient hv1))).mul
          (hu1.continuous.mul (hgexp t)))
      rw [u.2.2 x hx]
      ring
    have hIF : Integrable (fun x => (gt t x - Δ (g t) x - ⟪∇ (g t) x, ∇ (g t) x⟫) / 2
        * ((u : E → ℝ) x * (v : E → ℝ) x * exp (g t x))) (volume : Measure E) := by
      refine hsuppK _ (fun x hx => ?_)
        (hcF.mul ((hu1.continuous.mul hv1.continuous).mul (hgexp t)))
      rw [u.2.2 x hx]
      ring
    calc ∫ x, ((Sop hK.isClosed g gt hg hgt t u : smoothTestSubmodule K) : E → ℝ) x
          * (v : E → ℝ) x * exp (g t x)
        = (∫ x, (Δ (u : E → ℝ) x + ⟪∇ (g t) x, ∇ (u : E → ℝ) x⟫)
            * ((v : E → ℝ) x * exp (g t x)))
          - ∫ x, (gt t x - Δ (g t) x - ⟪∇ (g t) x, ∇ (g t) x⟫) / 2
            * ((u : E → ℝ) x * (v : E → ℝ) x * exp (g t x)) := by
          rw [← integral_sub hIA hIF]
          refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
          show Sfun g gt t (u : E → ℝ) x * (v : E → ℝ) x * exp (g t x) = _
          unfold Sfun
          ring
      _ = (∫ x, (Δ (v : E → ℝ) x + ⟪∇ (g t) x, ∇ (v : E → ℝ) x⟫)
            * ((u : E → ℝ) x * exp (g t x)))
          - ∫ x, (gt t x - Δ (g t) x - ⟪∇ (g t) x, ∇ (g t) x⟫) / 2
            * ((u : E → ℝ) x * (v : E → ℝ) x * exp (g t x)) := by
          rw [hSg]
      _ = ∫ x, (u : E → ℝ) x
          * ((Sop hK.isClosed g gt hg hgt t v : smoothTestSubmodule K) : E → ℝ) x
          * exp (g t x) := by
          rw [← integral_sub hIB hIF]
          refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
          show _ = (u : E → ℝ) x * Sfun g gt t (v : E → ℝ) x * exp (g t x)
          unfold Sfun
          ring
  · -- nonneg
    intro t u
    rw [weightedPairing_apply]
    refine integral_nonneg fun x => ?_
    exact mul_nonneg (mul_self_nonneg _) (Real.exp_pos _).le
  · -- deriv_pair: the master differential identity
    intro a haA b hbA t₀
    obtain ⟨a', ha'd, ha's, hca, hca'⟩ := hsub haA
    obtain ⟨b', hb'd, hb's, hcb, hcb'⟩ := hsub hbA
    have hu2 : ∀ t, ContDiff ℝ 2 ((a t : E → ℝ)) := fun t =>
      (a t).2.1.of_le (by norm_cast <;> exact le_top)
    have hv2 : ∀ t, ContDiff ℝ 2 ((b t : E → ℝ)) := fun t =>
      (b t).2.1.of_le (by norm_cast <;> exact le_top)
    have hg2 : ∀ t, ContDiff ℝ 2 (g t) := fun t =>
      (hg t).of_le (by norm_cast <;> exact le_top)
    have hM := hasDerivAt_weighted_pairing_master (K := K) hK t₀ hu2 hv2 hg2
      (fun t => (a t).2.2) (fun t => (b t).2.2) ha'd hb'd hgw hca hcb hcg hca' hcb' hcgt
    convert hM using 1
    -- value equality: rewrite the three pairings and split the master integrand
    have hu1 : ContDiff ℝ 1 ((a t₀ : E → ℝ)) := (hu2 t₀).of_le (by norm_num)
    have hv1 : ContDiff ℝ 1 ((b t₀ : E → ℝ)) := (hv2 t₀).of_le (by norm_num)
    have hg1 : ContDiff ℝ 1 (g t₀) := (hg2 t₀).of_le (by norm_num)
    have hPL : weightedPairing hK g hg t₀ (Lop K a t₀) (b t₀)
        = ∫ x, (a' t₀ x + Δ ((a t₀ : E → ℝ)) x)
            * ((b t₀ : E → ℝ) x * exp (g t₀ x)) := by
      rw [weightedPairing_apply]
      refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
      rw [Lop_coe hK.isClosed ha'd ha's t₀]
      show (a' t₀ x + Δ ((a t₀ : E → ℝ)) x) * (b t₀ : E → ℝ) x * exp (g t₀ x) = _
      ring
    have hPLb : weightedPairing hK g hg t₀ (a t₀) (Lop K b t₀)
        = ∫ x, (b' t₀ x + Δ ((b t₀ : E → ℝ)) x)
            * ((a t₀ : E → ℝ) x * exp (g t₀ x)) := by
      rw [weightedPairing_apply]
      refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
      rw [Lop_coe hK.isClosed hb'd hb's t₀]
      show (a t₀ : E → ℝ) x * (b' t₀ x + Δ ((b t₀ : E → ℝ)) x) * exp (g t₀ x) = _
      ring
    have hPS : weightedPairing hK g hg t₀
        (Sop hK.isClosed g gt hg hgt t₀ (a t₀)) (b t₀)
        = ∫ x, Sfun g gt t₀ ((a t₀ : E → ℝ)) x
            * ((b t₀ : E → ℝ) x * exp (g t₀ x)) := by
      rw [weightedPairing_apply]
      refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
      show Sfun g gt t₀ ((a t₀ : E → ℝ)) x * (b t₀ : E → ℝ) x * exp (g t₀ x) = _
      ring
    rw [hPL, hPLb, hPS]
    -- integrability of the three atoms
    have ha'0 : ∀ x, x ∉ K → a' t₀ x = 0 := by
      intro x hx
      have h1 : (fun τ => ((a τ : E → ℝ)) x) = fun _ => (0:ℝ) :=
        funext fun τ => (a τ).2.2 x hx
      have h2 := ha'd t₀ x
      rw [h1] at h2
      exact h2.unique (hasDerivAt_const _ _)
    have hT1 : Integrable (fun x => (a' t₀ x + Δ ((a t₀ : E → ℝ)) x)
        * ((b t₀ : E → ℝ) x * exp (g t₀ x))) (volume : Measure E) := by
      refine hsuppK _ (fun x hx => ?_)
        ((((ha's t₀).continuous).add (continuous_laplacian (hu2 t₀))).mul
          (hv1.continuous.mul (hgexp t₀)))
      rw [(b t₀).2.2 x hx]
      ring
    have hT2 : Integrable (fun x => (b' t₀ x + Δ ((b t₀ : E → ℝ)) x)
        * ((a t₀ : E → ℝ) x * exp (g t₀ x))) (volume : Measure E) := by
      refine hsuppK _ (fun x hx => ?_)
        ((((hb's t₀).continuous).add (continuous_laplacian (hv2 t₀))).mul
          (hu1.continuous.mul (hgexp t₀)))
      rw [(a t₀).2.2 x hx]
      ring
    have hT3 : Integrable (fun x => 2 * (Sfun g gt t₀ ((a t₀ : E → ℝ)) x
        * ((b t₀ : E → ℝ) x * exp (g t₀ x)))) (volume : Measure E) := by
      have hSc : Continuous (Sfun g gt t₀ ((a t₀ : E → ℝ))) := by
        unfold Sfun
        refine Continuous.sub (Continuous.add (continuous_laplacian (hu2 t₀)) ?_) ?_
        · exact (continuous_gradient hg1).inner (continuous_gradient hu1)
        · exact ((((hgt t₀).continuous.sub (continuous_laplacian (hg2 t₀))).sub
            ((continuous_gradient hg1).inner (continuous_gradient hg1))).div_const
            2).mul hu1.continuous
      refine hsuppK _ (fun x hx => ?_)
        (continuous_const.mul (hSc.mul (hv1.continuous.mul (hgexp t₀))))
      rw [(b t₀).2.2 x hx]
      ring
    have hT12 : Integrable (fun x => (a' t₀ x + Δ ((a t₀ : E → ℝ)) x)
        * ((b t₀ : E → ℝ) x * exp (g t₀ x))
        + (b' t₀ x + Δ ((b t₀ : E → ℝ)) x)
        * ((a t₀ : E → ℝ) x * exp (g t₀ x))) (volume : Measure E) := hT1.add hT2
    calc (∫ x, (a' t₀ x + Δ ((a t₀ : E → ℝ)) x) * ((b t₀ : E → ℝ) x * exp (g t₀ x)))
          + (∫ x, (b' t₀ x + Δ ((b t₀ : E → ℝ)) x)
            * ((a t₀ : E → ℝ) x * exp (g t₀ x)))
          - 2 * ∫ x, Sfun g gt t₀ ((a t₀ : E → ℝ)) x
            * ((b t₀ : E → ℝ) x * exp (g t₀ x))
        = (∫ x, (a' t₀ x + Δ ((a t₀ : E → ℝ)) x) * ((b t₀ : E → ℝ) x * exp (g t₀ x))
            + (b' t₀ x + Δ ((b t₀ : E → ℝ)) x) * ((a t₀ : E → ℝ) x * exp (g t₀ x)))
          - ∫ x, 2 * (Sfun g gt t₀ ((a t₀ : E → ℝ)) x
            * ((b t₀ : E → ℝ) x * exp (g t₀ x))) := by
          rw [integral_add hT1 hT2, integral_const_mul]
      _ = ∫ x, ((a' t₀ x + Δ ((a t₀ : E → ℝ)) x) * (b t₀ : E → ℝ) x
            + (a t₀ : E → ℝ) x * (b' t₀ x + Δ ((b t₀ : E → ℝ)) x)
            - 2 * ((Δ ((a t₀ : E → ℝ)) x + ⟪∇ (g t₀) x, ∇ ((a t₀ : E → ℝ)) x⟫
                - (gt t₀ x - Δ (g t₀) x - ⟪∇ (g t₀) x, ∇ (g t₀) x⟫) / 2
                  * (a t₀ : E → ℝ) x)
              * (b t₀ : E → ℝ) x)) * exp (g t₀ x) := by
          rw [← integral_sub hT12 hT3]
          refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
          show _ = ((a' t₀ x + Δ ((a t₀ : E → ℝ)) x) * (b t₀ : E → ℝ) x
            + (a t₀ : E → ℝ) x * (b' t₀ x + Δ ((b t₀ : E → ℝ)) x)
            - 2 * ((Δ ((a t₀ : E → ℝ)) x + ⟪∇ (g t₀) x, ∇ ((a t₀ : E → ℝ)) x⟫
                - (gt t₀ x - Δ (g t₀) x - ⟪∇ (g t₀) x, ∇ (g t₀) x⟫) / 2
                  * (a t₀ : E → ℝ) x)
              * (b t₀ : E → ℝ) x)) * exp (g t₀ x)
          unfold Sfun
          ring

end CommutatorInstance




/-! #### Ladder-5a: slice calculus — the Clairaut keystone for `mem_S`

For jointly C² functions `U : ℝ × E → ℝ`, the time derivative commutes with the
spatial (slice) Fréchet derivative: `∂t ∂ₓ U = ∂ₓ ∂t U`. This is the pairwise-swap
engine: the slice-Laplacian version (`∂t Δₓ = Δₓ ∂t`, two pairwise swaps) and the
discharge of the ladder-4 `mem_S` hypothesis iterate exactly this pattern — next
rung. Rests on `ContDiffAt.isSymmSndFDerivAt` (Schwarz/Clairaut). -/

section SliceCalculus

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]

/-- The spatial slice of a jointly differentiable function is differentiable, with
    derivative the joint derivative composed with the vertical injection. -/
theorem hasFDerivAt_slice {U : ℝ × E → ℝ} {p : ℝ × E}
    (hU : DifferentiableAt ℝ U p) :
    HasFDerivAt (fun y => U (p.1, y))
      ((fderiv ℝ U p).comp
        ((0 : E →L[ℝ] ℝ).prod (ContinuousLinearMap.id ℝ E))) p.2 := by
  have hemb : HasFDerivAt (fun y : E => ((p.1, y) : ℝ × E))
      ((0 : E →L[ℝ] ℝ).prod (ContinuousLinearMap.id ℝ E)) p.2 :=
    (hasFDerivAt_const p.1 p.2).prodMk (hasFDerivAt_id p.2)
  exact hU.hasFDerivAt.comp p.2 hemb

/-- Slice directional derivatives are joint directional derivatives in vertical
    directions. -/
theorem fderiv_slice_apply {U : ℝ × E → ℝ} {p : ℝ × E}
    (hU : DifferentiableAt ℝ U p) (v : E) :
    fderiv ℝ (fun y => U (p.1, y)) p.2 v = fderiv ℝ U p (0, v) := by
  rw [(hasFDerivAt_slice hU).fderiv]
  rfl

/-- The time-curve derivative of a jointly differentiable function is the joint
    derivative in the horizontal direction. -/
theorem hasDerivAt_curve {U : ℝ × E → ℝ} {t₀ : ℝ} {x : E}
    (hU : DifferentiableAt ℝ U (t₀, x)) :
    HasDerivAt (fun t => U (t, x)) (fderiv ℝ U (t₀, x) (1, 0)) t₀ := by
  have hc : HasDerivAt (fun t : ℝ => ((t, x) : ℝ × E)) ((1 : ℝ), (0 : E)) t₀ :=
    (hasDerivAt_id t₀).prodMk (hasDerivAt_const t₀ x)
  exact hU.hasFDerivAt.comp_hasDerivAt t₀ hc

/-- **First-order Clairaut for slices** (the `mem_S` keystone): for jointly C² `U`,
    `∂t (∂ₓU·v) = ∂ₓ(∂tU)·v` — the time derivative of the spatial directional
    derivative is the spatial directional derivative of the time derivative. -/
theorem hasDerivAt_fderiv_slice {U : ℝ × E → ℝ} (hU : ContDiff ℝ 2 U)
    (t₀ : ℝ) (x : E) (v : E) :
    HasDerivAt (fun t => fderiv ℝ (fun y => U (t, y)) x v)
      (fderiv ℝ (fun y => fderiv ℝ U (t₀, y) (1, 0)) x v) t₀ := by
  have hUd : ∀ p : ℝ × E, DifferentiableAt ℝ U p := fun p =>
    hU.differentiable (by norm_num) p
  have hfd : ContDiff ℝ 1 (fderiv ℝ U) := hU.fderiv_right (by norm_num)
  have hfdd : DifferentiableAt ℝ (fderiv ℝ U) (t₀, x) :=
    hfd.differentiable one_ne_zero (t₀, x)
  -- the LHS function through the slice conversion
  have hfun : (fun t => fderiv ℝ (fun y => U (t, y)) x v)
      = fun t => fderiv ℝ U (t, x) ((0 : ℝ), v) := by
    funext t
    exact fderiv_slice_apply (p := (t, x)) (hUd (t, x)) v
  rw [hfun]
  -- t-derivative of `t ↦ DU(t,x)(0,v)` via the chain rule
  have hF : HasFDerivAt (fun p : ℝ × E => fderiv ℝ U p ((0 : ℝ), v))
      ((ContinuousLinearMap.apply ℝ ℝ ((0 : ℝ), v)).comp
        (fderiv ℝ (fderiv ℝ U) (t₀, x))) (t₀, x) :=
    (ContinuousLinearMap.apply ℝ ℝ ((0 : ℝ), v)).hasFDerivAt.comp _ hfdd.hasFDerivAt
  have hcomp : HasDerivAt (fun t => fderiv ℝ U (t, x) ((0 : ℝ), v))
      (fderiv ℝ (fderiv ℝ U) (t₀, x) ((1 : ℝ), (0 : E)) ((0 : ℝ), v)) t₀ := by
    have hc : HasDerivAt (fun t : ℝ => ((t, x) : ℝ × E)) ((1 : ℝ), (0 : E)) t₀ :=
      (hasDerivAt_id t₀).prodMk (hasDerivAt_const t₀ x)
    have h := hF.comp_hasDerivAt t₀ hc
    simpa using h
  -- the Schwarz/Clairaut swap
  have hsymm : IsSymmSndFDerivAt ℝ U (t₀, x) :=
    hU.contDiffAt.isSymmSndFDerivAt (by simp)
  -- the RHS through the slice conversion for `∂tU`
  have hUt : DifferentiableAt ℝ (fun p : ℝ × E => fderiv ℝ U p ((1 : ℝ), (0 : E)))
      (t₀, x) :=
    ((ContinuousLinearMap.apply ℝ ℝ ((1 : ℝ), (0 : E))).differentiable.comp
      (hfd.differentiable one_ne_zero)) (t₀, x)
  have hF2 : HasFDerivAt (fun p : ℝ × E => fderiv ℝ U p ((1 : ℝ), (0 : E)))
      ((ContinuousLinearMap.apply ℝ ℝ ((1 : ℝ), (0 : E))).comp
        (fderiv ℝ (fderiv ℝ U) (t₀, x))) (t₀, x) :=
    (ContinuousLinearMap.apply ℝ ℝ ((1 : ℝ), (0 : E))).hasFDerivAt.comp _ hfdd.hasFDerivAt
  have hRHS : fderiv ℝ (fun y => fderiv ℝ U (t₀, y) ((1 : ℝ), (0 : E))) x v
      = fderiv ℝ (fderiv ℝ U) (t₀, x) ((0 : ℝ), v) ((1 : ℝ), (0 : E)) := by
    have h1 := fderiv_slice_apply
      (U := fun p : ℝ × E => fderiv ℝ U p ((1 : ℝ), (0 : E))) (p := (t₀, x)) hUt v
    rw [h1, hF2.fderiv]
    rfl
  rw [hRHS, ← hsymm ((1 : ℝ), (0 : E)) ((0 : ℝ), v)]
  exact hcomp

section LaplacianSwap

open Laplacian InnerProductSpace

variable [FiniteDimensional ℝ E]

/-- Second-order slice conversion: slice second directional derivatives are joint
    second derivatives in vertical directions. -/
theorem fderiv_fderiv_slice_apply {U : ℝ × E → ℝ} (hU : ContDiff ℝ 2 U)
    (t : ℝ) (x : E) (v w : E) :
    fderiv ℝ (fun y => fderiv ℝ (fun z => U (t, z)) y v) x w
      = fderiv ℝ (fderiv ℝ U) (t, x) ((0 : ℝ), w) ((0 : ℝ), v) := by
  have hUd : ∀ p : ℝ × E, DifferentiableAt ℝ U p := fun p =>
    hU.differentiable (by norm_num) p
  have hfd : ContDiff ℝ 1 (fderiv ℝ U) := hU.fderiv_right (by norm_num)
  have hfun : (fun y => fderiv ℝ (fun z => U (t, z)) y v)
      = fun y => fderiv ℝ U (t, y) ((0 : ℝ), v) := by
    funext y
    exact fderiv_slice_apply (p := (t, y)) (hUd (t, y)) v
  rw [hfun]
  have hVd : DifferentiableAt ℝ (fun p : ℝ × E => fderiv ℝ U p ((0 : ℝ), v)) (t, x) :=
    ((ContinuousLinearMap.apply ℝ ℝ ((0 : ℝ), v)).differentiable.comp
      (hfd.differentiable one_ne_zero)) (t, x)
  rw [fderiv_slice_apply (U := fun p : ℝ × E => fderiv ℝ U p ((0 : ℝ), v))
    (p := (t, x)) hVd w]
  have hF : HasFDerivAt (fun p : ℝ × E => fderiv ℝ U p ((0 : ℝ), v))
      ((ContinuousLinearMap.apply ℝ ℝ ((0 : ℝ), v)).comp
        (fderiv ℝ (fderiv ℝ U) (t, x))) (t, x) :=
    (ContinuousLinearMap.apply ℝ ℝ ((0 : ℝ), v)).hasFDerivAt.comp _
      ((hfd.differentiable one_ne_zero) (t, x)).hasFDerivAt
  rw [hF.fderiv]
  rfl

/-- The slice Laplacian in joint coordinates. -/
theorem laplacian_slice_eq {U : ℝ × E → ℝ} (hU : ContDiff ℝ 2 U) (t : ℝ) (x : E) :
    Δ (fun y => U (t, y)) x
      = ∑ i, fderiv ℝ (fderiv ℝ U) (t, x)
          ((0 : ℝ), stdOrthonormalBasis ℝ E i)
          ((0 : ℝ), stdOrthonormalBasis ℝ E i) := by
  have hsl2 : ContDiff ℝ 2 fun z : E => U (t, z) :=
    hU.comp ((contDiff_const (c := t)).prodMk contDiff_id)
  have hsfd : ContDiff ℝ 1 (fderiv ℝ fun z : E => U (t, z)) :=
    hsl2.fderiv_right (by norm_num)
  rw [congrFun (laplacian_eq_iteratedFDeriv_orthonormalBasis _
    (stdOrthonormalBasis ℝ E)) x]
  refine Finset.sum_congr rfl fun i _ => ?_
  rw [iteratedFDeriv_two_apply]
  simp only [Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons]
  have happ : fderiv ℝ (fun y => fderiv ℝ (fun z : E => U (t, z)) y
      (stdOrthonormalBasis ℝ E i)) x (stdOrthonormalBasis ℝ E i)
      = fderiv ℝ (fderiv ℝ fun z : E => U (t, z)) x
          (stdOrthonormalBasis ℝ E i) (stdOrthonormalBasis ℝ E i) := by
    have h : HasFDerivAt (fun y => fderiv ℝ (fun z : E => U (t, z)) y
        (stdOrthonormalBasis ℝ E i))
        ((ContinuousLinearMap.apply ℝ ℝ (stdOrthonormalBasis ℝ E i)).comp
          (fderiv ℝ (fderiv ℝ fun z : E => U (t, z)) x)) x :=
      (ContinuousLinearMap.apply ℝ ℝ (stdOrthonormalBasis ℝ E i)).hasFDerivAt.comp x
        ((hsfd.differentiable one_ne_zero) x).hasFDerivAt
    rw [h.fderiv]
    rfl
  rw [← happ]
  exact fderiv_fderiv_slice_apply hU t x _ _

/-- (α) The time derivative of a second-derivative coefficient, through the
    multilinear (instance-safe) route. -/
theorem hasDerivAt_iFD2_curve {U : ℝ × E → ℝ} (hU : ContDiff ℝ 3 U)
    (t₀ : ℝ) (x : E) (m : Fin 2 → ℝ × E) :
    HasDerivAt (fun t => iteratedFDeriv ℝ 2 U (t, x) m)
      (fderiv ℝ (iteratedFDeriv ℝ 2 U) (t₀, x) ((1 : ℝ), (0 : E)) m) t₀ := by
  have hifd : ContDiff ℝ 1 (iteratedFDeriv ℝ 2 U) :=
    hU.iteratedFDeriv_right (by norm_num)
  have hap := (ContinuousMultilinearMap.apply ℝ (fun _ : Fin 2 => ℝ × E) ℝ m).hasFDerivAt
    (x := iteratedFDeriv ℝ 2 U (t₀, x))
  have hF : HasFDerivAt (fun p : ℝ × E => iteratedFDeriv ℝ 2 U p m)
      ((ContinuousMultilinearMap.apply ℝ (fun _ : Fin 2 => ℝ × E) ℝ m).comp
        (fderiv ℝ (iteratedFDeriv ℝ 2 U) (t₀, x))) (t₀, x) := by
    exact hap.comp (t₀, x) ((hifd.differentiable one_ne_zero) (t₀, x)).hasFDerivAt
  have h := hF.comp_hasDerivAt t₀ ((hasDerivAt_id t₀).prodMk (hasDerivAt_const t₀ x))
  simpa using h

/-- (δ) Left-peeling bridge: third derivatives via the derivative of `iFD2`. -/
theorem iFD3_eq_left {U : ℝ × E → ℝ} (q : ℝ × E) (a b c : ℝ × E) :
    iteratedFDeriv ℝ 3 U q ![a, b, c]
      = fderiv ℝ (iteratedFDeriv ℝ 2 U) q a ![b, c] := by
  rw [iteratedFDeriv_succ_apply_left]
  congr 1

/-- (δ′) Directional-application bridge: `iFD2` of `p ↦ DU(p)·d` is `iFD3` with `d`
    in the last slot. -/
theorem iFD2_apply_dir {U : ℝ × E → ℝ} (hU : ContDiff ℝ 3 U)
    (q : ℝ × E) (d a b : ℝ × E) :
    iteratedFDeriv ℝ 2 (fun p : ℝ × E => fderiv ℝ U p d) q ![a, b]
      = iteratedFDeriv ℝ 3 U q ![a, b, d] := by
  have hfd : ContDiff ℝ 2 (fderiv ℝ U) := hU.fderiv_right (by norm_num)
  have hcomp := (ContinuousLinearMap.apply ℝ ℝ d).iteratedFDeriv_comp_left
    (f := fderiv ℝ U) (hfd.contDiffAt (x := q)) (i := 2) le_rfl
  have h1 : iteratedFDeriv ℝ 2 (fun p : ℝ × E => fderiv ℝ U p d) q ![a, b]
      = iteratedFDeriv ℝ 2 (fderiv ℝ U) q ![a, b] d := by
    have h2 := congrFun (congrArg DFunLike.coe hcomp) ![a, b]
    simpa using h2
  have hinit : Fin.init ![a, b, d] = ![a, b] := by
    funext i
    fin_cases i <;> simp [Fin.init]
  rw [h1]
  conv_rhs => rw [iteratedFDeriv_succ_apply_right]
  rw [hinit]
  rfl

/-- (β′) First-pair swap of the third derivative (scalar Schwarz on `p ↦ DU(p)·c`). -/
theorem iFD3_swap12 {U : ℝ × E → ℝ} (hU : ContDiff ℝ 3 U)
    (q : ℝ × E) (a b c : ℝ × E) :
    iteratedFDeriv ℝ 3 U q ![a, b, c] = iteratedFDeriv ℝ 3 U q ![b, a, c] := by
  have hfd : ContDiff ℝ 2 (fderiv ℝ U) := hU.fderiv_right (by norm_num)
  have hV : ContDiff ℝ 2 fun p : ℝ × E => fderiv ℝ U p c :=
    (ContinuousLinearMap.apply ℝ ℝ c).contDiff.comp hfd
  have hsymm : IsSymmSndFDerivAt ℝ (fun p : ℝ × E => fderiv ℝ U p c) q :=
    hV.contDiffAt.isSymmSndFDerivAt (by simp)
  rw [← iFD2_apply_dir hU q c a b, ← iFD2_apply_dir hU q c b a]
  exact IsSymmSndFDerivAt.iteratedFDeriv_cons (hf := hsymm)

/-- (γ′) Last-pair swap of the third derivative (differentiated pointwise Schwarz). -/
theorem iFD3_swap23 {U : ℝ × E → ℝ} (hU : ContDiff ℝ 3 U)
    (q : ℝ × E) (a b c : ℝ × E) :
    iteratedFDeriv ℝ 3 U q ![a, b, c] = iteratedFDeriv ℝ 3 U q ![a, c, b] := by
  have hU2 : ContDiff ℝ 2 U := hU.of_le (by norm_num)
  have hifd : ContDiff ℝ 1 (iteratedFDeriv ℝ 2 U) :=
    hU.iteratedFDeriv_right (by norm_num)
  have hφ : ∀ b c : ℝ × E,
      fderiv ℝ (fun p : ℝ × E => iteratedFDeriv ℝ 2 U p ![b, c]) q a
      = fderiv ℝ (iteratedFDeriv ℝ 2 U) q a ![b, c] := by
    intro b c
    have hap := (ContinuousMultilinearMap.apply ℝ (fun _ : Fin 2 => ℝ × E) ℝ ![b, c]).hasFDerivAt
      (x := iteratedFDeriv ℝ 2 U q)
    have hF : HasFDerivAt (fun p : ℝ × E => iteratedFDeriv ℝ 2 U p ![b, c])
        ((ContinuousMultilinearMap.apply ℝ (fun _ : Fin 2 => ℝ × E) ℝ ![b, c]).comp
          (fderiv ℝ (iteratedFDeriv ℝ 2 U) q)) q := by
      exact hap.comp q ((hifd.differentiable one_ne_zero) q).hasFDerivAt
    rw [hF.fderiv]
    rfl
  have hpoint : (fun p : ℝ × E => iteratedFDeriv ℝ 2 U p ![b, c])
      = fun p : ℝ × E => iteratedFDeriv ℝ 2 U p ![c, b] := by
    funext p
    exact IsSymmSndFDerivAt.iteratedFDeriv_cons
      (hf := hU2.contDiffAt.isSymmSndFDerivAt (by simp))
  rw [iFD3_eq_left, iFD3_eq_left, ← hφ b c, hpoint, hφ c b]

/-- **(ε) The slice-Laplacian Clairaut swap** (the second `mem_S` keystone): for
    jointly C³ `U`, `∂t(Δₓ U) = Δₓ(∂t U)`. -/
theorem hasDerivAt_laplacian_slice {U : ℝ × E → ℝ} (hU : ContDiff ℝ 3 U)
    (t₀ : ℝ) (x : E) :
    HasDerivAt (fun t => Δ (fun y => U (t, y)) x)
      (Δ (fun y => fderiv ℝ U (t₀, y) ((1 : ℝ), (0 : E))) x) t₀ := by
  have hU2 : ContDiff ℝ 2 U := hU.of_le (by norm_num)
  have hUt2 : ContDiff ℝ 2 fun p : ℝ × E => fderiv ℝ U p ((1 : ℝ), (0 : E)) :=
    (ContinuousLinearMap.apply ℝ ℝ _).contDiff.comp (hU.fderiv_right (by norm_num))
  -- both sides in iFD2 coordinates
  have hfun : (fun t => Δ (fun y => U (t, y)) x)
      = fun t => ∑ i, iteratedFDeriv ℝ 2 U (t, x)
          ![((0 : ℝ), stdOrthonormalBasis ℝ E i), ((0 : ℝ), stdOrthonormalBasis ℝ E i)] := by
    funext t
    rw [laplacian_slice_eq hU2 t x]
    refine Finset.sum_congr rfl fun i _ => ?_
    rw [iteratedFDeriv_two_apply]
    rfl
  have hRHS : Δ (fun y => fderiv ℝ U (t₀, y) ((1 : ℝ), (0 : E))) x
      = ∑ i, iteratedFDeriv ℝ 3 U (t₀, x)
          ![((0 : ℝ), stdOrthonormalBasis ℝ E i), ((0 : ℝ), stdOrthonormalBasis ℝ E i),
            ((1 : ℝ), (0 : E))] := by
    rw [laplacian_slice_eq hUt2 t₀ x]
    refine Finset.sum_congr rfl fun i _ => ?_
    rw [← iFD2_apply_dir hU (t₀, x) ((1 : ℝ), (0 : E)) _ _, iteratedFDeriv_two_apply]
    rfl
  rw [hfun, hRHS]
  have h := HasDerivAt.fun_sum (u := Finset.univ) (x := t₀)
    (A := fun i t => iteratedFDeriv ℝ 2 U (t, x)
      ![((0 : ℝ), stdOrthonormalBasis ℝ E i), ((0 : ℝ), stdOrthonormalBasis ℝ E i)])
    (A' := fun i => fderiv ℝ (iteratedFDeriv ℝ 2 U) (t₀, x) ((1 : ℝ), (0 : E))
      ![((0 : ℝ), stdOrthonormalBasis ℝ E i), ((0 : ℝ), stdOrthonormalBasis ℝ E i)])
    (fun i _ => hasDerivAt_iFD2_curve hU t₀ x _)
  convert h using 1
  refine Finset.sum_congr rfl fun i _ => ?_
  show iteratedFDeriv ℝ 3 U (t₀, x)
      ![((0 : ℝ), stdOrthonormalBasis ℝ E i), ((0 : ℝ), stdOrthonormalBasis ℝ E i),
        ((1 : ℝ), (0 : E))]
    = fderiv ℝ (iteratedFDeriv ℝ 2 U) (t₀, x) ((1 : ℝ), (0 : E))
        ![((0 : ℝ), stdOrthonormalBasis ℝ E i), ((0 : ℝ), stdOrthonormalBasis ℝ E i)]
  rw [← iFD3_eq_left,
    iFD3_swap12 hU (t₀, x) ((1 : ℝ), (0 : E)) ((0 : ℝ), stdOrthonormalBasis ℝ E i)
      ((0 : ℝ), stdOrthonormalBasis ℝ E i),
    iFD3_swap23 hU (t₀, x) ((0 : ℝ), stdOrthonormalBasis ℝ E i) ((1 : ℝ), (0 : E))
      ((0 : ℝ), stdOrthonormalBasis ℝ E i)]

end LaplacianSwap


end SliceCalculus

/-! ### Ladder-5c: the jointly smooth admissible class and the UNCONDITIONAL instance

`AdmissibleJoint` asks for ONE thing: the uncurried curve `(t,x) ↦ a(t)(x)` is jointly C^∞
(spatial support is already carried by the codomain). Every witness of `Admissible` then
*derives* (`admissibleJoint_subset`), and — via the two Clairaut keystones (5a/5b) — the class
is stable under `S_g(t)`: `admissibleJoint_mem_S` exhibits the S-curve's uncurried function as
a manifestly-smooth expression in joint `iteratedFDeriv`/`fderiv` coordinates. Together these
discharge `mem_S`, the one assumed hypothesis of ladder-4: `commutatorMethod_weighted_joint`
is the unconditional `CommutatorMethod` instance. -/

section JointAdmissible

open MeasureTheory Real Laplacian InnerProductSpace WeightedGreenAux
open scoped RealInnerProductSpace Gradient

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
  [FiniteDimensional ℝ E] [MeasurableSpace E] [BorelSpace E] [CompleteSpace E]
  {K : Set E}

/-- `laplacian_slice_eq` in joint `iteratedFDeriv` coordinates. -/
theorem laplacian_slice_eq_iFD2 {U : ℝ × E → ℝ} (hU : ContDiff ℝ 2 U) (t : ℝ) (x : E) :
    Δ (fun y => U (t, y)) x
      = ∑ i, iteratedFDeriv ℝ 2 U (t, x)
          ![((0 : ℝ), stdOrthonormalBasis ℝ E i),
            ((0 : ℝ), stdOrthonormalBasis ℝ E i)] := by
  rw [laplacian_slice_eq hU t x]
  refine Finset.sum_congr rfl fun i _ => ?_
  rw [iteratedFDeriv_two_apply]
  rfl

/-- Parseval for slice gradients, in joint coordinates: the inner product of two spatial
    slice gradients is the basis sum of products of vertical joint derivatives. -/
theorem inner_gradients_slice {F H : ℝ × E → ℝ} {p : ℝ × E}
    (hF : DifferentiableAt ℝ F p) (hH : DifferentiableAt ℝ H p) :
    ⟪∇ (fun x => F (p.1, x)) p.2, ∇ (fun x => H (p.1, x)) p.2⟫
      = ∑ i, fderiv ℝ F p ((0 : ℝ), stdOrthonormalBasis ℝ E i)
          * fderiv ℝ H p ((0 : ℝ), stdOrthonormalBasis ℝ E i) := by
  set b := stdOrthonormalBasis ℝ E with hb
  have hFs : DifferentiableAt ℝ (fun x => F (p.1, x)) p.2 :=
    (hasFDerivAt_slice hF).differentiableAt
  have hHs : DifferentiableAt ℝ (fun x => H (p.1, x)) p.2 :=
    (hasFDerivAt_slice hH).differentiableAt
  rw [← OrthonormalBasis.sum_inner_mul_inner b (∇ (fun x => F (p.1, x)) p.2)
      (∇ (fun x => H (p.1, x)) p.2)]
  refine Finset.sum_congr rfl fun i _ => ?_
  rw [← fderiv_slice_apply hF (b i), ← fderiv_slice_apply hH (b i),
      ← inner_gradient_left hFs, ← inner_gradient_left hHs,
      real_inner_comm (∇ (fun x => H (p.1, x)) p.2) (b i)]

/-- Jointly smooth admissible curves: the single requirement is joint smoothness of the
    uncurried function. Spatial support comes with the codomain. -/
def AdmissibleJoint : Set (ℝ → smoothTestSubmodule K) :=
  {a | ContDiff ℝ (⊤ : ℕ∞) fun p : ℝ × E => (a p.1 : E → ℝ) p.2}

/-- Every witness of `Admissible` derives from joint smoothness: the time-derivative
    curve is the horizontal joint derivative, smooth and continuous by inheritance. -/
theorem admissibleJoint_subset :
    (AdmissibleJoint : Set (ℝ → smoothTestSubmodule K)) ⊆ Admissible := by
  intro a ha
  have hU : ContDiff ℝ (⊤ : ℕ∞) fun p : ℝ × E => (a p.1 : E → ℝ) p.2 := ha
  have hfU : ContDiff ℝ (⊤ : ℕ∞) (fderiv ℝ fun p : ℝ × E => (a p.1 : E → ℝ) p.2) :=
    hU.fderiv_right (by exact_mod_cast le_top)
  refine ⟨fun t x => fderiv ℝ (fun p : ℝ × E => (a p.1 : E → ℝ) p.2) (t, x)
      ((1 : ℝ), (0 : E)), fun t x => ?_, fun t => ?_, ?_, ?_⟩
  · exact hasDerivAt_curve (hU.differentiable (by norm_num) (t, x))
  · exact (ContinuousLinearMap.apply ℝ ℝ ((1 : ℝ), (0 : E))).contDiff.comp
      (hfU.comp ((contDiff_const (c := t)).prodMk contDiff_id))
  · exact hU.continuous
  · exact (ContinuousLinearMap.apply ℝ ℝ ((1 : ℝ), (0 : E))).continuous.comp
      hfU.continuous

/-- **Stability of the jointly smooth class under `S_g(t)`** — the `mem_S` discharge.
    The S-curve's uncurried function is rewritten, via the slice calculus, into joint
    `iteratedFDeriv`/`fderiv` coordinates, where smoothness is inherited termwise. -/
theorem admissibleJoint_mem_S (hKc : IsClosed K) {G : ℝ × E → ℝ}
    (hG : ContDiff ℝ (⊤ : ℕ∞) G)
    (hg : ∀ t, ContDiff ℝ (⊤ : ℕ∞) fun x => G (t, x))
    (hgt : ∀ t, ContDiff ℝ (⊤ : ℕ∞) fun x => fderiv ℝ G (t, x) ((1 : ℝ), (0 : E)))
    {a : ℝ → smoothTestSubmodule K} (ha : a ∈ AdmissibleJoint) :
    (fun τ => Sop hKc (fun t x => G (t, x))
      (fun t x => fderiv ℝ G (t, x) ((1 : ℝ), (0 : E))) hg hgt τ (a τ))
      ∈ AdmissibleJoint := by
  have hU : ContDiff ℝ (⊤ : ℕ∞) fun p : ℝ × E => (a p.1 : E → ℝ) p.2 := ha
  have hU2 : ContDiff ℝ 2 fun p : ℝ × E => (a p.1 : E → ℝ) p.2 :=
    hU.of_le (by norm_cast <;> exact le_top)
  have hG2 : ContDiff ℝ 2 G := hG.of_le (by norm_cast <;> exact le_top)
  have hUd : Differentiable ℝ fun p : ℝ × E => (a p.1 : E → ℝ) p.2 :=
    hU.differentiable (by norm_num)
  have hGd : Differentiable ℝ G := hG.differentiable (by norm_num)
  set b := stdOrthonormalBasis ℝ E with hb
  show ContDiff ℝ (⊤ : ℕ∞) fun p : ℝ × E =>
    Sfun (fun t x => G (t, x)) (fun t x => fderiv ℝ G (t, x) ((1 : ℝ), (0 : E)))
      p.1 ((a p.1 : E → ℝ)) p.2
  have key : (fun p : ℝ × E =>
      Sfun (fun t x => G (t, x)) (fun t x => fderiv ℝ G (t, x) ((1 : ℝ), (0 : E)))
        p.1 ((a p.1 : E → ℝ)) p.2)
      = fun p : ℝ × E =>
        (∑ i, iteratedFDeriv ℝ 2 (fun q : ℝ × E => (a q.1 : E → ℝ) q.2) p
            ![((0 : ℝ), b i), ((0 : ℝ), b i)])
        + (∑ i, fderiv ℝ G p ((0 : ℝ), b i)
            * fderiv ℝ (fun q : ℝ × E => (a q.1 : E → ℝ) q.2) p ((0 : ℝ), b i))
        - (fderiv ℝ G p ((1 : ℝ), (0 : E))
            - (∑ i, iteratedFDeriv ℝ 2 G p ![((0 : ℝ), b i), ((0 : ℝ), b i)])
            - (∑ i, fderiv ℝ G p ((0 : ℝ), b i) * fderiv ℝ G p ((0 : ℝ), b i))) / 2
          * (a p.1 : E → ℝ) p.2 := by
    funext p
    show Δ ((a p.1 : E → ℝ)) p.2
        + ⟪∇ (fun x => G (p.1, x)) p.2, ∇ ((a p.1 : E → ℝ)) p.2⟫
        - (fderiv ℝ G (p.1, p.2) ((1 : ℝ), (0 : E)) - Δ (fun x => G (p.1, x)) p.2
            - ⟪∇ (fun x => G (p.1, x)) p.2, ∇ (fun x => G (p.1, x)) p.2⟫) / 2
          * (a p.1 : E → ℝ) p.2 = _
    have e1 : Δ ((a p.1 : E → ℝ)) p.2
        = ∑ i, iteratedFDeriv ℝ 2 (fun q : ℝ × E => (a q.1 : E → ℝ) q.2) p
            ![((0 : ℝ), b i), ((0 : ℝ), b i)] :=
      laplacian_slice_eq_iFD2 hU2 p.1 p.2
    have e2 : Δ (fun x => G (p.1, x)) p.2
        = ∑ i, iteratedFDeriv ℝ 2 G p ![((0 : ℝ), b i), ((0 : ℝ), b i)] :=
      laplacian_slice_eq_iFD2 hG2 p.1 p.2
    have e3 : ⟪∇ (fun x => G (p.1, x)) p.2, ∇ ((a p.1 : E → ℝ)) p.2⟫
        = ∑ i, fderiv ℝ G p ((0 : ℝ), b i)
            * fderiv ℝ (fun q : ℝ × E => (a q.1 : E → ℝ) q.2) p ((0 : ℝ), b i) :=
      inner_gradients_slice (hGd p) (hUd p)
    have e4 : ⟪∇ (fun x => G (p.1, x)) p.2, ∇ (fun x => G (p.1, x)) p.2⟫
        = ∑ i, fderiv ℝ G p ((0 : ℝ), b i) * fderiv ℝ G p ((0 : ℝ), b i) :=
      inner_gradients_slice (hGd p) (hGd p)
    rw [e1, e2, e3, e4]
  rw [key]
  have hiU : ContDiff ℝ (⊤ : ℕ∞)
      (iteratedFDeriv ℝ 2 fun q : ℝ × E => (a q.1 : E → ℝ) q.2) :=
    hU.iteratedFDeriv_right (by norm_cast)
  have hiG : ContDiff ℝ (⊤ : ℕ∞) (iteratedFDeriv ℝ 2 G) :=
    hG.iteratedFDeriv_right (by norm_cast)
  have hfU : ContDiff ℝ (⊤ : ℕ∞) (fderiv ℝ fun q : ℝ × E => (a q.1 : E → ℝ) q.2) :=
    hU.fderiv_right (by exact_mod_cast le_top)
  have hfG : ContDiff ℝ (⊤ : ℕ∞) (fderiv ℝ G) :=
    hG.fderiv_right (by exact_mod_cast le_top)
  have hA : ContDiff ℝ (⊤ : ℕ∞) fun p : ℝ × E =>
      ∑ i, iteratedFDeriv ℝ 2 (fun q : ℝ × E => (a q.1 : E → ℝ) q.2) p
        ![((0 : ℝ), b i), ((0 : ℝ), b i)] :=
    ContDiff.sum fun i _ => by
      exact (ContinuousMultilinearMap.apply ℝ (fun _ : Fin 2 => ℝ × E) ℝ
        ![((0 : ℝ), b i), ((0 : ℝ), b i)]).contDiff.comp hiU
  have hB : ContDiff ℝ (⊤ : ℕ∞) fun p : ℝ × E =>
      ∑ i, fderiv ℝ G p ((0 : ℝ), b i)
        * fderiv ℝ (fun q : ℝ × E => (a q.1 : E → ℝ) q.2) p ((0 : ℝ), b i) :=
    ContDiff.sum fun i _ => ContDiff.mul
      ((ContinuousLinearMap.apply ℝ ℝ ((0 : ℝ), b i)).contDiff.comp hfG)
      ((ContinuousLinearMap.apply ℝ ℝ ((0 : ℝ), b i)).contDiff.comp hfU)
  have hC : ContDiff ℝ (⊤ : ℕ∞) fun p : ℝ × E =>
      fderiv ℝ G p ((1 : ℝ), (0 : E)) :=
    (ContinuousLinearMap.apply ℝ ℝ ((1 : ℝ), (0 : E))).contDiff.comp hfG
  have hD : ContDiff ℝ (⊤ : ℕ∞) fun p : ℝ × E =>
      ∑ i, iteratedFDeriv ℝ 2 G p ![((0 : ℝ), b i), ((0 : ℝ), b i)] :=
    ContDiff.sum fun i _ => by
      exact (ContinuousMultilinearMap.apply ℝ (fun _ : Fin 2 => ℝ × E) ℝ
        ![((0 : ℝ), b i), ((0 : ℝ), b i)]).contDiff.comp hiG
  have hE : ContDiff ℝ (⊤ : ℕ∞) fun p : ℝ × E =>
      ∑ i, fderiv ℝ G p ((0 : ℝ), b i) * fderiv ℝ G p ((0 : ℝ), b i) :=
    ContDiff.sum fun i _ => ContDiff.mul
      ((ContinuousLinearMap.apply ℝ ℝ ((0 : ℝ), b i)).contDiff.comp hfG)
      ((ContinuousLinearMap.apply ℝ ℝ ((0 : ℝ), b i)).contDiff.comp hfG)
  exact (hA.add hB).sub ((((hC.sub hD).sub hE).div_const 2).mul hU)

/-- **Ladder-5c: the UNCONDITIONAL `CommutatorMethod` instance.** For a jointly smooth
    weight `G`, the weighted pairing / backwards-heat `L` / Carleman `S` triple satisfies
    the full commutator method on jointly smooth test curves — every field PROVED; the
    `mem_S` toll of ladder-4 is discharged by the two Clairaut keystones (5a/5b-ii).
    Library infrastructure; `:proved` = 0 for the PDE. -/
theorem commutatorMethod_weighted_joint (hK : IsCompact K) {G : ℝ × E → ℝ}
    (hG : ContDiff ℝ (⊤ : ℕ∞) G) :
    CommutatorMethod
      (weightedPairing hK (fun t x => G (t, x))
        (fun t => hG.comp ((contDiff_const (c := t)).prodMk contDiff_id)))
      (Lop K)
      (Sop hK.isClosed (fun t x => G (t, x))
        (fun t x => fderiv ℝ G (t, x) ((1 : ℝ), (0 : E)))
        (fun t => hG.comp ((contDiff_const (c := t)).prodMk contDiff_id))
        (fun t => (ContinuousLinearMap.apply ℝ ℝ ((1 : ℝ), (0 : E))).contDiff.comp
          ((hG.fderiv_right (m := (⊤ : ℕ∞)) (by exact_mod_cast le_top)).comp
            ((contDiff_const (c := t)).prodMk contDiff_id))))
      AdmissibleJoint := by
  refine commutatorMethod_weighted hK _ _ ?_ ?_ ?_ admissibleJoint_subset ?_
  · intro t x
    exact hasDerivAt_curve (hG.differentiable (by norm_num) (t, x))
  · exact hG.continuous
  · exact (ContinuousLinearMap.apply ℝ ℝ ((1 : ℝ), (0 : E))).continuous.comp
      ((hG.fderiv_right (m := (⊤ : ℕ∞)) (by exact_mod_cast le_top)).continuous)
  · intro a ha
    exact admissibleJoint_mem_S hK.isClosed hG _ _ ha

/-- **(6b-δ → Lemma 4.1, the differential inequality)** — instantiating the abstract
    drop-the-square inequality (`deriv_pair_S_le`, ladder-1) at the Carleman weighted-joint
    instance (`commutatorMethod_weighted_joint`): for a jointly smooth weight `G` and an
    `AdmissibleJoint` test curve `u`, `∂t⟨S u, u⟩ ≤ ⟨[L,S]u, u⟩ + ½⟨Lu, Lu⟩`. The commutator
    quadratic form `⟨[L,S]u,u⟩` here is the weighted pairing of `L(S∘u) − S(Lu)`; its concrete
    value `∫(−2 D²g(∇u,∇u) − ½(LF)u²)e^g` is `integral_commutator_quadratic`. -/
theorem carleman_diff_inequality {G : ℝ × E → ℝ} (hK : IsCompact K)
    (hG : ContDiff ℝ (⊤ : ℕ∞) G) {u : ℝ → smoothTestSubmodule K}
    (hu : u ∈ AdmissibleJoint) (t : ℝ) :
    deriv (fun τ => weightedPairing hK (fun t x => G (t, x))
        (fun t => hG.comp ((contDiff_const (c := t)).prodMk contDiff_id)) τ
        (Sop hK.isClosed (fun t x => G (t, x))
        (fun t x => fderiv ℝ G (t, x) ((1 : ℝ), (0 : E)))
        (fun t => hG.comp ((contDiff_const (c := t)).prodMk contDiff_id))
        (fun t => (ContinuousLinearMap.apply ℝ ℝ ((1 : ℝ), (0 : E))).contDiff.comp
          ((hG.fderiv_right (m := (⊤ : ℕ∞)) (by exact_mod_cast le_top)).comp
            ((contDiff_const (c := t)).prodMk contDiff_id))) τ (u τ)) (u τ)) t
      ≤ weightedPairing hK (fun t x => G (t, x))
        (fun t => hG.comp ((contDiff_const (c := t)).prodMk contDiff_id)) t
          (Lop K (fun τ => Sop hK.isClosed (fun t x => G (t, x))
        (fun t x => fderiv ℝ G (t, x) ((1 : ℝ), (0 : E)))
        (fun t => hG.comp ((contDiff_const (c := t)).prodMk contDiff_id))
        (fun t => (ContinuousLinearMap.apply ℝ ℝ ((1 : ℝ), (0 : E))).contDiff.comp
          ((hG.fderiv_right (m := (⊤ : ℕ∞)) (by exact_mod_cast le_top)).comp
            ((contDiff_const (c := t)).prodMk contDiff_id))) τ (u τ)) t - Sop hK.isClosed (fun t x => G (t, x))
        (fun t x => fderiv ℝ G (t, x) ((1 : ℝ), (0 : E)))
        (fun t => hG.comp ((contDiff_const (c := t)).prodMk contDiff_id))
        (fun t => (ContinuousLinearMap.apply ℝ ℝ ((1 : ℝ), (0 : E))).contDiff.comp
          ((hG.fderiv_right (m := (⊤ : ℕ∞)) (by exact_mod_cast le_top)).comp
            ((contDiff_const (c := t)).prodMk contDiff_id))) t (Lop K u t)) (u t)
        + (1 / 2) * weightedPairing hK (fun t x => G (t, x))
        (fun t => hG.comp ((contDiff_const (c := t)).prodMk contDiff_id)) t (Lop K u t) (Lop K u t) := by
  exact (commutatorMethod_weighted_joint hK hG).deriv_pair_S_le hu t

end JointAdmissible

/-! ### Ladder-6a: the energy identity — `⟨Su,u⟩ = −∫(‖∇u‖² + ½F·u²)e^g`

Tao 1908.04958 §4, the display following Lemma 4.1's master identity: the quadratic form of
`S_g(t)` on a test function is minus the weighted Dirichlet energy plus the `F`-potential
term. One application of the weighted Green identity (B8) with `v := u`. -/

section Lemma41

open MeasureTheory Real Laplacian InnerProductSpace WeightedGreenAux
open scoped RealInnerProductSpace Gradient

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
  [FiniteDimensional ℝ E] [MeasurableSpace E] [BorelSpace E] [CompleteSpace E]
  {K : Set E}

/-- **The energy identity (Tao §4, Lemma 4.1's `⟨Su,u⟩` display):**
    `⟨S_g(t)u, u⟩_g = −∫ (‖∇u‖² + ½·F·u²) e^g` with `F = ∂tg − Δg − ‖∇g‖²`. -/
theorem weightedPairing_S_self (hK : IsCompact K) {g gt : ℝ → E → ℝ}
    (hg : ∀ t, ContDiff ℝ (⊤ : ℕ∞) (g t)) (hgt : ∀ t, ContDiff ℝ (⊤ : ℕ∞) (gt t))
    (t : ℝ) (u : smoothTestSubmodule K) :
    weightedPairing hK g hg t (Sop hK.isClosed g gt hg hgt t u) u
      = - ∫ x, (⟪∇ (u : E → ℝ) x, ∇ (u : E → ℝ) x⟫
          + (gt t x - Δ (g t) x - ⟪∇ (g t) x, ∇ (g t) x⟫) / 2
            * ((u : E → ℝ) x) ^ 2) * exp (g t x) := by
  classical
  have hu2 : ContDiff ℝ 2 (u : E → ℝ) := u.2.1.of_le (by norm_cast <;> exact le_top)
  have hu1 : ContDiff ℝ 1 (u : E → ℝ) := hu2.of_le (by norm_num)
  have hcu : HasCompactSupport (u : E → ℝ) := HasCompactSupport.intro hK u.2.2
  have hg2 : ContDiff ℝ 2 (g t) := (hg t).of_le (by norm_cast <;> exact le_top)
  have hg1 : ContDiff ℝ 1 (g t) := hg2.of_le (by norm_num)
  have hts : tsupport (u : E → ℝ) ⊆ K :=
    closure_minimal (fun y hy => by
      by_contra hyn
      exact hy (u.2.2 y hyn)) hK.isClosed
  have hgrad0 : ∀ x ∉ K, ∇ (u : E → ℝ) x = 0 := by
    intro x hx
    by_contra hne
    exact (fun hmem => hx (hts hmem))
      (support_gradient_subset _ (Function.mem_support.mpr hne))
  have hsuppK : ∀ p : E → ℝ, (∀ x, x ∉ K → p x = 0) → Continuous p →
      Integrable p (volume : Measure E) := fun p hp hc =>
    hc.integrable_of_hasCompactSupport (HasCompactSupport.intro hK hp)
  have hgexp : Continuous fun x : E => exp (g t x) :=
    Real.continuous_exp.comp (hg t).continuous
  have hcF : Continuous fun x =>
      (gt t x - Δ (g t) x - ⟪∇ (g t) x, ∇ (g t) x⟫) / 2 :=
    (((hgt t).continuous.sub (continuous_laplacian hg2)).sub
      ((continuous_gradient hg1).inner (continuous_gradient hg1))).div_const 2
  -- the two integrable pieces of `Sfun·u·e^g`
  have hI1 : Integrable (fun x => (Δ (u : E → ℝ) x + ⟪∇ (g t) x, ∇ (u : E → ℝ) x⟫)
      * ((u : E → ℝ) x * exp (g t x))) (volume : Measure E) := by
    refine hsuppK _ (fun x hx => ?_)
      (((continuous_laplacian hu2).add
        ((continuous_gradient hg1).inner (continuous_gradient hu1))).mul
        (hu1.continuous.mul hgexp))
    rw [u.2.2 x hx]
    ring
  have hI2 : Integrable (fun x =>
      (gt t x - Δ (g t) x - ⟪∇ (g t) x, ∇ (g t) x⟫) / 2
        * ((u : E → ℝ) x) ^ 2 * exp (g t x)) (volume : Measure E) := by
    refine hsuppK _ (fun x hx => ?_)
      ((hcF.mul (hu1.continuous.pow 2)).mul hgexp)
    rw [u.2.2 x hx]
    ring
  have hI3 : Integrable (fun x =>
      ⟪∇ (u : E → ℝ) x, ∇ (u : E → ℝ) x⟫ * exp (g t x)) (volume : Measure E) := by
    refine hsuppK _ (fun x hx => ?_)
      (((continuous_gradient hu1).inner (continuous_gradient hu1)).mul hgexp)
    rw [hgrad0 x hx, inner_zero_right]
    ring
  -- expand the pairing and split
  rw [weightedPairing_apply]
  have hsplit : (∫ x, ((Sop hK.isClosed g gt hg hgt t u : smoothTestSubmodule K) : E → ℝ) x
        * (u : E → ℝ) x * exp (g t x))
      = (∫ x, (Δ (u : E → ℝ) x + ⟪∇ (g t) x, ∇ (u : E → ℝ) x⟫)
          * ((u : E → ℝ) x * exp (g t x)))
        - ∫ x, (gt t x - Δ (g t) x - ⟪∇ (g t) x, ∇ (g t) x⟫) / 2
            * ((u : E → ℝ) x) ^ 2 * exp (g t x) := by
    rw [← integral_sub hI1 hI2]
    refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
    show Sfun g gt t (u : E → ℝ) x * (u : E → ℝ) x * exp (g t x) = _
    unfold Sfun
    ring
  rw [hsplit, integral_weighted_green hu2 hcu hu1 hg1,
    sub_eq_add_neg, ← neg_add, ← integral_add hI3 hI2]
  refine congrArg Neg.neg (integral_congr_ae
    (Filter.Eventually.of_forall fun x => ?_))
  show ⟪∇ (u : E → ℝ) x, ∇ (u : E → ℝ) x⟫ * exp (g t x)
      + (gt t x - Δ (g t) x - ⟪∇ (g t) x, ∇ (g t) x⟫) / 2
        * ((u : E → ℝ) x) ^ 2 * exp (g t x)
    = (⟪∇ (u : E → ℝ) x, ∇ (u : E → ℝ) x⟫
        + (gt t x - Δ (g t) x - ⟪∇ (g t) x, ∇ (g t) x⟫) / 2
          * ((u : E → ℝ) x) ^ 2) * exp (g t x)
  ring

end Lemma41

/-! ### Ladder-6b-α: the spatial substrate for the concrete commutator

Pure spatial-calculus infrastructure for Tao §4's commutator quadratic form
`⟨[L,S]u,u⟩ = ∫(−2D²g(∇u,∇u) − ½(LF)u²)e^g`. The foundational gap is the Laplacian Leibniz
rule (`Δ(fg)` — absent from Mathlib). Everything is `:proved`=0-neutral library infrastructure. -/

section CommutatorSubstrate

open MeasureTheory Real Laplacian InnerProductSpace
open scoped RealInnerProductSpace Gradient

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
  [FiniteDimensional ℝ E] [CompleteSpace E]

/-- **The Laplacian Leibniz rule** (pointwise, a Mathlib gap):
    `Δ(u·v) = u·Δv + v·Δu + 2⟪∇u, ∇v⟫` for `u, v` C². -/
theorem laplacian_mul {u v : E → ℝ} (hu : ContDiff ℝ 2 u) (hv : ContDiff ℝ 2 v)
    (x : E) :
    Δ (fun y => u y * v y) x
      = u x * Δ v x + v x * Δ u x + 2 * ⟪∇ u x, ∇ v x⟫ := by
  classical
  set b := stdOrthonormalBasis ℝ E with hb
  have hfu1 : ContDiff ℝ 1 (fderiv ℝ u) := hu.fderiv_right (by norm_num)
  have hfv1 : ContDiff ℝ 1 (fderiv ℝ v) := hv.fderiv_right (by norm_num)
  have hud : ∀ y : E, HasFDerivAt u (fderiv ℝ u y) y := fun y =>
    (hu.differentiable (by norm_num) y).hasFDerivAt
  have hvd : ∀ y : E, HasFDerivAt v (fderiv ℝ v y) y := fun y =>
    (hv.differentiable (by norm_num) y).hasFDerivAt
  -- the first derivative of the product, as a function E → (E →L[ℝ] ℝ)
  have heq : (fderiv ℝ fun y : E => u y * v y)
      = fun y : E => u y • fderiv ℝ v y + v y • fderiv ℝ u y := by
    funext y
    exact ((hud y).mul (hvd y)).fderiv
  -- its second derivative at `x`
  have hH : HasFDerivAt (fun y : E => u y • fderiv ℝ v y + v y • fderiv ℝ u y) _ x :=
    (HasFDerivAt.smul (hud x) (hfv1.differentiable one_ne_zero x).hasFDerivAt).add
      (HasFDerivAt.smul (hvd x) (hfu1.differentiable one_ne_zero x).hasFDerivAt)
  rw [congrFun (laplacian_eq_iteratedFDeriv_orthonormalBasis _ b) x]
  have hterm : ∀ i, iteratedFDeriv ℝ 2 (fun y : E => u y * v y) x ![b i, b i]
      = u x * fderiv ℝ (fderiv ℝ v) x (b i) (b i)
        + v x * fderiv ℝ (fderiv ℝ u) x (b i) (b i)
        + 2 * (fderiv ℝ u x (b i) * fderiv ℝ v x (b i)) := by
    intro i
    rw [iteratedFDeriv_two_apply, heq, hH.fderiv]
    simp only [ContinuousLinearMap.add_apply, ContinuousLinearMap.smul_apply,
      ContinuousLinearMap.smulRight_apply, smul_eq_mul,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons]
    ring
  rw [Finset.sum_congr rfl fun i _ => hterm i, Finset.sum_add_distrib,
      Finset.sum_add_distrib, ← Finset.mul_sum, ← Finset.mul_sum, ← Finset.mul_sum]
  have hlapv : Δ v x = ∑ i, fderiv ℝ (fderiv ℝ v) x (b i) (b i) := by
    rw [congrFun (laplacian_eq_iteratedFDeriv_orthonormalBasis v b) x]
    exact Finset.sum_congr rfl fun i _ => by rw [iteratedFDeriv_two_apply]; rfl
  have hlapu : Δ u x = ∑ i, fderiv ℝ (fderiv ℝ u) x (b i) (b i) := by
    rw [congrFun (laplacian_eq_iteratedFDeriv_orthonormalBasis u b) x]
    exact Finset.sum_congr rfl fun i _ => by rw [iteratedFDeriv_two_apply]; rfl
  have hpar : ∑ i, fderiv ℝ u x (b i) * fderiv ℝ v x (b i) = ⟪∇ u x, ∇ v x⟫ := by
    rw [← OrthonormalBasis.sum_inner_mul_inner b (∇ u x) (∇ v x)]
    refine Finset.sum_congr rfl fun i _ => ?_
    rw [← inner_gradient_left (hu.differentiable (by norm_num) x),
        ← inner_gradient_left (hv.differentiable (by norm_num) x),
        real_inner_comm (∇ v x) (b i)]
  rw [← hlapv, ← hlapu, hpar]

/-- **Spatial Parseval for gradients:** `⟪∇f, ∇h⟫ = Σᵢ (∂ᵢf)(∂ᵢh)` in the standard
    orthonormal basis. -/
theorem inner_grad_eq_sum {f h : E → ℝ} (hf : DifferentiableAt ℝ f x)
    (hh : DifferentiableAt ℝ h x) :
    ⟪∇ f x, ∇ h x⟫
      = ∑ i, fderiv ℝ f x (stdOrthonormalBasis ℝ E i)
          * fderiv ℝ h x (stdOrthonormalBasis ℝ E i) := by
  set b := stdOrthonormalBasis ℝ E with hb
  rw [← OrthonormalBasis.sum_inner_mul_inner b (∇ f x) (∇ h x)]
  refine Finset.sum_congr rfl fun i _ => ?_
  rw [← inner_gradient_left hf, ← inner_gradient_left hh, real_inner_comm (∇ h x) (b i)]

/-- **The Laplacian is additive over finite sums:** `Δ(Σᵢ Fᵢ) = Σᵢ ΔFᵢ` for C² summands. -/
theorem laplacian_fun_sum {ι : Type*} (s : Finset ι) {F : ι → E → ℝ}
    (hF : ∀ i ∈ s, ContDiff ℝ 2 (F i)) (x : E) :
    Δ (fun y => ∑ i ∈ s, F i y) x = ∑ i ∈ s, Δ (F i) x := by
  classical
  induction s using Finset.induction with
  | empty => simp [laplacian_const]
  | insert a s ha ih =>
    have hFa : ContDiff ℝ 2 (F a) := hF a (Finset.mem_insert_self a s)
    have hFs : ∀ i ∈ s, ContDiff ℝ 2 (F i) := fun i hi =>
      hF i (Finset.mem_insert_of_mem hi)
    have hsum2 : ContDiff ℝ 2 (fun y => ∑ i ∈ s, F i y) :=
      ContDiff.sum fun i hi => hFs i hi
    have hcongr : (fun y => ∑ i ∈ insert a s, F i y)
        = F a + fun y => ∑ i ∈ s, F i y := by
      funext y; rw [Pi.add_apply, Finset.sum_insert ha]
    rw [hcongr, ContDiffAt.laplacian_add hFa.contDiffAt hsum2.contDiffAt,
        Finset.sum_insert ha, ih hFs]

/-! #### Ladder-6b-α substrate ii: the spatial Clairaut swap `Δ(∂_w f) = ∂_w(Δf)`

The E-domain port of the 5b-ii third-derivative swap chain (those proofs use nothing of the
`ℝ × E` product structure), assembled into the spatial mixed-partial commutation. -/

/-- (E-domain δ) Left-peeling bridge: `iFD3 f q ![a,b,c] = fderiv(iFD2 f) q a ![b,c]`. -/
theorem eIFD3_eq_left {f : E → ℝ} (q a b c : E) :
    iteratedFDeriv ℝ 3 f q ![a, b, c]
      = fderiv ℝ (iteratedFDeriv ℝ 2 f) q a ![b, c] := by
  rw [iteratedFDeriv_succ_apply_left]; congr 1

/-- (E-domain δ′) Directional-application bridge. -/
theorem eIFD2_apply_dir {f : E → ℝ} (hf : ContDiff ℝ 3 f) (q d a b : E) :
    iteratedFDeriv ℝ 2 (fun p : E => fderiv ℝ f p d) q ![a, b]
      = iteratedFDeriv ℝ 3 f q ![a, b, d] := by
  have hfd : ContDiff ℝ 2 (fderiv ℝ f) := hf.fderiv_right (by norm_num)
  have hcomp := (ContinuousLinearMap.apply ℝ ℝ d).iteratedFDeriv_comp_left
    (f := fderiv ℝ f) (hfd.contDiffAt (x := q)) (i := 2) le_rfl
  have h1 : iteratedFDeriv ℝ 2 (fun p : E => fderiv ℝ f p d) q ![a, b]
      = iteratedFDeriv ℝ 2 (fderiv ℝ f) q ![a, b] d := by
    have h2 := congrFun (congrArg DFunLike.coe hcomp) ![a, b]
    simpa using h2
  have hinit : Fin.init ![a, b, d] = ![a, b] := by
    funext i; fin_cases i <;> simp [Fin.init]
  rw [h1]
  conv_rhs => rw [iteratedFDeriv_succ_apply_right]
  rw [hinit]; rfl

/-- (E-domain β′) First-pair swap (scalar Schwarz on `p ↦ Df(p)·c`). -/
theorem eIFD3_swap12 {f : E → ℝ} (hf : ContDiff ℝ 3 f) (q a b c : E) :
    iteratedFDeriv ℝ 3 f q ![a, b, c] = iteratedFDeriv ℝ 3 f q ![b, a, c] := by
  have hfd : ContDiff ℝ 2 (fderiv ℝ f) := hf.fderiv_right (by norm_num)
  have hV : ContDiff ℝ 2 fun p : E => fderiv ℝ f p c :=
    (ContinuousLinearMap.apply ℝ ℝ c).contDiff.comp hfd
  have hsymm : IsSymmSndFDerivAt ℝ (fun p : E => fderiv ℝ f p c) q :=
    hV.contDiffAt.isSymmSndFDerivAt (by simp)
  rw [← eIFD2_apply_dir hf q c a b, ← eIFD2_apply_dir hf q c b a]
  exact IsSymmSndFDerivAt.iteratedFDeriv_cons (hf := hsymm)

/-- (E-domain γ′) Last-pair swap (differentiated pointwise Schwarz). -/
theorem eIFD3_swap23 {f : E → ℝ} (hf : ContDiff ℝ 3 f) (q a b c : E) :
    iteratedFDeriv ℝ 3 f q ![a, b, c] = iteratedFDeriv ℝ 3 f q ![a, c, b] := by
  have hf2 : ContDiff ℝ 2 f := hf.of_le (by norm_num)
  have hifd : ContDiff ℝ 1 (iteratedFDeriv ℝ 2 f) :=
    hf.iteratedFDeriv_right (by norm_num)
  have hφ : ∀ b c : E,
      fderiv ℝ (fun p : E => iteratedFDeriv ℝ 2 f p ![b, c]) q a
      = fderiv ℝ (iteratedFDeriv ℝ 2 f) q a ![b, c] := by
    intro b c
    have hap := (ContinuousMultilinearMap.apply ℝ (fun _ : Fin 2 => E) ℝ ![b, c]).hasFDerivAt
      (x := iteratedFDeriv ℝ 2 f q)
    have hF : HasFDerivAt (fun p : E => iteratedFDeriv ℝ 2 f p ![b, c])
        ((ContinuousMultilinearMap.apply ℝ (fun _ : Fin 2 => E) ℝ ![b, c]).comp
          (fderiv ℝ (iteratedFDeriv ℝ 2 f) q)) q := by
      exact hap.comp q ((hifd.differentiable one_ne_zero) q).hasFDerivAt
    rw [hF.fderiv]; rfl
  have hpoint : (fun p : E => iteratedFDeriv ℝ 2 f p ![b, c])
      = fun p : E => iteratedFDeriv ℝ 2 f p ![c, b] := by
    funext p
    exact IsSymmSndFDerivAt.iteratedFDeriv_cons
      (hf := hf2.contDiffAt.isSymmSndFDerivAt (by simp))
  rw [eIFD3_eq_left, eIFD3_eq_left, ← hφ b c, hpoint, hφ c b]

/-- The `fderiv` of an `iFD2`-coefficient prepends the direction: `∂_w(iFD2 f ·![a,b]) =
    iFD3 f ![w,a,b]`. -/
theorem fderiv_iFD2_coeff {f : E → ℝ} (hf : ContDiff ℝ 3 f) (x w a b : E) :
    fderiv ℝ (fun y => iteratedFDeriv ℝ 2 f y ![a, b]) x w
      = iteratedFDeriv ℝ 3 f x ![w, a, b] := by
  have hifd : ContDiff ℝ 1 (iteratedFDeriv ℝ 2 f) :=
    hf.iteratedFDeriv_right (by norm_num)
  have hap := (ContinuousMultilinearMap.apply ℝ (fun _ : Fin 2 => E) ℝ ![a, b]).hasFDerivAt
    (x := iteratedFDeriv ℝ 2 f x)
  have hF : HasFDerivAt (fun p : E => iteratedFDeriv ℝ 2 f p ![a, b])
      ((ContinuousMultilinearMap.apply ℝ (fun _ : Fin 2 => E) ℝ ![a, b]).comp
        (fderiv ℝ (iteratedFDeriv ℝ 2 f) x)) x := by
    exact hap.comp x ((hifd.differentiable one_ne_zero) x).hasFDerivAt
  rw [hF.fderiv, eIFD3_eq_left]; rfl

/-- **The spatial Clairaut swap:** `Δ(∂_w f) = ∂_w(Δf)` for `f` C³ — the Laplacian commutes
    with directional differentiation. -/
theorem laplacian_deriv_swap {f : E → ℝ} (hf : ContDiff ℝ 3 f) (x w : E) :
    Δ (fun y => fderiv ℝ f y w) x = fderiv ℝ (Δ f) x w := by
  classical
  set b := stdOrthonormalBasis ℝ E with hb
  have hifd1 : ContDiff ℝ 1 (iteratedFDeriv ℝ 2 f) := hf.iteratedFDeriv_right (by norm_num)
  have hLHS : Δ (fun y => fderiv ℝ f y w) x
      = ∑ i, iteratedFDeriv ℝ 3 f x ![b i, b i, w] := by
    rw [congrFun (laplacian_eq_iteratedFDeriv_orthonormalBasis
      (fun y => fderiv ℝ f y w) b) x]
    exact Finset.sum_congr rfl fun i _ => eIFD2_apply_dir hf x w (b i) (b i)
  have hΔf_eq : Δ f = fun y => ∑ i, iteratedFDeriv ℝ 2 f y ![b i, b i] :=
    funext fun y => congrFun (laplacian_eq_iteratedFDeriv_orthonormalBasis f b) y
  have hdiff : ∀ i ∈ (Finset.univ : Finset (Fin (Module.finrank ℝ E))),
      DifferentiableAt ℝ (fun y => iteratedFDeriv ℝ 2 f y ![b i, b i]) x := fun i _ =>
    ((ContinuousMultilinearMap.apply ℝ (fun _ : Fin 2 => E) ℝ ![b i, b i]).differentiable.comp
      (hifd1.differentiable one_ne_zero)) x
  have hRHS : fderiv ℝ (Δ f) x w = ∑ i, iteratedFDeriv ℝ 3 f x ![w, b i, b i] := by
    rw [hΔf_eq, fderiv_fun_sum hdiff, ContinuousLinearMap.sum_apply]
    exact Finset.sum_congr rfl fun i _ => fderiv_iFD2_coeff hf x w (b i) (b i)
  rw [hLHS, hRHS]
  refine Finset.sum_congr rfl fun i _ => ?_
  rw [eIFD3_swap23 hf x (b i) (b i) w, eIFD3_swap12 hf x (b i) w (b i)]

/-! #### Ladder-6b-α substrate iii: the four-index identity `Δ⟪∇f,∇h⟫` -/

/-- The `fderiv` of a directional derivative is a second iterated derivative:
    `∂_v(∂_d f) = iFD2 f ![v,d]`. -/
theorem fderiv_fderiv_dir {f : E → ℝ} (hf : ContDiff ℝ 2 f) (x v d : E) :
    fderiv ℝ (fun y => fderiv ℝ f y d) x v = iteratedFDeriv ℝ 2 f x ![v, d] := by
  have hfd : ContDiff ℝ 1 (fderiv ℝ f) := hf.fderiv_right (by norm_num)
  have hF : HasFDerivAt (fun y => fderiv ℝ f y d)
      ((ContinuousLinearMap.apply ℝ ℝ d).comp (fderiv ℝ (fderiv ℝ f) x)) x :=
    ((ContinuousLinearMap.apply ℝ ℝ d).hasFDerivAt (x := fderiv ℝ f x)).comp x
      ((hfd.differentiable one_ne_zero) x).hasFDerivAt
  rw [hF.fderiv, iteratedFDeriv_two_apply]; rfl

/-- **The four-index identity** (the engine of `Δ(∇g·∇u)`):
    `Δ⟪∇f,∇h⟫ = ⟪∇(Δf),∇h⟫ + 2·⟨D²f, D²h⟩_HS + ⟪∇f,∇(Δh)⟫`,
    where the Hilbert–Schmidt Hessian inner product is the basis double sum. -/
theorem laplacian_inner_grad {f h : E → ℝ} (hf : ContDiff ℝ 3 f)
    (hh : ContDiff ℝ 3 h) (x : E) :
    Δ (fun y => ⟪∇ f y, ∇ h y⟫) x
      = ⟪∇ (Δ f) x, ∇ h x⟫
        + 2 * ∑ i, ∑ j, iteratedFDeriv ℝ 2 f x ![stdOrthonormalBasis ℝ E i,
              stdOrthonormalBasis ℝ E j]
            * iteratedFDeriv ℝ 2 h x ![stdOrthonormalBasis ℝ E i,
              stdOrthonormalBasis ℝ E j]
        + ⟪∇ f x, ∇ (Δ h) x⟫ := by
  classical
  set b := stdOrthonormalBasis ℝ E with hb
  have hf2 : ContDiff ℝ 2 f := hf.of_le (by norm_num)
  have hh2 : ContDiff ℝ 2 h := hh.of_le (by norm_num)
  -- `⟪∇f,∇h⟫` as a basis sum of products of directional derivatives
  have hgrad_eq : (fun y => (⟪∇ f y, ∇ h y⟫ : ℝ))
      = fun y => ∑ j, fderiv ℝ f y (b j) * fderiv ℝ h y (b j) := by
    funext y
    rw [inner_grad_eq_sum (hf.differentiable (by norm_num) y)
      (hh.differentiable (by norm_num) y)]
  -- the smoothness of each `j`-summand
  have huC2 : ∀ j, ContDiff ℝ 2 (fun y => fderiv ℝ f y (b j)) := fun j =>
    (ContinuousLinearMap.apply ℝ ℝ (b j)).contDiff.comp (hf.fderiv_right (by norm_num))
  have hvC2 : ∀ j, ContDiff ℝ 2 (fun y => fderiv ℝ h y (b j)) := fun j =>
    (ContinuousLinearMap.apply ℝ ℝ (b j)).contDiff.comp (hh.fderiv_right (by norm_num))
  -- per-`j` Laplacian of the product, via the Leibniz rule + the spatial swap
  have hbridge : ∀ j, Δ (fun y => fderiv ℝ f y (b j) * fderiv ℝ h y (b j)) x
      = fderiv ℝ f x (b j) * fderiv ℝ (Δ h) x (b j)
        + fderiv ℝ h x (b j) * fderiv ℝ (Δ f) x (b j)
        + 2 * ∑ i, iteratedFDeriv ℝ 2 f x ![b i, b j]
              * iteratedFDeriv ℝ 2 h x ![b i, b j] := by
    intro j
    rw [laplacian_mul (huC2 j) (hvC2 j) x, laplacian_deriv_swap hh x (b j),
        laplacian_deriv_swap hf x (b j)]
    have hcross : (⟪∇ (fun y => fderiv ℝ f y (b j)) x,
          ∇ (fun y => fderiv ℝ h y (b j)) x⟫ : ℝ)
        = ∑ i, iteratedFDeriv ℝ 2 f x ![b i, b j]
            * iteratedFDeriv ℝ 2 h x ![b i, b j] := by
      rw [inner_grad_eq_sum ((huC2 j).differentiable (by norm_num) x)
        ((hvC2 j).differentiable (by norm_num) x)]
      exact Finset.sum_congr rfl fun i _ => by
        rw [fderiv_fderiv_dir hf2 x (b i) (b j), fderiv_fderiv_dir hh2 x (b i) (b j)]
    rw [hcross]
  -- assemble
  rw [hgrad_eq, laplacian_fun_sum Finset.univ
    (fun j _ => (huC2 j).mul (hvC2 j)) x]
  rw [Finset.sum_congr rfl fun j _ => hbridge j]
  rw [Finset.sum_add_distrib, Finset.sum_add_distrib]
  have hlapC1 : ∀ {g : E → ℝ}, ContDiff ℝ 3 g → ContDiff ℝ 1 (Δ g) := by
    intro g hg
    have he : (Δ g) = fun y => ∑ i, iteratedFDeriv ℝ 2 g y ![b i, b i] :=
      funext fun y => congrFun (laplacian_eq_iteratedFDeriv_orthonormalBasis g b) y
    rw [he]
    exact ContDiff.sum fun i _ =>
      (ContinuousMultilinearMap.apply ℝ (fun _ : Fin 2 => E) ℝ ![b i, b i]).contDiff.comp
        (hg.iteratedFDeriv_right (by norm_num))
  have hA : ∑ j, fderiv ℝ f x (b j) * fderiv ℝ (Δ h) x (b j)
      = ⟪∇ f x, ∇ (Δ h) x⟫ :=
    (inner_grad_eq_sum (hf.differentiable (by norm_num) x)
      ((hlapC1 hh).differentiable (by norm_num) x)).symm
  have hB : ∑ j, fderiv ℝ h x (b j) * fderiv ℝ (Δ f) x (b j)
      = ⟪∇ (Δ f) x, ∇ h x⟫ := by
    rw [← inner_grad_eq_sum (hh.differentiable (by norm_num) x)
      ((hlapC1 hf).differentiable (by norm_num) x),
      real_inner_comm]
  have hC : ∑ j, 2 * ∑ i, iteratedFDeriv ℝ 2 f x ![b i, b j]
        * iteratedFDeriv ℝ 2 h x ![b i, b j]
      = 2 * ∑ i, ∑ j, iteratedFDeriv ℝ 2 f x ![b i, b j]
          * iteratedFDeriv ℝ 2 h x ![b i, b j] := by
    rw [← Finset.mul_sum, Finset.sum_comm]
  rw [hA, hB, hC]
  ring

end CommutatorSubstrate






/-! ### Ladder-6b-β: the S-curve time derivative

`∂t(S(t)u(t))` along a jointly smooth weight/curve. The reusable core (β-i) is the time
derivative of a slice-gradient inner product, built from the 5a slice keystone. -/

section CommutatorTime

open MeasureTheory Real Laplacian InnerProductSpace
open scoped RealInnerProductSpace Gradient

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
  [FiniteDimensional ℝ E] [CompleteSpace E]

/-- **(β-i) Time derivative of a slice-gradient inner product:** for jointly C² `F, H`,
    `∂t⟪∇ₓF(t), ∇ₓH(t)⟫ = ⟪∇ₓ(∂tF), ∇ₓH⟫ + ⟪∇ₓF, ∇ₓ(∂tH)⟫` (the product rule with the
    slice-gradient time derivative `hasDerivAt_fderiv_slice`). -/
theorem hasDerivAt_slice_inner {F H : ℝ × E → ℝ} (hF : ContDiff ℝ 2 F)
    (hH : ContDiff ℝ 2 H) (t₀ : ℝ) (x : E) :
    HasDerivAt (fun t => (⟪∇ (fun y => F (t, y)) x, ∇ (fun y => H (t, y)) x⟫ : ℝ))
      (⟪∇ (fun y => fderiv ℝ F (t₀, y) ((1 : ℝ), (0 : E))) x, ∇ (fun y => H (t₀, y)) x⟫
        + ⟪∇ (fun y => F (t₀, y)) x,
            ∇ (fun y => fderiv ℝ H (t₀, y) ((1 : ℝ), (0 : E))) x⟫) t₀ := by
  classical
  set b := stdOrthonormalBasis ℝ E with hb
  have hFt1 : ContDiff ℝ 1 (fun p : ℝ × E => fderiv ℝ F p ((1 : ℝ), (0 : E))) :=
    (ContinuousLinearMap.apply ℝ ℝ _).contDiff.comp (hF.fderiv_right (by norm_num))
  have hHt1 : ContDiff ℝ 1 (fun p : ℝ × E => fderiv ℝ H p ((1 : ℝ), (0 : E))) :=
    (ContinuousLinearMap.apply ℝ ℝ _).contDiff.comp (hH.fderiv_right (by norm_num))
  -- slice differentiabilities, in the exact lambda forms the goal uses
  have hdF : DifferentiableAt ℝ (fun y => F (t₀, y)) x :=
    (hasFDerivAt_slice (hF.differentiable (by norm_num) (t₀, x))).differentiableAt
  have hdH : DifferentiableAt ℝ (fun y => H (t₀, y)) x :=
    (hasFDerivAt_slice (hH.differentiable (by norm_num) (t₀, x))).differentiableAt
  have hdFt : DifferentiableAt ℝ (fun y => fderiv ℝ F (t₀, y) ((1 : ℝ), (0 : E))) x :=
    (hasFDerivAt_slice (hFt1.differentiable (by norm_num) (t₀, x))).differentiableAt
  have hdHt : DifferentiableAt ℝ (fun y => fderiv ℝ H (t₀, y) ((1 : ℝ), (0 : E))) x :=
    (hasFDerivAt_slice (hHt1.differentiable (by norm_num) (t₀, x))).differentiableAt
  -- the curve as a basis sum of products of slice directional derivatives
  have hcurve_eq : (fun t => (⟪∇ (fun y => F (t, y)) x, ∇ (fun y => H (t, y)) x⟫ : ℝ))
      = fun t => ∑ j, fderiv ℝ (fun y => F (t, y)) x (b j)
          * fderiv ℝ (fun y => H (t, y)) x (b j) := by
    funext t
    exact inner_grad_eq_sum
      (hasFDerivAt_slice (hF.differentiable (by norm_num) (t, x))).differentiableAt
      (hasFDerivAt_slice (hH.differentiable (by norm_num) (t, x))).differentiableAt
  rw [hcurve_eq]
  have hsum : HasDerivAt (fun t => ∑ j, fderiv ℝ (fun y => F (t, y)) x (b j)
        * fderiv ℝ (fun y => H (t, y)) x (b j)) _ t₀ :=
    HasDerivAt.fun_sum fun j _ =>
      (hasDerivAt_fderiv_slice hF t₀ x (b j)).mul (hasDerivAt_fderiv_slice hH t₀ x (b j))
  convert hsum using 1
  rw [inner_grad_eq_sum hdFt hdH, inner_grad_eq_sum hdF hdHt, ← Finset.sum_add_distrib]

/-- **(β-ii) Time derivative of the potential `F = ∂tg − Δg − ‖∇g‖²`** along a jointly smooth
    weight: `∂t F = gtt − Δ(∂tg) − 2⟪∇(∂tg), ∇g⟫`. The `Δg`-piece uses the slice-Laplacian
    keystone (5b-ii), the `‖∇g‖²`-piece uses `hasDerivAt_slice_inner` (β-i) with `F = H = g`. -/
theorem hasDerivAt_slice_F {G : ℝ × E → ℝ} (hG : ContDiff ℝ (⊤ : ℕ∞) G) (t₀ : ℝ) (x : E) :
    HasDerivAt (fun t => fderiv ℝ G (t, x) ((1 : ℝ), (0 : E))
        - Δ (fun y => G (t, y)) x
        - ⟪∇ (fun y => G (t, y)) x, ∇ (fun y => G (t, y)) x⟫)
      (fderiv ℝ (fun p : ℝ × E => fderiv ℝ G p ((1 : ℝ), (0 : E))) (t₀, x) ((1 : ℝ), (0 : E))
        - Δ (fun y => fderiv ℝ G (t₀, y) ((1 : ℝ), (0 : E))) x
        - (⟪∇ (fun y => fderiv ℝ G (t₀, y) ((1 : ℝ), (0 : E))) x,
              ∇ (fun y => G (t₀, y)) x⟫
            + ⟪∇ (fun y => G (t₀, y)) x,
              ∇ (fun y => fderiv ℝ G (t₀, y) ((1 : ℝ), (0 : E))) x⟫)) t₀ := by
  have hGt : ContDiff ℝ (⊤ : ℕ∞) (fun p : ℝ × E => fderiv ℝ G p ((1 : ℝ), (0 : E))) :=
    (ContinuousLinearMap.apply ℝ ℝ _).contDiff.comp (hG.fderiv_right (by exact_mod_cast le_top))
  -- gtt: the second time derivative
  have h1 : HasDerivAt (fun t => fderiv ℝ G (t, x) ((1 : ℝ), (0 : E)))
      (fderiv ℝ (fun p : ℝ × E => fderiv ℝ G p ((1 : ℝ), (0 : E))) (t₀, x)
        ((1 : ℝ), (0 : E))) t₀ :=
    hasDerivAt_curve (hGt.differentiable (by norm_num) (t₀, x))
  -- ∂t Δg = Δ(∂t g)
  have h2 : HasDerivAt (fun t => Δ (fun y => G (t, y)) x)
      (Δ (fun y => fderiv ℝ G (t₀, y) ((1 : ℝ), (0 : E))) x) t₀ :=
    hasDerivAt_laplacian_slice (hG.of_le (by norm_cast <;> exact le_top)) t₀ x
  -- ∂t ‖∇g‖²
  have h3 := hasDerivAt_slice_inner (hG.of_le (by norm_cast <;> exact le_top))
    (hG.of_le (by norm_cast <;> exact le_top)) t₀ x
  exact (h1.sub h2).sub h3

/-- **(β assembly) The full time derivative of `S(t)u(t)`** along jointly smooth weight `G`
    and curve `U`: `∂t[Δu + ∇g·∇u − ½F·u]` term-by-term — the Δ-term by the slice-Laplacian
    keystone (5b-ii), the `∇g·∇u`-term by `hasDerivAt_slice_inner` (β-i), the `½F·u`-term by
    the product rule with `hasDerivAt_slice_F` (β-ii) and `hasDerivAt_curve`. Subtracting
    `S(t₀)(∂tu)` from this value leaves the commutator's time part `⟪∇gt,∇u⟫ − ½(∂tF)u`. -/
theorem hasDerivAt_Sslice {G U : ℝ × E → ℝ} (hG : ContDiff ℝ (⊤ : ℕ∞) G)
    (hU : ContDiff ℝ (⊤ : ℕ∞) U) (t₀ : ℝ) (x : E) :
    HasDerivAt (fun t => Δ (fun y => U (t, y)) x
        + ⟪∇ (fun y => G (t, y)) x, ∇ (fun y => U (t, y)) x⟫
        - (fderiv ℝ G (t, x) ((1 : ℝ), (0 : E)) - Δ (fun y => G (t, y)) x
            - ⟪∇ (fun y => G (t, y)) x, ∇ (fun y => G (t, y)) x⟫) / 2 * U (t, x))
      -- `S(t₀)(∂tu)` …
      ((Δ (fun y => fderiv ℝ U (t₀, y) ((1 : ℝ), (0 : E))) x
          + ⟪∇ (fun y => G (t₀, y)) x,
              ∇ (fun y => fderiv ℝ U (t₀, y) ((1 : ℝ), (0 : E))) x⟫
          - (fderiv ℝ G (t₀, x) ((1 : ℝ), (0 : E)) - Δ (fun y => G (t₀, y)) x
              - ⟪∇ (fun y => G (t₀, y)) x, ∇ (fun y => G (t₀, y)) x⟫) / 2
            * fderiv ℝ U (t₀, x) ((1 : ℝ), (0 : E)))
        -- … plus the commutator's TIME part `⟪∇gt,∇u⟫ − ½(∂tF)u`
        + (⟪∇ (fun y => fderiv ℝ G (t₀, y) ((1 : ℝ), (0 : E))) x,
                ∇ (fun y => U (t₀, y)) x⟫
            - (fderiv ℝ (fun p : ℝ × E => fderiv ℝ G p ((1 : ℝ), (0 : E))) (t₀, x)
                  ((1 : ℝ), (0 : E))
                - Δ (fun y => fderiv ℝ G (t₀, y) ((1 : ℝ), (0 : E))) x
                - (⟪∇ (fun y => fderiv ℝ G (t₀, y) ((1 : ℝ), (0 : E))) x,
                      ∇ (fun y => G (t₀, y)) x⟫
                  + ⟪∇ (fun y => G (t₀, y)) x,
                      ∇ (fun y => fderiv ℝ G (t₀, y) ((1 : ℝ), (0 : E))) x⟫)) / 2
              * U (t₀, x))) t₀ := by
  have hU3 : ContDiff ℝ 3 U := hU.of_le (by norm_cast <;> exact le_top)
  have hG2 : ContDiff ℝ 2 G := hG.of_le (by norm_cast <;> exact le_top)
  have hU2 : ContDiff ℝ 2 U := hU.of_le (by norm_cast <;> exact le_top)
  have hΔ := hasDerivAt_laplacian_slice hU3 t₀ x
  have hinner := hasDerivAt_slice_inner hG2 hU2 t₀ x
  have hFdiv := (hasDerivAt_slice_F hG t₀ x).div_const 2
  have hUc := hasDerivAt_curve (hU.differentiable (by norm_num) (t₀, x))
  convert (hΔ.add hinner).sub (hFdiv.mul hUc) using 1
  ring

end CommutatorTime



/-! ### Ladder-6b-γ: the Bochner IBP collapse

The spatial commutator part, integrated against `u·e^g`, collapses to `−2∫D²g(∇u,∇u)e^g` (the
`A + B` exact cancellation). γ-i is the reusable workhorse: a weighted directional integration
by parts where the exponential weight contributes the `∂ᵥg` term. -/

section CommutatorIBP

open MeasureTheory Real Laplacian InnerProductSpace
open scoped RealInnerProductSpace Gradient

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
  [FiniteDimensional ℝ E] [MeasurableSpace E] [BorelSpace E] [CompleteSpace E]

/-- **(γ-i) Weighted directional integration by parts:** for `φ` C¹ compactly supported, `ψ, g`
    C¹, and a direction `v`,
    `∫ (∂ᵥφ)·ψ·e^g = −∫ φ·(∂ᵥψ + ψ·∂ᵥg)·e^g`.
    The exponential weight `e^g` contributes the `ψ·∂ᵥg` term (from `∂ᵥ e^g = (∂ᵥg) e^g`). -/
theorem integral_fderiv_mul_weight {φ ψ g : E → ℝ} (v : E)
    (hφ : ContDiff ℝ 1 φ) (hcφ : HasCompactSupport φ)
    (hψ : ContDiff ℝ 1 ψ) (hg : ContDiff ℝ 1 g) :
    ∫ x, fderiv ℝ φ x v * ψ x * exp (g x)
      = - ∫ x, φ x * (fderiv ℝ ψ x v + ψ x * fderiv ℝ g x v) * exp (g x) := by
  classical
  -- the weight factor and its directional derivative
  have hexp : ∀ x, HasFDerivAt (fun y => exp (g y)) (exp (g x) • fderiv ℝ g x) x := fun x =>
    (Real.hasDerivAt_exp (g x)).comp_hasFDerivAt x (hg.differentiable one_ne_zero x).hasFDerivAt
  have hWfd : ∀ x, HasFDerivAt (fun y => ψ y * exp (g y))
      (ψ x • (exp (g x) • fderiv ℝ g x) + exp (g x) • fderiv ℝ ψ x) x := fun x =>
    (hψ.differentiable one_ne_zero x).hasFDerivAt.mul (hexp x)
  have hW : ∀ x, fderiv ℝ (fun y => ψ y * exp (g y)) x v
      = (fderiv ℝ ψ x v + ψ x * fderiv ℝ g x v) * exp (g x) := by
    intro x
    rw [(hWfd x).fderiv]
    simp only [ContinuousLinearMap.add_apply, ContinuousLinearMap.smul_apply, smul_eq_mul]
    ring
  -- continuity package
  have hcφ' : Continuous (fun x => fderiv ℝ φ x v) :=
    (ContinuousLinearMap.apply ℝ ℝ v).continuous.comp (hφ.continuous_fderiv one_ne_zero)
  have hcW : Continuous (fun x => ψ x * exp (g x)) :=
    hψ.continuous.mul (Real.continuous_exp.comp hg.continuous)
  have hcWfd : Continuous (fun x => fderiv ℝ (fun y => ψ y * exp (g y)) x v) := by
    have : (fun x => fderiv ℝ (fun y => ψ y * exp (g y)) x v)
        = fun x => (fderiv ℝ ψ x v + ψ x * fderiv ℝ g x v) * exp (g x) := funext hW
    rw [this]
    exact ((((ContinuousLinearMap.apply ℝ ℝ v).continuous.comp
        (hψ.continuous_fderiv one_ne_zero)).add
      (hψ.continuous.mul ((ContinuousLinearMap.apply ℝ ℝ v).continuous.comp
        (hg.continuous_fderiv one_ne_zero)))).mul (Real.continuous_exp.comp hg.continuous))
  -- integrability discharge (everything carries a `φ`/`∂φ` factor supported in `tsupport φ`)
  have hInt : ∀ h : E → ℝ, Continuous h → Function.support h ⊆ tsupport φ →
      Integrable h (volume : Measure E) := fun h hc hs =>
    hc.integrable_of_hasCompactSupport (hcφ.mono' hs)
  have hsdφ : Function.support (fun x => fderiv ℝ φ x v) ⊆ tsupport φ := by
    intro x hx
    have : fderiv ℝ φ x ≠ 0 := fun h0 => hx (by simp [h0])
    exact support_fderiv_subset ℝ (Function.mem_support.mpr this)
  have hIBP := integral_mul_fderiv_eq_neg_fderiv_mul_of_integrable
    (μ := (volume : Measure E)) (f := φ) (g := fun x => ψ x * exp (g x)) (v := v)
    (hInt _ (hcφ'.mul hcW) ((Function.support_mul_subset_left _ _).trans hsdφ))
    (hInt _ (hφ.continuous.mul hcWfd)
      ((Function.support_mul_subset_left _ _).trans subset_closure))
    (hInt _ (hφ.continuous.mul hcW)
      ((Function.support_mul_subset_left _ _).trans subset_closure))
    (fun x _ => hφ.differentiable one_ne_zero x)
    (fun x _ => (hWfd x).differentiableAt)
  -- assemble: rewrite both sides to the IBP shape
  have hL : (∫ x, fderiv ℝ φ x v * ψ x * exp (g x))
      = ∫ x, fderiv ℝ φ x v * (ψ x * exp (g x)) := by
    refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_); ring
  have hR : (∫ x, φ x * (fderiv ℝ ψ x v + ψ x * fderiv ℝ g x v) * exp (g x))
      = ∫ x, φ x * fderiv ℝ (fun y => ψ y * exp (g y)) x v := by
    refine integral_congr_ae (Filter.Eventually.of_forall fun x => ?_)
    show φ x * (fderiv ℝ ψ x v + ψ x * fderiv ℝ g x v) * exp (g x)
        = φ x * fderiv ℝ (fun y => ψ y * exp (g y)) x v
    rw [hW]; ring
  rw [hL, hR, hIBP, neg_neg]

/-- **(γ-ii core) Weighted Green identity for a triple product** — the workhorse for the `A`
    collapse. For `b` C¹ compactly supported, `a` C², `c, g` C¹:
    `∫ ⟪∇a,∇b⟫·c·e^g = −∫ b·(Δa·c + ⟪∇a,∇c⟫ + c·⟪∇a,∇g⟫)·e^g`.
    Each basis-direction IBP (`integral_fderiv_mul_weight`) moves `∂ᵢ` off `b`; the `i`-sums
    repackage into `Δa`, `⟪∇a,∇c⟫`, `⟪∇a,∇g⟫`. -/
theorem integral_inner_grad_mul_weight {a b c g : E → ℝ}
    (ha : ContDiff ℝ 2 a) (hb : ContDiff ℝ 1 b) (hcb : HasCompactSupport b)
    (hc : ContDiff ℝ 1 c) (hg : ContDiff ℝ 1 g) :
    ∫ x, ⟪∇ a x, ∇ b x⟫ * c x * exp (g x)
      = - ∫ x, b x * (Δ a x * c x + ⟪∇ a x, ∇ c x⟫ + c x * ⟪∇ a x, ∇ g x⟫) * exp (g x) := by
  classical
  set bb := stdOrthonormalBasis ℝ E with hbb
  have ha1 : ContDiff ℝ 1 a := ha.of_le (by norm_num)
  have hfda1 : ContDiff ℝ 1 (fderiv ℝ a) := ha.fderiv_right (by norm_num)
  have hψc : ∀ i, ContDiff ℝ 1 (fun y => fderiv ℝ a y (bb i) * c y) := fun i =>
    ((ContinuousLinearMap.apply ℝ ℝ (bb i)).contDiff.comp hfda1).mul hc
  have hω : Continuous (fun x => exp (g x)) := Real.continuous_exp.comp hg.continuous
  have hcb_d : ∀ i, Continuous (fun x => fderiv ℝ b x (bb i)) := fun i =>
    (ContinuousLinearMap.apply ℝ ℝ (bb i)).continuous.comp (hb.continuous_fderiv one_ne_zero)
  have hca_d : ∀ i, Continuous (fun x => fderiv ℝ a x (bb i)) := fun i =>
    (ContinuousLinearMap.apply ℝ ℝ (bb i)).continuous.comp (ha1.continuous_fderiv one_ne_zero)
  have hcg_d : ∀ i, Continuous (fun x => fderiv ℝ g x (bb i)) := fun i =>
    (ContinuousLinearMap.apply ℝ ℝ (bb i)).continuous.comp (hg.continuous_fderiv one_ne_zero)
  have hcψ_d : ∀ i, Continuous (fun x => fderiv ℝ (fun y => fderiv ℝ a y (bb i) * c y) x (bb i)) :=
    fun i => (ContinuousLinearMap.apply ℝ ℝ (bb i)).continuous.comp
      ((hψc i).continuous_fderiv one_ne_zero)
  have hInt : ∀ h : E → ℝ, Continuous h → Function.support h ⊆ tsupport b →
      Integrable h (volume : Measure E) := fun h hch hsh =>
    hch.integrable_of_hasCompactSupport (hcb.mono' hsh)
  have hsb : Function.support b ⊆ tsupport b := subset_closure
  have hsdb : ∀ i, Function.support (fun x => fderiv ℝ b x (bb i)) ⊆ tsupport b := by
    intro i x hx
    have : fderiv ℝ b x ≠ 0 := fun h0 => hx (by simp [h0])
    exact support_fderiv_subset ℝ (Function.mem_support.mpr this)
  -- the per-direction integrands
  have hLint : ∀ i, Integrable (fun x => fderiv ℝ b x (bb i)
      * (fderiv ℝ a x (bb i) * c x) * exp (g x)) (volume : Measure E) := fun i =>
    hInt _ (((hcb_d i).mul ((hca_d i).mul hc.continuous)).mul hω)
      ((Function.support_mul_subset_left _ _).trans
        ((Function.support_mul_subset_left _ _).trans (hsdb i)))
  have hRint : ∀ i, Integrable (fun x => b x
      * (fderiv ℝ (fun y => fderiv ℝ a y (bb i) * c y) x (bb i)
          + (fderiv ℝ a x (bb i) * c x) * fderiv ℝ g x (bb i)) * exp (g x))
      (volume : Measure E) := fun i =>
    hInt _ ((hb.continuous.mul ((hcψ_d i).add
      (((hca_d i).mul hc.continuous).mul (hcg_d i)))).mul hω)
      ((Function.support_mul_subset_left _ _).trans
        ((Function.support_mul_subset_left _ _).trans hsb))
  -- per-direction IBP via γ-i
  have hpi : ∀ i, (∫ x, fderiv ℝ b x (bb i) * (fderiv ℝ a x (bb i) * c x) * exp (g x))
      = - ∫ x, b x * (fderiv ℝ (fun y => fderiv ℝ a y (bb i) * c y) x (bb i)
          + (fderiv ℝ a x (bb i) * c x) * fderiv ℝ g x (bb i)) * exp (g x) := fun i =>
    integral_fderiv_mul_weight (bb i) hb hcb (hψc i) hg
  -- product rule for the per-`i` ψ-derivative
  have hψfd : ∀ (i : Fin (Module.finrank ℝ E)) (x : E),
      fderiv ℝ (fun y => fderiv ℝ a y (bb i) * c y) x (bb i)
      = iteratedFDeriv ℝ 2 a x ![bb i, bb i] * c x + fderiv ℝ a x (bb i) * fderiv ℝ c x (bb i) := by
    intro i x
    have hd : DifferentiableAt ℝ (fun y => fderiv ℝ a y (bb i)) x :=
      ((ContinuousLinearMap.apply ℝ ℝ (bb i)).differentiable.comp
        (hfda1.differentiable one_ne_zero)) x
    have hmul : HasFDerivAt (fun y => fderiv ℝ a y (bb i) * c y) _ x :=
      HasFDerivAt.mul hd.hasFDerivAt (hc.differentiable one_ne_zero x).hasFDerivAt
    rw [hmul.fderiv, ContinuousLinearMap.add_apply,
        ContinuousLinearMap.smul_apply, ContinuousLinearMap.smul_apply, smul_eq_mul, smul_eq_mul,
        fderiv_fderiv_dir ha x (bb i) (bb i)]
    ring
  -- LHS as a finite sum of integrals
  have hLHS : (∫ x, ⟪∇ a x, ∇ b x⟫ * c x * exp (g x))
      = ∑ i, ∫ x, fderiv ℝ b x (bb i) * (fderiv ℝ a x (bb i) * c x) * exp (g x) := by
    rw [show (fun x => ⟪∇ a x, ∇ b x⟫ * c x * exp (g x))
        = fun x => ∑ i, fderiv ℝ b x (bb i) * (fderiv ℝ a x (bb i) * c x) * exp (g x) from
      funext fun x => by
        rw [inner_grad_eq_sum (ha1.differentiable one_ne_zero x)
              (hb.differentiable one_ne_zero x), Finset.sum_mul, Finset.sum_mul]
        exact Finset.sum_congr rfl fun i _ => by ring]
    exact integral_finsetSum _ (fun i _ => hLint i)
  -- RHS as a finite sum of integrals
  have hRHS : (∫ x, b x * (Δ a x * c x + ⟪∇ a x, ∇ c x⟫ + c x * ⟪∇ a x, ∇ g x⟫) * exp (g x))
      = ∑ i, ∫ x, b x * (fderiv ℝ (fun y => fderiv ℝ a y (bb i) * c y) x (bb i)
          + (fderiv ℝ a x (bb i) * c x) * fderiv ℝ g x (bb i)) * exp (g x) := by
    rw [show (fun x => b x * (Δ a x * c x + ⟪∇ a x, ∇ c x⟫ + c x * ⟪∇ a x, ∇ g x⟫) * exp (g x))
        = fun x => ∑ i, b x * (fderiv ℝ (fun y => fderiv ℝ a y (bb i) * c y) x (bb i)
            + (fderiv ℝ a x (bb i) * c x) * fderiv ℝ g x (bb i)) * exp (g x) from
      funext fun x => by
        rw [congrFun (laplacian_eq_iteratedFDeriv_orthonormalBasis a bb) x,
            inner_grad_eq_sum (ha1.differentiable one_ne_zero x) (hc.differentiable one_ne_zero x),
            inner_grad_eq_sum (ha1.differentiable one_ne_zero x) (hg.differentiable one_ne_zero x)]
        simp only [Finset.sum_mul, Finset.mul_sum, mul_add, add_mul]
        rw [← Finset.sum_add_distrib, ← Finset.sum_add_distrib]
        refine Finset.sum_congr rfl fun i _ => ?_
        rw [hψfd i x]; ring]
    exact integral_finsetSum _ (fun i _ => hRint i)
  rw [hLHS, hRHS, Finset.sum_congr rfl (fun i _ => hpi i), ← Finset.sum_neg_distrib]

/-- **(γ-ii completion: the `A`-collapse)** — `A/2 = ∫⟨D²g,D²u⟩_HS·u·e^g` (written
    `∑ⱼ ∫⟪∇∂ⱼg, ∇∂ⱼu⟫·u·e^g`) collapses, via the triple-product Green identity per-`j` plus the
    spatial Clairaut swap `Δ(∂ⱼg) = ∂ⱼ(Δg)` (6b-α), to
    `−∫⟪∇u,∇Δg⟫u·e^g − ∫D²g(∇u,∇u)·e^g − ∫D²g(∇g,∇u)u·e^g`
    (the Hessian forms in single-sum coordinates). -/
theorem integral_hessianHS_collapse {u g : E → ℝ} (hu : ContDiff ℝ 2 u)
    (hcu : HasCompactSupport u) (hg : ContDiff ℝ 3 g) :
    (∑ j, ∫ x, ⟪∇ (fun y => fderiv ℝ g y (stdOrthonormalBasis ℝ E j)) x,
        ∇ (fun y => fderiv ℝ u y (stdOrthonormalBasis ℝ E j)) x⟫ * u x * exp (g x))
      = - (∫ x, ⟪∇ u x, ∇ (Δ g) x⟫ * u x * exp (g x))
        - (∫ x, (∑ j, fderiv ℝ u x (stdOrthonormalBasis ℝ E j)
            * ⟪∇ (fun y => fderiv ℝ g y (stdOrthonormalBasis ℝ E j)) x, ∇ u x⟫) * exp (g x))
        - (∫ x, (∑ j, fderiv ℝ u x (stdOrthonormalBasis ℝ E j)
            * ⟪∇ (fun y => fderiv ℝ g y (stdOrthonormalBasis ℝ E j)) x, ∇ g x⟫)
            * u x * exp (g x)) := by
  classical
  set sob := stdOrthonormalBasis ℝ E with hsob
  have hu1 : ContDiff ℝ 1 u := hu.of_le (by norm_num)
  have hg1 : ContDiff ℝ 1 g := hg.of_le (by norm_num)
  have hfdg2 : ContDiff ℝ 2 (fderiv ℝ g) := hg.fderiv_right (by norm_num)
  have hfdu1 : ContDiff ℝ 1 (fderiv ℝ u) := hu.fderiv_right (by norm_num)
  have hag : ∀ j, ContDiff ℝ 2 (fun y => fderiv ℝ g y (sob j)) := fun j =>
    (ContinuousLinearMap.apply ℝ ℝ (sob j)).contDiff.comp hfdg2
  have hbu : ∀ j, ContDiff ℝ 1 (fun y => fderiv ℝ u y (sob j)) := fun j =>
    (ContinuousLinearMap.apply ℝ ℝ (sob j)).contDiff.comp hfdu1
  have hcbu : ∀ j, HasCompactSupport (fun y => fderiv ℝ u y (sob j)) := fun j =>
    hcu.fderiv_apply (𝕜 := ℝ) (sob j)
  -- `Δg` is C¹ (basis formula) ⇒ differentiable; `∇(Δg)` continuous
  have hΔg1 : ContDiff ℝ 1 (Δ g) := by
    have he : (Δ g) = fun y => ∑ i, iteratedFDeriv ℝ 2 g y ![sob i, sob i] :=
      funext fun y => congrFun (laplacian_eq_iteratedFDeriv_orthonormalBasis g sob) y
    rw [he]
    exact ContDiff.sum fun i _ =>
      (ContinuousMultilinearMap.apply ℝ (fun _ : Fin 2 => E) ℝ ![sob i, sob i]).contDiff.comp
        (hg.iteratedFDeriv_right (by norm_cast))
  -- continuity package
  have hω : Continuous (fun x => exp (g x)) := Real.continuous_exp.comp hg.continuous
  have hcu' : Continuous (∇ u) :=
    (LinearIsometryEquiv.continuous _).comp (hu1.continuous_fderiv one_ne_zero)
  have hcg' : Continuous (∇ g) :=
    (LinearIsometryEquiv.continuous _).comp (hg1.continuous_fderiv one_ne_zero)
  have hcΔg' : Continuous (∇ (Δ g)) :=
    (LinearIsometryEquiv.continuous _).comp (hΔg1.continuous_fderiv one_ne_zero)
  have hc_du : ∀ j, Continuous (fun x => fderiv ℝ u x (sob j)) := fun j =>
    (ContinuousLinearMap.apply ℝ ℝ (sob j)).continuous.comp (hu1.continuous_fderiv one_ne_zero)
  have hc_gradag : ∀ j, Continuous (∇ (fun y => fderiv ℝ g y (sob j))) := fun j =>
    (LinearIsometryEquiv.continuous _).comp ((hag j).continuous_fderiv (by norm_num))
  have hc_Δag : ∀ j, Continuous (Δ (fun y => fderiv ℝ g y (sob j))) := fun j =>
    WeightedGreenAux.continuous_laplacian (hag j)
  -- vanishing off `tsupport u`
  have hfdu0 : ∀ x, x ∉ tsupport u → fderiv ℝ u x = 0 := fun x hx => by
    by_contra h0
    exact hx (support_fderiv_subset ℝ (Function.mem_support.mpr h0))
  have hu0 : ∀ x, x ∉ tsupport u → u x = 0 := fun x hx =>
    image_eq_zero_of_notMem_tsupport hx
  -- per-`j` triple-product Green identity (the core lemma)
  have hpj : ∀ j, (∫ x, ⟪∇ (fun y => fderiv ℝ g y (sob j)) x,
        ∇ (fun y => fderiv ℝ u y (sob j)) x⟫ * u x * exp (g x))
      = - ∫ x, fderiv ℝ u x (sob j)
          * (Δ (fun y => fderiv ℝ g y (sob j)) x * u x
            + ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ u x⟫
            + u x * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ g x⟫) * exp (g x) := fun j =>
    integral_inner_grad_mul_weight (hag j) (hbu j) (hcbu j) hu1 hg1
  have hVint : ∀ j, Integrable (fun x => fderiv ℝ u x (sob j)
      * (Δ (fun y => fderiv ℝ g y (sob j)) x * u x
        + ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ u x⟫
        + u x * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ g x⟫) * exp (g x))
      (volume : Measure E) := fun j => by
    exact ((((hc_du j).mul ((((hc_Δag j).mul hu1.continuous).add
        ((hc_gradag j).inner hcu')).add
          (hu1.continuous.mul ((hc_gradag j).inner hcg')))).mul hω)).integrable_of_hasCompactSupport
      (μ := (volume : Measure E)) (HasCompactSupport.intro hcu fun x hx => by simp [hfdu0 x hx, hu0 x hx])
  have hT1int : Integrable (fun x => ⟪∇ u x, ∇ (Δ g) x⟫ * u x * exp (g x)) (volume : Measure E) := by
    exact (((hcu'.inner hcΔg').mul hu1.continuous).mul hω).integrable_of_hasCompactSupport
      (HasCompactSupport.intro hcu fun x hx => by simp [hfdu0 x hx, hu0 x hx])
  have hT2int : Integrable (fun x => (∑ j, fderiv ℝ u x (sob j)
      * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ u x⟫) * exp (g x)) (volume : Measure E) := by
    exact ((continuous_finset_sum _ fun j _ => (hc_du j).mul ((hc_gradag j).inner hcu')).mul
      hω).integrable_of_hasCompactSupport
      (HasCompactSupport.intro hcu fun x hx => by simp [hfdu0 x hx, hu0 x hx])
  have hT3int : Integrable (fun x => (∑ j, fderiv ℝ u x (sob j)
      * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ g x⟫) * u x * exp (g x)) (volume : Measure E) := by
    exact (((continuous_finset_sum _ fun j _ => (hc_du j).mul ((hc_gradag j).inner hcg')).mul
      hu1.continuous).mul hω).integrable_of_hasCompactSupport
      (HasCompactSupport.intro hcu fun x hx => by simp [hfdu0 x hx, hu0 x hx])
  -- collapse
  rw [Finset.sum_congr rfl (fun j _ => hpj j), Finset.sum_neg_distrib,
      ← integral_finsetSum _ (fun j _ => hVint j)]
  have hcl : ∀ (x : E) j, Δ (fun y => fderiv ℝ g y (sob j)) x = fderiv ℝ (Δ g) x (sob j) :=
    fun x j => laplacian_deriv_swap hg x (sob j)
  have hpt : ∀ x, (∑ j, fderiv ℝ u x (sob j)
        * (Δ (fun y => fderiv ℝ g y (sob j)) x * u x
          + ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ u x⟫
          + u x * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ g x⟫) * exp (g x))
      = (⟪∇ u x, ∇ (Δ g) x⟫ * u x
          + (∑ j, fderiv ℝ u x (sob j) * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ u x⟫)
          + (∑ j, fderiv ℝ u x (sob j) * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ g x⟫) * u x)
        * exp (g x) := by
    intro x
    have h1 : (∑ j, fderiv ℝ u x (sob j) * fderiv ℝ (Δ g) x (sob j)) = ⟪∇ u x, ∇ (Δ g) x⟫ :=
      (inner_grad_eq_sum (hu1.differentiable one_ne_zero x)
        (hΔg1.differentiable one_ne_zero x)).symm
    have e1 : (∑ j, fderiv ℝ u x (sob j) * (Δ (fun y => fderiv ℝ g y (sob j)) x * u x))
        = ⟪∇ u x, ∇ (Δ g) x⟫ * u x := by
      rw [show (∑ j, fderiv ℝ u x (sob j) * (Δ (fun y => fderiv ℝ g y (sob j)) x * u x))
          = (∑ j, fderiv ℝ u x (sob j) * fderiv ℝ (Δ g) x (sob j)) * u x from by
        rw [Finset.sum_mul]; exact Finset.sum_congr rfl fun j _ => by rw [hcl x j]; ring, h1]
    have e3 : (∑ j, fderiv ℝ u x (sob j)
          * (u x * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ g x⟫))
        = (∑ j, fderiv ℝ u x (sob j)
            * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ g x⟫) * u x := by
      rw [Finset.sum_mul]; exact Finset.sum_congr rfl fun j _ => by ring
    rw [← Finset.sum_mul]
    congr 1
    simp only [mul_add]
    rw [Finset.sum_add_distrib, Finset.sum_add_distrib, e1, e3]
  have hT12int : Integrable (fun x => ⟪∇ u x, ∇ (Δ g) x⟫ * u x * exp (g x)
      + (∑ j, fderiv ℝ u x (sob j)
          * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ u x⟫) * exp (g x))
      (volume : Measure E) := hT1int.add hT2int
  rw [integral_congr_ae (Filter.Eventually.of_forall hpt),
      show (fun x => (⟪∇ u x, ∇ (Δ g) x⟫ * u x
            + (∑ j, fderiv ℝ u x (sob j) * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ u x⟫)
            + (∑ j, fderiv ℝ u x (sob j) * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ g x⟫) * u x)
          * exp (g x))
        = fun x => (⟪∇ u x, ∇ (Δ g) x⟫ * u x * exp (g x)
            + (∑ j, fderiv ℝ u x (sob j)
                * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ u x⟫) * exp (g x))
          + (∑ j, fderiv ℝ u x (sob j)
              * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ g x⟫) * u x * exp (g x)
        from funext fun x => by ring,
      integral_add hT12int hT3int, integral_add hT1int hT2int]
  ring

/-- **(γ-iii) The gradient of `‖∇g‖²`** paired with `∇u`: `⟪∇‖∇g‖², ∇u⟫ = 2·D²g(∇g,∇u)`
    (the latter in γ-ii's single-`j`-sum form). This is the `∇‖∇g‖² = 2 D²g ∇g` identity, the
    ingredient that — via `−⟪∇F,∇u⟫` — produces the `+2 D²g(∇g,∇u)` cancelling the `A`-collapse's
    `−2 D²g(∇g,∇u)`. The Hessian symmetry (Schwarz) reconciles the two index orders. -/
theorem inner_grad_normSq_eq {u g : E → ℝ} (hu : ContDiff ℝ 1 u) (hg : ContDiff ℝ 2 g) (x : E) :
    ⟪∇ (fun y => (⟪∇ g y, ∇ g y⟫ : ℝ)) x, ∇ u x⟫
      = 2 * ∑ j, fderiv ℝ u x (stdOrthonormalBasis ℝ E j)
          * ⟪∇ (fun y => fderiv ℝ g y (stdOrthonormalBasis ℝ E j)) x, ∇ g x⟫ := by
  classical
  set sob := stdOrthonormalBasis ℝ E with hsob
  have hg1 : ContDiff ℝ 1 g := hg.of_le (by norm_num)
  have hfdg1 : ContDiff ℝ 1 (fderiv ℝ g) := hg.fderiv_right (by norm_num)
  have hagd : ∀ i, DifferentiableAt ℝ (fun y => fderiv ℝ g y (sob i)) x := fun i =>
    ((ContinuousLinearMap.apply ℝ ℝ (sob i)).differentiable.comp
      (hfdg1.differentiable one_ne_zero)) x
  have hsymmg : IsSymmSndFDerivAt ℝ g x := hg.contDiffAt.isSymmSndFDerivAt (by simp)
  have hnormsq : (fun y => (⟪∇ g y, ∇ g y⟫ : ℝ))
      = fun y => ∑ i, fderiv ℝ g y (sob i) * fderiv ℝ g y (sob i) := by
    funext y
    exact inner_grad_eq_sum (hg1.differentiable one_ne_zero y) (hg1.differentiable one_ne_zero y)
  have hnsq_diff : DifferentiableAt ℝ (fun y => (⟪∇ g y, ∇ g y⟫ : ℝ)) x := by
    rw [hnormsq]; exact DifferentiableAt.fun_sum fun i _ => (hagd i).mul (hagd i)
  have hpartial : ∀ j, fderiv ℝ (fun y => (⟪∇ g y, ∇ g y⟫ : ℝ)) x (sob j)
      = ∑ i, 2 * (fderiv ℝ g x (sob i) * iteratedFDeriv ℝ 2 g x ![sob j, sob i]) := by
    intro j
    rw [hnormsq, fderiv_fun_sum (fun i _ => show DifferentiableAt ℝ
          (fun y => fderiv ℝ g y (sob i) * fderiv ℝ g y (sob i)) x from (hagd i).mul (hagd i)),
        ContinuousLinearMap.sum_apply]
    refine Finset.sum_congr rfl fun i _ => ?_
    have hm : HasFDerivAt (fun y => fderiv ℝ g y (sob i) * fderiv ℝ g y (sob i)) _ x :=
      HasFDerivAt.mul (hagd i).hasFDerivAt (hagd i).hasFDerivAt
    rw [hm.fderiv, ContinuousLinearMap.add_apply]
    simp only [ContinuousLinearMap.smul_apply, smul_eq_mul]
    rw [fderiv_fderiv_dir hg x (sob j) (sob i)]
    ring
  rw [inner_grad_eq_sum hnsq_diff (hu.differentiable one_ne_zero x), Finset.mul_sum]
  refine Finset.sum_congr rfl fun j _ => ?_
  rw [hpartial j, inner_grad_eq_sum (hagd j) (hg1.differentiable one_ne_zero x),
      Finset.sum_mul, Finset.mul_sum, Finset.mul_sum]
  refine Finset.sum_congr rfl fun i _ => ?_
  rw [fderiv_fderiv_dir hg x (sob i) (sob j),
      show iteratedFDeriv ℝ 2 g x ![sob j, sob i] = iteratedFDeriv ℝ 2 g x ![sob i, sob j] from
        IsSymmSndFDerivAt.iteratedFDeriv_cons (hf := hsymmg)]
  ring

/-- **(6b-δ core) The `A + B` cancellation.** Twice the `A`-collapse (γ-ii) plus the `B`-integral
    `∫(2⟪∇u,∇Δg⟫ + 2 D²g(∇g,∇u))·u·e^g` collapses to `−2∫D²g(∇u,∇u)·e^g`: the `⟪∇u,∇Δg⟫` terms
    cancel (`2` from B against `−2` from `2·A`), and the `D²g(∇g,∇u)` terms cancel (`+2` from B
    against `−2` from `2·A`), leaving only `−2 D²g(∇u,∇u)`. Pure integral arithmetic on top of γ-ii. -/
theorem integral_AB_collapse {u g : E → ℝ} (hu : ContDiff ℝ 2 u)
    (hcu : HasCompactSupport u) (hg : ContDiff ℝ 3 g) :
    2 * (∑ j, ∫ x, ⟪∇ (fun y => fderiv ℝ g y (stdOrthonormalBasis ℝ E j)) x,
          ∇ (fun y => fderiv ℝ u y (stdOrthonormalBasis ℝ E j)) x⟫ * u x * exp (g x))
      + ∫ x, (2 * ⟪∇ u x, ∇ (Δ g) x⟫
          + 2 * ∑ j, fderiv ℝ u x (stdOrthonormalBasis ℝ E j)
              * ⟪∇ (fun y => fderiv ℝ g y (stdOrthonormalBasis ℝ E j)) x, ∇ g x⟫)
          * u x * exp (g x)
      = -2 * ∫ x, (∑ j, fderiv ℝ u x (stdOrthonormalBasis ℝ E j)
          * ⟪∇ (fun y => fderiv ℝ g y (stdOrthonormalBasis ℝ E j)) x, ∇ u x⟫) * exp (g x) := by
  classical
  set sob := stdOrthonormalBasis ℝ E with hsob
  have hu1 : ContDiff ℝ 1 u := hu.of_le (by norm_num)
  have hg1 : ContDiff ℝ 1 g := hg.of_le (by norm_num)
  have hfdg1 : ContDiff ℝ 1 (fderiv ℝ g) := hg.fderiv_right (by norm_num)
  have hΔg1 : ContDiff ℝ 1 (Δ g) := by
    have he : (Δ g) = fun y => ∑ i, iteratedFDeriv ℝ 2 g y ![sob i, sob i] :=
      funext fun y => congrFun (laplacian_eq_iteratedFDeriv_orthonormalBasis g sob) y
    rw [he]
    exact ContDiff.sum fun i _ =>
      (ContinuousMultilinearMap.apply ℝ (fun _ : Fin 2 => E) ℝ ![sob i, sob i]).contDiff.comp
        (hg.iteratedFDeriv_right (by norm_cast))
  have hω : Continuous (fun x => exp (g x)) := Real.continuous_exp.comp hg.continuous
  have hcu' : Continuous (∇ u) :=
    (LinearIsometryEquiv.continuous _).comp (hu1.continuous_fderiv one_ne_zero)
  have hcg' : Continuous (∇ g) :=
    (LinearIsometryEquiv.continuous _).comp (hg1.continuous_fderiv one_ne_zero)
  have hcΔg' : Continuous (∇ (Δ g)) :=
    (LinearIsometryEquiv.continuous _).comp (hΔg1.continuous_fderiv one_ne_zero)
  have hc_du : ∀ j, Continuous (fun x => fderiv ℝ u x (sob j)) := fun j =>
    (ContinuousLinearMap.apply ℝ ℝ (sob j)).continuous.comp (hu1.continuous_fderiv one_ne_zero)
  have hc_gradag : ∀ j, Continuous (∇ (fun y => fderiv ℝ g y (sob j))) := fun j =>
    (LinearIsometryEquiv.continuous _).comp
      ((((ContinuousLinearMap.apply ℝ ℝ (sob j)).contDiff.comp hfdg1)).continuous_fderiv one_ne_zero)
  have hfdu0 : ∀ x, x ∉ tsupport u → fderiv ℝ u x = 0 := fun x hx => by
    by_contra h0; exact hx (support_fderiv_subset ℝ (Function.mem_support.mpr h0))
  have hu0 : ∀ x, x ∉ tsupport u → u x = 0 := fun x hx => image_eq_zero_of_notMem_tsupport hx
  -- I_Δ integrable
  have hI1 : Integrable (fun x => ⟪∇ u x, ∇ (Δ g) x⟫ * u x * exp (g x)) (volume : Measure E) := by
    exact (((hcu'.inner hcΔg').mul hu1.continuous).mul hω).integrable_of_hasCompactSupport
      (HasCompactSupport.intro hcu fun x hx => by simp [hfdu0 x hx, hu0 x hx])
  -- I_HSgu integrable
  have hI3 : Integrable (fun x => (∑ j, fderiv ℝ u x (sob j)
      * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ g x⟫) * u x * exp (g x)) (volume : Measure E) := by
    exact (((continuous_finset_sum _ fun j _ => (hc_du j).mul ((hc_gradag j).inner hcg')).mul
      hu1.continuous).mul hω).integrable_of_hasCompactSupport
      (HasCompactSupport.intro hcu fun x hx => by simp [hfdu0 x hx, hu0 x hx])
  have hBsplit : (∫ x, (2 * ⟪∇ u x, ∇ (Δ g) x⟫
        + 2 * ∑ j, fderiv ℝ u x (sob j)
            * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ g x⟫) * u x * exp (g x))
      = 2 * (∫ x, ⟪∇ u x, ∇ (Δ g) x⟫ * u x * exp (g x))
        + 2 * (∫ x, (∑ j, fderiv ℝ u x (sob j)
            * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ g x⟫) * u x * exp (g x)) := by
    rw [show (fun x => (2 * ⟪∇ u x, ∇ (Δ g) x⟫
          + 2 * ∑ j, fderiv ℝ u x (sob j)
              * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ g x⟫) * u x * exp (g x))
        = fun x => 2 * (⟪∇ u x, ∇ (Δ g) x⟫ * u x * exp (g x))
            + 2 * ((∑ j, fderiv ℝ u x (sob j)
                * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ g x⟫) * u x * exp (g x))
        from funext fun x => by ring,
      integral_add (hI1.const_mul 2) (hI3.const_mul 2), integral_const_mul, integral_const_mul]
  rw [integral_hessianHS_collapse hu hcu hg, hBsplit]
  ring

/-- **(6b-δ step 1: the integrated gradient+HS commutator collapse)** — with the Hilbert–Schmidt
    term written as a pointwise basis sum inside the integral:
    `∫ (2 Σⱼ⟪∇∂ⱼg,∇∂ⱼu⟫ + 2⟪∇u,∇Δg⟫ + 2 D²g(∇g,∇u))·u·e^g = −2∫D²g(∇u,∇u)·e^g`.
    Just `integral_AB_collapse` after moving the HS sum inside the integral. The `−½(LF)u²`
    potential term of `⟨[L,S]u,u⟩` rides along trivially (it pairs `u·u = u²`). -/
theorem integral_gradHS_collapse {u g : E → ℝ} (hu : ContDiff ℝ 2 u)
    (hcu : HasCompactSupport u) (hg : ContDiff ℝ 3 g) :
    (∫ x, (2 * (∑ j, ⟪∇ (fun y => fderiv ℝ g y (stdOrthonormalBasis ℝ E j)) x,
            ∇ (fun y => fderiv ℝ u y (stdOrthonormalBasis ℝ E j)) x⟫)
        + 2 * ⟪∇ u x, ∇ (Δ g) x⟫
        + 2 * ∑ j, fderiv ℝ u x (stdOrthonormalBasis ℝ E j)
            * ⟪∇ (fun y => fderiv ℝ g y (stdOrthonormalBasis ℝ E j)) x, ∇ g x⟫)
        * u x * exp (g x))
      = -2 * ∫ x, (∑ j, fderiv ℝ u x (stdOrthonormalBasis ℝ E j)
          * ⟪∇ (fun y => fderiv ℝ g y (stdOrthonormalBasis ℝ E j)) x, ∇ u x⟫) * exp (g x) := by
  classical
  set sob := stdOrthonormalBasis ℝ E with hsob
  have hu1 : ContDiff ℝ 1 u := hu.of_le (by norm_num)
  have hg1 : ContDiff ℝ 1 g := hg.of_le (by norm_num)
  have hΔg1 : ContDiff ℝ 1 (Δ g) := by
    have he : (Δ g) = fun y => ∑ i, iteratedFDeriv ℝ 2 g y ![sob i, sob i] :=
      funext fun y => congrFun (laplacian_eq_iteratedFDeriv_orthonormalBasis g sob) y
    rw [he]
    exact ContDiff.sum fun i _ =>
      (ContinuousMultilinearMap.apply ℝ (fun _ : Fin 2 => E) ℝ ![sob i, sob i]).contDiff.comp
        (hg.iteratedFDeriv_right (by norm_cast))
  have hω : Continuous (fun x => exp (g x)) := Real.continuous_exp.comp hg.continuous
  have hcu' : Continuous (∇ u) :=
    (LinearIsometryEquiv.continuous _).comp (hu1.continuous_fderiv one_ne_zero)
  have hcg' : Continuous (∇ g) :=
    (LinearIsometryEquiv.continuous _).comp (hg1.continuous_fderiv one_ne_zero)
  have hcΔg' : Continuous (∇ (Δ g)) :=
    (LinearIsometryEquiv.continuous _).comp (hΔg1.continuous_fderiv one_ne_zero)
  have hc_du : ∀ j, Continuous (fun x => fderiv ℝ u x (sob j)) := fun j =>
    (ContinuousLinearMap.apply ℝ ℝ (sob j)).continuous.comp (hu1.continuous_fderiv one_ne_zero)
  have hc_gradag : ∀ j, Continuous (∇ (fun y => fderiv ℝ g y (sob j))) := fun j =>
    (LinearIsometryEquiv.continuous _).comp
      ((((ContinuousLinearMap.apply ℝ ℝ (sob j)).contDiff.comp
        (hg.fderiv_right (by norm_num)))).continuous_fderiv one_ne_zero)
  have hc_gradau : ∀ j, Continuous (∇ (fun y => fderiv ℝ u y (sob j))) := fun j =>
    (LinearIsometryEquiv.continuous _).comp
      ((((ContinuousLinearMap.apply ℝ ℝ (sob j)).contDiff.comp
        (hu.fderiv_right (by norm_num)))).continuous_fderiv one_ne_zero)
  have hfdu0 : ∀ x, x ∉ tsupport u → fderiv ℝ u x = 0 := fun x hx => by
    by_contra h0; exact hx (support_fderiv_subset ℝ (Function.mem_support.mpr h0))
  have hu0 : ∀ x, x ∉ tsupport u → u x = 0 := fun x hx => image_eq_zero_of_notMem_tsupport hx
  -- per-`j` HS integrand integrable (carries a `u` factor)
  have hHSj : ∀ j, Integrable (fun x => ⟪∇ (fun y => fderiv ℝ g y (sob j)) x,
      ∇ (fun y => fderiv ℝ u y (sob j)) x⟫ * u x * exp (g x)) (volume : Measure E) := fun j => by
    exact ((((hc_gradag j).inner (hc_gradau j)).mul hu1.continuous).mul
      hω).integrable_of_hasCompactSupport
      (HasCompactSupport.intro hcu fun x hx => by simp [hu0 x hx])
  -- the B-integrand integrable
  have hBint : Integrable (fun x => (2 * ⟪∇ u x, ∇ (Δ g) x⟫
      + 2 * ∑ j, fderiv ℝ u x (sob j)
          * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ g x⟫) * u x * exp (g x))
      (volume : Measure E) := by
    exact ((((continuous_const.mul (hcu'.inner hcΔg')).add (continuous_const.mul
      (continuous_finset_sum _ fun j _ => (hc_du j).mul ((hc_gradag j).inner hcg')))).mul
      hu1.continuous).mul hω).integrable_of_hasCompactSupport
      (HasCompactSupport.intro hcu fun x hx => by simp [hfdu0 x hx, hu0 x hx])
  -- HS-part integrand integrable
  have hHSpart : Integrable (fun x => (2 * ∑ j, ⟪∇ (fun y => fderiv ℝ g y (sob j)) x,
      ∇ (fun y => fderiv ℝ u y (sob j)) x⟫) * u x * exp (g x)) (volume : Measure E) := by
    exact (((continuous_const.mul (continuous_finset_sum _ fun j _ =>
      (hc_gradag j).inner (hc_gradau j))).mul hu1.continuous).mul
      hω).integrable_of_hasCompactSupport
      (HasCompactSupport.intro hcu fun x hx => by simp [hu0 x hx])
  -- ∫ (2 Σⱼ HSⱼ)·u·ω = 2 Σⱼ ∫ HSⱼ·u·ω
  have hHSswap : (∫ x, (2 * ∑ j, ⟪∇ (fun y => fderiv ℝ g y (sob j)) x,
          ∇ (fun y => fderiv ℝ u y (sob j)) x⟫) * u x * exp (g x))
      = 2 * (∑ j, ∫ x, ⟪∇ (fun y => fderiv ℝ g y (sob j)) x,
          ∇ (fun y => fderiv ℝ u y (sob j)) x⟫ * u x * exp (g x)) := by
    rw [show (fun x => (2 * ∑ j, ⟪∇ (fun y => fderiv ℝ g y (sob j)) x,
            ∇ (fun y => fderiv ℝ u y (sob j)) x⟫) * u x * exp (g x))
        = fun x => 2 * ((∑ j, ⟪∇ (fun y => fderiv ℝ g y (sob j)) x,
            ∇ (fun y => fderiv ℝ u y (sob j)) x⟫) * u x * exp (g x))
        from funext fun x => by ring, integral_const_mul]
    congr 1
    rw [show (fun x => (∑ j, ⟪∇ (fun y => fderiv ℝ g y (sob j)) x,
            ∇ (fun y => fderiv ℝ u y (sob j)) x⟫) * u x * exp (g x))
        = fun x => ∑ j, ⟪∇ (fun y => fderiv ℝ g y (sob j)) x,
            ∇ (fun y => fderiv ℝ u y (sob j)) x⟫ * u x * exp (g x)
        from funext fun x => by rw [Finset.sum_mul, Finset.sum_mul],
      integral_finsetSum _ (fun j _ => hHSj j)]
  rw [show (fun x => (2 * (∑ j, ⟪∇ (fun y => fderiv ℝ g y (sob j)) x,
          ∇ (fun y => fderiv ℝ u y (sob j)) x⟫)
        + 2 * ⟪∇ u x, ∇ (Δ g) x⟫
        + 2 * ∑ j, fderiv ℝ u x (sob j)
            * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ g x⟫) * u x * exp (g x))
      = fun x => (2 * ∑ j, ⟪∇ (fun y => fderiv ℝ g y (sob j)) x,
            ∇ (fun y => fderiv ℝ u y (sob j)) x⟫) * u x * exp (g x)
        + (2 * ⟪∇ u x, ∇ (Δ g) x⟫
            + 2 * ∑ j, fderiv ℝ u x (sob j)
                * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ g x⟫) * u x * exp (g x)
      from funext fun x => by ring,
    integral_add hHSpart hBint, hHSswap, integral_AB_collapse hu hcu hg]

/-- **(6b-δ step 1: the full commutator integral identity)** — with the post-cancellation
    commutator integrand `2 Σⱼ⟪∇∂ⱼg,∇∂ⱼu⟫ + 2⟪∇u,∇Δg⟫ + 2 D²g(∇g,∇u) − ½·LF·u` (where `LF` is
    the given function `lf`):
    `∫ (commutator integrand)·u·e^g = ∫(−2 D²g(∇u,∇u) − ½·LF·u²)·e^g`.
    The gradient+HS part collapses (`integral_gradHS_collapse`) to `−2∫D²g(∇u,∇u)`; the `−½·LF·u`
    term pairs with `u` to the `−½·LF·u²` potential term. -/
theorem integral_commutator_full {u g lf : E → ℝ} (hu : ContDiff ℝ 2 u)
    (hcu : HasCompactSupport u) (hg : ContDiff ℝ 3 g) (hlf : Continuous lf) :
    (∫ x, (2 * (∑ j, ⟪∇ (fun y => fderiv ℝ g y (stdOrthonormalBasis ℝ E j)) x,
            ∇ (fun y => fderiv ℝ u y (stdOrthonormalBasis ℝ E j)) x⟫)
        + 2 * ⟪∇ u x, ∇ (Δ g) x⟫
        + 2 * ∑ j, fderiv ℝ u x (stdOrthonormalBasis ℝ E j)
            * ⟪∇ (fun y => fderiv ℝ g y (stdOrthonormalBasis ℝ E j)) x, ∇ g x⟫
        - lf x / 2 * u x) * u x * exp (g x))
      = ∫ x, (-2 * (∑ j, fderiv ℝ u x (stdOrthonormalBasis ℝ E j)
            * ⟪∇ (fun y => fderiv ℝ g y (stdOrthonormalBasis ℝ E j)) x, ∇ u x⟫)
          - lf x / 2 * (u x) ^ 2) * exp (g x) := by
  classical
  set sob := stdOrthonormalBasis ℝ E with hsob
  have hu1 : ContDiff ℝ 1 u := hu.of_le (by norm_num)
  have hg1 : ContDiff ℝ 1 g := hg.of_le (by norm_num)
  have hΔg1 : ContDiff ℝ 1 (Δ g) := by
    have he : (Δ g) = fun y => ∑ i, iteratedFDeriv ℝ 2 g y ![sob i, sob i] :=
      funext fun y => congrFun (laplacian_eq_iteratedFDeriv_orthonormalBasis g sob) y
    rw [he]
    exact ContDiff.sum fun i _ =>
      (ContinuousMultilinearMap.apply ℝ (fun _ : Fin 2 => E) ℝ ![sob i, sob i]).contDiff.comp
        (hg.iteratedFDeriv_right (by norm_cast))
  have hω : Continuous (fun x => exp (g x)) := Real.continuous_exp.comp hg.continuous
  have hcu' : Continuous (∇ u) :=
    (LinearIsometryEquiv.continuous _).comp (hu1.continuous_fderiv one_ne_zero)
  have hcg' : Continuous (∇ g) :=
    (LinearIsometryEquiv.continuous _).comp (hg1.continuous_fderiv one_ne_zero)
  have hcΔg' : Continuous (∇ (Δ g)) :=
    (LinearIsometryEquiv.continuous _).comp (hΔg1.continuous_fderiv one_ne_zero)
  have hc_du : ∀ j, Continuous (fun x => fderiv ℝ u x (sob j)) := fun j =>
    (ContinuousLinearMap.apply ℝ ℝ (sob j)).continuous.comp (hu1.continuous_fderiv one_ne_zero)
  have hc_gradag : ∀ j, Continuous (∇ (fun y => fderiv ℝ g y (sob j))) := fun j =>
    (LinearIsometryEquiv.continuous _).comp
      ((((ContinuousLinearMap.apply ℝ ℝ (sob j)).contDiff.comp
        (hg.fderiv_right (by norm_num)))).continuous_fderiv one_ne_zero)
  have hc_gradau : ∀ j, Continuous (∇ (fun y => fderiv ℝ u y (sob j))) := fun j =>
    (LinearIsometryEquiv.continuous _).comp
      ((((ContinuousLinearMap.apply ℝ ℝ (sob j)).contDiff.comp
        (hu.fderiv_right (by norm_num)))).continuous_fderiv one_ne_zero)
  have hu0 : ∀ x, x ∉ tsupport u → u x = 0 := fun x hx => image_eq_zero_of_notMem_tsupport hx
  -- the gradient+HS integrand and the potential integrand are integrable
  have hgradHS_cont : Continuous (fun x => (2 * (∑ j, ⟪∇ (fun y => fderiv ℝ g y (sob j)) x,
        ∇ (fun y => fderiv ℝ u y (sob j)) x⟫)
      + 2 * ⟪∇ u x, ∇ (Δ g) x⟫
      + 2 * ∑ j, fderiv ℝ u x (sob j)
          * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ g x⟫) * u x * exp (g x)) :=
    ((((continuous_const.mul (continuous_finset_sum _ fun j _ =>
        (hc_gradag j).inner (hc_gradau j))).add (continuous_const.mul (hcu'.inner hcΔg'))).add
      (continuous_const.mul (continuous_finset_sum _ fun j _ =>
        (hc_du j).mul ((hc_gradag j).inner hcg')))).mul hu1.continuous).mul hω
  have hI_collapse : Integrable (fun x => (2 * (∑ j, ⟪∇ (fun y => fderiv ℝ g y (sob j)) x,
        ∇ (fun y => fderiv ℝ u y (sob j)) x⟫)
      + 2 * ⟪∇ u x, ∇ (Δ g) x⟫
      + 2 * ∑ j, fderiv ℝ u x (sob j)
          * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ g x⟫) * u x * exp (g x))
      (volume : Measure E) := by
    exact hgradHS_cont.integrable_of_hasCompactSupport
      (HasCompactSupport.intro hcu fun x hx => by simp [hu0 x hx])
  have hI_lf : Integrable (fun x => lf x / 2 * (u x) ^ 2 * exp (g x)) (volume : Measure E) := by
    exact (((hlf.div_const 2).mul (hu1.continuous.pow 2)).mul hω).integrable_of_hasCompactSupport
      (HasCompactSupport.intro hcu fun x hx => by simp [hu0 x hx])
  have hI_HSuu : Integrable (fun x => (∑ j, fderiv ℝ u x (sob j)
      * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ u x⟫) * exp (g x)) (volume : Measure E) := by
    exact ((continuous_finset_sum _ fun j _ => (hc_du j).mul ((hc_gradag j).inner hcu')).mul
      hω).integrable_of_hasCompactSupport
      (HasCompactSupport.intro hcu fun x hx => by
        have hfdu0 : fderiv ℝ u x = 0 := by
          by_contra h0; exact hx (support_fderiv_subset ℝ (Function.mem_support.mpr h0))
        simp [hfdu0])
  rw [show (fun x => (2 * (∑ j, ⟪∇ (fun y => fderiv ℝ g y (sob j)) x,
            ∇ (fun y => fderiv ℝ u y (sob j)) x⟫)
        + 2 * ⟪∇ u x, ∇ (Δ g) x⟫
        + 2 * ∑ j, fderiv ℝ u x (sob j)
            * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ g x⟫
        - lf x / 2 * u x) * u x * exp (g x))
      = fun x => (2 * (∑ j, ⟪∇ (fun y => fderiv ℝ g y (sob j)) x,
            ∇ (fun y => fderiv ℝ u y (sob j)) x⟫)
          + 2 * ⟪∇ u x, ∇ (Δ g) x⟫
          + 2 * ∑ j, fderiv ℝ u x (sob j)
              * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ g x⟫) * u x * exp (g x)
        - lf x / 2 * (u x) ^ 2 * exp (g x)
      from funext fun x => by ring,
    integral_sub hI_collapse hI_lf, integral_gradHS_collapse hu hcu hg,
    show (fun x => (-2 * (∑ j, fderiv ℝ u x (sob j)
            * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ u x⟫)
          - lf x / 2 * (u x) ^ 2) * exp (g x))
      = fun x => -2 * ((∑ j, fderiv ℝ u x (sob j)
            * ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ u x⟫) * exp (g x))
        - lf x / 2 * (u x) ^ 2 * exp (g x)
      from funext fun x => by ring,
    integral_sub (hI_HSuu.const_mul (-2)) hI_lf, integral_const_mul]

/-- **(6b-δ step 2: the pointwise spatial commutator)** — for the spatial operator
    `Sφ = Δφ + ⟪∇g,∇φ⟫ − F·φ`, the spatial commutator `Δ(Sφ) − S(Δφ)`:
    `= ⟪∇Δg,∇φ⟫ + 2⟨D²g,D²φ⟩_HS − φ·ΔF − 2⟪∇F,∇φ⟫`. Direct from the four-index identity
    (`laplacian_inner_grad`) and the Leibniz rule (`laplacian_mul`), via Laplacian additivity. The
    actual Carleman `S` carries `−½F`; the `½` scales this at assembly. -/
theorem spatial_commutator_eq {u g F : E → ℝ} (hu : ContDiff ℝ (⊤ : ℕ∞) u)
    (hg : ContDiff ℝ (⊤ : ℕ∞) g) (hF : ContDiff ℝ (⊤ : ℕ∞) F) (x : E) :
    Δ (fun y => Δ u y + ⟪∇ g y, ∇ u y⟫ - F y * u y) x
      - (Δ (Δ u) x + ⟪∇ g x, ∇ (Δ u) x⟫ - F x * Δ u x)
      = ⟪∇ (Δ g) x, ∇ u x⟫
        + 2 * ∑ i, ∑ j, iteratedFDeriv ℝ 2 g x ![stdOrthonormalBasis ℝ E i,
              stdOrthonormalBasis ℝ E j]
            * iteratedFDeriv ℝ 2 u x ![stdOrthonormalBasis ℝ E i, stdOrthonormalBasis ℝ E j]
        - u x * Δ F x - 2 * ⟪∇ F x, ∇ u x⟫ := by
  classical
  have hu2 : ContDiff ℝ 2 u := hu.of_le (by norm_cast <;> exact le_top)
  have hu3 : ContDiff ℝ 3 u := hu.of_le (by norm_cast <;> exact le_top)
  have hg3 : ContDiff ℝ 3 g := hg.of_le (by norm_cast <;> exact le_top)
  have hF2 : ContDiff ℝ 2 F := hF.of_le (by norm_cast <;> exact le_top)
  have hΔu2 : ContDiff ℝ 2 (Δ u) := (contDiff_laplacian hu).of_le (by norm_cast <;> exact le_top)
  have hig2 : ContDiff ℝ 2 (fun y => ⟪∇ g y, ∇ u y⟫) :=
    (((contDiff_gradient hg).inner ℝ (contDiff_gradient hu))).of_le (by norm_cast <;> exact le_top)
  have hFu2 : ContDiff ℝ 2 (fun y => F y * u y) := hF2.mul hu2
  have h1 : ContDiffAt ℝ 2 (Δ u + fun y => ⟪∇ g y, ∇ u y⟫) x :=
    hΔu2.contDiffAt.add hig2.contDiffAt
  rw [show (fun y => Δ u y + ⟪∇ g y, ∇ u y⟫ - F y * u y)
      = (Δ u + fun y => ⟪∇ g y, ∇ u y⟫) - fun y => F y * u y from rfl,
    ContDiffAt.laplacian_sub h1 hFu2.contDiffAt,
    ContDiffAt.laplacian_add hΔu2.contDiffAt hig2.contDiffAt,
    laplacian_inner_grad hg3 hu3, laplacian_mul hF2 hu2]
  ring

/-- **(6b-δ step 2b: the pointwise commutator bridge)** — the full commutator value
    `[L,S]u = (time part) + (space part)`, with `F = gt − Δg − ‖∇g‖²`, equals the integrand that
    `integral_commutator_full` integrates to the Lemma 4.1 target. The `∇gt` terms cancel
    (time vs the `−⟪∇F,∇u⟫` of space), and `⟪∇‖∇g‖²,∇u⟫ → 2 D²g(∇g,∇u)` by γ-iii. `dtF` is the
    given `∂tF`; the potential collects to `−½(∂tF + ΔF)u = −½(LF)u`. -/
theorem commutator_pointwise_eq {u g gt dtF : E → ℝ} (hu : ContDiff ℝ (⊤ : ℕ∞) u)
    (hg : ContDiff ℝ (⊤ : ℕ∞) g) (hgt : ContDiff ℝ (⊤ : ℕ∞) gt) (x : E) :
    (⟪∇ gt x, ∇ u x⟫ - dtF x / 2 * u x)
      + (⟪∇ (Δ g) x, ∇ u x⟫
          + 2 * ∑ i, ∑ j, iteratedFDeriv ℝ 2 g x ![stdOrthonormalBasis ℝ E i,
                stdOrthonormalBasis ℝ E j]
              * iteratedFDeriv ℝ 2 u x ![stdOrthonormalBasis ℝ E i, stdOrthonormalBasis ℝ E j]
          - u x * Δ (fun y => gt y - Δ g y - ⟪∇ g y, ∇ g y⟫) x / 2
          - ⟪∇ (fun y => gt y - Δ g y - ⟪∇ g y, ∇ g y⟫) x, ∇ u x⟫)
      = (2 * (∑ j, ⟪∇ (fun y => fderiv ℝ g y (stdOrthonormalBasis ℝ E j)) x,
              ∇ (fun y => fderiv ℝ u y (stdOrthonormalBasis ℝ E j)) x⟫)
        + 2 * ⟪∇ u x, ∇ (Δ g) x⟫
        + 2 * ∑ j, fderiv ℝ u x (stdOrthonormalBasis ℝ E j)
            * ⟪∇ (fun y => fderiv ℝ g y (stdOrthonormalBasis ℝ E j)) x, ∇ g x⟫
        - (dtF x + Δ (fun y => gt y - Δ g y - ⟪∇ g y, ∇ g y⟫) x) / 2 * u x) := by
  classical
  set sob := stdOrthonormalBasis ℝ E with hsob
  have hu1 : ContDiff ℝ 1 u := hu.of_le (by norm_cast <;> exact le_top)
  have hg1 : ContDiff ℝ 1 g := hg.of_le (by norm_cast <;> exact le_top)
  have hg2 : ContDiff ℝ 2 g := hg.of_le (by norm_cast <;> exact le_top)
  have hu2 : ContDiff ℝ 2 u := hu.of_le (by norm_cast <;> exact le_top)
  have hfdg1 : ContDiff ℝ 1 (fderiv ℝ g) := hg2.fderiv_right (by norm_num)
  have hfdu1 : ContDiff ℝ 1 (fderiv ℝ u) := hu2.fderiv_right (by norm_num)
  have hΔg1 : ContDiff ℝ 1 (Δ g) := (contDiff_laplacian hg).of_le (by norm_cast <;> exact le_top)
  have hnsqC : ContDiff ℝ 1 (fun y => (⟪∇ g y, ∇ g y⟫ : ℝ)) :=
    (((contDiff_gradient hg).inner ℝ (contDiff_gradient hg))).of_le (by norm_cast <;> exact le_top)
  have hgt_diff : DifferentiableAt ℝ gt x := hgt.differentiable (by norm_num) x
  have hΔg_diff : DifferentiableAt ℝ (Δ g) x := hΔg1.differentiable one_ne_zero x
  have hnsq_diff : DifferentiableAt ℝ (fun y => (⟪∇ g y, ∇ g y⟫ : ℝ)) x :=
    hnsqC.differentiable one_ne_zero x
  -- expand ⟪∇F,∇u⟫ with F = gt − Δg − ‖∇g‖²
  have hF_fd : HasFDerivAt (fun y => gt y - Δ g y - ⟪∇ g y, ∇ g y⟫)
      (fderiv ℝ gt x - fderiv ℝ (Δ g) x - fderiv ℝ (fun y => (⟪∇ g y, ∇ g y⟫ : ℝ)) x) x :=
    (hgt_diff.hasFDerivAt.sub hΔg_diff.hasFDerivAt).sub hnsq_diff.hasFDerivAt
  have hFinner : ⟪∇ (fun y => gt y - Δ g y - ⟪∇ g y, ∇ g y⟫) x, ∇ u x⟫
      = ⟪∇ gt x, ∇ u x⟫ - ⟪∇ (Δ g) x, ∇ u x⟫
        - ⟪∇ (fun y => (⟪∇ g y, ∇ g y⟫ : ℝ)) x, ∇ u x⟫ := by
    rw [inner_gradient_left hF_fd.differentiableAt, hF_fd.fderiv,
        ContinuousLinearMap.sub_apply, ContinuousLinearMap.sub_apply,
        ← inner_gradient_left hgt_diff, ← inner_gradient_left hΔg_diff,
        ← inner_gradient_left hnsq_diff]
  have hHS : (∑ j, ⟪∇ (fun y => fderiv ℝ g y (sob j)) x, ∇ (fun y => fderiv ℝ u y (sob j)) x⟫)
      = ∑ i, ∑ j, iteratedFDeriv ℝ 2 g x ![sob i, sob j]
          * iteratedFDeriv ℝ 2 u x ![sob i, sob j] := by
    rw [Finset.sum_comm]
    refine Finset.sum_congr rfl fun j _ => ?_
    have hdjg : DifferentiableAt ℝ (fun y => fderiv ℝ g y (sob j)) x :=
      ((ContinuousLinearMap.apply ℝ ℝ (sob j)).differentiable.comp
        (hfdg1.differentiable one_ne_zero)) x
    have hdju : DifferentiableAt ℝ (fun y => fderiv ℝ u y (sob j)) x :=
      ((ContinuousLinearMap.apply ℝ ℝ (sob j)).differentiable.comp
        (hfdu1.differentiable one_ne_zero)) x
    rw [inner_grad_eq_sum hdjg hdju]
    refine Finset.sum_congr rfl fun i _ => ?_
    rw [fderiv_fderiv_dir hg2 x (sob i) (sob j), fderiv_fderiv_dir hu2 x (sob i) (sob j)]
  rw [hFinner, inner_grad_normSq_eq hu1 hg2 x, real_inner_comm (∇ (Δ g) x) (∇ u x), hHS]
  ring

/-- **(6b-δ: the concrete Carleman commutator quadratic form — Tao Lemma 4.1's display)** — for
    `u` C^∞ compactly supported, `g, gt` C^∞ and `dtF` (`= ∂tF`) continuous, the full commutator
    `[L,S]u = (time part ⟪∇gt,∇u⟫ − ½(∂tF)u) + (space part Δ(Su)−S(Δu))` paired against `u·e^g`:
    `∫ [L,S]u·u·e^g = ∫(−2 D²g(∇u,∇u) − ½(LF)u²)·e^g`, with `F = gt − Δg − ‖∇g‖²` and
    `LF = ∂tF + ΔF`. Combines the pointwise commutator bridge (`commutator_pointwise_eq`) with the
    integral collapse (`integral_commutator_full`). This is the value of Lemma 4.1's quadratic form. -/
theorem integral_commutator_quadratic {u g gt dtF : E → ℝ} (hu : ContDiff ℝ (⊤ : ℕ∞) u)
    (hcu : HasCompactSupport u) (hg : ContDiff ℝ (⊤ : ℕ∞) g) (hgt : ContDiff ℝ (⊤ : ℕ∞) gt)
    (hdtF : Continuous dtF) :
    (∫ x, ((⟪∇ gt x, ∇ u x⟫ - dtF x / 2 * u x)
        + (⟪∇ (Δ g) x, ∇ u x⟫
            + 2 * ∑ i, ∑ j, iteratedFDeriv ℝ 2 g x ![stdOrthonormalBasis ℝ E i,
                  stdOrthonormalBasis ℝ E j]
                * iteratedFDeriv ℝ 2 u x ![stdOrthonormalBasis ℝ E i, stdOrthonormalBasis ℝ E j]
            - u x * Δ (fun y => gt y - Δ g y - ⟪∇ g y, ∇ g y⟫) x / 2
            - ⟪∇ (fun y => gt y - Δ g y - ⟪∇ g y, ∇ g y⟫) x, ∇ u x⟫)) * u x * exp (g x))
      = ∫ x, (-2 * (∑ j, fderiv ℝ u x (stdOrthonormalBasis ℝ E j)
            * ⟪∇ (fun y => fderiv ℝ g y (stdOrthonormalBasis ℝ E j)) x, ∇ u x⟫)
          - (dtF x + Δ (fun y => gt y - Δ g y - ⟪∇ g y, ∇ g y⟫) x) / 2 * (u x) ^ 2) * exp (g x) := by
  classical
  have hu2 : ContDiff ℝ 2 u := hu.of_le (by norm_cast <;> exact le_top)
  have hg3 : ContDiff ℝ 3 g := hg.of_le (by norm_cast <;> exact le_top)
  have hg2 : ContDiff ℝ 2 g := hg.of_le (by norm_cast <;> exact le_top)
  have hΔFcont : Continuous (Δ (fun y => gt y - Δ g y - ⟪∇ g y, ∇ g y⟫)) := by
    have hFC : ContDiff ℝ 2 (fun y => gt y - Δ g y - ⟪∇ g y, ∇ g y⟫) :=
      ((hgt.sub (contDiff_laplacian hg)).sub
        ((contDiff_gradient hg).inner ℝ (contDiff_gradient hg))).of_le (by norm_cast <;> exact le_top)
    exact WeightedGreenAux.continuous_laplacian hFC
  have hlf : Continuous (fun x => dtF x + Δ (fun y => gt y - Δ g y - ⟪∇ g y, ∇ g y⟫) x) :=
    hdtF.add hΔFcont
  rw [show (fun x => ((⟪∇ gt x, ∇ u x⟫ - dtF x / 2 * u x)
        + (⟪∇ (Δ g) x, ∇ u x⟫
            + 2 * ∑ i, ∑ j, iteratedFDeriv ℝ 2 g x ![stdOrthonormalBasis ℝ E i,
                  stdOrthonormalBasis ℝ E j]
                * iteratedFDeriv ℝ 2 u x ![stdOrthonormalBasis ℝ E i, stdOrthonormalBasis ℝ E j]
            - u x * Δ (fun y => gt y - Δ g y - ⟪∇ g y, ∇ g y⟫) x / 2
            - ⟪∇ (fun y => gt y - Δ g y - ⟪∇ g y, ∇ g y⟫) x, ∇ u x⟫)) * u x * exp (g x))
      = fun x => (2 * (∑ j, ⟪∇ (fun y => fderiv ℝ g y (stdOrthonormalBasis ℝ E j)) x,
              ∇ (fun y => fderiv ℝ u y (stdOrthonormalBasis ℝ E j)) x⟫)
          + 2 * ⟪∇ u x, ∇ (Δ g) x⟫
          + 2 * ∑ j, fderiv ℝ u x (stdOrthonormalBasis ℝ E j)
              * ⟪∇ (fun y => fderiv ℝ g y (stdOrthonormalBasis ℝ E j)) x, ∇ g x⟫
          - (dtF x + Δ (fun y => gt y - Δ g y - ⟪∇ g y, ∇ g y⟫) x) / 2 * u x) * u x * exp (g x)
      from funext fun x => by rw [commutator_pointwise_eq hu hg hgt x],
    integral_commutator_full hu2 hcu hg3 hlf]

end CommutatorIBP


end NSCarleman

#eval "Carleman commutator-method core — machine-verified."
