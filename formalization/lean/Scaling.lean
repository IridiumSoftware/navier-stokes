/-
  Scaling.lean — Rung 0, MACHINE-VERIFIED layer (`lean-proved` evidence)

  The Navier–Stokes scaling-criticality facts, proved over Rat by `native_decide`
  (kernel-checked native evaluation). Hermetic: `import Std` ships with the Lean
  toolchain (no Mathlib, no external Batteries fetch). Mirrors the Julia
  (algebraic) and Haskell (type-checked) layers — same definitions, now machine
  verified. Pin: lean-toolchain (leanprover/lean4 v4.30.0).

  CONVENTIONS (identical to scaling_criticality.jl / Scaling.hs):
    u_λ(x,t)=λ^f u(λx,λ²t);  [X] defined by ‖u_λ‖_X = λ^[X] ‖u‖_X (f=1, velocity);
    critical ⇔ [X]=0 · subcritical ⇔ [X]>0 · supercritical ⇔ [X]<0 (NS-002).
  ∞ SENTINEL: Lean's `Rat` has x/0 = 0, which is exactly our 1/∞ = 0, so p=0 (resp.
  q=0) encodes p=∞ (resp. q=∞).
-/
import Std

/-- Scaling exponent of the (axially-weighted) mixed norm ‖|x₃|^α u^θ‖_{L^q_t L^p_x}:
    [X] = 1 − α − 3/p − 2/q  (velocity field power f = 1). -/
def lebExp (α p q : Rat) : Rat := (1:Rat) - α - (3:Rat)/p - (2:Rat)/q

/-- Scaling exponent of the homogeneous Sobolev norm Ḣ^s: [Ḣ^s] = s − 1/2. -/
def sobExp (s : Rat) : Rat := s - (1:Rat)/2

-- (1) the critical / sub / super facts of the unweighted Lebesgue & Sobolev norms
theorem L3_critical       : lebExp 0 3 0 = 0          := by native_decide   -- L³ critical
theorem L2_supercritical  : lebExp 0 2 0 = (-1/2:Rat)   := by native_decide   -- L² (energy) super (NS-002)
theorem Linf_subcritical  : lebExp 0 0 0 = 1          := by native_decide   -- L^∞ subcritical (p=∞ sentinel)
theorem Hhalf_critical    : sobExp (1/2) = 0          := by native_decide   -- Ḣ^{1/2} critical

-- (2) cross-family coherence and the supercriticality gap
theorem Hzero_eq_L2       : sobExp 0 = lebExp 0 2 0              := by native_decide   -- Ḣ⁰ = L²
theorem energy_gap        : lebExp 0 2 0 - sobExp (1/2) = (-1/2:Rat) := by native_decide -- σ=−1 vs σ=0 wall

-- (3) the anisotropic |x₃|^α criticality  [X]=0 ⇔ 2/q+3/p = 1−α, at the three triples
theorem aniso_critical_weighted : lebExp (1/4) 6 8 = 0        := by native_decide  -- 2/8+3/6 = 3/4 = 1−1/4
theorem aniso_critical_serrin   : lebExp 0 3 0 = 0            := by native_decide  -- 0+1 = 1 = 1−0
theorem aniso_control           : lebExp (1/8) 4 8 = (-1/8:Rat) := by native_decide  -- 2/8+3/4=1 ≠ 7/8 ⇒ super

-- the criticality classification realized as decidable comparisons at the triples
theorem weighted_is_critical    : lebExp (1/4) 6 8 = 0    := by native_decide
theorem control_is_supercrit    : lebExp (1/8) 4 8 < 0    := by native_decide

#eval "Rung 0 (Lean): all scaling-criticality theorems machine-verified (native_decide)."
