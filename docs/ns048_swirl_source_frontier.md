# NS-048 — the swirl-source closing problem: precise formulation + positioning

**Date:** 2026-06-07. **FORMULATION / POSITIONING artifact. NO theorem.** `:proved`=0; distance
UNTOUCHED; NS-048 unchanged. This sharpens the open problem the external witness triad crystallized
(`docs/ns048_axisym_swirl_witness_verdict.md` §3a) into a precisely-posed, literature-positioned research
target — and, on the way, **corrects the framing of that target** using a line-by-line reading of how the
known with-swirl results actually work.

**The witnesses' target (verbatim):** *find a weighted space `X` on `ℝ³` such that (1) boundedness in `X`
is strictly weaker than KNSS, and (2) it forces decay of `∂_zΓ` enough to close the estimate on the
source `S=(2Γ/r⁴)∂_zΓ` — or prove no such `X` exists.*

**The correction this note makes:** "close `S`" is a strategy **no known result uses** — every known
with-swirl ancient-Liouville theorem closes by forcing **`Γ` itself to decay/vanish** and reducing to the
swirl-free case, *bypassing* `S`. So the witnesses' target is a **road not taken**, not a weakening of the
existing road. And "strictly weaker than KNSS" is **not yet justified** — the comparison between an
`S`-route condition and the known `Γ`-decay conditions is genuinely open (the columnar case cuts against a
naive "incomparable," see §5). The honest target is reframed accordingly.

---

## 1. The two horns (restated)

- **Horn A:** exhibit a condition (on `∂_zΓ`, or anisotropic/weighted in `z`) under which the with-swirl
  ancient Liouville theorem holds *by controlling the source `S` directly* — and determine how it relates
  to the known `Γ`-decay conditions.
- **Horn B:** show no such condition genuinely helps — e.g. any control strong enough to close `S` already
  forces `Γ`-decay (collapsing the `S`-route into the known route) or already forces the full conclusion.

---

## 2. VERIFIED — how the known with-swirl results actually close (none of them touch `S`)

Read line-by-line from the primary PDFs (LZZ §5; review §3):

- **Lei–Zhang–Zhao (arXiv:1701.00868), `Γ∈L^∞_tL^p_x`, `p<∞`:** the proof runs **entirely on the
  source-free `Γ` equation** `∂_tΓ+b·∇Γ+(2/r)∂_rΓ−ΔΓ=0`. (i) De Giorgi–Nash–Moser iteration on it gives a
  mean-value bound `sup_{Q_{1/2}}|Γ|≤C(∫_{Q_1}|Γ|^p)^{1/p}`; (ii) `L^p` is then used **purely
  geometrically** — axisymmetry packs `≈r` disjoint unit balls around the circle of radius `r`, so
  `∫_{B_1}|Γ|^p ≤ r^{−1}‖Γ‖^p_{L^∞_tL^p}`, giving **radial decay `|Γ|≤Cr^{−1/p}→0`**; (iii) the maximum
  principle + a blow-down force `Γ≡0`, i.e. swirl-free, and the **swirl-free reduction (KNSS)** finishes.
  **`Ω`, `ω^θ`, `S`, and `∂_zΓ` never appear.** The `L^p` hypothesis is *lossy*: its only job is to force
  uniform radial decay of `Γ` (the true sufficient input, LZZ Remark 1.4: `lim Γ=0` uniformly).
- **Lei–Ren–Zhang (`ℝ²×T¹`):** `Γ` bounded + **`z`-periodic** ⇒ `v≡c e_z`. Closes by a DGNM Hölder
  estimate forcing `Γ≡0`, with `z`-periodicity + `∇·b=0` supplying the critical-scaling control. *(Read
  via the review, not the primary — flagged.)*
- **Thm 3.7 (the weakest non-periodic frontier):** `Γ` bounded + a **small radial-oscillation** condition
  `|Γ²−limsup_{r→∞}Γ²|≤(ε₀/r)limsup Γ²`, via a weighted-energy estimate. *(Review only — flagged.)*

