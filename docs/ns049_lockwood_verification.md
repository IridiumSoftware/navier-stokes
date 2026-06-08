# NS-049 verification — engaging the Lockwood "Singularity Surgery" math

**Date:** 2026-06-07. **An adversarial line-read of Parts I–V** (proof skeletons in II, the final theorem
+ dependency chain in III, the smooth hard-branch closure in IV, the weak-lift/selection reduction in V),
to locate the real difficulty. **Posture caveat:** I am an AI reading unrefereed AI-assisted working
papers; the program's own validator-confirmation-bias discipline applies to *me* — findings below are
where I could not make a step work after genuinely trying, not verdicts. The work is sophisticated and the
conditional content (below) is real. `:proved`=0; nothing here is PDE progress.

---

## 1. The architecture, restated faithfully

A CKN local-contradiction deformation. Branch on the active weighted enstrophy `m_n(ℓ)`: **Case A**
(`m_n→0`, *closed* by a div–curl/energy argument) vs **Case B** (`m_n≥m_*`). In Case B the chain is
(Part IV, eq 104):

> Case B nondegeneracy ⟹ relative perpendicular-defect smallness at `r_*` ⟹ branch-scale **depletion** ⟹
> branch-scale **compactness** (U-prime) ⟹ strict-threshold transfer ⟹ **strict frozen-direction core**
> ⟹ scalar gain ⟹ div–curl bridge ⟹ **two-scale contraction** (the CKN decay).

The advertised remaining work (Part III §J): two pieces — the **CZ Depletion Lemma** and the **strict-core
compactness-rigidity theorem** — "everything else turned into ordinary PDE scaffold." Part V then lifts the
smooth closure to suitable weak solutions via exact biharmonic regularization, reducing the last issue to a
**selection problem** (core-amplitude selection + a harmonic Neumann-trace identification).

---

## 2. Finding 1 (headline) — the central conditionality is on `δ_Λ→0`, and it is *assumed, never derived*; the multi-directional case is unaddressed and is not on the remaining-problem list.

The two-scale contraction (Part III, **Thm 8.1**) is proven only for solutions **`with δ_Λ(0,1) ≤ ε`**, and
the proof's closing line is *"choose ε so that the small-defect hypotheses of the previous theorems are
triggered."* Part IV's **Lemma 3.1** (the step eq 104 compresses to "Case B nondegeneracy ⟹ defect
smallness") does **not** derive defect-vanishing from nondegeneracy: it shows the *relative* defect
`Y_b,n(r_*)/Z_n(r_*) ≤ (ℓM_ω/4m_*)·δ_Λ^{(n)}(0,1) → 0` (eq 21) — using the Case-B lower bound
`Z_n(r_*) ≥ 4m_*/ℓ` (eq 20) to turn *absolute* defect smallness `Y_b≤M_ωδ_Λ` into *relative* smallness — but
the `→0` is still **driven by the external hypothesis `δ_Λ(0,1)→0`**.

So the whole program proves (modulo §3–4 below): **IF the weighted anisotropy defect vanishes along the
blow-up (the intense vorticity becomes asymptotically one-directional at the singular point), THEN no
singularity.** The complementary case — a singular blow-up that keeps `δ_Λ` **bounded below**
(multi-directional intense vorticity) — is **nowhere addressed**, and is not even listed among the remaining
problems. This is a *different and more fundamental* gap than the two advertised lemmas, both of which are
only relevant *inside* the `δ_Λ→0` regime.

**Why this is not a nitpick.** This program's own resolved DNS (NS-038) measures, at the most singular-like
event (Kerr-tube reconnection), vorticity aligned with the **intermediate** strain eigenvector
(`c²_int≈0.72` — the classic HIT signature), in sheet/tube structures — i.e. **not** a single frozen
direction. So the physically indicated intense-vorticity geometry is precisely the **multi-directional
(`δ_Λ` bounded below)** case the machinery does **not** cover. The defect-vanishing hypothesis may be not
just unproven but physically off the relevant regime. (Steelman I could not complete: if `δ_Λ→0` is forced
by the blow-up *construction* — e.g. concentration ⟹ one-directionality — or if the bounded-below case is
separately excludable, the gap closes; I did not find either in the five parts.)

