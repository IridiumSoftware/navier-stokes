# NS-048 — The exclusion / no-split machinery: a learning study

**Date:** 2026-06-06. **This is a STUDY artifact — learning the machinery, NOT a result.**
`:proved`=0; distance to the prize UNTOUCHED. NS-048 stays `:open`, **unengaged**; this document
does not change its status, the corpus, or any ledger claim. It is a rigorous, literature-verified
map of the standard apparatus a singularity-exclusion attack on 3D Navier–Stokes would have to
command — assembled so a future session can attack *one* sub-target from an informed position
instead of from a blank page.

**Don't-bluff discipline.** Every theorem statement below was verified against the literature
(primary papers / arXiv where reachable, authoritative secondary sources otherwise). Anything that
could not be confirmed at primary source is **flagged in §12** and must be checked before being cited
as established. Exact constants (CKN's `ε₀`, Tao's triple-log exponent, etc.) are non-explicit in the
sources and are **not** quoted with numerical values.

**Provenance.** Built from a six-way parallel literature sweep (modules M1–M3, M5–M7) plus a
calibration search (M4), 2026-06-06. Sources consolidated in §11; flags in §12.

---

## 0. What this is / what it is not

- **Is:** a teaching map of (i) the rescaling setup, (ii) the compactness engine, (iii) the *done*
  self-similar sub-case, (iv) the *open* Liouville core, (v) the no-split mechanism, (vi) the
  backward-uniqueness tool, (vii) the Type-II frontier — and how they assemble into one conditional
  exclusion argument with a precisely-located hole.
- **Is not:** progress on NS-048, a new gadget, or evidence about the PDE. Nothing here is original;
  it is the field's standard machinery, organized. The within-truncation geometry findings (NS-045
  Beltramization, NS-046 pressure-Hessian, NS-013/CFM `∇ξ`) are **not** inputs to any step below —
  per the 7th-over-reach correction, a resolved-DNS truncation cannot reach the singular-limit
  ancient object; those findings are at most a *suggestive prior* on where to probe, never a
  rigidity input.

---

## 1. The exclusion strategy in one diagram

```
  ASSUME a finite-time singularity at (x0, T)
        │
        ├─[Type-I rate: ‖u(t)‖∞ ≲ (T−t)^−1/2]──────────────┐
        │                                                   │
   rescale  u_k(y,s) = λ_k u(x0+λ_k y, T+λ_k² s),  λ_k→0    │  M1
        │                                                   │
   CKN ε-regularity ⇒ uniform local bounds ⇒ C∞_loc compactness   M2
        │                                                   │
        ▼                                                   │
   a NONTRIVIAL bounded mild ANCIENT solution on ℝ³×(−∞,0)  │  M1/M4
        │                                                   │
   ┌────┴─────────── no-split / minimality ─────────────┐   │  M5
   │  profile decomposition + minimal-norm datum force  │   │
   │  the limit to be a SINGLE canonical object         │   │
   └────┬───────────────────────────────────────────────┘   │
        ▼                                                   │
   LIOUVILLE: prove the ancient object is trivial ──────────┘
        │   • self-similar special case: DONE (NRŠ/Tsai)      M3
        │   • backward-uniqueness tool kills decaying tails   M6
        │   • GENERAL 3D ancient: ← THE OPEN HOLE             M4
        ▼
   contradiction ⇒ no Type-I singularity

  [Type-II rate: faster than self-similar] → rescaling gives NO bounded limit → SEPARATE, OPEN  M7
```

The argument is **complete except at two places**: the general 3D Liouville theorem (M4) and the
entire Type-II branch (M7). Everything else (M1, M2, M3, M5, M6) is rigorous, standard, and
assembled below.

---

## 2. M1 — Rescaling and ancient solutions

**Scaling symmetry.** If `(u,p)` solves 3D NS, so does
$$u_\lambda(x,t)=\lambda\,u(\lambda x,\lambda^2 t),\qquad p_\lambda(x,t)=\lambda^2 p(\lambda x,\lambda^2 t).$$
Parabolic scaling: length `∼λ`, time `∼λ²`, velocity `∼λ⁻¹`. This is the *only* one-parameter
symmetry that lets `λ→0` zoom into a singular point while keeping the equation form-invariant.

