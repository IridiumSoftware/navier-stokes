# NS-048 attack (C) — the swirl sign-condition class: why it doesn't help (and where it closes)

**Date:** 2026-06-07. **ATTACK / ANALYSIS artifact. NO theorem is claimed.** `:proved`=0; distance
UNTOUCHED; NS-048 unchanged. Default: **"not established."** This works the one genuinely *new*
restricted class flagged in `docs/ns048_axisym_swirl_attack.md` §6(C): a one-sided/monotonicity sign
condition on the swirl, meant to make the production term `(1/r⁴)∂_z(Γ²)` signed and thus usable in a
maximum principle for `Ω=ω^θ/r`.

**Sanity check held throughout:** any step that would also prove the bare KNSS conjecture is wrong. The
result below is a *negative* finding (the natural sign route does not close), triangulating the same
wall the previous two attacks hit — not a theorem and not an over-reach in either direction.

**Result in one line:** the sign that the dynamics *can* control (`Γ≥0`) does **not** sign the source;
the sign that *would* sign the source (`∂_zΓ` one-signed) is **not dynamically preserved** and is
plausibly vacuous; and even if granted it yields only **one-sided** control of `Ω`, which does not
close. The only sub-case that closes is the degenerate `∂_zΓ≡0` (columnar) endpoint — essentially the
already-known 2D / periodic-in-`z` reduction.

---

## 1. The idea and the two candidate classes

Recall the verified production term in the `Ω=ω^θ/r` equation (`docs/ns048_axisym_swirl_attack.md` §2):
$$\partial_t\Omega + b\cdot\nabla\Omega = \nu\big(\partial_r^2+\tfrac3r\partial_r+\partial_z^2\big)\Omega + S,\qquad S=\frac{1}{r^4}\partial_z(\Gamma^2)=\frac{2\Gamma}{r^4}\,\partial_z\Gamma.$$
Write the homogeneous parabolic operator `𝒫Ω := ∂_tΩ + b·∇Ω − ν(∂_r²+\tfrac3r∂_r+∂_z²)Ω`, so `𝒫Ω=S`.
The hope: if `S` has a fixed sign, `Ω` is a sub- or super-solution of `𝒫`, and a maximum principle
forces rigidity. To sign `S=(2Γ/r⁴)∂_zΓ` we need both factors controlled. The two natural classes:

- **(C-i) one-signed swirl:** `Γ≥0` everywhere (WLOG; else replace `Γ→−Γ`, which solves the same
  equation).
- **(C-ii) `z`-monotone swirl:** `∂_zΓ≤0` everywhere. Together with (C-i), `S≤0`.

---

## 2. Dynamical-consistency test (the decisive filter for any sign hypothesis)

A sign hypothesis is only meaningful if the flow *preserves* it for an ancient solution (defined for all
`t≤0`). Test each.

**(C-i) `Γ≥0` — PRESERVED, non-vacuous. ✓** The swirl equation
`∂_tΓ + b·∇Γ = ν(∂_r²−\tfrac1r∂_r+∂_z²)Γ` has **no source**, so it obeys both a maximum *and* a minimum
principle: `Γ≥0` at one time ⇒ `Γ≥0` for all later times, and for an ancient solution `Γ≥0` on `(−∞,0]`
is fully consistent. It is non-vacuous — any flow with one-directional swirl (e.g. all fluid rotating
the same way about the axis) satisfies it. So `Γ≥0` is a *legitimate, dynamically natural* restricted
class.

**(C-ii) `∂_zΓ≤0` — NOT preserved. ✗** Let `G:=∂_zΓ`. Since the coefficients of
`L_Γ=∂_r²−\tfrac1r∂_r+∂_z²` depend only on `r`, `∂_z` commutes with `L_Γ`, and differentiating the swirl
equation in `z` gives
$$\partial_t G + b\cdot\nabla G = \nu L_\Gamma G \;-\;\big[(\partial_z u^r)\,\partial_r\Gamma + (\partial_z u^z)\,G\big].$$
The bracket is the obstruction. **[Sharpened post-witness:** the decisive term is the *inhomogeneous*
`−(∂_z u^r)∂_rΓ` — an **unsigned forcing independent of `G`, generically nonzero on `{G=0}`**, which
directly drives `G` across zero. (The other term `−(∂_z u^z)G` is zeroth-order in `G`; a bounded
zeroth-order coefficient *alone* would not break one-sided sign preservation — an exponential-weight
trick survives it — so the inhomogeneity, not this term, is the real reason.)**]** So `G` does **not**
satisfy a maximum principle that would preserve `G≤0`; the meridional shear `∂_z b` can manufacture
either sign of `∂_zΓ`. Imposing
`∂_zΓ≤0` for all time on an ancient solution is therefore an *artificial* constraint the equation fights
— and (see §4) the only configurations that sustain it appear to be the degenerate `∂_zΓ≡0` ones, making
the strict class plausibly **vacuous** among genuinely 3D ancient solutions.

