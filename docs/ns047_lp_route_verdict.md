# Witness verdict — NS-047 candidate (LP/paraproduct-local route to NS-046): REFUTED

**Seats:** Grok (edge-Φ) + Gemini (synthesis) + ChatGPT (naive). **Date:** 2026-06-05.
**Brief:** `docs/ns047_lp_route_brief.md`. **Disposition: NS-047 NOT created; folded into NS-046 as a
note.** (Note: Gemini ran on a fast model this round — but it *converged* with the other two, so the
verdict does not depend on it.) `:proved`=0; distance UNTOUCHED.

## Per-question verdicts (convergent 3/3)

- **Q1 (Besov / sub-endpoint) — REFUTED. The load-bearing failure.** All three seats: C1's claim that
  controlling the pressure Hessian *must* strike the L^∞/BMO endpoint (= BKM) is a **false dichotomy**.
  CZ/Riesz operators are bounded on critical Besov spaces — `Ḃ⁰_{∞,1}` (no log-penalty; `Ḃ⁰_{∞,1} ↪ L^∞
  ↪ Ḃ⁰_{∞,∞}`), `Ḃ⁰_{p,1}` (p finite), Triebel–Lizorkin, Lorentz — and the entire purpose of LP
  machinery is to *slice around* the L^∞ endpoint, summing dyadically in `∑_j ‖Δ_j ∇u‖_{L^∞}` without
  ever invoking the un-decomposed `‖∇u‖_{L^∞}` that drives BKM. So a critical-*Besov* coercive bound
  need never invoke BKM. **C1 is false.**

- **Q2 (null-structure) — HOLDS / can't-decide (mixed, leans against C1's "generic CZ").** Gemini: the
  source `tr((∇u)²)` leaves the diagonal squares strictly positive and un-cancelled at σ=0 — no
  null-form drops it sub-critical. Grok/ChatGPT: no *proven* null-form escape, but C1 overstates by
  treating the (div-free-structured) source as generic CZ forcing. Net: no proven Q2 escape, but C1's
  "generic" framing is loose.

- **Q3 (CKN ε-regularity vs C2) — C2 HOLDS (all three).** CKN generates smallness only on
  already-regular cylinders; the singular set (where the maximal-function tail must be absorbed) is
  exactly where local energy is *not* small and the local Reynolds number is O(1). So CKN **relocates**
  the gap to NS-006's ≤1-D set rather than closing it. C2 survives — but the seats note it is a
  restatement of the known supercritical difficulty, not a new barrier.

- **Q4 (over-reach / scope) — OVER-REACH; NOT a new obstruction (all three).** C3 is honestly scoped
  ("straightforward scheme") but its tone ("generates no new coercivity… sibling to NS-008… NS-047")
  reads as a broad no-go on harmonic analysis, which it is not (wave-packet / profile-decomposition /
  anisotropic / compensated-compactness routes are untouched). It is a *diagnostic heuristic*, not a
  theorem-level obstruction (which would need "any estimate of class X ⟹ endpoint inequality Y" —
  not established). **Unanimous: do not elevate to NS-047; append as a note to NS-046.**

## What survives (corrected — and it cuts AGAINST the over-reach)

Not an obstruction; a sharper read of the frontier:
1. **The harmonic-analytic route to NS-046 is NOT blocked at the BKM endpoint** — critical Besov
   (`Ḃ⁰_{∞,1}`) escapes it. So the §11 `∇ξ`-frontier kill-criterion does **not** fire: a
   harmonic-analytic route is genuinely *live*, not ruled out. (The candidate claimed it was blocked.)
2. **The route's real obstacle is the supercritical smallness on the CKN ≤1-D singular set** (NS-006 /
   NS-002) — where coercivity must be generated and smallness is unavailable (C2, modest).
3. **Framework correction:** critical *Besov*, not L^∞; the obstacle is the *singular set*, not BKM.

## Disposition

- **No NS-047.** Folded into NS-046 as a witnessed note; NS-046 stays `:open`.
- **Meta:** the *fourth* tidy-"reduces to the wall" over-reach this session (LOW#1 → MID → §5-"≡" →
  NS-047-C1). The naive seat and Gemini both made the surface-level catch ("why must it live in L^∞?").
  The §11 kill-criterion machinery worked: the test was honest, and its result is that the frontier is
  *more open* than the over-reach wanted. Reinforces `feedback_totalizing_word_overreach`.
- `:proved`=0; distance UNTOUCHED.
