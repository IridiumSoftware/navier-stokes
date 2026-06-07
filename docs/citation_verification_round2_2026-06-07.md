# Citation verification round 2 — targets #1b (Type-I ⟺) + #2 (NS-007 self-similar) — 2026-06-07

Executes audit targets **#1b** (the Type-I⟺ancient equivalence, surfaced by target #1) and **#2**
(NS-007 NRŠ/Tsai self-similar exclusion). Both read at primary / faithful-primary level.
**Foundation-hardening, NOT PDE progress; `:proved`=0; distance UNTOUCHED.** The pass found a **major
misattribution** (a citation-supply-chain catch — exactly what C0–C5 was instituted for) and a scope
overstatement, both of which were in my own just-committed v0.1.85.

---

## 1. #1b — the Type-I ⟺ ancient equivalence: **Albritton–Barker, NOT Seregin–Šverák; Type-I-conditioned**

**MISATTRIBUTION CORRECTED (line-verified, C3).** `arXiv:1811.00502` is **Dallas Albritton & Tobias
Barker, "On local Type I singularities of the Navier–Stokes equations and Liouville theorems" (2019)** —
**not** Seregin–Šverák. The program (M4 calibration) and my v0.1.85 correction merged two distinct papers:
the **Seregin–Šverák** paper of near-identical title is a *different* **2009, axisymmetric** Type-I paper
(Comm. PDE 34(1-3):171–201, = Albritton–Barker's ref [29]). The general-3D biconditional is
Albritton–Barker's.

**The equivalence (Albritton–Barker Thm 1.1, C3):** *there exists a suitable weak solution with a Type-I
singular point* **⟺** *there exists a nontrivial mild bounded ancient solution with `I<∞`.* A genuine iff,
**general 3D, no axisymmetry, no swirl, no smallness.** The **⇒** is "essentially known" (imported from
the KNSS-type line [29],[37]); the **⇐** (zoom-out an ancient solution to manufacture a singularity, via
Rusin–Šverák persistence + backward uniqueness) is Albritton–Barker's novelty.

**SCOPE CORRECTION — the iff is Type-I-CONDITIONED.** The ancient-side hypothesis is `I<∞`, where `I` is
the **scaled-energy / Morrey** Type-I quantity (`sup` over parabolic balls of scaled energy + scaled `L³`
+ scaled pressure + scaled Dirichlet) — **not** the pointwise `C/√(−t)` form (which is explicitly
*insufficient* for ⇐, their Remark 3.2). Consequence for our framing:

> "Type-I singularity ⟺ Type-I-conditioned (`I<∞`) nontrivial ancient solution" — **NOT** "general
> Liouville ⟺ no blowup." The **unconditioned** KNSS conjecture (mild bounded ancient ⇒ constant, *no*
> Type-I assumption) is **strictly stronger and open.**

So my v0.1.85 "Liouville is the linchpin / NS-048 ≡ general Liouville" **overstated it.** Honest: **NS-048
(Type-I exclusion) ≡ the *Type-I-conditioned* ancient Liouville (Albritton–Barker)**; closing the
*general* Liouville is more than NS-048 needs and is itself the open KNSS conjecture. (The machinery study
§5 hedge "*a reformulation of the result **for the Type-I case***" was right; the "general 3D Liouville ⟺"
phrasing and the v0.1.85 framing were not.)

**Tier: C3.** **New (low-priority) target spawned:** Seregin–Šverák 2009 (CPDE 34), if the axisymmetric
Type-I result is wanted specifically.

---

## 2. #2 — NS-007 (NRŠ + Tsai self-similar exclusion): **CONFIRMED**

A **global no-go** (kills the backward self-similar construction). Verified:

- **NRŠ (Acta 1996) — tier C2** (via Tsai's faithful primary reproduction; the Acta PDF is paywalled, not
  line-read). Profile system `−νΔU + aU + a(y·∇)U + (U·∇)U + ∇P = 0, div U=0`. **Hypothesis: `U∈L³(ℝ³)`,
  precisely a *weak solution* `U∈W^{1,2}_loc∩L³`** (smooth by interior regularity). Conclusion `U≡0`.
  Mechanism confirmed: the auxiliary scalar **`Π=½|U|²+P+a(y·U)`** obeys `−νΔΠ+(U+ay)·∇Π = −ν|Ω|²≤0`
  (max principle); the `L³` hypothesis gives decay `U=O(|y|^{−3})`, `P=O(|y|^{−2})` ⇒ `Π=o(1)` at ∞ ⇒
  `Π` const ⇒ `|Ω|²=0` ⇒ irrotational + Liouville ⇒ `U≡0`. The `L³` role is *exactly* decay-at-infinity
  with no boundary term (Remark 5.4: some growth/integrability assumption is necessary — `U=∇Φ` for
  harmonic `Φ` solves the profile equation, so the hypothesis is load-bearing).
