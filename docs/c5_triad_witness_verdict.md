# C5 triad witness verdict — both targets SURVIVE; use faithful; no hard verification (externally confirmed)

**Date:** 2026-06-07. Metabolized record of the external triad pass on `docs/c5_triad_witness_brief.md`
(`~/Desktop/c5witness.rtf`). **Seats this round: Grok (edge-Φ / cold-adversarial), Gemini (synthesis),
Venice (naive seat).** (My brief named ChatGPT for the naive seat; Venice took it — recorded accurately.)
Foundation-hardening, NOT PDE progress; `:proved`=0; distance UNTOUCHED.

**Headline:** **no disproof — both targets SURVIVE all three independent model families**, and **"use is
faithful + NO hard verification exists" is unanimous** (externally confirming the internal C5 social-floor
finding). The external pass added value the same-model internal pass could not: it **located the black
boxes more precisely**, surfaced **two new scope conditions**, and prompted **two gentle corrections** of
our own characterization. Nothing it raised changes a load-bearing conclusion.

---

## 1. Unanimous consensus (all three witnesses)

- **Use is FAITHFUL** for both targets: A3 (`|x₃|^α` doesn't transfer to ancient — the Gronwall is
  `t=0`-anchored), B1 (partial exclusion), B3 (the gap is qualitative). All three: SURVIVES.
- **NO hard verification exists** (A4, B4) — no Lean/Coq/Isabelle, no CAP/rigorous-numerics, no errata;
  `|x₃|^α` has no independent re-proof (same-author JMAA). Unanimous. **Externally confirms the C5
  social-floor finding.**