**Critical (σ=0) norms** are the scaling-invariant ones. With `u` of dimension `λ⁻¹` in `d=3`:
`‖u_λ‖_{L^p}=λ^{1−3/p}‖u‖_{L^p}` (critical iff `p=3`); `‖u_λ‖_{Ḣ^s}=λ^{s−1/2}‖u‖_{Ḣ^s}` (critical
iff `s=1/2`). The verified embedding chain of critical spaces:
$$L^3 \subset \dot B^{-1+3/p}_{p,\infty} \subset BMO^{-1} \subset \dot B^{-1}_{\infty,\infty},$$
with `BMO⁻¹` the Koch–Tataru space (largest with small-data global well-posedness) and
`Ḃ^{-1}_{∞,∞}` the largest critical space. `L^{3,∞}` (weak-`L³`) sits just above `L³`, same homogeneity.

**Type-I vs Type-II.** Let `T` be the first singular time.
- **Type-I:** the scaling-critical rate, `sup_{t<T} √(T−t)·‖u(t)‖_{L^∞} < ∞` (or any critical norm
  staying bounded / scaled local energy bounded). The `(T−t)^{−1/2}` rate is exactly what the
  velocity-`λ⁻¹` / time-`λ²` bookkeeping forces.
- **Type-II:** strictly faster, `limsup_{t→T} √(T−t)·‖u(t)‖_{L^∞}=∞` (critical norm unbounded).

**Bounded mild ancient solution (MBAS)** — the Koch–Nadirashvili–Seregin–Šverák object: a solution
on `ℝ³×(−∞,0)` that is (i) **ancient** (all past time), (ii) **bounded** (`sup_{t<0}‖u(t)‖_{L^∞}<∞`),
(iii) **mild** (satisfies the Duhamel/heat-semigroup integral form, which fixes the pressure from the
velocity and excludes "parasitic" pressure-driven solutions like `u=b(t)`). Strictly smaller class than
ancient *weak/suitable* solutions (which only satisfy NS distributionally + the local energy inequality).

**The compactness mechanism (Type-I ⇒ ancient limit).**
1. Rescale at the singular point: `u_k(y,s)=λ_k u(x₀+λ_k y, T+λ_k² s)`, `λ_k→0`; each solves NS on an
   *expanding* time interval `(−λ_k^{−2}T₀, 0)`.
2. The Type-I bound is scaling-invariant ⇒ `sup_k‖u_k‖_{L^∞}≤C` uniformly on every fixed compact set.
3. Interior parabolic regularity (via ε-regularity, M2) upgrades the `L^∞` bound to uniform bounds on
   `∇u_k` and higher derivatives on slightly smaller sets.
4. Arzelà–Ascoli ⇒ a subsequence converges in `C^∞_loc` to a limit.
5. The expanding time intervals + a diagonal argument ⇒ the limit is defined for all `s<0`: a
   **bounded mild ancient solution**, the *blowup profile*.

The exclusion logic is the contrapositive: a Type-I singularity produces a **nontrivial** MBAS, so a
**Liouville theorem** ("every MBAS is constant") would force a contradiction.

---

## 3. M2 — CKN ε-regularity: the compactness engine

**Suitable weak solution (Caffarelli–Kohn–Nirenberg 1982):** a Leray–Hopf weak solution
(`u∈L^∞_tL²_x∩L²_tH¹_x`, div-free, distributional NS) with `p∈L^{3/2}_{loc}` satisfying the **local
energy inequality** for all `0≤φ∈C_c^∞`:
$$\int|u|^2\varphi\,dx\Big|_t + 2\!\iint|\nabla u|^2\varphi \;\le\; \iint|u|^2(\partial_t\varphi+\Delta\varphi)+\iint(|u|^2+2p)(u\cdot\nabla\varphi).$$
The pressure term is what distinguishes "suitable" from plain Leray–Hopf; such solutions exist for any
`L²` div-free datum.

**Partial-regularity theorem (CKN 1982).** The singular set `S` of a suitable weak solution has
**one-dimensional parabolic Hausdorff measure zero**, `𝒫¹(S)=0` (parabolic Hausdorff dim `≤1`) — "at
most a curve in space-time."