---

## 3. Finding 2 — the depletion lemma is a *sound-but-unfinalized skeleton* (Lockwood's own framing).

The mechanism is genuine and clean: with `ω=a e_3+b` (`b⊥e_3`), the principal strain is a Riesz/CZ operator
on the perpendicular vorticity, `S₃₃=T₁(ηb₁)+T₂(ηb₂)+H₃₃`, so all three stretching pieces (principal
`a²S₃₃`, mixed `2a(Se_3)·b`, quadratic `(Sb)·b`) carry a perpendicular factor and are depleted as `b→0`.
The interpolation arithmetic checks (`3/10+3/10+2/5=1`; `3/10+7/20+7/20=1`), the CZ operators act at
`L^{10/3}` (`1<10/3<∞`, so boundedness is fine — *not* the `L^∞` endpoint trap), and the defect enters via
interpolating `‖χb‖` between `L²` (defect) and `L^{10/3}` (energy). **But it is explicitly a skeleton** —
Lockwood: *"proof blocks that still need to be converted from a proof skeleton into a finalized argument."*
The asserted-not-estimated load-bearing steps: the cutoff **commutators** are called *"harmless"* (CZ
localization commutators are a classic hiding place — needs an estimate), and the **harmonic remainder** is
*"lower-order"* / controlled by *"the `L^∞` norm of `S[h]`"* (plausible by interior estimates for harmonic
`h`, but asserted). Verdict: mechanism **C4-plausible**; finalized estimate **not done** (his admission).

---

## 4. Finding 3 — the strict-core "rigidity" is essentially the defect–alignment *identity*, not a deep theorem.

The defect obeys the exact identity `∫χ|ω×e_max|² = tr(M_Λ) − λ_max(M_Λ) = tr(M_Λ)·δ_Λ` (with
`M_Λ=∫∫χ ω⊗ω`). So `δ_Λ→0` ⟺ weighted-`L²` alignment to the top eigenvector — *by definition*. The
strict-core theorem (Part II §16) then upgrades weighted-`L²` alignment to "`ω=a e_*` a.e. on the active
set" by soft means: mollify (`J_{n,ℓ}=ρ_ℓ*(χω)`), use U-prime strong `L²` compactness to pass smoothed↔raw,
and diagonal-extract `ℓ→0` with `e_n→e_*`. The genuinely non-trivial part is only the *fixed-direction*
extraction; the core (`δ_Λ→0 ⟹ L²` alignment) is definitional. Lockwood agrees in spirit (Part III): *"the
final obstacle is no longer a global regularity miracle; it is the compactness of a very specific active
weighted direction field."* So the program's real content was always **(depletion)** + **(the `δ_Λ→0`
hypothesis)** — the "rigidity" is soft once those hold.

---

## 5. Finding 4 — Part V's "selection problem" is downstream of, and conditional on, `δ_Λ→0`.

Part V's weak-lift (exact biharmonic regularization, `+α∆²u`) and its reduction to the core-amplitude /
Neumann-trace **selection problem** are the last *technical* issues **inside** the `δ_Λ→0` conditional
program (the scalar-core comparison `w=a−ā`, blocked on identifying the admissible trace class). Real and
honestly stated — but it is **not** the resolution of Finding 1; the central conditionality sits upstream
of everything Part V does.

---

## 6. The fair reading (what the program *is*)

