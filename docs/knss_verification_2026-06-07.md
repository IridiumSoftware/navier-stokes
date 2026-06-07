# KNSS verification (citation-audit target #1) — line-verified to C3, with corrections

**Date:** 2026-06-07. Executes target #1 of `docs/program_citation_audit_2026-06-07.md`: read
Koch–Nadirashvili–Seregin–Šverák, *Liouville theorems for the NS equations and applications* (Acta Math.
203 (2009); arXiv:0709.3599; canonical PDF `sverak/publications/liouville.pdf`) **line-by-line** and
promote our citation from C2/C1 to **C3**. **Foundation-hardening, NOT PDE progress; `:proved`=0; distance
UNTOUCHED.** Method: `curl` + `pdftotext -layout`, both URLs cross-checked (byte-identical text).

---

## 1. The five items — all now C3 (line-verified)

| Item | KNSS locus | Exact result | Tier |
|---|---|---|---|
| 2D Liouville | Thm 5.1 | bounded **weak** ancient on `ℝ²×(−∞,0)` ⇒ `u=b(t)` (**not** constant — see §3a) | **C3** |
| 3D axisym **no-swirl** | Thm 5.2 | bounded **weak** ancient axisym, `u^θ≡0` ⇒ `u=(0,0,b₃(t))` | **C3** |
| `|u|≤C/r` ⇒ 0 | Thm 5.3 | + cylindrical-radius bound `|u|≤C/√(x₁²+x₂²)` ⇒ `u≡0` | **C3** |
| compactness | Lemma 6.1 | uniform `|u_l|≤C` + `T_l↘−∞` ⇒ subseq → ancient mild limit, `|u|≤C` | **C3** |
| Type-I ⇒ ancient | Prop 6.1 | a finite-time singularity from a **mild** solution generates a nontrivial bounded ancient **mild** solution | **C3** |

Common proof engine (2D / no-swirl): the scalar `ω` (2D) or `ω^θ/r` (axisym, recognized as a **5-D
Laplacian** on SO(4)-invariant functions) satisfies a source-free drift-diffusion; Lemma 2.1
(perturbed strong-maximum-principle stability) forces `≥M₁/2` on arbitrarily large parabolic balls; an
`R⁴`-vs-`R³` Stokes/flux count then kills it ⇒ `curl u=0=div u`, bounded ⇒ harmonic-Liouville ⇒ result.

---

## 2. The key POSITIVE — the swirl-free reduction is hypothesis-clean

**Thm 5.2 carries NO hidden hypothesis.** It is exactly *bounded + weak + axisymmetric + no-swirl*;
interior smoothness is **derived** from boundedness (KNSS §4: decomposition Lemma 3.1 + smoothing
Prop 4.1 + `ω`-bootstrap), not assumed — no decay, no suitability, no extra regularity. Since mild ⊂
weak and mild kills the `b(t)` parasite (Remark 6.1 ⇒ literally constant), **every downstream invocation
of "bounded mild axisymmetric swirl-free ancient ⇒ trivial" is FAITHFUL.** This is the single most
load-bearing fact in the axisymmetric arc — every closer (LZZ, LRZ, Thm 3.7, our route (i)/(ii)) reduces
to it — and it is now C3 and confirmed clean. **The reduction chain's terminal step is solid.**

---

## 3. Corrections the verification produced (the don't-bluff check did work)

**(a) 2D is `u=b(t)`, not "constant" — for weak solutions.** Weak solutions admit the parasitic
`u=b(t), p=−b′(t)·x`; "constant" holds **only** under the *mild* convention (Remark 6.1). We mostly
carried this hedge already (machinery study M1/M4: "constant (or `b(t)` per convention)"); now pinned to
source. Honest cite: *weak ⇒ `b(t)`; mild ⇒ constant.*