**ε-regularity criteria** (universal `ε₀>0`; both quantities scaling-invariant):
- *Gradient form:* `limsup_{r→0} (1/r)∬_{Q_r}|∇u|² < ε₀  ⇒  (x₀,t₀) regular.` This scale-invariant
  quantity is what yields the dimension-1 bound (each singular point needs a quantum `≥ε₀`; Vitali
  covering ⇒ `𝒫¹(S)=0`).
- *`L³` form (Lin 1998):* `(1/r²)∬_{Q_r}(|u|³+|p|^{3/2}) < ε₁  ⇒  u∈L^∞(Q_{r/2})`, hence regular.

**Why it is the compactness engine.** Local smallness of these scale-invariant quantities ⇒ uniform
local bounds on the rescaled sequence ⇒ (Aubin–Lions / parabolic Schauder) strong `L³_loc`
convergence + higher-derivative bounds ⇒ the `C^∞_loc` limit of step M1. Conversely, singularities can
form *only* where smallness fails — the singular set is exactly where the rescaled gradient energy
refuses to decay below `ε₀`, which is what localizes concentration.

**Re-proofs / refinements (verified to exist):** Lin (CPAM 1998, blow-up/compactness);
Ladyzhenskaya–Seregin (JMFM 1999); Vasseur (NoDEA 2007, De Giorgi method); Gustafson–Kang–Tsai
(CMP 2007, scaled interior criteria, e.g. velocity `3/p+2/q≤2`, vorticity `≤3`, `∇ω≤4`).

---

## 4. M3 — Self-similar exclusion (the DONE sub-case = NS-007)

**Leray's backward self-similar ansatz (1934).**
`u(x,t) = (2a(T−t))^{−1/2} U(x/√(2a(T−t)))`, profile variable `y=x/√(2a(T−t))`, satisfying the
stationary profile system
$$-\Delta U + a\big(U + (y\cdot\nabla)U\big) + (U\cdot\nabla)U + \nabla P = 0,\qquad \operatorname{div}U=0.$$
The linear stretching term `a(U+y·∇U)` is the scaling signature. This is the *exactly* scale-invariant
blowup candidate — the cleanest shape NS could self-focus into. Open for 62 years.

**Nečas–Růžička–Šverák (Acta Math. 176, 1996).** If a profile `U∈L³(ℝ³)` (weak solution,
`W^{1,2}_loc∩L³`) solves the profile system, then **`U≡0`** — no nontrivial backward self-similar
blowup of finite kinetic/Dirichlet energy.

**Mechanism (NRŠ).** Build the scalar `Π = ½|U|² + P + a(y·U)`. The profile PDE yields an elliptic
drift-diffusion inequality for `Π` obeying a **maximum principle**; the `L³` decay kills the
boundary-at-infinity contribution, forcing `Π` constant/non-positive; feeding back into the energy
identity (test the PDE against `U`) collapses the Dirichlet energy to zero ⇒ `U≡0`.

**Tsai (ARMA 143, 1998).** Same conclusion under the much weaker **local energy estimates** (CKN
class) instead of global `L³`, plus exclusion of **asymptotically** self-similar singularities in that
class — same `Π`-maximum-principle + energy-cancellation skeleton.

**The DSS nuance — why "self-similar excluded" ≠ "general ancient excluded."** *Backward* self-similar
blowup is excluded, but *forward* self-similar and **discretely self-similar (DSS)** solutions
provably **EXIST** from rough `(−1)`-homogeneous data (regular for `t>0`, not blowing up):
- **Jia–Šverák (Invent. Math. 196, 2014):** forward self-similar solution for *every* locally-Hölder
  `(−1)`-homogeneous datum, including arbitrarily large data.
- **Korobkov–Tsai (Anal. PDE, 2016):** forward self-similar in the **half-space** *(half-space, not
  ℝ³ — flagged)*.
- **Bradshaw–Tsai (Ann. Henri Poincaré, 2017):** forward DSS local-Leray solutions for DSS data in
  weak-`L³`.
- **Chae–Wolf (Ann. IHP-ANL, 2018):** DSS for any DSS datum in `L²_loc` (weakest data class).

Backward (a singularity pulling in) and forward (scale-invariant evolution *out of* rough data) share
the scaling algebra but are physically opposite. Exact self-similarity is killed; only the *exactly*
self-similar **backward** case is closed. The general program needs a Liouville theorem for *all*
nontrivial bounded ancient solutions of the rescaled equation — of which the steady self-similar
profile is the cleanest special case.

