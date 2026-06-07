# Witness verdict — axisymmetric-swirl arc (external triad, 2026-06-07)

**Metabolized record of the external adversarial pass** on `docs/ns048_axisym_swirl_witness_brief.md`.
Witnesses: **Grok** (edge-Φ / cold-adversarial seat), **Venice.ai** (synthesis seat, swapped in for Gemini),
**ChatGPT** (naive seat). All three primed to refute; given the self-contained brief + the internal
pre-screen's findings to verify-or-challenge. `:proved`=0; NS-048 unchanged; "no theorem" stands.

**Headline:** the external pass — across three independent model families — **independently confirmed the
internal trim** (C9 = echo; C4 = overstated; math clean; no theorem found), **and went further on two
points the same-model pre-screen structurally could not:** it corrected a residual imprecision in *my own*
C4 correction, and it sharpened C7 with a concrete two-point stall analysis. This is the external layer
earning its keep.

---

## 1. Per-claim verdict (three witnesses + net)

| Claim | Grok (Φ) | Venice | ChatGPT | NET |
|---|---|---|---|---|
| C1 reduction to controlling `S` | correct | correct | correct | **CORRECT** |
| C2 wall at axial ∞, not axis | correct (caveat) | correct (caveat) | correct | **CORRECT** — `L¹`-divergence is a *heuristic*, not proved; `z` dominates |
| C3 max-principle = temporal not spatial | correct | correct | correct | **CORRECT** (slightly over-sharp in phrasing) |
| C4 "no soft step beyond frontier" | NOT ESTABLISHED | overstated | real hit / overstated | **OVERSTATED → refine** (confirms 10th-over-reach trim) |
| C5 `Γ≥0` preserved but doesn't sign `S` | correct | correct | correct | **CORRECT** |
| C6 `∂_zΓ`-sign not preserved | correct | correct | correct | **CORRECT** |
| C7 signed source ⇒ one-sided only | NOT ESTABLISHED (path?) | overstated (bootstrap stalls, traced) | gap in pessimism | **SHARPEN** — "no *known* mechanism," not "dead end"; bootstrap stalls at 2 points; "no theorem" stands |
| C8 only columnar closes | correct | correct | correct | **CORRECT** |
| C9 "three independent convergent" | REFUTED (echo) | accepted (echo) | persuasively refuted | **REFUTED — echo** (confirms 11th-over-reach trim) |

---

## 2. What the external pass CONFIRMED (independently of the internal pre-screen)

1. **Math is clean.** No witness found a sign/factor/scaling/logic error. C1/C2/C3/C5/C6/C8 stand.
2. **C9 is echo, not corroboration.** All three converge on the *same* formulation: (a) energy, (b)
   maximum principle, (c) sign condition are **three languages for one obstruction** — uncontrolled
   `∂_zΓ` on the non-compact `z`-axis. Grok: "echo, not independent confirmation." Venice: "projections of
   a single obstruction onto different functional spaces… not triangulation." ChatGPT: "multiple standard
   toolkits all run into the same axial non-compactness barrier." This *independently re-derives* the
   internal trim (the 11th-over-reach correction) from three separate model families — genuine
   corroboration *of the meta-claim's falsity* (and, pleasingly, a real instance of the NS-024 lesson:
   what looked like convergence was echo).
3. **"No theorem" stands.** No witness produced a closing path. The C7 bootstrap does not close (§4).
4. **No step proves the bare KNSS conjecture** — firewall intact (all three checked).

## 3. What the external pass ADDED beyond the internal trim — and corrected in MY correction

**(a) C4 — the open frontier is a weighted condition on `∂_zΓ`, NOT plain `L^p` on `Γ` (a 12th item:
my own corrective over-reach).** My v0.1.76 C4 correction floated "weak-`L^p`/Lorentz swirl
`Γ∈L^∞_tL^{p,∞}_x` plausibly closable." **Venice refuted this specific suggestion:** the production is
`S=(2Γ/r⁴)∂_zΓ`, so *any* integrability/decay on `Γ` alone is insufficient — "the `L^p` bound doesn't give
decay of `∂_zΓ`." The honest open frontier (Venice + ChatGPT converge):

> Find a **weighted space `X` on `ℝ³`** such that (1) boundedness in `X` is strictly weaker than full
> KNSS, and (2) it implies decay of **`∂_zΓ`** sufficient to close the estimate on `S` — *or* prove no
> such `X` exists (any condition strong enough to control `S` is equivalent to the conjecture).

