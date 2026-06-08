# C5 adversarial pass — `|x₃|^α` + Type-II rate bounds: both SURVIVED; hard verification = NONE exists

**Date:** 2026-06-07. A **C5 pass** (per the high bar: *try to DISPROVE the result*; audit whether anyone
has done — and published — **hard** verification: formal/machine, computer-algebra, rigorous-numerics, as
opposed to *social* verification = peer-review + citation; and scope-check our use) on the two recent
load-bearing results. Four hostile/audit agents (proof-attack + verification-audit × 2 targets).
**Foundation-hardening, NOT PDE progress; `:proved`=0; distance UNTOUCHED.**

**Headline:** both results **survive adversarial attack** at the text-checkable level and our **use is
faithful** — but **neither has any hard/machine verification, and essentially no analytic-PDE regularity
result does.** The deepest technical cores (Carleman estimates; near-axis fractional GN) are *not*
text-checkable and remain the irreducible "trust peer-review" floor. The obstruction manifold's
foundation is **socially verified** (+ for Type-II, a partial independent cross-check of the
*phenomenon*). That is the honest ceiling.

---

## 1. `|x₃|^α` criterion — Wang–Huang–Wei–Yu, arXiv:2205.13893, Thm 1.4

**Proof-attack: SURVIVED.** No error/gap/counterexample. The adversary independently re-derived
(C4-grade): the anisotropic-Hardy–Sobolev scaling; the **`α<1/4` constraint traced precisely** —
`(p−2)/(2p)=½−1/p` minimized at the Serrin floor `p=3/(1−α)` gives `α=1/4`, so `α<1/4` is exactly "keep
the full `p`-range," a *range-choice not a method ceiling* (honestly not claimed sharp by the authors);
the **Gronwall closing** — every exponent checked, the coefficient `2p/(p−pα−3)` positive throughout,
criticality `2/q+3/p=1−α` used *correctly* (it is exactly what makes the coefficient `L¹` in time),
nothing dropped. **The one step beyond text-checking:** the fractional-GN step chained with Lemma 2.1's
near-axis identification `‖∇∂_r(u_r/r)‖_{L²}≈‖∇Γ‖_{L²}` (imports external lemmas; most likely place a
constant could blow up if `α` is pushed).

**Scope of OUR use: FAITHFUL.** We cite it only to conclude "the finite-time proof is
direct-Gronwall-on-`[0,T)`, so it does NOT transfer to the ancient (no-initial-time) setting." Confirmed
structurally: the closing integrates `d/dt Y ≤ C g Y` **forward from `t=0`**, output constant depends on
`Y(0)=‖Φ(0)‖²+‖Γ(0)‖²`, seeded by the **`u₀∈H²`** hypothesis — an ancient solution has no `Y(0)` to
anchor it. *(Refinement: `u₀∈H²` is a real, visible hypothesis — the result is a finite-time *smoothness*
criterion, not bare Leray–Hopf; this does not affect our use, which is about proof-structure.)*

**Hard-verification status: PEER-REVIEWED-ONLY (social).** Published **JMAA 2023** — *same four authors*
(not an independent re-proof). **No** Lean/Coq/Isabelle formalization (the only Lean NS artifact is a
problem-statement scaffold). **No** CAP/rigorous-numerics (non-explicit constants — nothing to interval-
check). **No** independent re-proof, no errata. Lightly cited, mostly in-passing. *(The round-2
"Chen–Tsai–Zhang misprint" flag was a name-conflation — the paper improves Chen–**Fang**–Zhang, no erratum
in its body.)*

---

## 2. Type-II rate bounds — Tao 2019 (triple-log) + Ożański–Palasek 2022 (double-log)