**Filter verdict:** the controllable sign (`Γ≥0`) does not sign `S`; the signing sign (`∂_zΓ`) is not
controllable. The sign-condition idea is already in trouble before any maximum-principle step.

---

## 3. Even granting (C-i)+(C-ii): the conclusion is one-sided

Suppose, despite §2, we *assume* `S≤0`. Then `𝒫Ω=S≤0`, so `Ω` is a **subsolution** of `𝒫`. The
parabolic maximum principle then bounds `Ω` **from above** (a bounded ancient subsolution cannot exceed
its asymptotic supremum). But a Liouville conclusion needs `Ω≡0` — i.e. control from **both** sides,
which requires `S` signed **both** ways simultaneously, impossible for a single one-signed source.

A one-sided bound `Ω≤C` does not obviously bootstrap: `Ω=ω^θ/r` one-signed (signed meridional vorticity)
does not force the meridional flow trivial, and closing the loop would require coupling the bound back
through Biot–Savart (`(u^r,u^z)←rΩ`) and the `Γ`-transport — not session-tractable, and not visibly
convergent. **Default: not established.** So even in the best case the sign hypothesis yields a one-sided
estimate, not a Liouville theorem.

*(This is the §2-of-the-parent break in a new guise: a maximum principle controls one extremum, and on
the non-compact domain that is not enough.)*

---

## 4. The one sub-case that DOES close: `∂_zΓ≡0` (columnar swirl) — and it is not new

The strict monotonicity collapses, at its boundary, to `∂_zΓ≡0`: the swirl is **`z`-independent**
(columnar). Then `S≡0` identically, and the attack's whole difficulty evaporates:

1. `S≡0` ⇒ `Ω` solves the **sourceless** drift-diffusion — the *no-swirl* structure. A bounded ancient
   solution of it is, by the KNSS no-swirl machinery, trivial (`Ω≡0`, meridional velocity constant; an
   axisymmetric constant field is `c\,e_z`).
2. With trivial meridional flow, `∂_tΓ = ν(∂_r²−\tfrac1r∂_r)Γ`. **[Sharpened post-witness:** this
   operator is *degenerate* at `r=0`, so "heat-type ⇒ constant" needs care; the clean route is the
   substitution `u₁=Γ/r²`, under which `Γ` solving the degenerate equation ⇔ `u₁` solving the
   *non-degenerate* 4-D radial heat equation `∂_tu₁=ν(∂_r²+\tfrac3r∂_r)u₁`. A bounded ancient caloric
   function is constant (classical, any dimension) ⇒ `u₁≡`const ⇒ `Γ=r²u₁`, and boundedness of
   `u^θ=Γ/r=r·u₁` forces that constant to 0 ⇒ `Γ≡0`.**]

So **columnar-swirl bounded ancient ⇒ trivial.** But this is the *degenerate* endpoint where the problem
ceases to be genuinely 3D, and it is essentially the known reduction: the literature already has
**`Γ` bounded + solution periodic in `z` ⇒ `v≡c\,e_z`** (Lei–Ren–Zhang `ℝ²×T¹`, arXiv:1911.01571; and
the ancient-periodic line, arXiv:1902.11229), of which `z`-independence is the extreme case. **Not new.**

---

## 5. Verdict — (C) triangulates the wall, it does not beat it

No theorem; `:proved`=0. The sign-condition route fails for two structural reasons (§2 non-preservation /
vacuity, §3 one-sidedness), and closes only in the degenerate source-free `∂_zΓ≡0` case (§4), which is
already known. The intellectually useful content — **as honestly trimmed by the witness pass
(2026-06-07; `docs/ns048_axisym_swirl_witness_brief.md`):**

