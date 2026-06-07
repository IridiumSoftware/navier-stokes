# NS-048 attack — axisymmetric-with-swirl ancient Liouville: where the wall is

**Date:** 2026-06-06. **This is an ATTACK / ANALYSIS artifact. NO theorem is claimed.**
`:proved`=0; distance to the prize UNTOUCHED. NS-048 stays `:open`/unengaged; this changes no ledger
entry. Default throughout: **"not established."** The session's honest outcome is a *precise
localization of the wall* for the most tractable NS-048 sub-target — not its removal.

**Pre-committed sanity check (held the whole way):** *any correct restricted argument must use its
restriction essentially — a step that would also prove the full KNSS conjecture is wrong, because that
conjecture is open.* This is the firewall against an 8th over-reach (a manufactured theorem). The
verdict in §5 is that I did **not** produce a new theorem; I produced a sharp statement of why the
"just-beyond" targets coincide with the bare conjecture.

**Inputs (literature-verified, 2026-06-06; two parallel research passes).** Frontier table + the exact
axisymmetric PDE structure (Γ, Ω, ψ) with signs/constants cross-checked against primary sources. Sources
§7; flags §8.

---

## 1. The target and why it is the most tractable sub-target

From the NS-048 machinery study (`docs/ns048_machinery_study.md`, §10a), the most tractable open hole is
a **Liouville theorem for a restricted non-self-similar bounded mild ancient class beyond
axisymmetric-no-swirl.** The verified frontier:

| Result | Class | Restriction that buys closure | Conclusion |
|---|---|---|---|
| KNSS 2009 | axisym, **no swirl** | swirl `=0` | constant |
| KNSS 2009 | axisym, any swirl | `|v| ≤ C/r` (all components decay) | **0** |
| Chen–Strain–Tsai–Yau 2008/09 | axisym, swirl | `|v| ≤ C/r` | regular (Type-I excluded) |
| Lei–Zhang–Zhao 2017 | axisym, swirl | `Γ=ru^θ ∈ L^∞_t L^p_x`, **1≤p<∞** | constant |
| Pan–Li 2020 | axisym, swirl | `|u| ≤ C r^α`, **α<1** (optimal) | constant |
| Lei–Ren–Zhang 2019 | axisym, swirl, on **ℝ²×T¹** | compact axis direction | constant |
| **KNSS conjecture** | **axisym, swirl, on ℝ³** | **none beyond boundedness** | **OPEN** |

Every with-swirl theorem buys **decay or compactness**. The conjecture withholds both. The attack below
asks: *exactly what does the restriction buy, and is there a soft step just beyond the frontier?*

---

## 2. The verified coupled system and the single crux

Cylindrical `(r,θ,z)`, `θ`-independent components, meridional field `b=u^r e_r+u^z e_z`
(`∇·b=∂_r u^r+u^r/r+∂_z u^z=0`), viscosity `ν`. Verified equations:

**Swirl `Γ=r u^θ` — transport-diffusion, NO source:**
$$\partial_t\Gamma + (u^r\partial_r+u^z\partial_z)\Gamma = \nu\big(\partial_r^2 - \tfrac1r\partial_r + \partial_z^2\big)\Gamma. \tag{Γ}$$
Hence the **maximum principle**: `M(t):=‖Γ(·,t)‖_{L^∞}` is non-increasing in `t`. (`Γ≡0` is preserved —
the no-swirl reduction.)

**Good quantity `Ω:=ω^θ/r` — the ONLY production is the swirl term:**
$$\partial_t\Omega + b\cdot\nabla\Omega = \nu\big(\partial_r^2 + \tfrac3r\partial_r + \partial_z^2\big)\Omega + \frac{1}{r^4}\partial_z(\Gamma^2). \tag{Ω}$$
The source `(1/r⁴)∂_z(Γ²) = ∂_z(u_1²)` with `u_1=u^θ/r=Γ/r²` (verified two independent ways). This is
the swirl-to-meridional-vorticity mechanism — *the entire coupling.*

