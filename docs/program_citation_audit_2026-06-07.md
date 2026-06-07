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
| 1 | **KNSS, Acta 2009** — 2D & axisym-no-swirl Liouville (Thm 5.1/5.2); `|u|≤C/r`⇒0 (Thm 5.3); compactness lemma (Lemma 6.1); Type-I **⇒** ancient (Prop 6.1) | **C3** ✅ *(line-verified 2026-06-07, `docs/knss_verification_2026-06-07.md`)* | *Terminal step of every axisymmetric closer* (swirl-free reduction); the compactness behind the blow-down; the Type-I⇒ancient bridge | **Global** (foundation) | **DONE** — swirl-free reduction confirmed **hypothesis-clean** |
| 1b | **Seregin–Šverák, arXiv:1811.00502** — the Type-I **⟺** ancient equivalence (NOT KNSS, which is ⇒ only) | **C1** (calibration-search only) | "Liouville is the linchpin" reformulation | **Global** | **YES — new (ex-#1)** |
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

**#1 — KNSS (Acta 2009): the swirl-free reduction + compactness lemma — ✅ DONE 2026-06-07** (C2/C1 → C3,
`docs/knss_verification_2026-06-07.md`). Line-verified: the swirl-free reduction (Thm 5.2) is **C3 and
hypothesis-clean** (exactly bounded+axisym+no-swirl; regularity derived); the compactness lemma (Lemma
6.1) is **C3** with a **uniform-`L∞`-only** input — which *also* C3-confirmed route (i)'s compactness
break. Corrections surfaced: the Type-I **⟺** is *not* KNSS (KNSS = ⇒ only, Prop 6.1) but **Seregin–Šverák
(new C1 target #1b)**; 2D is `b(t)`(weak)/constant(mild); the Type-I *exclusion* needs the off-axis
`|u|≤C/r` decay; "Lemma 6.1" is the *compactness* lemma, not the rescaling. Foundation of the arc is now
solid.

**#1b — Seregin–Šverák, arXiv:1811.00502 (the Type-I ⟺ ancient equivalence, C1 → C2/C3).** *Surfaced by
target #1.* Carries the "Liouville is the linchpin" reformulation; currently calibration-search-only.
Reading it firms the load-bearing claim that NS-048 (Type-I exclusion) ≡ the general 3D Liouville theorem.

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
