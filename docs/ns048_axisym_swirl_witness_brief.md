# Adversarial witness brief — axisymmetric-with-swirl ancient Liouville attack

**You are an adversarial referee. Your job is to REFUTE.** Default verdict for every claim below is
**"NOT established."** Promote a claim to "correct" only if you cannot find an error, an over-reach, a
hidden assumption, a vacuity, or a missed alternative after genuinely trying. Be especially hostile to
(i) mathematical/sign/scaling errors, (ii) claims of "the difficulty is X" or "no approach works"
(over-reach), and (iii) claims that several arguments "converge" / "independently confirm" the same
thing — test whether they are genuinely independent or one observation restated.

This brief is **self-contained**: everything you need is below. Do not assume the author is right.

---

## 0. Background (the setting — all standard, assume given)

3D incompressible Navier–Stokes, **axisymmetric** velocity in cylindrical coordinates `(r,θ,z)`,
components `θ`-independent: `u = u^r e_r + u^θ e_θ + u^z e_z`. Meridional field `b = u^r e_r + u^z e_z`,
`∇·b = ∂_r u^r + u^r/r + ∂_z u^z = 0`. Viscosity `ν>0`.

A **bounded mild ancient solution** is a solution on `ℝ³×(−∞,0]`, bounded (`sup_{t≤0}‖u(t)‖_∞<∞`),
satisfying the integral (mild) form. **KNSS conjecture:** every such solution is constant. **Known:**
true without swirl (`u^θ≡0`); true with swirl only under extra hypotheses — `Γ=ru^θ ∈ L^∞_t L^p_x`,
`1≤p<∞` (Lei–Zhang–Zhao); sublinear growth `|u|≤Cr^α`, `α<1` optimal (Pan–Li); or on `ℝ²×T¹`
(compact/periodic axis, Lei–Ren–Zhang). The **bare conjecture on ℝ³ with swirl is OPEN.**

**Verified structural equations** (you may trust these — they are textbook; check the *use* of them):
- Swirl `Γ=ru^θ`: `∂_tΓ + b·∇Γ = ν(∂_r² − (1/r)∂_r + ∂_z²)Γ`. **No source term** ⇒ maximum & minimum
  principles; `‖Γ(t)‖_∞` non-increasing in `t`.
- `Ω := ω^θ/r` (`ω^θ` = azimuthal vorticity): `∂_tΩ + b·∇Ω = ν(∂_r² + (3/r)∂_r + ∂_z²)Ω + S`, where the
  **only production** is `S = (1/r⁴)∂_z(Γ²) = (2Γ/r⁴)∂_zΓ`.
- Biot–Savart: `−(∂_r² + (1/r)∂_r − 1/r² + ∂_z²)ψ = ω^θ`, `u^r=−∂_zψ`, `u^z=(1/r)∂_r(rψ)`. So
  `(u^r,u^z) ← ω^θ = rΩ`.
- Near the axis, smoothness forces `u^θ=O(r)`, hence `Γ=ru^θ=O(r²)` as `r→0`.

---

## 1. The claims to refute

**C1 (reduction).** With-swirl ancient Liouville is equivalent to controlling the single source `S` in
the `Ω` equation: if `Γ≡0` then `S≡0`, `Ω` is a sourceless drift-diffusion (no-swirl case, known
trivial), so the entire with-swirl difficulty is the term `S`.

**C2 (the wall is at axial infinity, not the axis).** The factor `1/r⁴` looks singular at the axis but is
NOT the obstruction for smooth flows: since `Γ=O(r²)`, `S=(2Γ/r⁴)∂_zΓ = O(r²·r²/r⁴)=O(1)` as `r→0` — the
source is bounded at the axis. Moreover at large `r` with `|u^θ|` bounded (`Γ=O(r)`),
`S=O(r·∂_zΓ/r⁴)=O(1/r²)·∂_zΓ`, which decays in `r`. Hence the source is tame at both `r→0` and `r→∞`,
and the obstruction is the **non-compact axial direction `z→±∞`**, where the production `∂_z(Γ²)` has no
decay or compactness under boundedness alone.
   - *Sub-claim to check (scaling, heuristic):* in an `L¹` sense `∬|S| r\,dr\,dz ∼ ∬(1/r)\,dr\,dz`
     diverges logarithmically in `r` and linearly in `z` — so `z` is the dominant divergence.