- **The black boxes are correctly located:** A1 (anisotropic Hardy–Sobolev + fractional-GN + near-axis
  identification) and B2 (Tao's Carleman inequalities + pigeonholing constants) are the irreducible
  un-text-checkable cores. All three flagged exactly these.

## 2. What the external pass ADDED (internal-pass blind spots)

1. **A1 escalated — the endpoint may be a genuine constant barrier (not just a range-choice).** The
   internal pass said "`α<1/4` is a range-choice (keeps the full Serrin `p`-range), not a sharpness
   ceiling." All three witnesses **suspect the embedding constant `C(α)→∞` as `α→1/4`** (Venice:
   `~(1/4−α)^{−N}`), which would make `α<1/4` load-bearing and the endpoint vacuous. **Honest status
   (don't overstate):** the `p`-range constraint is *established*; whether `C(α)` *also* diverges is an
   **unverified black box** — the paper does not track `C(α)`, and the triad *suspects* but did not
   *establish* divergence. **Gentle correction:** soften our "range-choice, not a ceiling" to "`α<1/4` is
   the established `p`-range constraint; whether the constant also forces it is an open, un-tracked black
   box (triad suspects endpoint divergence)." *Immaterial to our use* (we never use the endpoint).

2. **A2 refined (Venice) — it's a continuation theorem, not a criterion for weak solutions.** `Φ(0)=ω^r(0)/r`,
   `Γ(0)=ω^θ(0)/r` need `ω(0)∈H¹` (division by `r` near the axis costs a derivative), which generic
   Leray–Hopf `L²` data does not provide. So the result reads "among `H²` solutions, those satisfying the
   weighted bound stay smooth" — a **conditional-smoothness/continuation** statement, not a criterion
   applicable to arbitrary weak solutions. (Gemini + Grok rate A2 SURVIVES — `H²` is a standard
   load-bearing initialization, not a tautology — and Venice agrees it's not a tautology; the dispute is
   only over the *label* "criterion.") **Sharpens** our "`u₀∈H²` is a real hypothesis"; *immaterial to our
   use* (we use only the proof-structure for the ancient non-transfer).

3. **B2 sharpened (Venice) — the precise risk is Carleman-constant *universality*.** The danger in Tao's
   black box is specifically whether the Carleman constant is **solution-independent**; if it secretly
   depends on `‖u‖_{L³}` (exponentially), the triple-exp→triple-log inversion could collapse to a *weaker*
   bound. **This does not change our use** (we rely on the qualitative "diverges arbitrarily slowly," and
   a *weaker* bound is still slow divergence) — but it locates the irreducible risk precisely.

4. **B scope (Gemini) — Tao's triple-log requires the Leray–Hopf global energy inequality.** The Bourgain
   pigeonholing bounds the number of "bad" scales *using* the global energy inequality; without it the
   pigeonhole fails and the rate "vaporizes." So the bound is **tied to the Leray energy class**, not a
   universal PDE bound. **New scope condition, recorded.** Our use (rate bounds on NS singularities, which
   live in the Leray class) is *within* it — faithful — but the condition should travel with the citation.

5. **Palasek UPGRADED (Grok + all) — structurally independent, not merely "partial."** Palasek's double-log
   uses Nazarov–Ural'tseva parabolic-Harnack, a **structurally different method** from Tao's Carleman, so
   it is **genuine independent evidence of the slow-divergence phenomenon** — *more* than the "partial
   cross-check" we'd written. **Gentle correction (generous direction):** upgrade "partial independent
   cross-check of the phenomenon" → "**structurally-independent** (Harnack-vs-Carleman) cross-check **of
   the phenomenon**" (still: of the phenomenon, *not* of Tao's exact constant).

## 3. The one challenge I do NOT accept as stated (Venice, naive seat)

Venice (B1): *"Type-II IS excluded for axisymmetric solutions with bounded swirl … so the 'open problem'
claim needs qualification — closed with bounded swirl."* **Assessment: this conflates conditional
regularity with unconditional exclusion.** "Bounded-swirl ⇒ regularity" results (Chen–Strain–Tsai–Yau
`|v|≤C/r`; the Lei–Zhang–Zhao `L^p` family — exactly the **closers we already mapped** in the NS-048 arc)
exclude *all* blowup *under that hypothesis*; they are conditional. They are **not** an *unconditional*
Type-II exclusion for axisymmetric NS, which remains **open**. So our "unconditional Type-II is open" claim
**stands**; Venice's point is a re-labeling of the conditional-regularity family we have. (Flagged as a
naive-seat conflation, consistent with the seat's role.)

## 4. Net verdict + tier

- **C5 status: adversarially survived BOTH the internal AND the external (3 independent model families)
  pass; use FAITHFUL; hard-verification = NONE (externally confirmed social floor).** This is the strongest
  non-formal tier achievable for these citations.
- **No disproof; no error/counterexample/scope-misuse found.** The residual risk is exactly the
  un-text-checkable cores — A1 constant-tracking (endpoint), B2 Carleman-universality — which the external
  pass *located precisely* but (rightly) could not crack, and confirmed have **no hard verification**.
- **Two gentle self-corrections recorded:** (i) `α<1/4` "range-choice" → "established `p`-range constraint
  + un-tracked constant black box (endpoint possibly a genuine barrier)"; (ii) Palasek "partial" →
  "structurally-independent" cross-check.
- **Two new scope conditions recorded:** `|x₃|^α` = `H²`-continuation theorem (not a weak-solution
  criterion); Tao triple-log = tied to the Leray–Hopf class (global energy inequality).
- **The irreducible floor is unchanged:** the Carleman/GN cores remain socially verified; formal
  verification is a multi-year, field-wide undertaking that does not exist. The honest tier label stands:
  **"C5-adversarial-survived (internal+external); hard-verification = none."**

## 5. Honesty note

No over-reach was caught this round — our *use* was confirmed faithful by all three. The corrections are
**sharpenings + two generous-direction adjustments** (we'd *under*-claimed Palasek's independence and been
slightly *too sanguine* about the `α=1/4` endpoint), not refutations. The witness protocol did its job:
external models **independently confirmed the social-verification floor**, **located the black boxes more
sharply**, and **surfaced two scope conditions the same-model pass missed** (Leray-class for Tao;
`H²`-continuation for WHWY). The "Type-II closed with bounded swirl" challenge was correctly identified as
a conditional-vs-unconditional conflation and declined.

## 6. Sources

External triad, 2026-06-07 (`~/Desktop/c5witness.rtf`): **Grok** (edge-Φ), **Gemini** (synthesis),
**Venice** (naive seat). Internal C5 pass: `docs/c5_adversarial_pass_2026-06-07.md`. Brief:
`docs/c5_triad_witness_brief.md`. Targets: Wang–Huang–Wei–Yu arXiv:2205.13893; Tao arXiv:1908.04958;
Ożański–Palasek arXiv:2210.10030.