Read as an **unconditional** regularity proof, it is incomplete: beyond the two skeleton lemmas there is an
unremoved (and physically suspect) `δ_Λ→0` hypothesis whose complementary case is open — so "Part I corners
the program / only two lemmas remain" **overstates** it. Read as a **conditional anisotropic regularity
criterion** — *"a suitable weak solution whose weighted anisotropy defect vanishes (asymptotically
one-directional intense vorticity) is regular"* — it is a **genuine, plausible contribution** in the
Constantin–Fefferman family, with the notable feature that its one-directionality trigger is a **weighted/
integral** condition, *weaker* than CF's pointwise Lipschitz vorticity-direction. That conditional criterion
(modulo finalizing the depletion estimate) is the honest, citable content. **It is not the Millennium
problem.**

---

## 7. Bridge to this program (and evidence bearing on his hypothesis)

- **Against the `δ_Λ→0` regime:** our NS-038 (intermediate-eigenvector alignment, sheet/tube reconnection)
  is direct numerical evidence that the intense geometry is multi-directional — the case his machinery
  excludes. This is the sharpest thing we can offer him.
- **Different depletion trigger:** our NS-045 depletion is via **helicity/Beltramization** (`u∥ω`, killing
  the Lamb vector), a *different* geometric condition than his anisotropy (`ω` one-directional). Whether
  one implies/excludes the other is open and worth his eye.
- **Convergence on integral-not-pointwise:** his weighted-`L²` depletion is exactly the *integral* control
  our NS-046 uniform-domination sub-probe concluded is necessary (pointwise domination being non-uniform).

---

## 8. The questions for Lockwood (the real forcing — sharper than the brief's generic ones)

1. **Conditional or unconditional?** Is the result intended as unconditional regularity, or as a
   conditional small-anisotropy-defect criterion? Every theorem carries `δ_Λ(0,1)≤ε` / `δ_Λ→0`.
2. **What forces `δ_Λ→0` along a blow-up?** Is the `δ_Λ` bounded-below (multi-directional) case reducible,
   excludable, or genuinely outside scope? I could not find where defect-vanishing is *derived*.
   **— Probed internally (2026-06-07, `ns049_anisotropy_defect_probe.jl`):** measured `δ_Λ` of the top-`q`
   `|ω|` cores on the resolved DNS — *the dynamics drive `δ_Λ` UP at the intense events*. At the Kerr
   reconnection the top-0.1% cores rise `δ_Λ`: 0.008 → 0.35 → 0.59 through the event (the bridge adds
   directions, rank-1→3D); at peak intensity the cores are δ≈0.32–0.54 across TG/tubes/helical — bounded
   well above one-directional. So *nothing in the resolved flow forces `δ_Λ→0`*. **Sharpened question:**
   `δ_Λ→0` could hold only on the **rescaled ancient / Type-I limit**, not the resolved geometry — so does
   the ancient limit one-directionalize even though resolved reconnections drive `δ_Λ` up (linking this to
   NS-048)? Vacuity cap: resolved evidence, not proof about the singular limit.
3. **Does the `δ_Λ→0` regime capture the physical geometry?** DNS shows intermediate-eigenvector alignment
   (not a frozen direction) at reconnection, and `δ_Λ` rising at the cores (§probe above) — the
   one-directional regime appears to miss where the resolved intense dynamics go.

---

## 9. Tier / honest scope

My **conditionality finding (§2)** is line-verified against the stated hypotheses (Part III Thm 8.1; Part IV
Lemma 3.1 eq 21) — **C3 on my side**. The **depletion-skeleton status (§3)** is Lockwood's own admission.
The **strict-core-is-soft reading (§4)** rests on the exact `tr·δ` identity (elementary). Overall the
Lockwood program stays **C0/C1, `:open`, UNVERIFIED** as an external object; this memo *sharpens NS-049's
caution from generic "unverified" to specific* — *conditional on an underived, physically-suspect
defect-vanishing hypothesis*. I may be missing a derivation of `δ_Λ→0`; that is exactly Question 2.
`:proved`=0; distance UNTOUCHED.