**C3 (maximum principle gives temporal, not spatial, control).** `‖Γ(t)‖_∞` non-increasing gives a
temporal envelope but NOT spatial decay of `Γ(·,t)` at fixed `t`; on non-compact `ℝ³` the supremum need
not be attained (the max point can escape to infinity), so the strong maximum principle has no interior
extremum to exploit. This is claimed to be exactly why Lei–Ren–Zhang compactify the axis to `T¹`.

**C4 (no soft step beyond the frontier).** There is no "just-beyond" restricted class that is genuinely
easier than the bare conjecture: each known axis is at its endpoint (`L^p` at `p<∞`, the `p=∞` endpoint
being ≈ the bare conjecture; `α<1` optimal with linear-growth counterexamples; `T¹` whose removal IS the
conjecture). So the "most tractable restricted target" collapses onto the open conjecture with only a
thin decay/compactness collar.

**C5 (one-signed swirl is preserved but useless).** `Γ≥0` is dynamically preserved (sourceless `Γ`
equation ⇒ min principle) and non-vacuous, but does NOT sign `S=(2Γ/r⁴)∂_zΓ` (since `∂_zΓ` is free).

**C6 (the signing monotonicity is not preserved).** To sign `S` one needs `∂_zΓ` one-signed (e.g.
`∂_zΓ≤0`). But `G:=∂_zΓ` satisfies
`∂_tG + b·∇G = νL_ΓG − [(∂_zu^r)∂_rΓ + (∂_zu^z)G]` (`L_Γ=∂_r²−(1/r)∂_r+∂_z²`), whose bracket — a no-sign
zeroth-order term `−(∂_zu^z)G` plus a no-sign source `−(∂_zu^r)∂_rΓ` — destroys any maximum principle for
`G`. So `∂_zΓ≤0` is NOT dynamically preserved, is artificial, and is **plausibly vacuous** among
genuinely-3D bounded ancient solutions.

**C7 (signed source ⇒ only one-sided control).** Even granting `S≤0`, `Ω` is only a **subsolution** of
the homogeneous parabolic operator, so the maximum principle bounds `Ω` from above only — never forces
`Ω≡0` (which would need control from both sides). A one-sided bound `Ω≤C` is claimed NOT to bootstrap to
triviality via Biot–Savart + `Γ`-transport (no closing path visible).

**C8 (only the degenerate case closes).** The sole sub-case where the sign route closes is `∂_zΓ≡0`
(columnar / `z`-independent swirl): then `S≡0`, `Ω` is sourceless ⇒ trivial, and `Γ` solves a heat-type
equation ⇒ constant ⇒ (axis-boundedness) `Γ≡0`. This is essentially the already-known periodic-in-`z`
reduction, hence not new.

**C9 (the META-claim — convergence).** Three structurally different session-scale attacks — (a) an
energy/Caccioppoli estimate, (b) the `Γ` maximum principle, (c) the swirl sign condition — all
**independently** identify the SAME irreducible difficulty: the `z`-dependence of the swirl (`∂_zΓ`),
equivalently the production `∂_z(Γ²)` in the non-compact axial direction. This convergence is claimed to
be robust corroboration that the wall is correctly localized.

---

## 2. What to return

For EACH of C1–C9: a verdict in {REFUTED, NOT ESTABLISHED, CORRECT-AS-STATED}, with the specific error /
over-reach / hidden assumption / counterexample / missed path you found, or — if you genuinely cannot
break it — why. Be concrete; cite the exact step.

**Highest-priority targets for refutation:**
- **C9** — are (a),(b),(c) genuinely independent, or are they one observation (the source is `∂_z(Γ²)`
  and `z` is non-compact) restated three times in different vocabulary? If the latter, "three convergent
  independent attacks" is over-reach (echo, not corroboration). This is the claim most likely to be
  inflated.