- **(C) re-lands on the same locus the two prior attacks hit: the non-compact axial direction.** But
  **[WITNESS-CORRECTED — the original "three independent convergent attacks" was an over-reach (echo,
  not corroboration; an 11th over-reach).]** They are **not** three independent lines:
  - §4.1 of the parent (energy/Caccioppoli) and **this note (sign condition)** both fail on the
    *literally identical* term `S=(2Γ/r⁴)∂_zΓ` — one says its integral is uncontrolled in `z`, the other
    says its sign `∂_zΓ` is uncontrollable. **Two failure modes of ONE term = echo, not independence.**
  - Only §4.3 (maximum principle) carries near-distinct information — a *function-theoretic* obstruction
    (non-attainment of the sup on non-compact `ℝ³`), a different category than "this term's integral has
    a bad tail."
  - So there are at most **~1.5 independent lines**, both pointing at the non-compact axial direction —
    not three. And two further deflations: a **selection effect** (energy / max-principle / sign are
    exactly the *soft* tools that predictably fail on *any* supercritical non-compact problem, so their
    common stopping point may reflect the methods' shared softness, not an intrinsic property), and the
    localization merely **re-derives** what the known results already encode (their hypotheses — `L^p`,
    `α<1`, `T¹` — all function precisely by neutralizing non-compact-`z` / buying axial decay).
- **Honest residue:** *these elementary methods all stop at the non-compact axial direction, consistent
  with — and re-deriving — the known structure.* This is **method-failure localization**, NOT proof that
  `z`-dependence is "**the** irreducible difficulty" (that is a claim about *all* methods; three soft
  failures don't establish it), and NOT a new finding (the diagnosis is implicit in the known
  hypotheses).

This does **not** prove "no sign-based argument can ever work" — only that the natural one fails for these
specific, robust reasons. A cleverer use of `Γ≥0` coupled to a quantity other than `∂_zΓ` is not ruled
out. Note also (witness, target 1): if one *additionally* assumes `ω^θ` (hence `Ω`) one-signed — a
strictly stronger hypothesis than signing `S` — the route *does* close (non-negative ancient supersolution
of the 5D-type operator ⇒ constant ⇒ swirl-free ⇒ KNSS), but that is a different, stronger restricted
class. Default: not established.

The 9th tidy hope — "a sign condition signs the source and a maximum principle closes it" — was deflated
by working it through. **Honesty ledger for the NS-048 arc:** 7th = geometry-re-tasking; 8th = a
manufactured restricted theorem (declined); 9th = the sign-condition shortcut (deflated here); **10th =
"no soft step beyond the frontier" (over-reach, witness-refuted — `ℝ²×T¹` is itself an intermediate
class); 11th = "three independent convergent attacks" (over-reach, witness-trimmed to ~1.5 + echo, this
section).** The 10th/11th are the witness pass catching *this arc's own* over-reaches — the discipline
working exactly as intended.

---

## 6. Literature check + sources

A targeted search (2026-06-07) found **no** one-signed-swirl or monotone-swirl ancient Liouville theorem;
the neighbors are the `L^p` (Lei–Zhang–Zhao), sublinear-growth (Pan–Li), and **periodic-in-`z`**
(Lei–Ren–Zhang; ancient-periodic, arXiv:1902.11229) results. The columnar `∂_zΓ≡0` closable case (§4) is
covered by those `z`-compact/periodic reductions and the no-swirl theory (KNSS). So the *framing* of (C)
appears unattempted, but its only closable instance is known and its general case does not close — there
is no novelty to claim.

- KNSS, Acta Math. 203 (2009), arXiv:0709.3599 — no-swirl ⇒ constant (the `S≡0` engine).
- Lei–Zhang–Zhao, Sci. China Math. 2017, arXiv:1701.00868 — `Γ∈L^∞_tL^p_x`, `p<∞`.
- Pan–Li, Bull. Sci. Math. 2020, arXiv:1908.11591 — sublinear growth `α<1` optimal.
- Lei–Ren–Zhang, arXiv:1911.01571 — `ℝ²×T¹` / periodic-`z`.
- Ancient periodic axisymmetric, arXiv:1902.11229 — `Γ` bounded + `z`-periodic ⇒ `v≡c\,e_z`.
- Pan–Zhang review, arXiv:2101.04905.
- Structure (Γ, Ω, Biot–Savart): Lei–Zhang arXiv:1011.5066; Hou–Li arXiv:2107.06509;
  Gallay–Šverák arXiv:1510.01036 (see `docs/ns048_axisym_swirl_attack.md` §7).

---

## 7. Flagged / not primary-verified

1. **`G=∂_zΓ` equation** (§2) — derived here by differentiating the verified `Γ` equation in `z`
   (`∂_z` commutes with the `r`-only-coefficient operator `L_Γ`); elementary, but it is my derivation,
   not a quoted result. The qualitative conclusion (the `−(∂_z b)·∇Γ` coupling has no sign) is robust.
2. **Vacuity of strict `∂_zΓ≤0`** (§2, §4) — argued, not proved: I claim the strict monotone class is
   plausibly empty among genuinely-3D bounded ancient solutions (only `∂_zΓ≡0` sustains the sign). Not a
   theorem; a structural expectation. Default not established.
3. **Columnar `∂_zΓ≡0` ⇒ trivial** (§4) — the reduction is standard (sourceless `Ω` ⇒ no-swirl KNSS;
   heat-type `Γ` ⇒ constant ⇒ 0), but I did not locate a paper stating the `z`-independent case verbatim;
   it is covered a fortiori by the periodic-`z` results. Treat as known/folklore, not a new claim.
4. **One-sided non-bootstrapping** (§3) — the assertion that `Ω≤C` does not close is a
   non-exhaustiveness statement (no closing path is visible), not a proof that none exists.
