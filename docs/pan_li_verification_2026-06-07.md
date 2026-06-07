# Pan–Li verification (last audit thread) — C3, NO-SWIRL; corrects two of our characterizations

**Date:** 2026-06-07. Verifies the Pan–Li "growing-velocity" Liouville result (held at C2, scope-uncertain).
Read line-by-line. **Foundation-hardening, NOT PDE progress; `:proved`=0.** Two corrections to our records;
the combined-conjecture verdict (v0.1.88) is **confirmed and sharpened**.

---

## 1. What Pan–Li actually is (C3, line-read)

**Xinghong Pan & Zijin Li, "Liouville theorem of axially symmetric Navier–Stokes equations with growing
velocity at infinity," Nonlinear Analysis: RWA 56 (2020), art. 103159** (arXiv:1908.11591). *[Venue
corrected: NA:RWA, **not** Bull. Sci. Math. as we'd cited.]*

**Theorem 1.1.** A smooth **no-swirl** (`u^θ≡0`) ancient axisymmetric solution with
`|u^r|+|u^z| ≤ C(√(−t)+|x|)^α` (`α<1`, full distance `|x|=√(r²+z²)`) and `|u^r|+|u^z(t,r,z)−u^z(t,0,z)|≤Cr`
is `u=(0,c(t))`. **Prop 1.5 (`α=1` sharp):** explicit non-constant **no-swirl** linear-growth solutions
`u^r=C₁r`, `u^z=−2C₁z+C₂(t)`. **Mechanism:** `Ω=ω^θ/r` Caccioppoli/`L^q`-energy estimate; `α<1` ⇒
`‖Ω‖_{L^q}=0` ⇒ `ω^θ≡0` ⇒ `∇×u=0` ⇒ harmonic ⇒ Liouville. The swirl source `S` is **structurally absent**
(no swirl).

**Scope puzzle RESOLVED:** Pan–Li does not prove the open KNSS conjecture because it is the **no-swirl**
case (where bounded⇒constant is already KNSS-known), merely extended from *bounded* to *sublinear growth*.
It is **not** "swirl allowed."

---

## 2. The load-bearing answer (confirms + sharpens the combined verdict)

**Does Pan–Li close the weak-radial regime** (bounded mild ancient axisym **with swirl**, `u^θ~r^{−β}`,
`0<β<1`, so `Γ` grows sublinearly)? **NO — it does not even apply.** That regime has *nonzero* swirl;
Pan–Li's hypothesis is `u^θ≡0`. So:

- The weak-radial **with-swirl** regime is **genuinely OPEN** (Pan–Li, the nearest sublinear-growth result,
  is no-swirl). It is **not redundant** via Pan–Li.
- The combined-conjecture verdict (`docs/ns048_combined_axial_radial.md`) therefore **stands and sharpens**:
  in the weak-radial regime the combined condition yields only `∫|S|<∞` (the un-mechanised `S`-control
  route), and that regime is now *pinned* as open — the dichotomy's second branch, confirmed. Combined is
  **not a new closer**.

---

## 3. Two corrections to our records

**(a) Pan–Li is no-swirl** (was characterized "axisym, swirl allowed" via the review — a secondary-source
drift, ~C1). Corrected to **no-swirl, ancient, sublinear-growth, C3**; venue NA:RWA 2020.

**(b) Route (i)'s "axial-only conjecture suspect" basis was wrong — 16th honesty-ledger item.**
`docs/ns048_route_i_blowdown.md` §6 argued the *axial-only* (with-swirl) conjecture is "suspect/possibly
false" because *"Pan–Li make `α=1` the sharp threshold with non-constant counterexamples."* But those
counterexamples are **no-swirl** (Prop 1.5: `u^θ=0`), so they do **not** evidence a *with-swirl* bounded
counterexample. The route-(i) blow-down **break itself stands** (axial decay is orthogonal to the radial
blow-down — self-derived, solid); only the extra "possibly false" claim's Pan–Li support is removed.
**Downgrade:** the axial-only conjecture is **genuinely open / status unknown** (no closer reaches the
`Γ~r`-growth-with-swirl regime, but Pan–Li gives no counterexample there). Corrected in route (i) §6/§8.

---

## 4. Verdict + campaign closure

- **Pan–Li: C2 → C3** (line-read); **no-swirl** sublinear-growth Liouville; NA:RWA 2020.
- **Combined verdict confirmed + sharpened:** weak-radial-with-swirl is open (not redundant via Pan–Li);
  combined ≠ new closer.
- **Route (i) corrected:** the axial-only "suspect" downgraded to "open" (its Pan–Li counterexample link was
  no-swirl — 16th over-reach).
- **The verification campaign is now fully closed** — #1 KNSS, #1b Albritton–Barker, #2 NS-007, #3
  LRZ+Thm3.7, and this Pan–Li thread all at C2/C3, with **four** citation-supply-chain errors caught and
  corrected across the campaign (Albritton–Barker≠Seregin–Šverák; the Type-I "general"→"conditioned" scope;
  the Lemma-6.1 naming; and now Pan–Li "swirl-allowed"→"no-swirl"). `:proved`=0; distance UNTOUCHED.

The NS-048 standing remains: session-scale attacks exhausted; the residue is the **bare conjecture**
(`Γ∈L^∞` with swirl) and the **un-mechanised `S`-control route** — both needing a genuinely new idea.

---

## 5. Sources + flags

**Verified (C3, line-read):** arXiv:1908.11591 (curl + `pdftotext -layout`, v2, 10pp — Thm 1.1, Prop 1.5,
proof §2). **Venue** (NA:RWA 56 (2020) 103159) web-confirmed (ScienceDirect S1468121820300778), C2.
**Flagged:** Prop 1.5's pressure-formula algebra stated "by direct computation," not re-derived (statement
C3, algebra unverified); read v2 (final typeset wording may differ; load-bearing hypotheses stable).