---

## 5. M4 — Liouville theorems for ancient solutions (THE OPEN CORE)

This is the hole the whole strategy reduces to. A "Liouville theorem" here = *every bounded mild
ancient solution is trivial (constant)*.

**Koch–Nadirashvili–Seregin–Šverák (Acta Math. 203, 2009; arXiv 0709.3599).** Verified statements:
- **2D:** every bounded ancient (mild) solution is constant (or `u=b(t)` depending on the admissibility
  convention — convention-dependent, *flagged*). ⇒ **no Type-I blowup in 2D.**
- **3D axisymmetric, no swirl (`v^θ=0`):** every bounded mild ancient solution is **constant**; and
  `=0` if `|v(x)|≤C/r`.
- **General 3D:** "seems to be out of reach of existing techniques." ← **the open frontier.**

**The equivalence that makes Liouville the linchpin.** A suitable weak solution has a
**Type-I singularity if and only if there exists a nontrivial mild bounded ancient solution satisfying
a Type-I decay condition.** So *general 3D Liouville ⟺ no Type-I blowup* — the Liouville theorem is not
a tool toward the result, it is *(a reformulation of)* the result for the Type-I case.
**[ATTRIBUTION CORRECTED 2026-06-07, KNSS line-verification:** KNSS (0709.3599) **Prop 6.1** proves only
the **⇒** direction (singularity ⇒ nontrivial bounded ancient mild solution; **C3**, line-read); the full
**⟺** is **Seregin–Šverák, arXiv:1811.00502** — held at **C1** (not primary-read), a verification target.
See `docs/knss_verification_2026-06-07.md` §3b.**]**

**Extensions (verified to exist):** axisymmetric *with* swirl under structural bounds, e.g.
`Γ=rv^θ ∈ L^∞_t L^p_x`, `1≤p<∞` (Liouville property holds); the Lei–Zhang / Chen–Strain–Tsai–Yau /
Seregin–Šverák lines of axisymmetric conditional results. All are **restricted classes**; none reach
general 3D.

**Where our ledger sits:** NS-007 (self-similar — the steady special case, done), NS-006 (CKN
input), NS-005/M6 (backward uniqueness). The gap NS-048 names = the **general (non-self-similar /
discretely self-similar) ancient-limit Liouville theorem** — exactly what KNSS call out of reach.

---

## 6. M5 — Concentration-compactness / profile decomposition / no-split

**The no-split problem.** Rescaling near a singularity along different subsequences `λ_k` may
concentrate at different scales/points ("bubbling"), so the rescaled limit need not be unique — energy
can leak to infinity or split among separating bubbles. The **concentration-compactness dichotomy**:
a bounded critical sequence either (i) **concentrates as a single profile** (compactness), or (ii)
**splits into asymptotically orthogonal bubbles** whose critical "energies" add. No in-between.

**Profile decomposition (verified).**
- **Bahouri–Gérard (Amer. J. Math. 121, 1999):** the prototype, for critical NLW — bounded sequences
  decompose into rescaled/translated asymptotically-orthogonal profiles + a remainder small in the
  critical norm.
- **Gallagher (Bull. Soc. Math. France 129, 2001):** the NS version — bounded NS data decompose into
  asymptotically orthogonal profiles bounded in `Ḣ^{1/2}(ℝ³)` + remainder small in `L³`. *(This is
  2001, not 1998 — corrected.)*

**Kenig–Merle concentration-compactness/rigidity scheme** (Invent. Math. 2006, NLS; Acta Math. 2008,
wave): if global regularity holds below a threshold but fails somewhere, the *minimal* failing size is
attained by a **critical element** — a solution whose trajectory is precompact modulo scaling/translation
— which a **rigidity (Liouville) theorem** then kills. Two steps: extract minimal compact object, then
prove it trivial.

**NS adaptation (verified).** The no-split is engineered via **minimality**: a minimal-norm singular
datum cannot split (each bubble has strictly smaller critical norm, but at least one must stay
singular — contradiction), forcing case (i), a single canonical limit.
- **Rusin–Šverák (JFA 260, 2011):** if any `Ḣ^{1/2}` datum is singular, a **minimal-`Ḣ^{1/2}`-norm**
  one exists.
