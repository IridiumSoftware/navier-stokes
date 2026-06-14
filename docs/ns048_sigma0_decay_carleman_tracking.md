# NS-048 tracking — the "σ=0 backward decay ⇒ Type-I exclusion" reduction vs. the Carleman ladder

**Date:** 2026-06-13. **Status: a tracking document (no new claim). Scope: PDE-analysis (≠ the PDE)
+ formalization-track tracking.** `:proved`=0; distance UNTOUCHED. Tracks the litmap §4.1 residual
(`docs/ab_sequential_l3_verification_2026-06-12.md`) against the concurrent Carleman ladder
(NS-051 / T-28; `formalization/lean-mathlib/Carleman.lean`). **Purpose:** state the reduction
precisely, locate exactly where the ladder plugs in, and pre-register the watch-triggers — so the
question "is the formalization track closing in on NS-048's Type-I exclusion?" has an honest,
checkable answer rather than a hopeful one.

## 0. The one-paragraph answer

The reduction "any σ=0 backward-decay mechanism for ancient solutions ⇒ Type-I exclusion" is real
and cited (Albritton–Barker Thm 1.2). It has **two** sub-parts: a **closer** (AB Thm 1.2, whose
engine is ESS-lineage backward uniqueness) and a missing **antecedent** (a mechanism forcing
`L³`-boundedness along a backward time sequence — i.e. spatial decay at critical scaling). **The
Carleman ladder is building the closer's engine** (Tao's quantitative form of the ESS Carleman /
backward-uniqueness substrate) — **but it is not building AB Thm 1.2, and it is not building the
antecedent.** So the ladder's progress advances the *formal status of the engine the closer shares
with Tao's theorem*; it does **not** advance toward closing NS-048, because the gap is the
antecedent, which is on no track and is the σ=0 analytic wall. Completing the ladder ⇏ closing
NS-048.

## 1. The reduction chain (precise)

Excluding a Type-I singularity of 3D NS decomposes into three links:

| Link | Statement | Where it lives | Status |
|---|---|---|---|
| **L1** | A Type-I singularity ⟹ a non-trivial bounded ancient mild solution `v` with `I<∞` | KNSS Prop 6.1 (rescaling) + AB Thm 1.1 (the `⟺`, reverse direction) | **cited / established** — C3 in-repo (round-2 verification; G4 wording) |
| **L2** | **[the gap]** some mechanism forces `sup_k ‖v(·,t_k)‖_{L³} < ∞` along a backward sequence `t_k ↓ −∞` (σ=0 / critical-scale decay of the ancient solution) | — *no theorem; this is the open antecedent* | **OPEN — analytic wall.** On no track. |
| **L3** | `sup_k ‖v(·,t_k)‖_{L³} < ∞` along `t_k ↓ −∞` ⟹ `v ≡ 0` | **Albritton–Barker Thm 1.2** (arXiv:1811.00502) | **cited** — C2 (statement verbatim) + proof-architecture mapped |

**L3's internal architecture** (from the §4.1 verification): rescale-at-`t_k` (sequentiality enters)
→ compactness (AB Lemma 2.2, powered by the sequential `L³` bound) → persistence (AB Prop 2.3 ←
Rusin–Šverák JFA 2011) → **regularity control (AB Prop 4.2 ← AB ARMA 2018 ← Barker–Seregin–Šverák
CPDE 2018, "by backward uniqueness arguments")**. The backward uniqueness is **one layer down**, inside
AB Prop 4.2 — Thm 1.2 does not invoke it directly.

**σ-bookkeeping.** L2 is "spatial decay at critical scaling (σ=0) for an ancient solution." That is
the σ=0 wall (S1) seen from the ancient side, i.e. the litmap §3 diagnosis (no critical monotonicity
formula) and the same object NS-053 hunts from the construction side (litmap §5). **L2 = the
monotonicity-formula hunt.** It is the program's central open wall, not a session task.

## 2. What the Carleman ladder actually targets (the disambiguation that matters)

`formalization/lean-mathlib/Carleman.lean` (NS-051 / T-28) formalizes **Tao arXiv:1908.04958 §4**
(*Quantitative bounds for critically bounded solutions to NS*) — header line 1–3, confirmed. Its
roadmap (`docs/carleman_ladder0_tao_sec4_audit.md` §4):

1. **Tao Lemma 4.1** — the General Carleman inequality (the S/A-split + commutator chain). *Tao notes
   it is "essentially contained in [ESS2],[ESS]" made quantitative — the ESS backward-uniqueness
   lineage.* ← **the ladder is HERE** (mid-rung: ladder-6b-γ, assembling Lemma 4.1's analytic
   instantiation — energy identity → commutator → Bochner IBP → the displayed inequality; changelog
   ~v0.15.44).