**(b) The Type-I "⟺" is NOT KNSS — it is `⇒` only in KNSS; the full equivalence is Seregin–Šverák.**
KNSS **Prop 6.1** proves only the forward direction (*singularity ⇒ nontrivial bounded ancient mild
solution*). KNSS does **not** state a biconditional. The full **⟺** (the "Liouville is the linchpin"
reformulation) is **Seregin–Šverák, arXiv:1811.00502** — which we hold at **C1** (M4 calibration search,
not primary-read). **Correction:** wherever the program writes "KNSS: Type-I ⟺ ancient," it should read
"KNSS: ⇒ (Prop 6.1, **C3**); the ⟺ is Seregin–Šverák (**C1** — new verification target)." Applied to the
citation audit (KNSS row) and the machinery study §5 attribution.

**(c) The Type-I *exclusion* (Thm 6.2) needs the off-axis decay `|u|≤C/r` (eq 6.6).** KNSS explicitly
flags that dropping (6.6) makes the statement fail (`u=b(t)` counterexample). So "KNSS rules out Type-I
axisymmetric singularities" must carry the off-axis `|u|≤C/r` condition (holds for fast-decaying /
compactly-supported data). Caveat to attach wherever the Type-I exclusion is cited.

**(d) "Lemma 6.1" is the COMPACTNESS lemma, not the rescaling.** Its statement is: *uniform `|u_l|≤C` +
`T_l↘−∞` ⇒ a subsequence converges locally-uniformly to an ancient mild solution with `|u|≤C`.* The
**compactness input is a uniform `L∞` bound only** (parabolic smoothing §4 upgrades `L∞`→`C^∞_loc`). The
*blow-down* itself is an **unlabeled procedure** before Prop 6.1 (`v^(k)(y,s)=M_k⁻¹u(x_k+y/M_k,
t_k+s/M_k²)`, `M_k=H(t_k)→∞`), and the *rigidity* excluding the limit is the §5 Liouville theorem +
scale-invariant bound. So citing "the KNSS Lemma-6.1 blow-down" conflates the compactness lemma with the
procedure; corrected in route (i) §8 and the audit.

---

## 4. This C3-confirms route (i)'s second break

Route (i) (`docs/ns048_route_i_blowdown.md` §4) claimed the `|x₃|^α` blow-down fails compactness because
`‖u_λ‖_∞=λ‖u‖_∞→∞`. **KNSS's compactness lemma (item 3) needs precisely a uniform `L∞` bound** — now
read at source (C3). So the blow-down's compactness genuinely requires the uniform sup-bound that the
`|x₃|^α` family lacks: **route (i)'s break #2 is now C3-confirmed against KNSS's actual compactness
input,** not merely asserted. (Break #1 — the radial-amplification — remains self-derived + C3-LZZ
contrast.)

---

## 5. Tier updates + verdict

- **KNSS (Acta 2009): C2/C1 → C3** for items 1–5 (audit row updated). The swirl-free reduction (§2) is
  C3 **and hypothesis-clean** — the reduction chain's foundation is solid.
- **NEW C1 verification target surfaced:** Seregin–Šverák arXiv:1811.00502 (the Type-I **⟺**), currently
  C1. It carries the "Liouville is the linchpin" claim, so it inherits target-priority (slots in alongside
  audit #2/#3).
- **Target #1: DONE.** Net informational work: confirmed the foundation clean (§2); reattributed the ⟺
  (§3b); attached the Type-I-exclusion off-axis caveat (§3c); fixed the Lemma-6.1 naming (§3d); and
  C3-confirmed route (i)'s compactness break (§4). `:proved`=0; nothing here is PDE progress.

---

## 6. Sources + flags

**Verified (C3, read line-by-line):** `https://www-users.cse.umn.edu/~sverak/publications/liouville.pdf`
(curl + `pdftotext -layout`); `https://arxiv.org/pdf/0709.3599` (cross-check, identical text). Line/lemma
numbers per the canonical PDF.

**Flagged:** Acta pagination (83–105) not cross-checked vs the 26-pp preprint numbering (immaterial). The
references KNSS cite for "no-swirl ⇒ regular" ([18],[29]) and Chen–Strain–Tsai–Yau were read only through
KNSS's own characterization, not retrieved. **Seregin–Šverák arXiv:1811.00502 (the ⟺) remains C1** — not
read at source this pass; the new target.
