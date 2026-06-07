# NS-048 — porting the anisotropic-`z` swirl criterion to ancient Liouville: attempt + located gap

**Date:** 2026-06-07. **PORTING ATTEMPT / ANALYSIS. NO theorem.** `:proved`=0; distance UNTOUCHED;
NS-048 unchanged. Default "not established." This executes the entry sub-question from
`docs/ns048_swirl_source_frontier.md` §6: *port the finite-time anisotropic-`z` swirl regularity criterion
to the bounded-ancient setting.* Outcome: the port is a **genuine new ancient-Liouville question** (not
implicit in the existing proof), the **transfer gap is precisely located**, and the condition is
**well-motivated but partial** (kills the dominant `z`-tail of the source, leaves the borderline radial
tail). No ancient argument is produced.

---

## 1. The finite-time conditions (exact) — with a citation correction

Read line-by-line from the primary PDFs:

- **Yu** (H. Yu, *Appl. Anal.* 99 (2020), 313–325; via its faithful restatement in arXiv:2205.13893):
  a Leray-type axisymmetric solution with `|x₃| u^θ ∈ L^∞_t L^∞_x` of **sufficiently small norm** is
  regular.
- **Wang–Huang–Wei–Yu** (arXiv:2205.13893, Thm 1.4): if `|x₃|^α u^θ ∈ L^q_t L^p_x` with
  `2/q+3/p = 1−α`, `0≤α<1/4`, `3/(1−α)<p≤∞`, `2/(1−α)≤q<∞` (or the small-norm endpoint
  `|x₃|^α u^θ ∈ L^∞_t L^{3/(1−α)}_x`), the solution is smooth on `(0,T]`.

**[CITATION CORRECTION to `ns048_swirl_source_frontier.md` §4 / §6 and the witness verdict.]** I had
attributed the "`|x₃|^α u^θ` mixed-norm" condition to **Chen–Fang–Zhang**. That is wrong: **CFZ's criteria
are radial-weighted (`r^d u^θ`)**; the genuinely `|x₃|^α` (axial-weighted) conditions are **Yu's** and
**Wang–Huang–Wei–Yu's**. The entry sub-question is unchanged, but the correct sources are Yu / Wang et al.

---

## 2. Criticality (the prerequisite for a Liouville translation)

Under `u_λ(x,t)=λu(λx,λ²t)`: `u^θ_λ=λu^θ(λx,λ²t)`, and the axial weight scales `|x₃|^α→(|x₃|/λ)^α`. Then
$$\|\,|x_3|^\alpha u^\theta_\lambda\,\|_{L^q_tL^p_x}=\lambda^{\,1-\alpha-3/p-2/q}\,\|\,|x_3|^\alpha u^\theta\,\|_{L^q_tL^p_x},$$
so the norm is **scale-invariant ⇔ `2/q+3/p=1−α`** — exactly Thm 1.4's admissible line. For Yu's
`L^∞_tL^∞_x` (`α=1,p=q=∞`): `λ^{1−1}=λ^0`, **scale-invariant** (your computation, verified). Critical
conditions are precisely the ones that translate to Liouville statements on rescaled limits — so the port
is well-posed in principle.

---

## 3. The proposed ancient port (a new conjecture)

> **(Port-conjecture.)** A bounded mild ancient axisymmetric solution on `ℝ³×(−∞,0]` with a critical
> anisotropic-`z` swirl bound `‖|x₃|^α u^θ‖_{L^q_tL^p_x} < ∞` (`2/q+3/p=1−α`), or `‖|x₃|u^θ‖_{L^∞}` small,
> is constant.

This is **not in the literature** (verified: every ancient/Liouville ASNS result uses *radial*-weight
conditions — `Γ=ru^θ∈L^p`, `|v|≤C/r`, sublinear growth — never an axial `|x₃|^α` weight).

---

## 4. Transferability verdict — the finite-time proof does NOT transfer

Read line-by-line (Wang et al. Thm 1.4 proof; CFZ §4 identical skeleton). The mechanism is **direct
finite-time**, *not* blow-up/ancient-limit:

