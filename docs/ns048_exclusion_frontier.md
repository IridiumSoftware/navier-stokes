# NS-048 — The exclusion / no-split frontier (map of the machinery; NOT a result)

**Date:** 2026-06-06. **Status: `:open`, unengaged candidate direction.** This is a *map of the attack
shape and its machinery* + an honest correction to NS-048's own framing — **no exclusion, Liouville
theorem, or no-split control is claimed here.** `:proved`=0; distance UNTOUCHED. Specific current-best
theorem statements/scopes below are named at the lineage level and **flagged for literature
verification** before any are cited as established (don't-bluff rule).

## 1. The attack shape (the colleague's mindset shift, made precise)

Don't prove "all turbulence is smooth." Instead: **assume** a singularity at `(x₀,T)`, **rescale** to the
blowup, and **exclude** the rescaled limit. Concretely:

1. **Rescale.** `u_λ(y,s) = λ·u(x₀+λy, T+λ²s)` (the exact NS scaling). For **Type-I** blowup
   (`‖u(t)‖_∞ ≲ (T−t)^{-1/2}`, the scaling-critical rate), `{u_λ}` is bounded and — by parabolic
   compactness + CKN ε-regularity (NS-006) — converges along a subsequence to an **ancient solution**
   (a bounded mild solution defined for all `s<0`).
2. **Exclude (Liouville).** Show the ancient limit is **trivial** (constant/zero). A Liouville theorem
   for bounded ancient NS solutions ⇒ no Type-I singularity.
3. **No-split.** The rescaled sequence may concentrate at several scales/points ("bubbling") →
   *different subsequences → different limits.* A **concentration-compactness / profile-decomposition**
   control is needed so the limit is well-defined (a single bubble, or a controlled finite tree).
4. **Type-II** blowup (faster than critical) does not give a bounded rescaled limit directly — a
   *separate*, harder branch.

## 2. The machinery (named; scopes to verify in the literature)

- **Self-similar exclusion — DONE (this is NS-007):** Nečas–Růžička–Šverák (no nontrivial
  (−1/2)-self-similar blowup in L³) + Tsai (asymptotically self-similar). So the *self-similar* ancient
  solutions are excluded. NS-048 is the **generalization to non-self-similar ancient limits.**
- **Liouville for ancient NS — OPEN in general, known in restricted classes** (2D; axisymmetric without
  swirl; and the Koch–Nadirashvili–Seregin–Šverák line of conditional results). The general 3D Liouville
  is essentially equivalent to the Type-I regularity question.
- **No-split / profile decomposition** in critical spaces (the Gallagher–Koch–Planchon / Kenig–Koch
  lineage). The "no-split mechanism" the colleague names.
- **Backward uniqueness + unique continuation** for the parabolic operator — the engine of
  Escauriaza–Seregin–Šverák's L³ endpoint (**NS-005**); rules out a nontrivial limit that decays
  backward.
- **CKN ε-regularity + singular-set ≤1** (**NS-006**) — supplies the local smallness that makes the
  rescaling compactness work.

## 3. Where our ledger sits, and the gap

Held pieces: **NS-007** (self-similar excluded — the cleanest sub-case), **NS-006** (CKN/rescaling
input), **NS-005** (backward-uniqueness exemplar). **The gap NS-048 names:** the **general
(non-self-similar / discretely self-similar) ancient-limit Liouville theorem**, the **no-split control**,
and the **Type-II** branch. The program had *no entry* for any of these three; NS-048 records them as the
dynamic frontier.

## 4. The precise obstruction (one sentence — the colleague's rule)

> *Exclude every nontrivial bounded ancient solution of 3D Euler/NS that can arise as a no-split
> rescaled limit of a Type-I singularity (and separately handle Type-II) — equivalently, prove a Liouville
> theorem for the rescaled blowup limit.*

Sub-targets (each `:open`): (a) a Liouville theorem for a restricted non-self-similar ancient class
beyond axisymmetric-no-swirl; (b) a no-split control for the critical-space rescaled sequence; (c) a
Type-II rate exclusion.

## 5. Honest correction to NS-048's own framing (a caught over-reach)

NS-048 (and the colleague-notes assessment) proposed *"re-task our geometry findings (Beltramization
NS-045, the pressure-Hessian NS-046, ∇ξ) as rigidity constraints on the ancient limit."* **Working it
honestly, that is over-optimistic — the same vacuity cap the witnesses kept catching:** our geometry
findings are **within-truncation** (resolved Re=1600 flows); the **ancient limit is a singular-limit PDE
object the truncation cannot reach.** A Liouville rigidity must be proven **analytically on the ancient
solution**, not inherited from a truncation's geometry. So the honest role of our findings is a
**suggestive prior** — *where* to probe the ancient limit's geometry (the strain–vorticity alignment, the
sign of `e₃ᵀ∇²p e₃`, the `∇ξ` smoothness) — **not** an exclusion input. (Recording this as the catch it
is: a 7th tidy hope, deflated by thinking it through rather than by the witnesses.)

## 6. Disposition

Engaging NS-048 for real means **learning the machinery** (§2's literature) and attacking *one* sub-target
(§4a–c) — a genuine research undertaking, not a session task, and explicitly **not** a new geometric
gadget. Recorded as the precise dynamic frontier; `:open`; `:proved`=0; distance UNTOUCHED. *The most
useful output of "doing NS-048" today is the map + the deflation of its own geometry-re-tasking hope.*
