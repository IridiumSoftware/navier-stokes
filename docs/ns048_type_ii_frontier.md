# NS-048 Type-II branch — frontier map (exclusion ⊕ construction): both sides OPEN

**Date:** 2026-06-07. **MAP / POSITIONING artifact. NO theorem.** `:proved`=0; distance UNTOUCHED;
NS-048 unchanged. Maps the *harder* branch of the exclusion program (machinery study `ns048_machinery_study.md`
§8/M7) at primary-source level, with C0–C5 tiers. **Verdict up front: Type-II singularity formation for the
true, unforced, viscous 3D NS is OPEN on BOTH sides** — no rigorous construction exists, and no general
exclusion exists; the program can map it but cannot resolve it.

---

## 1. Why Type-II is the hard branch — and the *complement* of the Type-I machinery

**Type-I** (`‖u(t)‖_∞ ≲ (T−t)^{−1/2}`, critical norm bounded): the parabolic rescaling `u_λ` stays bounded
→ a bounded ancient limit → excluded by a Liouville theorem. *This is the entire NS-048 axisymmetric arc.*
**Type-II** (faster / critical norm UNBOUNDED): the rescaling **loses compactness** — no bounded ancient
limit — so the Liouville/extract-and-kill machinery **does not apply at all.**

**Structural complement (load-bearing).** The Albritton–Barker equivalence (Type-I singularity ⟺
nontrivial bounded ancient mild solution, **C3**, verified `docs/citation_verification_round2`) is
**Type-I-conditioned** (`I<∞`). So **Type-II is precisely the regime *outside* that bridge.** The
program's main tool — the ancient-solution Liouville machinery — has a **Type-I ceiling**; Type-II is the
complement, and it needs a *different paradigm* (modulation theory / matched asymptotics, §3), not
compactness-Liouville. By ESS (**C3**), a genuine singularity must have `‖u(t)‖_{L³}→∞` — i.e. any NS
singularity is necessarily of this critical-norm-unbounded (Type-II-ish) kind. So Type-II is not a corner
case; **it is where a real NS singularity, if any, must live.**

---

## 2. The EXCLUSION side — quantitative regularity = *partial* Type-II exclusion

The quantitative-regularity program proves blowup-rate **lower** bounds: *if* a singularity exists, the
critical norm must diverge at least at rate `R(t)`. Excluding Type-II would mean pushing `R(t)` past what
a solution can satisfy. Current frontier (all primary-read, **C3** unless noted):

| Result | Statement | Tier |
|---|---|---|
| ESS (2003) | singularity ⇒ `limsup_{t→T}‖u(t)‖_{L³}=∞` (weak-`L^{3,∞}` endpoint) | C3 (stmt; orig. proof C1) |
| **Tao 2019** (1908.04958) | general: `limsup ‖u(t)‖_{L³}/(\log\log\log\tfrac1{T−t})^c=∞` — **triple-log** | C3 |
| **Barker–Prange** (2003.06717) | Type-I: **single-log**, at *every* t, **localized** to a parabolic-scale ball `O((T−t)^{1/2−})` | C3 |
| **Ożański–Palasek** (2210.10030) | **axisymmetric** weak-`L³`: `(\log\log\tfrac1{T−t})^c` — **double-log** (best plain-critical) | C3 |
| **Palasek** (2101.08586) | general **weighted** `‖r^{1−3/q}u‖_{L^q}`: double-log (`q∈(3,∞)`; axisym `q∈(2,3]`) | C3 |
| **Palasek** (2111.08991) | high-dim `d≥4`, `L^d`: **quadruple-log** (one log *worse* than 3D) | C3 |

**THE GAP (qualitative, not a constant).** Every bound *diverges but arbitrarily slowly*
(`loglog`/`logloglog`). To **exclude** Type-II you must force the rate to grow *faster than the equation
permits* — the chasm from "diverges like `logloglog`" to "must diverge impossibly fast" **is the whole
open problem.** (The triple-log is so slow that even *numerically testing* it exceeds computing capacity.)

**[RE-CONFIRMED + INDEX-RECONCILED 2026-06-13, `docs/ns048_typeii_rate_verification.md`.]** The Tao
1908.04958 (triple-log) and Palasek 2101.08586 (weighted axisym double-log) headline statements were
re-confirmed **verbatim vs arXiv**; `citation_tiers.md` was found drifted (stale C1/C2, two papers
missing) and reconciled to the C3 here. Disambiguation banked: "the gap is *qualitative*" (this §2 —
a leap in growth class, not a constant) and "Type-II is a *quantitative* race, not a qualitative
dichotomy" (§4 — the nature of the Type-I/II line) describe **two different aspects** and are both
right; do not conflate. Honesty catch: Palasek's abstract makes no explicit "improves Tao" claim —
"double-log ≻ triple-log" is our correct rate-inference but in a *weighted* norm (the plain-critical
axisym double-log is Ożański–Palasek 2210.10030). Also: Tao 1908.04958 is exactly what the Carleman
ladder (NS-051) formalizes ⇒ even a completed ladder certifies this *rate bound*, not exclusion
(`docs/ns048_sigma0_decay_carleman_tracking.md`).