**Biot–Savart (stream function `ψ`):** `−(∂_r²+\tfrac1r∂_r−\tfrac1{r²}+∂_z²)ψ=ω^θ`,
`u^r=−∂_zψ`, `u^z=\tfrac1r∂_r(rψ)`. So `(u^r,u^z)←ω^θ=rΩ`. The loop closes:
$$\boxed{\;\Gamma \xrightarrow{\;(1/r^4)\partial_z(\Gamma^2)\;} \Omega \xrightarrow{\;\text{Biot–Savart}\;} (u^r,u^z) \xrightarrow{\;b\cdot\nabla\Gamma\;} \Gamma\;}$$

**Organizing principle (standard, NOT new):** if `Γ≡0`, the source vanishes, (Ω) is a pure
drift-diffusion with a maximum principle, and the problem collapses to the no-swirl case (KNSS, trivial).
*Therefore every with-swirl Liouville theorem is, structurally, a theorem about controlling the single
source `(1/r⁴)∂_z(Γ²)`.* The attack is an attack on that term.

---

## 3. What each restriction buys (all the same thing: tame the source)

- **`|v|≤C/r` (KNSS/CSTY):** forces `Γ=ru^θ ≤ C` *and* meridional decay; the source becomes globally
  integrable and the loop is contractive. Strongest, cleanest — and the source is killed at infinity by
  pointwise decay.
- **`Γ∈L^∞_tL^p_x`, `p<∞` (Lei–Zhang–Zhao):** pure **decay-at-infinity** of the swirl function in an
  integrated sense; controls `∫(source)` at spatial infinity, then parabolic estimates + the Γ-maximum
  principle close it. The endpoint `p=∞` gives **no decay** → open.
- **`|u|≤Cr^α`, `α<1` (Pan–Li):** caps the *growth* of `Γ=ru^θ=O(r^{1+α})`... wait — `|u^θ|≤Cr^α`
  ⇒ `Γ=O(r^{1+α})`; the sublinear cap on `u` controls how fast the source can grow. `α=1` (linear)
  is **false** — explicit counterexamples — so this axis is already at its optimal endpoint.
- **`ℝ²×T¹` (Lei–Ren–Zhang):** the axis direction `z` is **compact**. Since the source is a
  `z`-derivative `∂_z(Γ²)`, a Poincaré/Fourier-in-`z` argument controls it *without* assuming spatial
  decay — the compactness of `T¹` substitutes for decay. (Structural reading — see §4.3; flagged in §8.)

**Common denominator:** every restriction supplies *control of the swirl's variation in the unbounded
directions* — by decay (`L^p`, `C/r`), by growth-capping (`r^α`), or by removing an unbounded direction
(`T¹`). None is available under boundedness alone.

---

## 4. The attack: three honest attempts and where each breaks