- **Gallagher–Koch–Planchon (Math. Ann. 355, 2013):** profile-decomposition proof of the ESS `L³`
  criterion; existence of a minimal critical-norm singular datum.
- **Jia–Šverák (SIAM J. Math. Anal. 45, 2013):** simpler (splitting + energy) proof of a minimal-`L³`
  singular datum. *(Their separate papers — JFA 2015, Invent. Math. 2014 — reduce regularity/
  ill-posedness to **rigidity of scale-invariant/ancient solutions**; do not attribute that reduction
  to the 2013 minimal-data paper.)*
- **Gallagher–Koch–Planchon (CMP 343, 2016):** at a finite-`T` singularity, **every** critical Besov
  norm `Ḃ^{-1+3/p}_{p,q}` (`1<p,q<∞`) blows up — generalizes ESS.

**The catch (verified, important).** NS is **dissipative, not Hamiltonian / time-reversible** — no
conserved critical-level energy, no clean virial identity — so Kenig–Merle is *adapted*, not
transplanted; compactness comes from parabolic smoothing + minimality. And Jia–Šverák indicate
possible **non-uniqueness of scale-invariant solutions**, so even the minimal canonical limit may not
be unique. No-split holds for the *minimal* element by construction — **not** for arbitrary blowup
sequences.

---

## 7. M6 — Backward uniqueness + unique continuation