**Actual Type-II exclusion: NONE general.** Only **conditional scenario-exclusions** (Seregin 2402.13229,
2507.08733, **C3** for the scenario / **C2** for status) rule out *specific* axisymmetric concentration
scenarios. Type-I is excluded only for axisymmetric/self-similar (Seregin); **general Type-I is open**.
(Conditional *regularity* under bounded-swirl/`|v|≤C/r` — CSTY, LZZ, the closers mapped in the NS-048 arc —
excludes *all* blowup *under that hypothesis*, but is **not** an unconditional Type-II exclusion; that
distinction was a triad clarification, 2026-06-07.)

**[TRIAD-REFINED 2026-06-07, `docs/c5_triad_witness_verdict.md`]:** (i) **Tao's triple-log is tied to the
Leray–Hopf class** — the Bourgain pigeonholing bounds the bad scales *using* the global energy inequality,
so the rate is not a universal bound (our use, on Leray-class NS singularities, is within scope). (ii)
**Palasek's double-log is a *structurally-independent* cross-check** (Nazarov–Ural'tseva parabolic-Harnack,
not Carleman) of the slow-divergence *phenomenon* — genuine independent evidence, not merely "partial."

*(Honest correction: my initial intuition of a "near-`(T−t)^{−1/2+}` axisymmetric exclusion" was wrong —
the strongest plain-critical-norm axisymmetric result is **double-log**; "near-`1/2`" conflated this with
the Leray *Type-I criterion* `‖u‖_∞≳(T−t)^{−1/2}`, a different object. Flagged so it is not re-introduced.)*

---

## 3. The CONSTRUCTION side — NO rigorous true-NS blowup; the rigor partition

| Rigor class | Result(s) | Equation — why NOT true NS |
|---|---|---|
| **(a) Rigorous, true 3D viscous unforced NS** | **— NONE —** | (open) |
| **(b) Rigorous, model / related eqn** | Tao 2016 **averaged-NS** (1402.0290); Córdoba–MZ–Zheng **forced + hypodissipative** (2407.06776); Q. Zhang **forced** critical-order force (2411.13896); Li–Sinai **complex** NS (1702.07139) | averaged / forced / fractional-dissipation / complex-valued |
| **(c) Computer-assisted proof (CAP)** | **Chen–Hou** I+II (2210.07191 + SIAM MMS): **2D Boussinesq + 3D axisym EULER with BOUNDARY**; gCLM/De Gregorio **1D** models | inviscid + boundary; or 1D models of Euler |
| **(d) Numerical-only** | **Hou** axisym NS (2107.06509, `ν=5·10⁻³`, interior); Hou **`d≈3.188`** generalized NS (2405.10916) | numerics; not a proof; not `d=3` |
| **(e) Open** | true 3D viscous unforced NS Type-II | — |

**Other-equation Type-II toolkit (b):** Raphaël–Schweyer (harmonic-map heat flow, quantized rates,
1301.1859, **C3**); Krieger–Schlag–Tataru (wave maps, **C1/C2**); Merle–Raphaël–Rodnianski (NLS,
**C1/C2**) — these supply **modulation theory + matched asymptotics + finite-codimension stability**, the
machinery a true-NS construction would have to import. *None is NS.*

**The methodology gap.** A true-NS Type-II construction needs: a nearly-self-similar profile (exact
backward self-similar is excluded — NS-007/NRŠ/Tsai, **C2/C3**); modulation of `λ(t)`; spectral stability;
inner–outer matched asymptotics. **Viscosity is the obstacle:** the full Laplacian is *critical* relative
to the natural scaling, so parabolic smoothing fights concentration at every scale and **cannot be a
lower-order perturbation of an inviscid (Euler) profile** — which is exactly why the rigorous CAP works for
*Euler*-with-boundary and Hou's NS scenario needs large `ν` / fractional / varying-dimension to rebalance.

---

## 4. Structural observations (the program's contribution to the Type-II map)