### 4.1 Attempt — reduce to the source and bound it by energy (Caccioppoli)
Test (Ω) against a cutoff and integrate; the source contributes, after `∂_z` by parts,
`−∫(1/r⁴)Γ²∂_z(\text{test})`. To close a Liouville argument one needs this to vanish on large balls.
**Break:** with only `|u|≤C`, `Γ=ru^θ=O(r)` at meridional infinity, so `Γ²/r⁴=O(1/r²)`; against the
axisymmetric volume element `r\,dr\,dz` the source's tail is `O(1/r)\,dr\,dz` — **borderline
non-integrable** in `r`, and *entirely uncontrolled in `z`*. The energy method needs decay the
hypothesis does not give. (Consistent with: `L^p`, `p<∞`, is exactly the assumption that makes this
tail integrable — Lei–Zhang–Zhao's restriction is the minimal fix for *this* integral.)

### 4.2 Attempt — is the `1/r⁴` axis singularity the obstruction? **No — and this corrects a naive reading.**
The factor `1/r⁴` looks like an axis catastrophe. It is not, for smooth flows. Regularity forces
`u^θ=O(r)` near the axis, so `Γ=ru^θ=O(r²)`, hence
$$\frac{1}{r^4}\partial_z(\Gamma^2)=\frac{2\Gamma\,\partial_z\Gamma}{r^4}=\frac{O(r^2)\cdot O(r^2)}{r^4}=O(1)\quad(r\to0).$$
**The source `S` is bounded at the axis.** So the *source term that obstructs the energy estimate* is
benign at `r=0`; the binding obstruction for that estimate is at axial infinity `|z|→∞` (the production
is a `z`-derivative). **[WITNESS-CORRECTED 2026-06-07 — the original "the obstruction is *not* the
axis" was an over-reach.]** This does **not** assert the axis is irrelevant to the *full problem*: the
`1/r`-weighted operators (the `(3/r)∂_r` in (Ω), the `1/r²` in Biot–Savart) may still impose real
constraints at `r=0`. What is shown is only that the *source* `S` does not break *there* — not that the
axis plays no role. (Confident on `S=O(1)` at `r=0`; `Γ=O(r²)` is verified folklore — §8.)

### 4.3 Attempt — use the Γ maximum principle to extract decay. **Break: temporal ≠ spatial; non-attainment on ℝ³.**
The maximum principle gives `M(t)=‖Γ(·,t)‖_{L^∞}` non-increasing, bounded ⇒ `M(t)→M_{-∞}≤M_0<∞` as
`t→−∞`. **The hope:** monotone, near-constant `M(t)` forces `Γ` rigid (the strong maximum principle:
an interior space-time max of a sub/supersolution ⇒ `Γ` locally constant). **The break:** on the
*non-compact* `ℝ³` the supremum need **not be attained** — the maximizing point `x(t)` can escape to
infinity — so the strong maximum principle has no interior extremum to bite on, and `M(t)` controls a
*temporal* envelope, never *spatial decay* at fixed `t`. The maximum principle is blind to what `Γ` does
at `|x|→∞`. 

This break is **exactly diagnostic**: Lei–Ren–Zhang's `ℝ²×T¹` works because making the axis `T¹`
compact restores attainment/Poincaré control in the `z` direction — the precise direction the source
`∂_z(Γ²)` lives in. So the obstruction localizes further: **the non-compact axial direction `z∈ℝ`**,
where boundedness supplies neither decay nor compactness, and the maximum principle cannot reach. (The
`T¹`-mechanism reading is my structural interpretation, consistent with the verified equations and the
LRZ result; I did not read LRZ's proof line-by-line — §8.)

---

## 5. Verdict

**No theorem. The wall is localized, sharply, and it coincides with the conjecture itself.**

1. With-swirl ancient Liouville = controlling the single source `(1/r⁴)∂_z(Γ²)` in (Ω) (§2).
2. That control = decay/compactness of the swirl in the **unbounded directions** (§3). For the *methods
   tried here*, the binding direction is the **non-compact axial direction `z`**, because the source is
   `∂_z(Γ²)` (§4.3); the source does *not* break at the axis `r=0` for smooth flows (§4.2 — though the
   `1/r`-weighted operators may still constrain there).
3. Boundedness alone gives `Γ=O(r)` growth — **no decay, no compactness** (§4.1). So the three
   session-scale attempts break at the place the literature buys its hypothesis.
4. **[WITNESS-CORRECTED 2026-06-07 — the original "there is no soft just-beyond step" was an
   over-reach, refuted in the witness pass.]** The three *specific* frontier axes I considered are each
   near their endpoint (`L^p` at `p<∞`; `r^α` at the optimal `α<1`; `T¹` whose removal LRZ frame as the
   remaining `T¹→ℝ` step). **But the restricted-class space is NOT exhausted, and a soft intermediate
   manifestly exists:** `ℝ²×T¹` is *itself* a proven class strictly between 2D and 3D (I listed it as
   "known" above — so claiming "no intermediate class" was self-contradictory). Softer-than-conjecture
   refinements also plausibly exist — weak-`L^p`/Lorentz swirl `Γ∈L^∞_tL^{p,∞}_x` (plausibly closable by
   extending the De Giorgi–Nash–Moser argument on the source-free `Γ` equation + Lorentz interpolation)
   and *small-swirl* `‖Γ‖_∞≤ε` (plausibly closable by perturbing the *complete* swirl-free KNSS proof,
   the source being `O(ε²)`). These two are **plausible, not verified** — but their existence refutes the
   universal claim.

So the honest content of "attacking the most tractable sub-target," after the witness trim, is narrower:
**the three frontier hypotheses I considered are individually near-endpoint, and all three session-scale
*methods* (energy, max-principle, sign) stop at the same place — the non-compact axial direction. But
there ARE softer restricted classes (proven: `ℝ²×T¹`; plausible: weak-`L^p`, small-swirl), so the
sub-target does NOT simply collapse onto the bare conjecture.** Not progress on the prize; `:proved`
stays 0. The 8th over-reach (a manufactured theorem) was declined; the **"no soft step" claim was itself
a 10th over-reach, caught by the witness pass** (see `docs/ns048_axisym_swirl_witness_brief.md`,
changelog v0.1.76).

---

## 6. What a genuine assault would actually require

Not session work — each is a real paper, named honestly so a future attempt starts informed:

- **(A) A borderline/Lorentz refinement of Lei–Zhang–Zhao at the `p=∞` endpoint** — replace `Γ∈L^p`
  (`p<∞`) by a strictly weaker decay (e.g. `Γ∈L^∞_t L^{∞}_x` *with* a vanishing-oscillation or
  log-decay modulus in `z`). Requires redoing LZZ's parabolic machinery in a borderline space. *Most
  promising; high technical cost.*
- **(B) A `z`-decay mechanism replacing `T¹`-compactness** — port Lei–Ren–Zhang's compact-axis argument
  to `ℝ` by proving the swirl's `z`-variation decays for bounded ancient solutions. This is the explicit
  `T¹→ℝ` step LRZ leave open.
- **(C) A one-sided/structural swirl condition** (sign or monotonicity of `Γ` in `z`) making the source
  `(1/r⁴)∂_z(Γ²)` signed, hence usable in a maximum principle for `Ω`. A genuinely *new restricted
  class* — but whether it is non-vacuous for ancient solutions and whether it closes is unknown; default
  "not established."

All three respect the sanity check (each uses its restriction essentially; none would prove the bare
conjecture). The within-truncation geometry (NS-045/046/`∇ξ`) remains a *suggestive prior on where to
probe*, never a rigidity input (the 7th-over-reach correction stands).

---

## 7. Verified sources

**Frontier:** KNSS, Acta Math. 203 (2009), arXiv:0709.3599 · Lei–Zhang, JFA 2011, arXiv:1011.5066 ·
Lei–Zhang–Zhao, Sci. China Math. 2017, arXiv:1701.00868 · Pan–Li, Bull. Sci. Math. 2020,
arXiv:1908.11591 · Lei–Ren–Zhang, arXiv:1911.01571 · Chen–Strain–Tsai–Yau, IMRN 2008 / Comm. PDE 34
(2009) · Albritton–Barker, JMFM 2019, arXiv:1811.00502 · Pan–Zhang review, arXiv:2101.04905.

**Structure (signs/constants cross-checked):** Lei–Zhang arXiv:1011.5066 (Γ eq.) · Hou–Li
arXiv:2107.06509 (the `∂_r²+\tfrac3r∂_r+∂_z²` operator + `∂_z(u_1²)` source) · Gallay–Šverák
arXiv:1510.01036 (Biot–Savart, near-axis BCs) · Pan–Zhang review arXiv:2101.04905 (independent source
cross-check) · Majda–Bertozzi, *Vorticity and Incompressible Flow*.

---

## 8. Flagged / not primary-verified

1. **`Γ=O(r²)` near the axis** (the §4.2 cancellation) — standard smooth-flow Taylor behavior
   (`u^θ=O(r)`), universally used, but not located as a quoted theorem; derivable, high confidence.
2. **The `T¹`-compactness ↔ `∂_z`-control reading** (§3, §4.3) — my structural interpretation of why
   Lei–Ren–Zhang's `ℝ²×T¹` result works; consistent with the verified `∂_z(Γ²)` source and their stated
   `T¹→ℝ` framing, but I did not read their proof in detail. Do not cite as their stated mechanism.
3. **The §4.1 tail integrability** (`Γ²/r⁴` borderline in `r`) — a scaling heuristic at the level of
   powers, not a completed estimate; the `z`-direction divergence is the dominant point and is robust.
4. **Lei–Ren–Zhang "constant" conclusion** — the abstract says "Liouville theorem for bounded mild
   ancient solutions"; the word "constant" is inferred from KNSS context (frontier-pass flag).
5. **Chen–Strain–Tsai–Yau venue split** (IMRN 2008 Part I / Comm. PDE 2009 Part II) probable, not
   abstract-verified; "Navas/Navarro-Fernández" name spelling flagged.
6. **`Γ∈L^∞_tL^∞_x ≈ bare conjecture`** (§5.4) — the claim that the `p=∞` endpoint equals the open case
   rests on "bounded `v` ⇒ `Γ=O(r)`, not `L^∞`"; the precise equivalence to KNSS is a frontier-research
   reading, not a quoted theorem.