- **Tsai (ARMA 1998) — tier C3** (line-read, his UBC page `~ttsai/publications/leray.pdf`). **Thm 1:**
  weak solution `U∈L^q`, `q∈(3,∞]` ⇒ constant (≡0 for `q<∞`; `q=∞` only forces *constant*). **Thm 2:** a
  self-similar solution satisfying the **local energy estimates** (CKN-class, *strictly weaker than `L³`*,
  admitting the homogeneity-`(−1)` candidate) ⇒ `u≡0` — no Leray–Hopf or boundary condition imposed; the
  suitable-weak-solution structure is *derived*.

**Faithfulness check:** our "no nontrivial backward self-similar blowup in `L³`" (NRŠ) is **faithful**
(with the `W^{1,2}_loc` weak-solution understanding); the **local-energy** strengthening is **Tsai**, and
we'd already attributed it to Tsai (machinery study M3 — correct). Minor: cite "`q<∞` ⇒ `≡0`" (the `q=∞`
case yields only *constant*); state "weak solution" alongside `L³`.

---

## 3. What this corrects (honesty ledger + supply-chain)

- **Two citation-supply-chain catches, both in my v0.1.85:** (a) *secondary-source drift* (failure-mode
  #2) — the M4 calibration's "Seregin–Šverák" label propagated into my KNSS-verification correction
  without my checking the arXiv id, which actually resolves to **Albritton–Barker**; (b) *wrong-emphasis /
  over-broad scope* (failure-mode #3) — I framed the iff as "general Liouville," but it is **Type-I-
  conditioned**. Both are exactly the failure modes the C0–C5 discipline (and this audit) target — and the
  discipline caught them *one verification pass later*. The previous KNSS-verification doc's §3b/§5/§6
  "Seregin–Šverák" statements are **superseded by this doc** (corrected inline there too).
- **Net:** the ⟺ is real, C3, and **owned by Albritton–Barker (2019), Type-I-conditioned**; NS-007 is
  confirmed (NRŠ `L³` C2, Tsai C3). The "linchpin" claim survives in its correct, narrower form (NS-048 ≡
  *Type-I-conditioned* Liouville), not the overstated general form.

---

## 4. Tier updates + agenda

- **#1b DONE:** Albritton–Barker arXiv:1811.00502 Thm 1.1 = **C3** (Type-I-conditioned iff, general 3D).
  Misattribution + scope corrected in: this doc, `knss_verification_2026-06-07.md` §3b (banner),
  `ns048_machinery_study.md` §5, the audit (#1b row).
- **#2 DONE:** NS-007 — **NRŠ C2** (via faithful Tsai reproduction), **Tsai C3** (line-read). Solid.
- **Remaining audit target:** **#3** — Lei–Ren–Zhang + "Thm 3.7" (C1), firms the arc's "every known
  closer bypasses S" universal. **New low-priority:** Seregin–Šverák 2009 (CPDE 34) axisym Type-I.

---

## 5. Sources + flags

**Verified:** Albritton–Barker `https://arxiv.org/pdf/1811.00502` (curl + `pdftotext -layout`, 15pp,
**C3**); Tsai `https://personal.math.ubc.ca/~ttsai/publications/leray.pdf` (curl + pdftotext, full ARMA
text, **C3**); Ozański–Pooley review `arXiv:1708.09787` (corroborates NRŠ, secondary).

**Flagged:** Albritton–Barker published venue not confirmable from the arXiv PDF (preprint v2). **NRŠ Acta
1996 not line-read** (paywalled — Project Euclid/Springer blocked) ⇒ NRŠ stays **C2-via-faithful-Tsai-
reproduction**, not C3; reaching C3 needs the Acta PDF. Seregin–Šverák 2009 (CPDE 34) not retrieved (the
axisymmetric Type-I paper) — title only.