**Pattern (verified — now C3 for all three closers, 2026-06-07):** every known with-swirl closer is a
condition **on `Γ`** (radial decay, `z`-periodicity, small radial oscillation) that **kills `Γ` → reduces
to swirl-free**. **None controls the source `S`; none is phrased on `∂_zΓ`.** All three —
Lei–Zhang–Zhao, Lei–Ren–Zhang (ℝ²×T¹), Thm 3.7 — were line-read at primary
(`docs/citation_verification_round3_2026-06-07.md`); the earlier C1 hedge on "every" is **lifted**, the
"road not taken" strengthened.

---

## 3. Consequence — the `S`-route is a road not taken

The witnesses' "control `∂_zΓ` to close `S`" is therefore **not a weakening of the LZZ road — it is a
different road.** LZZ et al. never estimate `S`; they remove `Γ`. A theorem that instead *controls `S`
directly* (leaving `Γ` possibly large) would be a **structurally new type of argument** for the ancient
Liouville problem. This is the genuine content of the open problem, sharper than "find a weighted space":

> Is the *source-control* strategy (bound `S` via `∂_zΓ`, without forcing `Γ`-decay) viable for ancient
> Liouville at all — or does every route necessarily go through killing `Γ`?

---

## 4. The available machinery — exists, but untransferred

The objects needed to even *state* an `∂_zΓ`/anisotropic-`z` condition exist — but only in the
**finite-time regularity** literature, never deployed for ancient Liouville:

- **`J:=−∂_zv^θ/r`** (Chen–Fang–Zhang; Lei–Zhang "Criticality" arXiv:1505.02628): the source written in
  `(Ω,J)` form is `−2(v^θ/r)J`, exactly `S`. But their closing hypothesis is a **form-boundedness
  condition on `v^θ`** (Hardy-type), not on `J`/`∂_zΓ`.
- **Anisotropic-`z` swirl conditions** (Yu: `|x₃|u^θ∈L^∞` small; Chen–Fang–Zhang: `|x₃|^α u^θ` in
  mixed-norm `L^{p₃}_{x₃}L^{p₂}_{x₂}L^{p₁}_{x₁}`): these **do** weight the axial direction specially —
  but they are conditions on the swirl **component `u^θ`**, are **finite-time regularity criteria**, and
  are **not on `∂_zΓ`**.

So the `z`-anisotropic / swirl-derivative toolkit is real and the natural raw material for Horn A — it has
simply never been pointed at the ancient-solution problem.

---

## 5. Positioning the horns honestly (and a 13th over-reach declined)

- **"Strictly weaker than KNSS" is not justified — the comparison is OPEN.** A tempting move is to call an
  `S`-route condition *incomparable* to the `Γ`-decay conditions (different quantities: `∂_zΓ` vs radial
  decay of `Γ`). **I decline that as a fresh over-reach.** The columnar case cuts against it: `∂_zΓ≡0 ⇒
  S≡0`, and there (C8) the *full dynamics* force `Γ≡0` — i.e. controlling `S` to zero *does* end up forcing
  `Γ`-decay through the coupled system. So `S`-control and `Γ`-decay are **not obviously independent**;
  whether an `S`-route condition is weaker, stronger, or incomparable to the `Γ`-decay conditions is
  **genuinely open**. Horn A's "strictly weaker" should read "of *unknown* strength relative to the known
  conditions."
- **Horn B has no equivalence theorem, only hardness remarks (verified).** The review (arXiv:2101.04905)
  notes studying the `Γ` equation "in isolation is likely to fail" (a counterexample *without* `∇·b=0`)
  and that the bounded-swirl ancient problem "contains [the homogeneous `D`-solution `=0` question] as a
  special case" — a **reduction/hardness** statement (the problem is *at least as hard* as another open
  one), **not** an equivalence. So Horn B is not settled either; the `S`-route is not known to be
  redundant.

---

## 6. The cleanest concrete entry sub-question

Not a session task, but a **bounded** first step that uses existing machinery rather than inventing it:

> **Port the finite-time anisotropic-`z` swirl conditions (Yu's `|x₃|u^θ` smallness; Chen–Fang–Zhang's
> `|x₃|^α u^θ` mixed-norm) to the ancient-solution setting** — i.e. ask whether a bounded mild ancient
> axisymmetric solution with `|z|^α u^θ` controlled (anisotropically in `z`) is constant.

