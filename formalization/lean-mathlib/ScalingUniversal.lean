/-
  ScalingUniversal.lean — Rung 0, UNIVERSAL machine-verified theorems (`lean-proved`)

  The scaling-criticality calculus proved for ALL parameters (∀ α p q : ℚ), not just
  at exemplar triples — the Mathlib-backed upgrade of the hermetic, native_decide
  Rung-0 file (`../lean/Scaling.lean`). Mathlib supplies `linarith`/`norm_num` over
  ℚ; the criticality iff is a linear rearrangement in the atoms {α, 3/p, 2/q}.

  Pin: leanprover/lean4 v4.30.0-rc2 + Mathlib (mirrors the TCE `lean4-cv` project,
  whose built Mathlib this was checked against — see README). Verified by:
      cd <TCE>/src/lean4-cv && lake env lean <this file>      (exits 0)
  or standalone:  lake exe cache get && lake build            (this project).

  CONVENTIONS (identical to the Julia/Haskell/native-Lean layers):
    [|x₃|^α u^θ]_{L^q_t L^p_x} = 1 − α − 3/p − 2/q  (velocity, f=1);
    critical ⇔ [X]=0; the ∞ sentinel is p=0 / q=0 (ℚ: x/0 = 0).
-/
import Mathlib

namespace NSScaling

/-- Scaling exponent of the axially-weighted mixed norm ‖|x₃|^α u^θ‖_{L^q_t L^p_x}. -/
def lebExp (α p q : ℚ) : ℚ := 1 - α - 3/p - 2/q

/-- Scaling exponent of the homogeneous Sobolev norm Ḣ^s. -/
def sobExp (s : ℚ) : ℚ := s - 1/2

/-- Exact algebraic form: the exponent is `(1−α)` minus the WHWY left-hand side. -/
theorem lebExp_eq (α p q : ℚ) : lebExp α p q = (1 - α) - (2/q + 3/p) := by
  unfold lebExp; ring

/-- **Universal anisotropic criticality (WHWY).** For ALL α,p,q : ℚ, the norm is
    scale-invariant (exponent 0) iff `2/q + 3/p = 1 − α`. -/
theorem lebExp_critical_iff (α p q : ℚ) : lebExp α p q = 0 ↔ 2/q + 3/p = 1 - α := by
  unfold lebExp; constructor <;> intro h <;> linarith

/-- **Universal Sobolev criticality.** Ḣ^s is critical iff s = 1/2. -/
theorem sobExp_critical_iff (s : ℚ) : sobExp s = 0 ↔ s = 1/2 := by
  unfold sobExp; constructor <;> intro h <;> linarith

/-- Ḣ^{1/2} is critical (corollary of the universal iff). -/
theorem Hhalf_critical : sobExp (1/2) = 0 := (sobExp_critical_iff (1/2)).mpr rfl

/-- **Energy (L² = Ḣ⁰) is strictly SUPERcritical:** its exponent is `< 0 = [critical]` (NS-002). -/
theorem energy_supercritical : sobExp 0 < 0 := by norm_num [sobExp]

/-- The supercriticality GAP: `[L²] = [Ḣ^{1/2}] − 1/2` — energy sits a full step below critical. -/
theorem energy_gap : sobExp 0 = sobExp (1/2) - 1/2 := by
  unfold sobExp; ring

/-- L³ (spatial, α=0, p=3, q=∞ via the 0-sentinel) is critical — a corollary of the universal iff. -/
theorem L3_critical : lebExp 0 3 0 = 0 := by
  rw [lebExp_critical_iff]; norm_num

end NSScaling
