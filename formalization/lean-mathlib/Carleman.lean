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

end NSCarleman

#eval "Carleman commutator-method core — machine-verified."