1. **The blowup *rate* is the single shared object.** Exclusion proves `rate ≥` (slow divergence);
   construction would exhibit `rate =` (explicit faster divergence). **The gap between them IS the open
   problem** — Type-II is a quantitative race, not a qualitative dichotomy.
2. **Viscosity is *tool and obstacle* — the same term, opposite roles.** On exclusion it *supplies* the
   rate bounds (via Leray's regularity intervals + ε-regularity; `d≥4` is *worse* — quadruple-log —
   precisely because there are fewer Leray intervals). On construction it is *the* barrier (parabolic
   smoothing fights concentration). A Type-II resolution must turn this same term to one side.
3. **Axisymmetric is the sharpest arena on BOTH sides** — best exclusion (Type-I excluded; double-log
   Type-II rate) *and* the strongest construction evidence (Hou's interior scenario). So **axisymmetric
   Type-II is the concrete frontier** where the two sides will first meet.
4. **NS-048's machinery has a Type-I ceiling (§1).** The compactness-Liouville paradigm is structurally
   Type-I-only; Type-II requires the modulation/matched-asymptotics paradigm — a *different* mathematics.
   This is a **global** statement about the program's reach (per the global>local framing).

---

## 5. The tractable entry sub-question

**On the exclusion side** (the only side with session-adjacent traction): **push the axisymmetric
weak-`L³` double-log rate toward a single-log, or to a critical Besov `Ḃ^{-1}_{∞,∞}` norm** — **Palasek
explicitly conjectures** (2210.10030, after Cor 1.2) that his Thm 1.1 holds with weak-`L³` replaced by a
critical Besov norm "and can be proved using the ideas presented here." Adjacent: tighten the
**criticality-breaking** Orlicz bound `‖u‖_{L³(\log\log\log L)^{-θ}}` (Barker–Prange Result D, answering
Tao's Remark-1.6 conjecture "at the cost of one extra log"). Each is a *specific quantitative estimate*
using existing swirl/parabolic + Carleman machinery — **research-scale, named, not a session task, and not
full exclusion.**

**On the construction side:** no tractable entry without importing the modulation/matched-asymptotics
toolkit to *viscous* NS and defeating the criticality of dissipation — the methodology gap (§3), a major
program.

---

## 6. Verdict

- **Type-II is genuinely OPEN on both sides** for true unforced viscous 3D NS: no rigorous construction
  (class (a) = NONE), no general exclusion (only slow rate bounds + conditional scenario-exclusions).
- **It is the complement of the program's Type-I machinery** (§1) — the global gap the ancient-Liouville
  paradigm cannot reach — and where a real NS singularity, if any, must live (ESS).
- **The program's contribution is the map + the structural observations** (§4): the rate as the shared
  object; viscosity as tool-and-obstacle; axisymmetric as the sharpest arena; the Type-I ceiling. Plus the
  one named tractable entry (§5, exclusion-side axisymmetric rate). `:proved`=0; distance UNTOUCHED.

This mirrors the NS-048 static/axisymmetric outcome: a high-fidelity localization of where the wall is and
which paradigm is needed, **not** a theorem — search-space compression, honestly scoped.

---

## 7. Sources + flags (C0–C5)

**Exclusion (C3, primary-read):** Tao 1908.04958; Barker–Prange 2003.06717 + survey 2211.16215; Palasek
2210.10030 / 2101.08586 / 2111.08991; Seregin 2402.13229 / 2507.08733. **ESS 2003** (`L_{3,∞}` endpoint)
**C3** — *proof line-read 2026-06-07* (`docs/nrs_ess_verification_2026-06-07.md`), via the authors'
verbatim English version + published-RMS metadata confirmed.
**Construction (C3, primary-read):** Hou 2107.06509, 2405.10916; Chen–Hou 2210.07191 (Part II SIAM MMS
**C2**, via publisher summary); Tao 1402.0290; Córdoba–MZ–Zheng 2407.06776; Q. Zhang 2411.13896; Li–Sinai
1702.07139; Raphaël–Schweyer 1301.1859; gCLM 2305.05895 (**Huang et al.**, not Chen–Hou).
**Flagged:** KST (wave maps) + MRR (NLS) — **C1/C2**, secondary only (verify primaries if quoting rates);
the gCLM/De Gregorio CAP attributions are 1D-model results, none viscous NS; Chen–Hou Part II read via
WebFetch summary, not PDF. **Don't-bluff reaffirmed:** every (c) CAP is Euler/Boussinesq-with-boundary or
1D; every (b) NS result is averaged/forced/fractional/complex; every NS-specific (d) is numerical — **no
result establishes a Type-II singularity for true, unforced, viscous 3D NS.**