**Escauriaza–Seregin–Šverák (Russian Math. Surveys 58:2, 2003).** A Leray–Hopf solution bounded in
`L^∞_t L^{3,∞}_x` (weak-`L³`, the genuine endpoint, strictly larger than `L³`) on `[0,T)` does **not**
blow up at `T`. Closes the `p=3` endpoint of the Prodi–Serrin–Ladyzhenskaya scale
(`2/p+3/q≤1`, previously open at `(∞,3)`). Equivalently (Tao's restatement): finite maximal time
`T*` ⇒ `limsup_{t→T*}‖u(t)‖_{L³}=+∞`.

**The two driving tools (Carleman-estimate machinery):**
- **Backward uniqueness for parabolic operators (ESS, ARMA 169, 2003):** if `w` solves
  `|∂_t w+Δw| ≤ C(|w|+|∇w|)` on an **exterior** region `(ℝⁿ∖B_R)×(0,T)` with controlled (Gaussian-type)
  growth at infinity, and `w(·,T)=0`, then `w≡0`.
- **Unique continuation (spatial/space-time):** a solution of the same inequality vanishing to
  **infinite order at a point** is locally zero.

Both rest on **Carleman estimates** — weighted `L²` inequalities `∫e^{2φ}|Lw|² ≳ ∫e^{2φ}(|w|²+|∇w|²)`
with convex weight `φ` making `L=∂_t+Δ` coercive, so interior `|w|²` is dominated by boundary/initial
data; when those vanish, `w≡0`. The weights make the tools *quantitative*.

**How they kill the rescaled limit.** From an `L³` singularity, rescaling extracts a bounded ancient
solution whose vorticity decays at spatial infinity (inherited from the critical bound). Apply to the
vorticity equation `∂_tω = Δω − (u·∇)ω + (ω·∇)u` (a variable-coefficient heat equation): unique
continuation propagates an interior zero outward; backward uniqueness on the exterior, using vanishing
at the final time + Gaussian decay, forces `ω≡0` backward in time ⇒ trivial limit ⇒ contradiction. The
two tools are exactly matched: unique continuation for the bounded core, backward uniqueness for the
decaying tail.

**Refinements (verified):** Seregin (CMP 312, 2012) — the *strong* limit `lim_{t→T}‖u(t)‖_{L³}=∞`
(not just limsup); Phuc — non-endpoint `L^{3,q}` (`q≠∞`); **Tao (2019, arXiv 1908.04958)** — fully
*quantitative* version with triple-exponential higher-norm bounds and the triple-logarithm blowup-rate
lower bound `‖u(t)‖_{L³} ≳ (log log log 1/(T*−t))^c`; Barker–Prange (CMP 2021) — quantitative
concentration at singular points.

---

## 8. M7 — The Type-II frontier (separate, mostly OPEN)

**Why Type-II breaks the argument.** Under Type-I, choosing `λ(t)∼√(T−t)` makes `u_λ` uniformly
bounded ⇒ compact ancient limit. Under Type-II the amplitude `M(t)` satisfies `M(t)√(T−t)→∞`; matching
`λ∼1/M` decouples space and time scales (`λ²≪T−t`), so no single rescaling keeps `u_λ` bounded *and*
tracks the amplitude. **Arzelà–Ascoli fails; no compact ancient limit; the "extract-and-kill" strategy
is unavailable.** ("Type-II" definitions vary across the literature — rate faster than self-similar /
critical norm `→∞` / scale ratio `→∞`; the cleanest is the critical-norm one.)

**Honest partition of what is known:**

*ESTABLISHED rigorously for 3D NS:*
- ESS: no critical-`L³`-bounded blowup ⇒ a genuine singularity *must* have `‖u(t)‖_{L³}→∞`. This
  already excludes the cleanest "critical-norm-bounded / Type-I-ish" scenario.
- Tao (2019): rigorous *triple-logarithm* `L³` blowup-rate lower bound — extremely weak but
  quantitative.
- Barker–Prange: a fixed quantum of critical norm concentrates at the parabolic scale `O(√(T−t))`.
- KNSS + successors: **no Type-I** for axisymmetric NS (conditional, axisymmetric).

*KNOWN only for OTHER/MODIFIED equations (methodological analogues, NOT NS — clearly fenced):*
- **Tao (JAMS 2016, averaged NS):** finite-time blowup of an energy-identity-preserving *model* — proof
  of the supercriticality barrier (= our NS-008), **not** the true nonlinearity.
- Type-II constructions via modulation/matched asymptotics for harmonic-map heat flow / wave maps /
  supercritical NLS: **Raphaël–Schweyer** (APDE 2014), **Krieger–Schlag–Tataru** (wave maps, ~2008),
  Merle–Raphaël–Rodnianski. These prove Type-II is *real* and supply the toolkit, on *different*
  equations.

*NUMERICAL (not proof) for NS:*
- **Hou (FoCM 2022, arXiv 2107.06509):** numerical *nearly* self-similar potentially-singular
  axisymmetric **interior** behavior (companion to a 3D Euler scenario).
- **Hou et al. (arXiv 2405.10916, 2024):** numerical, needs a *dynamically varied space dimension*
  (`d≈3.188`) to stabilize the profile — itself a sign of NS's scaling instability.
- *(The boundary blowup scenario is Luo–Hou 2014 for 3D **Euler**, not NS — do not conflate.)*

*OPEN:* whether **any** Type-II singularity exists for true 3D NS, and whether it can be excluded, is
**fully open**. No rigorous construction, no rigorous exclusion. The branch needs modulation theory /
matched asymptotics, not just compactness.

---

## 9. The assembled argument and the precise gap

Putting M1–M6 together, the following is a **rigorous, standard, conditional** statement:

> If 3D NS admits a finite-time **Type-I** singularity, then (M1–M2) parabolic rescaling +
> CKN ε-regularity extract a nontrivial bounded mild ancient solution; (M5) minimality forces it to
> be a single canonical object; (M6) backward uniqueness + unique continuation handle its decaying
> tail; (M3) the *exactly self-similar* such object is already excluded (NRŠ/Tsai). What remains is to
> exclude the **general non-self-similar bounded mild ancient solution** — i.e. prove the **3D
> Liouville theorem (M4)**, which is known only in 2D and restricted axisymmetric classes and is
> *equivalent* to ruling out Type-I blowup.
>
> The **Type-II** branch (M7) is untouched by this argument and is separately open.

**So the program's precise standing on NS-048:**
- **Done / standard:** the rescaling-to-ancient reduction, the compactness engine, no-split via
  minimality, the backward-uniqueness tool, self-similar exclusion.
- **Open hole #1 (M4):** general 3D Liouville for bounded mild ancient solutions (⟺ Type-I exclusion).
- **Open hole #2 (M7):** the entire Type-II branch (no compact limit to attack).

This matches NS-048's recorded scope exactly — "the general rescaled-limit (asymptotically/discretely
self-similar) exclusion, plus the no-split mechanism, plus Type-II" — now with the literature pinned
and the holes located to the theorem level.

---

## 10. What "engaging NS-048" would actually mean

Genuinely attacking NS-048 = picking **one** sub-target below and committing to its machinery. None is
a session task; each is a research program. Listed by tractability:

- **(a) A Liouville theorem for a restricted non-self-similar ancient class beyond axisymmetric-no-swirl.**
  The most active front (extend the `Γ=rv^θ∈L^∞_tL^p_x` swirl results; weaken decay hypotheses). Needs:
  axisymmetric NS structure, the maximum-principle/`Π`-functional technology (M3), De Giorgi/Moser
  iteration. *Most tractable; incremental.*
- **(b) A no-split / minimality refinement** addressing the Jia–Šverák non-uniqueness of scale-invariant
  solutions, so the canonical limit is genuinely well-defined. Needs: profile decomposition in critical
  Besov spaces (M5), Koch–Tataru theory.
- **(c) A Type-II rate exclusion** (or sharper blowup-rate lower bound improving Tao's triple-log).
  Needs: quantitative Carleman / quantitative regularity (M6, M7), modulation theory. *Hardest.*

**Honest scope.** Engaging means *learning to prove* in (a)/(b)/(c)'s technology, then contributing one
theorem — explicitly **not** a new geometric gadget (the colleague's own warning + this program's
seven-refutation track record forbid that). The within-truncation geometry (NS-045/046/`∇ξ`) is a
*suggestive prior on where to probe the ancient limit's geometry*, never a rigidity input — a
truncation cannot reach the singular-limit object (the 7th-over-reach correction stands).

The most useful output of *this* study is the map itself: the strategy is conditionally complete, and
the two holes are now located precisely enough that a future session can walk straight to sub-target
(a) and read the right five papers.

---

## 11. Verified-source bibliography

**Rescaling / ancient solutions (M1, M4):**
- Koch, Nadirashvili, Seregin, Šverák, *Liouville theorems for the Navier–Stokes equations and
  applications*, Acta Math. 203 (2009) 83–105. arXiv:0709.3599 ·
  https://doi.org/10.1007/s11511-009-0039-6
- Seregin, *Lecture Notes on Regularity Theory for the Navier–Stokes Equations*, World Scientific
  (2014; 2nd ed. 2024). https://www.worldscientific.com/worldscibooks/10.1142/14601
- Seregin & Šverák, *On Type I singularities … and Liouville theorems*, arXiv:1811.00502
- axisymmetric Liouville: arXiv:1011.5066

**CKN partial regularity (M2):**
- Caffarelli, Kohn, Nirenberg, *Partial regularity of suitable weak solutions of the Navier–Stokes
  equations*, CPAM 35 (1982) 771–831.
- Lin, *A new proof of the Caffarelli–Kohn–Nirenberg theorem*, CPAM 51 (1998) 241–257.
- Ladyzhenskaya & Seregin, JMFM 1 (1999) 356–387. https://doi.org/10.1007/s000210050015
- Vasseur, NoDEA 14 (2007) 753–785. https://doi.org/10.1007/s00030-007-6001-4
- Gustafson, Kang, Tsai, CMP 273 (2007) 161–176. https://doi.org/10.1007/s00220-007-0214-6
- Ożański, *The Partial Regularity Theory of CKN and its Sharpness* (Springer 2019).

**Self-similar (M3):**
- Nečas, Růžička, Šverák, Acta Math. 176 (1996) 283–294. https://doi.org/10.1007/BF02551584
- Tsai, ARMA 143 (1998) 29–51. https://doi.org/10.1007/s002050050099
- Jia & Šverák, Invent. Math. 196 (2014) 233–265. arXiv:1204.0529
- Korobkov & Tsai, Anal. PDE (2016) — *half-space*. arXiv:1409.2516
- Bradshaw & Tsai, Ann. Henri Poincaré (2017). arXiv:1510.07504
- Chae & Wolf, Ann. IHP-ANL (2018). arXiv:1610.01386
- Bradshaw–Tsai survey, arXiv:1802.00038; Leray review (Ożański–Pooley), arXiv:1708.09787

**Concentration-compactness / no-split (M5):**
- Bahouri & Gérard, Amer. J. Math. 121 (1999) 131–175.
- Gallagher, Bull. Soc. Math. France 129 (2001) 285–316. https://www.numdam.org/item/BSMF_2001__129_2_285_0/
- Kenig & Merle, Invent. Math. 166 (2006) 645–675 (NLS, arXiv:math/0610266); Acta Math. 201 (2008)
  147–212 (wave, arXiv:math/0610801).
- Rusin & Šverák, JFA 260 (2011) 879–891. arXiv:0911.0500
- Gallagher, Koch, Planchon, Math. Ann. 355 (2013) 1527–1559. arXiv:1012.0145
- Jia & Šverák, SIAM J. Math. Anal. 45 (2013) 1448–1459. arXiv:1201.1592
- Gallagher, Koch, Planchon, CMP 343 (2016) 39–82. arXiv:1407.4156

**Backward uniqueness / endpoint (M6) + Type-II (M7):**
- Escauriaza, Seregin, Šverák, Russian Math. Surveys 58:2 (2003) 211–250.
  https://www.mathnet.ru/eng/rm609 ; *Backward uniqueness for parabolic equations*, ARMA 169 (2003)
  147–157. https://doi.org/10.1007/s00205-003-0263-8
- Seregin, CMP 312 (2012) 833–845. arXiv:1104.3615
- Phuc, arXiv:1407.5129, arXiv:1511.00626
- Tao, *Quantitative bounds for critically bounded solutions*, arXiv:1908.04958
- Barker & Prange, CMP 385 (2021) 717–792, arXiv:2003.06717; survey arXiv:2211.16215
- Tao, *Finite-time blowup for an averaged 3D NS*, JAMS 29 (2016), arXiv:1402.0290
- Raphaël & Schweyer, APDE 7 (2014). Krieger–Schlag–Tataru (wave maps, ~2008).
- Hou, FoCM 2022, arXiv:2107.06509; Hou et al., arXiv:2405.10916 (numerical).

---

## 12. Flagged / not-primary-verified (don't-bluff appendix)

Items below were confirmed in *structure/scope* but **not** quoted from primary text, or carry a
convention dependence. Check before citing verbatim.

1. **MBAS Duhamel formula** — exact KNSS sign/operator conventions not pulled from arXiv:0709.3599 PDF;
   the structure (heat-semigroup Picard, Leray projector, pressure-from-velocity) is verified.
2. **2D Liouville wording** — "constant" vs "`u=b(t)`" is admissibility-convention-dependent in KNSS.
3. **CKN exact `ε₀`, `ε₁` constants and factor normalizations** — non-explicit / behind paywall; only
   the scale-invariant *forms* of the two criteria are verified.
4. **Lin (1998) exact theorem numbering/wording** — reconstructed from secondary sources.
5. **Vasseur (2007) precise De Giorgi level-set quantity** — paper/scope verified, exact inequality not
   extracted.
6. **NRŠ exact hypothesis** (`W^{1,2}_loc∩L³`) and **Tsai exact local-energy hypothesis** —
   high-confidence, consistent across secondary literature, not quoted from primary PDFs.
7. **Korobkov–Tsai is HALF-SPACE** — do not cite as a general ℝ³ existence result.
8. **Bradshaw–Tsai data class** is **weak-`L³`**; do not conflate with the later `L²_loc` DSS paper.
9. **Gallagher NS profile decomposition is 2001 (BSMF 129)**, *not* 1998 — corrected.
10. **Jia–Šverák 2013 (arXiv:1201.1592)** gives the minimal-`L³` *datum*; the *ancient-rigidity
    reduction* is their separate JFA 2015 / Invent. Math. 2014 work — do not merge.
11. **ESS backward-uniqueness exact lemma numbers + growth constant** — taken from Tao's faithful
    restatements (his Props. 4.2/4.3 cite "[ESS, Lemma 4]", "[ESS2, Thm 4.1]"), not the ARMA PDF.
12. **Phuc exact venue/year** for the `L^{3,q}` result — result + preprints verified, publication not
    pinned.
13. **"Choe–Wolf–Yang Type-I"** — **could not be verified; do NOT assert.** Verified axisymmetric
    no-Type-I attributions are KNSS, Seregin–Šverák, Chen–Strain–Tsai–Yau, Lei–Zhang.
14. **Krieger–Schlag–Tataru exact venue/year** (commonly Invent. Math. 2008) — result verified,
    primary not opened.
15. **Hou "boundary" scenario** is **Luo–Hou 2014 (3D Euler)**, not NS; the verified Hou *NS* work is
    interior + numerical.
16. **All blowup-rate / concentration constants** (Tao's triple-log exponent, Barker–Prange's
    `γ_univ`) are non-explicit — never attach numbers.
