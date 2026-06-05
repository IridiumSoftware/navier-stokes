# Triad-witness brief — NS-013 obstruction-map (complex⇏real)

**To:** Grok (edge-witness Φ) and Gemini (synthesis). **From:** Aaron + Claude (metabolism).
**Date:** 2026-06-04. **Repo:** navier-stokes obstruction program.

**Your job is to REFUTE, not endorse.** Validators (you, and Claude's own endorsements) tend to pass
plausible arguments uniformly. We have explicitly seen this fail in this program. So: assume the
argument below is *wrong somewhere* and find where. A bare "this is sound / elegant" is useless — we
want the strongest counter, the hidden assumption, the place an assertion is wearing an argument's
clothes. Default to "refuted / not established" unless you cannot break it.

**Firewall (do not cross, and flag us if WE cross it):** this is an *obstruction-map* about a famous
open problem (does complex-data NS blowup inform real-data regularity?). It claims **no** PDE
regularity-or-blowup result. `:proved`=0. If any part reads as a step toward the Clay prize, that is
over-reach and you must call it.

---

## The claim under witness (NS-013 obstruction-map)

**Background.** Li–Sinai (2008) *proved* finite-time blowup for 3D NS with **complex** initial data
(an RG fixed point). NS-013 asks: does this inform the **real-data** regularity problem? Open;
no implication real⇐complex is established.

**The argument (4 steps):**
1. **Li–Sinai's engine is the absence of the energy bound.** For complex `u`, `∫|u|²` is not real/
   positive; the Leray energy inequality (NS-003) does not bind. The blowup construction lives in a
   regime with **no global coercive control**.
2. **Reality = the energy bound + conjugate-pair symmetry.** Real `u(x)∈ℝ³` ⟺ `û(−k)=conj(û(k))`,
   under which `∫|u|² = Σ|û|² ≥ 0` (so reality *is* the coercive control), and complex singularities
   come in conjugate pairs (real blowup needs a *pair* to hit the axis simultaneously).
3. **So complex⇏real is VACUOUS:** the very mechanism of the complex construction (escape from the
   energy constraint) is exactly what reality removes. Li–Sinai lives in a regime the real problem
   never enters; it is not a rung toward the real prize.
4. **The only genuine content is protective, and it is the prize:** "reality keeps the conjugate pair
   off the axis" is a *regularity* statement; but the control reality supplies (energy) is
   **supercritical** (NS-002) — it doesn't reach small scales. So it reduces to the bounded-enstrophy
   rung (NS-036, the criticality–Casimir hinge): *can `∫|ω|²` be bounded a priori?* — the open problem.

**Net:** NS-013 splits into a vacuous half (complex⇏real) and the prize (real-regularity ⟺ the
NS-002/036 enstrophy wall). Li–Sinai is *not* a shortcut.

**Corroboration (in models only — scoped truncation, NOT the PDE):** a "reality-leakage" ladder —
complex data + a damping `−iλ·Im` (λ→∞ forces real) — across viscous Burgers / inviscid CLM / 2D NS
/ 3D NS. Result: every model **with** a coercive control protects (finite threshold λ_c); CLM (pure
stretching, **no** control) never does; and at matched viscosity λ_c rises monotonically with
dimension / decreasing criticality (1D 0.05 < 2D 0.1 < 3D 0.5) — 3D hardest because supercritical.
**Caveat:** finite truncations are regular *anyway*, so this is mechanism-mapping in models, not PDE
evidence.

---

## Pre-registered witness questions (answer each; try to break it)

**Q1 (the load-bearing one — for Grok edge-Φ).** Is the absence of a real⇐complex implication
**argued or merely asserted**? Step 3 says "complex⇏real is vacuous." But absence-of-implication is
not itself proved. **Is there a clever real⇐complex implication the map misses** — e.g., a way the
complex blowup *does* constrain real data (a partial-regularity transfer, a measure-theoretic or
analyticity argument, a real solution shadowing a complex one)? Find the strongest candidate, or
state precisely why none exists.

**Q2 (tightness — for Gemini synthesis).** Is the reduction "reality ⟹ (only) the energy bound ⟹
supercritical ⟹ the NS-036 enstrophy rung" **tight or loose**? Specifically: (a) does reality supply
*only* the energy bound, or also exploitable structure from the conjugate-pair symmetry that the map
undervalues? (b) Is "energy is supercritical ⟹ reality can't protect at small scales" airtight, or is
there slack (e.g., the conjugate-pair constraint adding scale-information beyond energy)?

**Q3 (over-reach check — both).** Where, if anywhere, does the write-up (or the ladder's "criticality
gradient") drift toward sounding like progress on real 3D-NS? The ladder is truncation-scoped — is
that caveat honestly load-bearing, or is the gradient being oversold?

**Q4 (the ladder's validity).** Does the reality-leakage `−iλ·Im` operator actually test what we
claim (the role of the coercive control), or is the result partly **definitional** (λ→∞ *is* the real
solution, so of course its fate is the real fate)? Is the *monotone λ_c gradient at matched ν* a real
signal or an artifact of IC/N/ν tuning?

Return: per-question verdict (refuted / holds-under-attack / can't-decide-here) with the specific
reasoning. If you converge with the other seat, say so explicitly — and we will still treat a
convergence as "broad/generic" until it survives a witnessed adversarial pass (cf. NS-024).
