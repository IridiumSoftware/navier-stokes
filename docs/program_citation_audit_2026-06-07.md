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
| 1b | **Albritton–Barker, arXiv:1811.00502** (2019) — the Type-I **⟺** ancient equivalence, **Type-I-conditioned** (`I<∞`); **NOT** Seregin–Šverák (a different 2009 axisym paper), **NOT** KNSS (⇒ only) | **C3** ✅ *(line-verified 2026-06-07, round 2)* | "Liouville is the linchpin" — but only NS-048 ≡ *Type-I-conditioned* Liouville (the unconditioned KNSS conjecture is strictly stronger/open) | **Global** | **DONE** — misattribution + scope corrected |
| 2 | **NRŠ Acta 1996 + Tsai ARMA 1998** (NS-007) — self-similar exclusion | **NRŠ C2** (via Tsai's faithful reproduction; `U∈W^{1,2}_loc∩L³`⇒0) · **Tsai C3** (line-read) ✅ *(round 2)* | A **global no-go** (kills the backward self-similar construction) | **Global** | **DONE** — `L³` faithful; local-energy = Tsai (correctly attributed) |
| 3 | **Lei–Ren–Zhang (ℝ²×T¹, arXiv:1911.01571) + "Thm 3.7"** (= Thm 1.2 of arXiv:1902.11229) | **C3** ✅ *(line-read 2026-06-07, round 3)* | The universal *"every known with-swirl closer bypasses S / forces Γ-decay"* — **both confirmed to bypass S** (DGNM/weighted-energy on Γ → swirl-free → KNSS) | local | **DONE** — universal HOLDS, C1 hedge lifted |
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

**#1b — the Type-I ⟺ ancient equivalence — ✅ DONE 2026-06-07** (C1 → C3, round 2). **Misattribution +
scope corrected:** `arXiv:1811.00502` is **Albritton–Barker (2019)**, NOT Seregin–Šverák (a different,
2009 axisym paper). The ⟺ (Thm 1.1, **C3** line-verified) is a genuine general-3D biconditional, **but
Type-I-conditioned** (ancient hypothesis `I<∞`, scaled-energy — *not* pointwise `C/√(−t)`). So the
linchpin claim holds in its **narrower** form: *NS-048 (Type-I exclusion) ≡ the **Type-I-conditioned**
ancient Liouville* — the **unconditioned** KNSS conjecture is strictly stronger and open. My v0.1.85
"general Liouville" framing overstated it. (New low-priority: Seregin–Šverák 2009 CPDE 34, axisym Type-I.)

**#2 — NS-007: NRŠ (1996) + Tsai (1998) — ✅ DONE 2026-06-07** (round 2). **NRŠ → C2** (via Tsai's
faithful primary reproduction; hypothesis `U∈W^{1,2}_loc∩L³` ⇒ `U≡0`; the `Π`-max-principle + `L³`-decay
mechanism confirmed) — Acta 1996 PDF paywalled, so not C3. **Tsai → C3** (line-read his UBC PDF; Thm 1
`L^q` `q∈(3,∞]`, Thm 2 local-energy strictly weaker than `L³`). Our "`L³`" cite is **faithful** (with the
weak-solution understanding); the local-energy version was **correctly** attributed to Tsai. Global anchor
firmed.

**#3 — Lei–Ren–Zhang + "Thm 3.7" — ✅ DONE 2026-06-07** (C1 → C3, round 3). Both line-read at primary
(LRZ arXiv:1911.01571; Thm 3.7 = Thm 1.2 of arXiv:1902.11229, hypothesis byte-identical to the review's).
**Both BYPASS S** — LRZ forces `Γ≡0` (DGNM/oscillation-Harnack on the `Γ`-transport eq, using
z-periodicity + `∇·b=0`); Thm 3.7 forces `lim_{r→∞}Γ=0` (weighted `Γ`-energy estimate) — each → swirl-free
→ KNSS; neither writes the `Ω`-equation or touches `S`. **Universal HOLDS; the C1 hedge is lifted** (now
C3 for all three closers). The frontier doc's "road not taken" is strengthened, not threatened. See
`docs/citation_verification_round3_2026-06-07.md`.

**Verification campaign COMPLETE** (§ below): #1 ✅, #1b ✅, #2 ✅, #3 ✅.

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