**Proof-attack: SURVIVED.**
- **Tao triple-log:** all three logs are **load-bearing** — the decisive consistency check is that in
  `d≥4` you lose Leray's epochs of regularity and gain *exactly one more* exponential (quadruple-log),
  precisely as Remark 1.5's attribution predicts. It is a genuine **lower** bound (a higher true rate
  would not weaken it). `Thm 1.2 ⇒ Thm 1.4` verified (the exp↔log inversion checked numerically:
  #exponentials = #logs).
- **Palasek double-log:** confirmed genuinely *double*-log, genuinely *plain weak-`L³` (`L^{3,∞}`)*,
  genuinely *axisymmetric-only*; `Cor 1.2` follows from `Thm 1.1`; the swirl/parabolic (Nazarov–Ural'tseva)
  step legitimately replaces Tao's Carleman.
- **Beyond text-checking (honest don't-bluff):** the agent did **not** re-derive Tao's Carleman
  inequalities (Props 4.2/4.3) or the pigeonholing constants, or Palasek's Prop 5.1 Hölder step — "I am
  not faking a verdict on them." Nothing *checkable* showed an error.

**Scope of OUR use: FAITHFUL.** "(i) partial Type-II exclusion via slowly-diverging rate lower bounds;
(ii) the gap to full exclusion is *qualitative* (force the rate faster than the equation permits)" is
**exactly the content** — neither result *excludes* Type-II; neither gets a power/near-power rate
anywhere; "diverges arbitrarily slowly" is precise. **One tightening (already honored in our Type-II
doc):** keep the double-log tagged **"axisymmetric, weak-`L³`"** (Tao's is general 3D strong-`L³`; do not
pair the double-log with general 3D).

**Hard-verification status: PEER-REVIEWED + PARTIALLY INDEPENDENTLY CROSS-CHECKED (phenomenon only).**
Strong venues (Tao: AMS PSPUM 104, 65 cites/20 influential, method *used* by follow-ons; Ożański–Palasek:
Annals of PDE 2023; Barker–Prange: CMP 2021). **Palasek's distinct-method double-log is a genuine partial
independent cross-check of the slow-divergence *phenomenon*** — multiple authors, re-engineered (not
copied) Carleman step, same iterated-log conclusion — **but not** of Tao's exact triple-log constant.
**No** formal/machine verification (no proof-assistant has Carleman/parabolic-NS theory); **no** CAP
(non-explicit constants). *(Bonus: Palasek flags a real misprint in the published Chen–Tsai–Zhang [9] rate
— double-log, not as printed; we don't cite CTZ directly, so no action.)*

---

## 3. The honest C5 verdict + the epistemic floor

- **C5-adversarial: ACHIEVED for both** — survived a hostile disprove-attempt at the text-checkable level,
  with **faithful use** confirmed.
- **Hard/machine verification: NONE exists** — for either target, or (essentially) for *any* analytic-PDE
  regularity result. The Clay problem and its surrounding machinery (Carleman estimates, mixed-Lorentz /
  Besov harmonic analysis with quantitative constants, axisymmetric-NS `H²` theory) are **un-formalized**;
  CAP is structurally inapplicable while constants stay non-explicit.
- **So the irreducible floor:** the obstruction manifold's load-bearing foundation is **socially verified**
  (peer-review + citation; for Type-II also a partial *phenomenon* cross-check). The C5 pass confirms
  **internal consistency + faithful use**; it **cannot** substitute for the non-existent formal/machine
  verification of the Carleman/GN cores. *That is the true status — stated plainly, not hidden behind a
  tier label.*
- **Independence caveat:** this pass was **internal** (Claude adversaries) + literature audit — weaker than
  external by the program's own [[feedback_validator_confirmation_bias]] rule. A genuinely-independent C5
  would route through external witnesses; the *gold standard* (formal/machine) doesn't exist and would be a
  multi-year Lean+mathlib effort no group has announced.

---

## 4. What hard verification would actually take (the ceiling, for the record)

- **Formal (Lean/Isabelle):** first formalize the missing substrate — mixed/anisotropic Lorentz & Besov
  spaces with quantitative constants, fractional GN, Mihlin–Hörmander, **Carleman estimates for the heat
  operator** (quantitative backward-uniqueness / unique-continuation — *absent from every proof-assistant
  library*), the axisymmetric-NS weak-solution + `H²`-continuation theory. Multi-year mathlib efforts
  *before the theorems could even be stated*.
- **Computer-assisted (CAP/interval):** inapplicable as written (non-explicit `O(1)`/`C_k` constants). Would
  require first re-proving an *explicit-constant* version (a genuine new analytic contribution), then
  interval-validating — done by no one.

---

## 5. Net + actions

No error or gap found in either target; **our use is faithful**; the firewall is untouched (`:proved`=0).
Micro-refinements recorded: `|x₃|^α` carries `u₀∈H²` (smoothness criterion, not bare Leray–Hopf — immaterial
to our proof-structure use); the double-log stays "axisymmetric weak-`L³`"-tagged (already so). **Honest
tier label going forward: "C5-adversarial-survived; hard-verification = none (social-verification floor)."**
This is the truthful ceiling for citation hardening short of original formalization work — which is itself
a separate, field-wide, multi-year undertaking, not a session task.

---

## 6. Sources + the agents' honest limits

**Targets (primary, read in full):** Wang–Huang–Wei–Yu arXiv:2205.13893 (Thm 1.4, §4 proof); Tao
arXiv:1908.04958 (Thms 1.2/1.4, Remark 1.5, §6); Ożański–Palasek arXiv:2210.10030 (Thm 1.1, Cor 1.2);
context: Palasek arXiv:2101.08586 (ARMA 2021), Barker–Prange arXiv:2003.06717 (CMP 2021) + survey
arXiv:2211.16215. Verification-status: Lean `lean-dojo/LeanMillenniumPrizeProblems` (scaffold only),
Isabelle AFP, Semantic Scholar citation data, Tao's 2019 blog (no errata/error-trail).

**Honest limits (recorded, not hidden):** the adversaries verified statements, scalings, exponent
identities, and theorem-to-corollary implications; they did **not** re-derive the Carleman estimates, the
pigeonholing constants, the near-axis fractional-GN constant, or Palasek's Hölder-exponent step — these
are genuinely beyond text-level checking and no verdict was faked on them. If an error exists in any
target, it is most plausibly in one of those imported/black-box analytic cores — exactly the part that
*also* has no hard verification anywhere.
