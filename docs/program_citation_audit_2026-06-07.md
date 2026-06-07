# Citation audit (C0–C5) + verification targets — 2026-06-07

First **program-level** application of the C0–C5 citation discipline (instituted v0.1.81). Purpose: tier
the program's load-bearing external citations and **rank what to verify next**, by
`priority = load-bearing-ness × (gap to C3) × (global > local)`. This is **verification of the obstruction
manifold's foundations — not PDE progress;** `:proved`=0 unchanged. Tiers: C0 unverified · C1
secondary/restatement · C2 primary statement read · C3 proof line-verified · C4 mechanism re-derived ·
C5 adversarially checked.

---

## 1. The audit table (load-bearing external citations)

| # | Citation | Tier | Supports (load-bearing role) | Global/local | Verify? |
|---|---|---|---|---|---|
| 1 | **KNSS, Acta 2009** — 2D & axisym-no-swirl Liouville; Type-I⟺ancient equivalence; **swirl-free reduction**; **Lemma 6.1 blow-down** | **C2** (statements); **C1** (Lemma 6.1, via LZZ's use) | *Terminal step of every axisymmetric closer*; the rescaling device route (i) leaned on; the ancient↔Type-I bridge | **Global** (foundation of the ancient approach) | **YES — #1** |
| 2 | **NRŠ Acta 1996 + Tsai ARMA 1998** (NS-007) — self-similar exclusion | **C1** (exact spaces: `W^{1,2}_loc∩L³`? Tsai's local-energy hypothesis — paraphrased, not primary-read) | A **global no-go** (kills the backward self-similar construction) | **Global** | **YES — #2** |
| 3 | **Lei–Ren–Zhang (ℝ²×T¹) + "Thm 3.7"** (review's frontier closers) | **C1** (Q.S. Zhang review paragraph only) | The universal *"every known with-swirl closer bypasses S / forces Γ-decay"* (NS-048 arc) | local | **YES — #3** |
| 4 | **Tao, JAMS 2016** (NS-008) averaged-NS blowup | **C2** (statement); scope of the killed method-class not line-verified | A **global no-go** (energy-only methods can't close NS) | **Global** | partial |
| 5 | **Pan–Li, Bull. Sci. Math. 2020** — `α<1` constancy, `α=1` sharp counterexamples | **C2** (via review) | The route-(i) **counterexample suspicion** for the axial-only conjecture | local | Tier-3 |
| 6 | **ESS 2003** (NS-005) endpoint + backward-uniqueness | **C2** (endpoint); **C1** (lemma numbering/constants, via Tao's restatement) | The L³ endpoint; M6 of the machinery study | **Global** | Tier-3 |
| 7 | **CKN 1982** (NS-006) ε-regularity, `𝒫¹(S)=0` | **C2** (statement); **C1** (`ε₀` constants) | CKN/rescaling input; partial regularity | **Global** | Tier-3 (details only) |
| 8 | **NS-002 supercriticality** | **C2+** (mainstream consensus) | THE central global obstruction | **Global** | no (solid) |
| — | **Solid (C3, no action):** Lei–Zhang–Zhao 1701.00868 §5; Wang–Huang–Wei–Yu 2205.13893; CFZ 1802.08956 (multi-scale) | **C3** (line-read this session) | LZZ-bypasses-S; the `|x₃|^α` transfer verdict | — | no |
| — | **Yu Appl. Anal. 2020** (C1, paywalled) | **C1** | the L^∞ small-norm `|x₃|` variant — **NOT load-bearing** (transfer verdict rests on Wang et al. C3) | local | low |
| — | **CFZ DCDS 2017 [10]** (C1, unfetched) | **C1** | continuation lemma — corroborated via the C3 multi-scale reuse | local | low |

---

## 2. The ranked verification targets (what to attack next)

**#1 — KNSS (Acta 2009): the swirl-free reduction + Lemma 6.1 blow-down (C2/C1 → C3).** *Highest
leverage.* Every axisymmetric-with-swirl closer (LZZ, LRZ, Thm 3.7, and our route (i)/(ii) framings)
terminates by reducing to the **swirl-free** case and invoking KNSS; and route (i)'s entire device is the
KNSS **Lemma 6.1** blow-down, currently **C1** (known only through LZZ's use of it). The whole ancient
approach — including the Type-I⟺ancient equivalence that licenses NS-048 — rests on this one paper.
Line-verifying the swirl-free reduction theorem and Lemma 6.1 promotes the **foundation** of the arc from
C2/C1 to C3.

**#2 — NS-007: NRŠ (1996) + Tsai (1998) exact hypotheses (C1 → C2).** A **global no-go** (self-similar
exclusion) whose *exact spaces* are currently paraphrased, not primary-read (machinery study §12 flag:
`U∈L³` vs `W^{1,2}_loc∩L³`; Tsai's local-energy class). Per the new mission framing (global anchors are
top value), firming a global exclusion's hypotheses is high-priority — a dropped hypothesis here would
silently weaken the whole self-similar branch.

**#3 — Lei–Ren–Zhang + "Thm 3.7" (C1 → C2/C3).** The NS-048-arc universal *"every known with-swirl closer
bypasses S"* is **C3 for LZZ but only C1 for these two** (review-paragraph only). Reading their primaries
either firms the universal to C2/C3 or surfaces a closer that *does* touch S (which would itself reshape
the frontier doc). Either outcome is informative.

---

## 3. Tier-3 (lower leverage)

- **Pan–Li (C2→C3):** firms the route-(i) counterexample suspicion (is `α=1` truly sharp with a
  *bounded-`u^θ`, `z`-decaying* counterexample?). Worth it *if* we pursue the counterexample sub-question.
- **NS-008 Tao scope (C2→C3-ish):** verify exactly which method-class the averaged-NS blowup kills — the
  precise scope is what makes it a *global* no-go.
- **ESS lemma-level / CKN `ε₀` constants (C1):** details only; the load-bearing *statements* are C2-solid.
  Promote only if a future argument leans on the constants.
- **Yu / CFZ-2017 (C1):** not load-bearing for any current conclusion — leave unless they become so.

---

## 4. Recommendation + honest scope

**Attack #1 (KNSS) first.** It is the single highest-leverage verification: the terminal reduction and the
blow-down device of the entire axisymmetric program, currently sitting at C2/C1 under everything. **#2
(NS-007)** is the top *global-anchor* firm-up. **#3 (LRZ/Thm 3.7)** resolves the standing C1 hedge on the
arc's universal.

**This is foundation-hardening, not PDE progress** — it raises the confidence of the obstruction manifold
(the meta-review's "epistemic supply-chain integrity"), nothing more. `:proved`=0; distance UNTOUCHED. The
audit also discharges the meta-review's deferred "global-no-go anchors first" retrofit *as a plan*: the
anchors NS-002 (solid), NS-005/006 (C2 statements, C1 details), NS-007 (C1 — **target #2**), NS-008 (C2 —
Tier-3) are now tiered; NS-007 is the one global anchor whose load-bearing hypotheses are genuinely
under-verified.