1. Vorticity-energy estimate on `Φ=ω^r/r`, `Ω=ω^θ/r`: `½ d/dt(‖Φ‖²+‖Ω‖²) + (‖∇Φ‖²+‖∇Ω‖²) = ∫(\dots)`.
2. Bound the RHS by Hölder + the **anisotropic Hardy–Sobolev inequality** (this is where `|x₃|^α u^θ`
   enters) + fractional Gagliardo–Nirenberg.
3. **Gronwall** ⇒ `‖Ω(t)‖_{L²}` bounded — **anchored to the initial data**: in CFZ explicitly
   `sup_{[0,T*)}‖Ω‖²_{L²} ≤ (‖Φ₀‖²+‖Ω₀‖²)·exp(C‖u^θ‖^{...})`.
4. **Finite-time continuation lemma:** `T<∞` + `Ω∈L^∞_tL²` ⇒ the solution extends past `T`.

There is **no rescaling, no `λ→0` limit, no ancient solution, no Liouville exclusion.** Therefore:

> **The `|x₃|^α` ancient Liouville theorem is NOT implicit/extractable from the finite-time proof.** The
> proof genuinely relies on finite-`T`/initial-data structure an ancient solution does not possess.

**(Hedge, verified):** CFZ's *critical radial endpoint* (Thm 2.3, `Γ∈L^∞_tL^{2,w}`-type) *is* proved
"analogously to" the Lei–Zhang **ancient/Liouville** theorem — so at the critical *radial* endpoint a
Liouville argument is used. But that is the `r`-weighted case; the `|x₃|^α` (axial) criteria are
direct-Gronwall only.

---

## 5. The precise gap

Porting must **replace the two finite-`T`-dependent steps** (§4.3 Gronwall anchored to `(Φ₀,Ω₀)`; §4.4
continuation past finite `T`) — both vacuous on `(−∞,0]` — with an ancient mechanism. Two candidate
replacements:

- **(i) Blow-down / Liouville-via-rescaling** (the KNSS Lemma-6.1 device that Lei–Zhang–Zhao invoke):
  rescale the ancient solution at large scales, use the critical (scale-invariant) `|x₃|^α` bound to keep
  the rescaled family compact, exclude the limit. *The critical scaling (§2) is exactly what this needs —
  but the exclusion of the limit is the open content.*
- **(ii) Maximum-principle + `z`-decay** (the LZZ radial route, re-aimed at `z`): use the `|x₃|^α` bound to
  force `z`-decay of `u^θ` (hence of `Γ`), then push the `Γ`-maximum-principle to `Γ≡0` → swirl-free →
  KNSS. *The obstacle: `Γ=ru^θ` decays in `z` but grows in `r` under this bound (see §6), so the radial
  rigidity LZZ uses is not supplied.*

Either route is a genuine analytic undertaking; neither is carried out here. **The gap is the
initial-data/finite-`T` Gronwall+continuation structure, with no ancient replacement in hand.**

---

## 6. Why the condition is well-motivated — and why it is only *partial*

**The genuine positive (scoped):** the `|x₃|^α` bound is an **axial-decay condition on the swirl**, aimed
squarely at the non-compact `z`-direction that the frontier doc and the witness triad identified as the
obstruction. Heuristic scaling (regularity-dependent; **flagged heuristic, not an estimate**): from
`|x₃|^α u^θ ≲ 1` one has `u^θ ≲ |z|^{−α}`, so `Γ=ru^θ ≲ r|z|^{−α}`, `Γ² ≲ r²|z|^{−2α}`,
`∂_z(Γ²) ≲ r²|z|^{−2α−1}`, hence the source
$$S=\frac{1}{r^4}\partial_z(\Gamma^2)\ \lesssim\ \frac{|z|^{-2\alpha-1}}{r^2}.$$
Since `2α+1>1`, this is **`z`-integrable** — the condition *kills the dominant `z`-tail* of `S` (which,
under mere boundedness, diverged linearly in `z`; frontier doc §4.1).

