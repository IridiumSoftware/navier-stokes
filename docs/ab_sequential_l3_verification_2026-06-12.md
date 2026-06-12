# Sequential-L³ Liouville line-read (litmap §4.1, the priority edge) — 2026-06-12

**Executes the litmap's top-ranked edge** (`docs/ns048_ancient_liouville_litmap.md` §4.1) and **resolves the
NS-054 G1∧G4 coupling tier** (MDAGC §5b). Source: arXiv:1811.00502 full text (ar5iv), theorem inventory +
proof-architecture extraction with verbatim anchors. `:proved`=0; distance UNTOUCHED.

## 1. Attribution — CONFIRMED (the litmap's open flag, closed)

The sequential-L³ Liouville **is Albritton–Barker: Theorem 1.2** of arXiv:1811.00502 (not a Seregin-line
result, as the litmap had flagged possible):

> **Thm 1.2 (verbatim hypothesis):** v a mild ancient solution with `sup_{k∈ℕ} ‖v(·,t_k)‖_{L³} < ∞` for a
> sequence of times `t_k ↓ −∞` ⇒ **v ≡ 0**.

Boundedness is required **only along a sequence** — the theorem is already in its weak-hypothesis form.
Also inventoried: Thm 1.1 (the Type-I ⟺ ancient equivalence, `I<∞`-conditioned — matching our round-2
C3 record exactly); Thm 3.1 (weak-`L^{p,∞}` Type-I characterizations, p∈[3,∞)); Thm 4.1 (a quantitative
weak-L³ variant, `‖v(·,t_k)‖ ≤ M` along a sequence).

## 2. The proof architecture — where each hypothesis works

| Step | Content | Source | Role of the hypothesis |
|---|---|---|---|
| rescale | `v^{(k)}(x,t) = √\|t_k\| v(√\|t_k\| x, \|t_k\| t)`-type rescaling **at the sequence times** | AB §2 | the L³ bound *at the t_k* normalizes the rescaled family at unit scale — **this is where sequentiality enters** |
| compactness | rescaled family → limit in `L³_loc` | Lemma 2.2 | powered entirely by the sequential L³ bound |
| persistence | a nontrivial limit would carry a singularity | Prop 2.3 ← **Rusin–Šverák** (JFA 2011, minimal-data) [their ref 26] | the contradiction's engine |
| regularity control | weak-`L^{3,∞}` solutions with the stated smallness are essentially bounded | Prop 4.2 ← **Albritton–Barker ARMA 2018** [3], resting on **Barker–Seregin–Šverák** CPDE 2018 [6] | *"proven in [3] by contradiction and **backward uniqueness arguments**"* (verbatim) |

**The Carleman-synergy question (litmap §4.1), answered with precision:** Theorem 1.2 does **not** invoke
backward uniqueness directly; it rests on it **one layer down** — Prop 4.2's engine is the ESS-lineage
backward-uniqueness machinery. So the repo's Carleman ladder (NS-051/T-28, currently mid-ladder-6 on Tao's
quantitative-L³ Carleman) **does touch the proof's substrate**: when the ladder reaches the
backward-uniqueness rung, it will be machine-verifying the engine under Prop 4.2 — the first place the
formalization track touches a live exclusion theorem's core, as the litmap anticipated.

## 3. The verdict on the edge (the kill criterion, applied honestly)

The litmap's kill: *"if the hypothesis is load-bearing at a step requiring ESS-type backward uniqueness in
a form known to be sharp, the edge is a wall-restatement — log and stop."*

**Partially met — and the structure is sharper than the kill anticipated.** The sequential hypothesis is
load-bearing at **compactness**, not at backward uniqueness. But the real finding is about the *gap*:

> **The gap from Thm 1.2 to the unconditional KNSS conjecture is NOT a "sequence → all times" refinement —
> the theorem already needs only a sequence. The gap is the `L³` structure itself:** a bounded ancient
> solution need not lie in `L³` at *any* time (a nonzero constant is the trivial witness — bounded,
> ancient, never `L³`; Thm 1.2 rightly concludes `≡0` because its hypothesis silently excludes the whole
> bounded-non-decaying class). The missing ingredient is **spatial decay at critical scaling** for ancient
> solutions — which is the σ=0 wall (S1) seen from the ancient side, i.e. precisely the litmap §3
> diagnosis (no critical monotonicity formula), again.

**Disposition: a SHARPENED wall-restatement.** Dead as a "small-δ improvement" lane (there is no obvious
interpolation between "`L³` along a sequence" and "merely bounded" — the hypothesis classes are
qualitatively different, not quantitatively adjacent). **Live in one precise sense:** the machinery is
*ready* — any future mechanism producing σ=0-decay along even one backward sequence of an ancient solution
plugs directly into Thm 1.2 and closes Type-I. That conditional form is the honest residual: **"σ=0
backward decay ⇒ Type-I exclusion" is now a cited, mechanism-mapped reduction**, not a hope.

## 4. Ledger actions

- **citation_tiers:** AB row extended — Thm 1.2 added at **C2 (statement verbatim) + proof-architecture
  mapped** (full line-verification of [3]'s backward-uniqueness core NOT done — flagged); lineage named
  (Rusin–Šverák JFA 2011; AB ARMA 2018; Barker–Seregin–Šverák CPDE 2018 — C1, named).
- **litmap:** §2.6 attribution flag closed (it IS AB; tier updated); §4.1 marked EXECUTED with this verdict.
- **MDAGC §5b:** the G1∧G4 edge's "tier-pending" resolved — the coupling now reads: *the ancient limit of
  an admissible singularity cannot admit any backward `L³`-quiet sequence* (AB Thm 1.2, C2+architecture).
- **NS-054 companion:** the open-tier note resolved the same way.

`:proved`=0. Distance UNTOUCHED — this pass verified and located other people's theorems; the open core
(the σ=0 decay/monotonicity structure) is unchanged and now named at one more wall-face.