This is the most direct test of whether the `z`-anisotropic toolkit transfers from regularity to ancient
Liouville, and whether it routes through `S`-control or collapses back to `Γ`-decay (informing Horn A vs
B). It is concrete, has a clear precedent to adapt, and does not require a new gadget.

---

## 7. Verdict

**Both horns open; `:proved`=0.** The genuine contribution of this pass is the **reframing**, grounded in
the verified LZZ mechanism:

1. The known with-swirl closers all work by **forcing `Γ`-decay → swirl-free reduction**, *bypassing* the
   source `S` (verified line-by-line). The witnesses' "close `S` via `∂_zΓ`" is a **road not taken**, not a
   weakening of the known road.
2. "Strictly weaker than KNSS" is **unjustified** — the comparison between an `S`-route condition and the
   `Γ`-decay conditions is open (the columnar case suggests `S`-control may force `Γ`-decay, not be
   independent of it). The naive "incomparable" claim is declined (13th over-reach, caught here).
3. The `z`-anisotropic / `∂_z`-swirl machinery (`J`, `|x₃|^α u^θ`) **exists but is untransferred** from
   finite-time regularity to ancient Liouville — the natural raw material for Horn A.
4. **Cleanest entry:** port the anisotropic-`z` swirl conditions to the ancient setting (§6).

**[EXECUTED — annotation 2026-06-12; this §7 pointer was stale and misled a later session's planning.]**
Item 4 (the port) was carried out the same day and the whole thread run to exhaustion:
`docs/ns048_anisotropic_z_port.md` (the port — a genuine NEW conjecture; the finite-time proof does NOT
transfer: Gronwall-anchored-to-data + finite-`T` continuation, both vacuous on `(−∞,0]`; attribution
corrected — the `|x₃|^α` conditions are **Yu / Wang–Huang–Wei–Yu**, not CFZ, whose criteria are radial) →
`docs/ns048_route_i_blowdown.md` (route (i) attempted: **broken** — the blow-down amplifies `Γ`'s radial
growth `λ^{1−α}` and compactness fails by supercriticality; 14th over-reach corrected) →
`docs/ns048_combined_axial_radial.md` (the combined axial+radial conjecture **collapsed** — redundant where
radial is strong, stuck where weak). **Net standing: the axial-only ancient conjecture is OPEN; the
session-scale attacks are exhausted; what remains is the bare conjecture + the un-mechanised `S`-control
route — genuine analytic undertakings, not session tasks.**

This is a sharpened, defensible problem statement — *not* progress on either horn. The genuine open
question is now: *is source-control a viable ancient-Liouville strategy at all, or does every route reduce
to killing `Γ`?*

---

## 8. Sources + flags

**Verified (read line-by-line via local `pdftotext`):** Lei–Zhang–Zhao arXiv:1701.00868 §5 (the
DGNM-on-source-free-`Γ` + ball-packing + swirl-free-reduction mechanism); review arXiv:2101.04905 §3
(frontier conditions; the "isolation likely fails" + "contains `D`-solution problem" remarks);
Lei–Zhang "Criticality" arXiv:1505.02628 (`J=−∂_zv^θ/r`, the `(Ω,J)` source form, the FBC-on-`v^θ`);
anisotropic Hardy–Sobolev arXiv:2205.13893 (Yu `|x₃|u^θ`; Chen–Fang–Zhang `|x₃|^α u^θ` mixed-norm,
finite-time).

**Flagged / not primary-verified:** Lei–Ren–Zhang (`ℝ²×T¹`) and Thm 3.7's weighted-energy proof — read
**via the review's one-paragraph descriptions, not the primary PDFs**. Pan–Li, Carrillo–Pan–Zhang–Zhao,
Wei — title/abstract only. The **negative finding** ("no ancient-Liouville result on `∂_zΓ`/`S`/anisotropic-`z`")
is an absence within the searched literature, **not** a proof of nonexistence; 2023–2025 preprints
(Pan/Wei/Tsai ancient-solution work) were not exhaustively checked. The columnar `S≡0⇒Γ≡0` claim (§5)
rests on this repo's own C8 reduction (`u₁=Γ/r²`→4-D radial heat Liouville), itself flagged folklore-level
in `docs/ns048_swirl_sign_condition_attack.md` §7.