**The limit (why it is only half the fix):** the *radial* tail survives. With the axisymmetric volume
element `r\,dr\,dz`,
$$\iint |S|\,r\,dr\,dz \ \lesssim\ \Big(\!\int |z|^{-2\alpha-1}dz\Big)\!\Big(\!\int \tfrac{1}{r^2}\cdot r\,dr\Big) = (\text{finite})\times\Big(\!\int \tfrac{dr}{r}\Big),$$
which **still log-diverges in `r`**. So `|x₃|^α` controls the dominant (`z`) obstruction but **not** the
borderline radial-log tail. The honest structural reading:

> The source's obstruction has **two tails** — dominant in `z` (linear under boundedness), borderline in
> `r` (log). LZZ's radial `L^p` kills the `r`-tail (and forces full `Γ`-decay); the `|x₃|^α` condition
> kills the `z`-tail. A *complete* ancient closing condition plausibly **combines an axial (`|x₃|^α`) and
> a radial (LZZ-type) control** — neither alone is visibly sufficient.

This is a heuristic `L¹` diagnostic, not the actual closing estimate (which would be the
Hardy–Sobolev/Gronwall machinery re-done in the ancient setting); flagged accordingly.

---

## 7. Comparison to the radial conditions (disciplined)

The `|x₃|^α` (axial) and LZZ `L^p` (radial) conditions address **orthogonal non-compact directions**.
Notably, `|x₃|^α u^θ` bounded **excludes the columnar case** (`∂_zΓ≡0`, `Γ=Γ(r)`): there `u^θ=Γ(r)/r` is
`z`-independent, so `|z|^α u^θ→∞` as `|z|→∞` unless `Γ≡0`. So the axial condition is a *genuinely
different* hypothesis class. **I do not claim it is "incomparable" to the radial conditions** (the same
discipline that declined the 13th over-reach in the frontier doc — the precise comparison is open); I
state only that it is *complementary in direction* (`z` vs `r`) and *excludes the columnar degeneracy*.

---

## 8. Verdict

- **The port is a genuine NEW ancient-Liouville question** (verified: not implicit in the finite-time
  proof, not in the literature).
- **The finite-time proof does not transfer** — it is direct Gronwall-on-`[0,T)` anchored to initial data
  + finite-`T` continuation; the gap is precisely those two finite-`T`/initial-data steps, with no ancient
  replacement produced (§5).
- **The condition is well-motivated but partial:** it kills the dominant `z`-tail of the source `S` (the
  identified obstruction) but leaves the borderline radial-log tail; a complete closing condition likely
  needs **axial `|x₃|^α` + radial (LZZ-type) control combined** (§6).
- **No theorem; `:proved`=0; NS-048 unchanged.** The contribution is: a precise new conjecture, the
  verified non-transfer + located gap, the scoped mechanism (and its partiality), and the structural
  "two-tail" reading that points at a combined axial+radial closing condition as the next formulation.

The honest next step (again, a real analytic undertaking, not a session task): **attempt route (i)** —
the blow-down/Liouville-rescaling under the critical `|x₃|^α` bound — since the criticality (§2) is
exactly what that device requires, and it sidesteps the radial-tail problem of route (ii).

---

## 9. Sources + flags

**Verified (read in full via `pdftotext`):** Wang–Huang–Wei–Yu arXiv:2205.13893 (Thm 1.4 statement +
proof: Hardy–Sobolev → Gronwall → continuation); Chen–Fang–Zhang arXiv:1802.08956 (radial `r^d u^θ`,
the explicit initial-data-anchored Gronwall bound, the continuation lemma, the critical-endpoint
"analogously to [Lei–Zhang]" remark); Q.S. Zhang review arXiv:2101.04905 §3 (ancient results all
radial-weighted — the negative).

**Flagged:** Yu *Appl. Anal.* 99 (2020) — paywalled; statement/mechanism taken from its faithful
restatement + reused inequality in 2205.13893, not the original PDF. The §6 scaling is a **heuristic
power-count assuming `∂_zΓ` inherits `Γ`'s `z`-decay rate** (parabolic-regularity plausible for smooth
ancient solutions, not proven here) and uses a crude `L¹`-of-`S` proxy, not the actual Hardy–Sobolev
closing estimate. The "no `|x₃|^α` ancient result exists" is a literature-search negative, not a proof of
nonexistence. The columnar-exclusion (§7) rests on this repo's C8 reduction.
