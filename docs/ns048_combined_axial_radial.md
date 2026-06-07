# NS-048 — the "combined axial+radial" conjecture: formulation + why it collapses

**Date:** 2026-06-07. **ANALYSIS. NO theorem.** `:proved`=0; distance UNTOUCHED; NS-048 unchanged.
Default "not established." Examines the live conjecture proposed by route (i) / the port doc — *a complete
closing condition needs an axial (`|x₃|^α`) **and** a radial (LZZ-type) control combined.* **Outcome: the
combined conjecture collapses** — it is redundant where the radial half is strong, and stuck on
pre-existing open problems where it is weak. This **retires the "needs combined" framing as
over-optimistic (15th honesty-ledger item)** and refocuses on the genuine frontier. Citation tiers in §6.

---

## 1. The conjecture (precise)

> A bounded mild ancient axisymmetric solution with **axial** swirl control `‖|x₃|^α u^θ‖_{crit}<∞`
> **and** a **radial** swirl control (some decay of `u^θ`/`Γ` in `r`) is constant.

Motivation (route (i) §6, port §6): the source `S=(2Γ/r⁴)∂_zΓ` has **two tails** — a dominant `z`-tail
(killed by the axial condition) and a borderline `r`-tail. The hope: kill both ⇒ control `S` ⇒ close.

---

## 2. Scaling: any radial decay `β>0` already kills the `r`-tail (self-derived)

Take `u^θ ≲ r^{−β}|z|^{−α}` (radial decay rate `β`, axial rate `α`). Then `Γ=ru^θ ≲ r^{1−β}|z|^{−α}`,
`Γ² ≲ r^{2−2β}|z|^{−2α}`, `∂_z(Γ²) ≲ r^{2−2β}|z|^{−2α−1}`, and
$$S=\frac{1}{r^4}\partial_z(\Gamma^2) \ \lesssim\ r^{-2-2\beta}\,|z|^{-2\alpha-1}.$$
Against the axisymmetric volume `r\,dr\,dz`:
$$\iint |S|\,r\,dr\,dz \ \lesssim\ \Big(\!\int |z|^{-2\alpha-1}dz\Big)\Big(\!\int r^{-1-2\beta}\,dr\Big),$$
which **converges in `r` for every `β>0`** (and in `z` for `α>0`). So **any** radial decay — however weak —
kills the `r`-tail; the axial condition kills the `z`-tail; together `∫|S|<∞`. This is exactly the
"two-tail" picture made quantitative.

**But two things make this NOT a clean closing condition** — §3 (strong radial: redundant) and §4 (weak
radial: stuck).

---

## 3. Strong radial ⇒ REDUNDANT (the radial half closes *alone*) — C3

If the radial control is strong enough to be a *named* condition, it already closes the problem by itself,
**with no axial input** (both line-verified C3 this campaign):

- **`Γ=ru^θ ∈ L^∞_tL^p_x`, `p<∞` (LZZ):** ⇒ constant. *Alone.* (arXiv:1701.00868, C3.)
- **`|u| ≤ C/r` (full velocity, KNSS Thm 5.3):** ⇒ `u≡0`. *Alone.* (arXiv:0709.3599, C3.)

Moreover the closing *machinery* itself (the blow-down, route (i)) needs **radial** decay of `Γ`
(`Γ_λ=Γ(λx,λ²t)→0` requires `Γ` to decay in `r`); once that radial decay is present, the blow-down
closes — the axial condition is never invoked. **So whenever the radial half is strong enough to help, it
is strong enough to finish; the axial condition adds nothing.** The combined conjecture is redundant here.

---

## 4. Weak radial ⇒ STUCK on two pre-existing open problems (no new closure) — robust to Pan–Li's scope

The only non-redundant niche is **weak radial decay** — `u^θ ≲ r^{−β}` with `0<β<1` (so `Γ ≲ r^{1−β}`
*grows* sublinearly), or swirl-only radial decay without meridional-velocity decay (so KNSS Thm 5.3 does
not apply). There the combined condition gives `∫|S|<∞` (§2) but does **not** close, because:

1. **`∫|S|<∞` is not a known closing mechanism.** Controlling the source's `L¹` norm is the *`S`-control
   route* — which the verification campaign showed is **a road not taken**: every known closer bypasses
   `S` by forcing `Γ`-decay, never by estimating `S` (C3 for LZZ, LRZ, Thm 3.7). No argument takes
   `∫|S|<∞` (or any source bound) to the Liouville conclusion. The combined condition delivers the wrong
   kind of object.
2. **The weak-radial regime's *solo* status is itself open / verification-dependent, and EITHER WAY the
   combined adds nothing.** The relevant result is Pan–Li (sublinear-growth Liouville, **C2** via review,
   scope-uncertain — possibly steady-`D`-solution rather than ancient; a verification target). The robust
   dichotomy:
   - *If* Pan–Li (or a successor) closes the weak-radial regime **alone**, the combined is **redundant
     there too** (radial alone closes — §3 logic extends).
   - *If* it does **not**, the weak-radial regime is **open**, and the combined condition — yielding only
     `∫|S|<∞` — does **not** close it (no `S`-control mechanism, point 1).
   Either branch: **the combined condition is not a new closing condition.**

---

## 5. Verdict — the combined direction is retired

**No theorem; `:proved`=0.** The "combined axial+radial" conjecture does not yield a new ancient-Liouville
closer:

- **Strong radial:** redundant — the radial half (LZZ `L^p`, or KNSS `|u|≤C/r`) closes alone; the axial
  condition is never the binding constraint (§3, C3).
- **Weak radial:** stuck — the combined condition gives `∫|S|<∞`, which is the unexplored `S`-control
  route (no known mechanism), and the regime's solo status is open either way (§4).

So route (i)'s / the port doc's *"a complete closer likely needs axial + radial combined"* was
**over-optimistic — the 15th honesty-ledger item, caught by working the scaling through.** The axial
condition never becomes load-bearing: radial decay sufficient to feed the closing machinery already
finishes, and radial decay insufficient to finish leaves a problem the axial condition cannot reach.

**The genuine open frontier is unchanged by this:** the *bare* conjecture (`Γ∈L^∞`, no radial decay —
KNSS-with-swirl), or a **new idea for the `S`-control route** (which controlling `∫|S|` does not supply).
NS-048's session-scale sub-questions are now exhausted: every concrete attack (energy, max-principle,
sign, blow-down, axial port, combined) reduces to one of these two genuinely-open cores.

*(Honesty ledger, NS-048 arc: 7th geometry-re-tasking · 8th manufactured-theorem-declined · 9th
sign-shortcut · 10th "no soft step" · 11th "three independent convergent" · 12th weak-`L^p`-in-correction ·
13th "incomparable"-declined · 14th "route (i) sidesteps radial tail" · **15th "needs axial+radial
combined"**.)*

---

## 6. Refocus + citation tiers

**What is *actually* next (honest):** not "combined." Two options, both real:
- **(a) Verify Pan–Li at primary (C2→C3)** to pin whether the sublinear-radial-growth regime closes alone
  — this either absorbs more of the conjecture into "redundant" or sharpens the open weak-radial gap. A
  bounded verification task (extends the audit).
- **(b) The `S`-control route's viability** is the one genuinely-unexplored direction — but it has **no
  known mechanism** (campaign: everyone bypasses `S`), so it needs a new analytic idea, not a session task.
The disciplined reading: **NS-048's tractable session-scale attacks are exhausted;** the residue is the
bare conjecture + the un-mechanised `S`-control route — both needing ideas the program does not have.

**Citation tiers (C0–C5):**
- **LZZ `L^p`** (arXiv:1701.00868): **C3** — closes alone (§3).
- **KNSS Thm 5.3** `|u|≤C/r` (arXiv:0709.3599): **C3** — closes alone (§3).
- **"every closer bypasses `S`"** (LZZ/LRZ/Thm 3.7): **C3** — the §4.1 no-`S`-mechanism fact.
- **Pan–Li sublinear-growth Liouville**: **C2** (review only; *scope uncertain — ancient vs steady-`D`*;
  the §4 verdict is **robust to this**, but a primary read would sharpen the weak-radial niche).
- **Self-derived (no citation):** the §2 two-tail scaling; the redundancy/dichotomy logic.