- **C7** — is the one-sided bound *really* a dead end? Try hard to CLOSE it: can `Ω≤C` plus `Γ≥0` plus
  Biot–Savart plus the `Γ`-transport be bootstrapped to `Ω≡0` or to a contradiction? If you find a
  closing path, C7 (and "no theorem") is refuted.
- **C2** — is the axis really irrelevant? Check whether the `1/r` weights elsewhere (the `(3/r)∂_r` in
  the `Ω` operator; the `1/r²` in Biot–Savart) re-introduce axis sensitivity that C2 ignores. Verify the
  `r→0` and `r→∞` scalings and the C2 sub-claim divergence.
- **C4 / C6** — are these over-reaching negatives? For C4, exhibit a soft restricted class strictly
  easier than the conjecture if one exists. For C6, is "plausibly vacuous" justified, or could a
  nontrivial 3D bounded ancient solution sustain one-signed `∂_zΓ`?
- **C8** — verify the columnar reduction is actually valid (does sourceless `Ω` + bounded ancient really
  force triviality, and does the heat-type `Γ` argument hold on the degenerate domain?).

Also: flag any place where a step, if correct, would prove the FULL KNSS conjecture — that would mean the
step is wrong (the conjecture is open).

---

## 3. Internal pre-screen outcome (2026-06-07) — verify or challenge; then hunt for what it MISSED

An internal adversarial pre-screen (three independent reviewers) was run before this external relay. Its
findings are below. **Your job is NOT to rubber-stamp them — verify each independently, challenge any you
think wrong, and especially find over-reaches the pre-screen did NOT catch.** (The pre-screen was a
same-model check; it is structurally prone to confirmation bias, so an independent model is exactly the
value here.)

- **Math (C2 scalings, C6 `G`-equation, C7 subsolution sign, C8 columnar reduction): found CORRECT.**
  Re-derive at least one yourself and confirm or refute. (Two presentational notes were adopted: C6's
  decisive non-preservation term is the *inhomogeneity* `−(∂_zu^r)∂_rΓ`, not the zeroth-order
  `−(∂_zu^z)G`; C8's columnar closure is cleanest via `u₁=Γ/r²` → non-degenerate 4-D radial heat ⇒
  bounded ancient caloric ⇒ constant.)
- **C4 ("no soft step beyond the frontier"): REFUTED → corrected.** `ℝ²×T¹` is itself a proven
  intermediate class (the original claim was self-contradictory); plausibly-tractable softer classes also
  exist (weak-`L^p`/Lorentz swirl; small-swirl perturbing the complete swirl-free KNSS proof). *Challenge:
  are the weak-`L^p` and small-swirl closures actually plausible, or did the pre-screen over-claim those
  too?*
- **C9 ("three independent convergent attacks"): OVER-REACH → corrected to ~1.5 independent + echo.**
  The energy attack (a) and the sign attack (c) act on the *same* term `S`; only the max-principle (b) is
  near-distinct; plus a selection effect and re-derivation of known structure. *Challenge: is even "~1.5"
  too generous — is (b) also just the same obstruction in disguise? Or, conversely, is there genuine
  independence the pre-screen dismissed?*
- **C2's "NOT the axis" clause: OVER-REACH → corrected** to "the *source* is benign at `r=0`, not 'the
  axis is irrelevant.'"
- **C7 (one-sided control does not close): SURVIVED.** The sign is on the source `S`, not on `Ω`, so `Ω`
  is non-sign-definite and no parabolic Liouville theorem applies; the 5-D-Laplacian structure is real
  but insufficient. *A crack was noted: adding `ω^θ` one-signed (a strictly stronger hypothesis) does
  close. Try harder to close C7 under the ORIGINAL hypothesis (sign on `S` only).*
- **C6 vacuity ("plausibly vacuous"): SURVIVED** (hedged; no genuinely-3D counterexample found, structural
  pressure toward columnar). *Try to construct a counterexample.*

Report, for each: AGREE / DISAGREE-(with reason) + any NEW over-reach or error.