2. weight calculus (B11/B12 as Lean lemmas)
3. **Tao Prop 4.2** (First Carleman inequality, annulus)
4. **Tao Prop 4.3** (Second Carleman inequality, cylinder)
5. **the backward-uniqueness wrapper** (the ESS-lineage backward uniqueness, in Tao's quantitative
   form). ← **the farthest rung.**

**The relationship to L3 — exact, and the over-read it corrects:**

- Tao's "Lemma 4.1 / Prop 4.2 / Prop 4.3" are **Tao's** numbering. AB's "Prop 4.2" is a **different
  paper's** proposition. They are *not the same object* — a naive "the ladder is formalizing the
  Prop 4.2 that AB Thm 1.2 needs" is **wrong** (they merely share a number).
- What they **do** share is the **substrate**: ESS (Escauriaza–Seregin–Šverák 2003) Carleman
  estimates + backward uniqueness for the heat operator. AB Prop 4.2 (via ARMA 2018 ← BSŠ) uses the
  *qualitative* ESS backward uniqueness; Tao's §4 + step-5 wrapper is the *quantitative* form of the
  same lineage.
- **So the ladder, at step 5, will machine-verify the ESS backward-uniqueness engine that AB Prop 4.2
  also rests on** — "the first place the formalization track touches a live exclusion theorem's core"
  (litmap §4.1). It will **not** thereby have formalized AB Thm 1.2 (a different theorem), and a
  formal bridge "Tao-quantitative-BU ⟹ AB-Prop-4.2's qualitative BU" would itself be extra work.

## 3. Tracking table — per-link status and watch-triggers

| Link | Closure status | On a track? | Watch-trigger |
|---|---|---|---|
| **L1** (Type-I ⟹ ancient) | cited/established (C3) | done | — (stable) |
| **L2** (σ=0 backward decay) | **OPEN — analytic wall** | **NO** | *Any* result producing critical-scale decay along one backward sequence of a bounded ancient solution. This is the only trigger that would move NS-048 — and it is the monotonicity-formula hunt (= NS-053's object, litmap §5). |
| **L3** (AB Thm 1.2) | cited (C2 + architecture) | partially (its engine) | as below |
| **L3-engine** (ESS backward uniqueness) | being formalized **as Tao's quantitative form** | **YES — the Carleman ladder** | **M1:** Tao Lemma 4.1 lands (no-`sorry`). **M2:** Props 4.2/4.3 land. **M3:** the backward-uniqueness wrapper lands ⟹ the ESS engine under AB Prop 4.2 is machine-verified (in Tao's form). M3 is the farthest rung — multi-year. |

## 4. Verdict (honest, firewalled)

**The Carleman ladder is necessary-infrastructure-adjacent to L3, not progress on NS-048.** Its
advance changes the *formal-verification status of the engine* L3 shares with Tao's theorem; it does
not, and cannot, supply L2. Concretely:

- Even at **M3** (the whole ladder done, backward-uniqueness wrapper machine-verified), NS-048's
  Type-I exclusion remains **open**, because L2 is still missing.
- The ladder is **Scope: formalization, `:proved`=0 for the PDE** (its own header: "library
  infrastructure … not an NS theorem"). It machine-verifies *existing* results (Tao's §4, an ESS
  descendant); it produces **no new PDE theorem** and so cannot close L2 by construction.
- Therefore: *do not* read ladder progress as "closing in on NS-048." The correct reading is "the
  closer's engine is being hardened; the gap (the antecedent) is untouched and is the σ=0 wall."

**What would change the verdict:** only movement on **L2** — a σ=0/critical-decay mechanism for
ancient solutions (the monotonicity-formula hunt, litmap §3/§5, NS-053's construction-side object).
If that ever lands, L1+L2+L3 compose and Type-I is excluded — and *then* a completed ladder would
mean the closer's engine is also machine-verified. The two are complementary, not substitutes; the
ladder is the cheap-to-track half, L2 is the hard half.

## 5. Ledger / watch

- This reduction is now a **tracked item** under NS-048 (dashboard P2 / registry note point here).
- **Trigger to revisit this doc:** (a) the Carleman ladder reaches step 3/4/5 (M1–M3) — update the
  L3-engine row + note whether a Tao-BU ⟹ AB-Prop-4.2 bridge is attempted; (b) *any* L2 movement
  (the real one) — which would be logged at NS-048 / NS-053 directly, not here.
- Relation to NS-053: L2 **is** the monotonicity-formula hunt; NS-053 approaches the same object from
  the construction side (litmap §5). A convergence of the two on a single quantity is the program's
  first genuine M4 candidate (aspiration, not a claim).

`:proved`=0. Distance UNTOUCHED. This doc verified and located other people's theorems and one
formalization track; the open core (L2, the σ=0 antecedent) is unchanged.