So: the **C4 *direction* stands** (the universal "no soft step" was wrong — `ℝ²×T¹` is a proven
intermediate class; small-swirl `‖Γ‖_∞≤ε` remains a plausible soft class, unchallenged), but my **specific
weak-`L^p` example was imprecise** — corrected to "a weighted/mixed-norm condition controlling `∂_zΓ` in
`z`." Even the correction needed correcting. ChatGPT's defensible re-statement: *"No currently known
intermediate hypothesis appears both natural and substantially weaker than existing Liouville assumptions
while still yielding a proof."*

**(b) C7 — the bootstrap STALLS at two identifiable points (sharper than my "not visibly convergent").**
Venice traced the candidate closing chain `Ω≤C ⇒ |ω^θ|≤Cr ⇒` Biot–Savart on `b` `⇒` transport-diffusion
estimates on `Γ` `⇒` feedback into `S`, and located exactly where it dies:
- **Stall 1 (Biot–Savart):** Calderón–Zygmund gives `‖∇b‖_{L^p}≲‖ω^θ‖_{L^p}` only for `1<p<∞`; it **fails
  at `p=∞`**, and `|ω^θ|≤Cr` grows linearly in `r` (so `ω^θ∉L^∞(ℝ³)`). The kernel is not integrable
  against linearly-growing vorticity without extra decay.
- **Stall 2 (transport-diffusion):** the `Γ`-equation's drift `b·∇` is divergence-free (preserves `L^p`,
  **generates no decay**) and the diffusion is isotropic (**cannot distinguish `r` from `z`**). So
  boundedness alone yields **no `z`-decay of `Γ`**, hence no improved control on `∂_zΓ`, hence none on `S`.

Net: the bootstrap is **not demonstrated impossible**, but it has **no currently known closure mechanism**
and stalls at two concrete points. C7 reframed from "dead end / no path visible" → **"no known closure
mechanism; the one-sided bound does not propagate to any quantitative `∂_zΓ` estimate by any visible
route."** "No theorem" stands; the negative is epistemically softer and now *localized* (which is more
useful than the original blanket claim).

## 4. Net metabolized position (after both passes)

- **Reduction (C1), localization (C2: source benign at axis, wall at axial ∞), and the structural facts
  (C5/C6: `∂_zΓ` has no preserved sign) are correct and robust.**
- **The crux is uncontrolled `∂_zΓ` on the non-compact `z`-axis** — but this is a **shared obstruction
  seen by multiple standard methods** (NOT three independent confirmations; NOT proof that it is "the"
  irreducible difficulty — it is where the *known soft toolkits* lose control, consistent with and
  re-deriving the existing `L^p`/`α<1`/`T¹` hypotheses).
- **The open problem, sharply:** a weighted space controlling `∂_zΓ` in `z`, strictly weaker than KNSS,
  closing `S` — or a proof none exists. Plain `L^p` on `Γ` is *not* it.
- **`no theorem`; `:proved`=0; distance UNTOUCHED.** Both the static-inequality (NS-046) and this
  dynamic/axisymmetric (NS-048) frontiers remain genuinely open.

## 5. Honesty-ledger update (NS-048 arc)

7th = geometry-re-tasking (deflated); 8th = manufactured theorem (declined); 9th = sign-condition shortcut
(deflated); **10th = "no soft step" (internal-caught, external-confirmed); 11th = "three independent
convergent attacks" (internal-caught, external-confirmed across 3 model families); 12th = the weak-`L^p`
suggestion *inside* my 10th-correction (external-caught by Venice — `L^p` on `Γ` ≠ control of `∂_zΓ`).**
The 12th is the sharpest lesson of this pass: *the correction itself over-reached, and only an independent
model caught it* — vindicating the external layer over a same-model pre-screen (the
confirmation-bias hazard, [[feedback_validator_confirmation_bias]], made concrete).

## 6. Attribution

External witnesses, 2026-06-07 (`~/Desktop/triad.rtf`): **Grok** (cold/adversarial Φ-seat), **Venice.ai**
(synthesis seat — substituted for Gemini this round), **ChatGPT** (naive seat). Internal pre-screen
(same-model, 3 reviewers) recorded in `docs/ns048_axisym_swirl_witness_brief.md` §3. The two passes agree
on the trim; the external pass additionally supplied the C4-`∂_zΓ` refinement and the C7 stall-analysis.
