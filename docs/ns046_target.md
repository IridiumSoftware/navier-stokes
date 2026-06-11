# NS-046 — The Critical Coercive Deformation Inequality (precise open target)

**Date:** 2026-06-06. **Status: `:open` (analytic target). Scope: PDE-analysis.** `:proved`=0; distance
to the prize UNTOUCHED. This is the standing, admissible statement of *where the prize sits* for the 3D
Navier–Stokes obstruction program — sharpened by NS-047 (the framework) and the Idea-3 / uniform-
domination sub-probes (the irreducible difficulty, computationally pinned). It is a **target**, not a
result; the program holds NS-046 *paused at this statement* pending a genuine analytic idea.

## 1. The established reduction chain (what licenses the target)

`regularity` ⟺ control a **critical (σ=0) norm** (NS-005, Prodi–Serrin–ESS) ⟸ bound **enstrophy** `∫|ω|²`
(NS-036, via the exact interpolation `‖u‖²_{Ḣ^{1/2}} ≤ ‖u‖_{L²}‖u‖_{Ḣ¹}`, with energy always controlled)
⟸ control the **vortex-stretching production** `P = ∫ω·Sω = ∫|ω|²(ξ·Sξ)` — the σ=+1 rung's breaker. The
only a-priori control, energy (σ=−1), is provably insufficient (NS-008, Tao's averaged-NS). Bounding
enstrophy is a *sufficient, most-natural* route — **not** the unique framing (critical-Besov,
concentration-compactness, probabilistic routes survive; cf. the MID witness in §10 of the write-up).

## 2. The target inequality

On CKN-compatible parabolic cylinders `Q_r` (singular-set-admissible: filamentary / sheet-like /
intermittent), in a **critical Besov framework** `Ḃ⁰_{∞,1}` — *not* `L^∞` (NS-047: this escapes the
Beale–Kato–Majda endpoint; the harmonic-analytic route is **live**, not blocked at BKM) — establish a
**uniform `δ>0`** such that the strain deformation is coercively controlled:

> the strain self-amplification of the maximal eigenvalue `λ₃` (and hence the production `P`)
> is dominated, at scaling σ=0, by the **nonlocal pressure-Hessian counter-transport**
> `−e₃ᵀ(∇²p)e₃` (with `∇²p` recovered from the singular-integral Poisson solve `−Δp = ∂_iu_j∂_ju_i`)
> **plus** viscous dissipation `ν|∇ω|²`, up to controlled lower-order terms — uniformly on `Q_r`.

CCATT admissibility (every term recoverable from NS by admissible transport): acts at σ=0; controls the
production / an implied critical norm; incorporates the nonlocal pressure **explicitly**; survives
localization to CKN sets; DNS/model evidence admissible only as witness/counter-witness, never as the
analytic step; any depletion claim must **export to a quantitative inequality**, not stay descriptive.

## 3. A candidate remaining difficulty (within-truncation probes; witness-corrected — NOT "the" difficulty)

The inequality requires the depletion to dominate **uniformly on the intense-production / high-strain
set** — the singular-set proxy. Two within-truncation probes pin exactly where this is hard:

- **Idea-3** (`ns046_gradxi_pressure_probe`): the nonlocal pressure-Hessian counter-transport *is* the
  operative depletion in the zero-helicity maximal-stretch (Kerr-tube) worst case where Beltramization
  (NS-045) is weakest — enstrophy-weighted ratio 1.5–11×, N-converged 64↔128. The *mechanism is real*.
- **Uniform-domination sub-probe** (`ns046_uniform_domination_probe`): but the domination is
  **NON-UNIFORM** — conditioned across production intensity, `⟨e₃ᵀ∇²p e₃⟩/⟨λ₃²⟩` is **negative on the
  bulk** (the pressure *enhances* the max-stretch — Vieillefosse local-pressure stretching) and turns
  strongly depleting **only at the extreme `|ω|` cores** (top-0.1%); viscosity is **≪1 on the intense
  set** (supercriticality).

**A natural remaining target (NOT "the" irreducible difficulty — witness-corrected, triad 3/3,
2026-06-06):** *if* the Besov-endpoint objection is set aside (NS-047), one such target is uniform
domination on the bad set — pursued through **Besov/integral/cancellation controls, not pointwise
domination** (the within-truncation probes refute only the *pointwise-domination heuristic*, not the
inequality; a regular truncation has no singular set, so its non-uniformity does not bear on the
analytic statement). **The real difficulty may lie elsewhere** — e.g. derivative loss at the precise
scaling where cancellations are marginal — and "*the* irreducible difficulty is the non-uniformity" was
over-reach (the 6th this arc). Closing NS-046 needs a genuine analytic idea the program does not have;
the discipline forbids manufacturing one. *(Honesty ledger: six over-reaches caught this arc — four by
the adversarial witnesses [LOW#1, MID, §5-"≡", NS-047-C1], one by the probe-first call [Idea-3 "pressure
dominates"], one by the witnesses again here [the NS-046-arc interpretations].)*

**Integral / cancellation probe (2026-06-11, `scripts/ns046_integral_cancellation_probe.jl`) — within-truncation
witness, vacuity-capped, `:proved`=0; TRIAD-TRIMMED same day (`docs/ns046_ns013_triad_verdict.md`).** Measures
the PRODUCTION-WEIGHTED integral `R_int = Σ_w(e₃ᵀ∇²p e₃ + ν|∇ω|²)/Σ_w(λ₃²)` on the Kerr worst case. The honest
post-triad reading: **(i) a WEIGHT-SENSITIVE integral reconciliation** — `R_int(full)` = **2.42** under
`w=|ω|²` but **1.53** under the production weight `|ω·Sω|` and **0.21 (BELOW 1)** under the strain-energy
weight `|S|²` (the seats' demanded sweep, run): enstrophy weighting emphasizes the coherent cores; *no weight
is canonical and no domination claim survives weight-independently* (the original "weighting artifact" reading
was refuted as over-reach). **(ii) The "difficulty locus at small scales" reading is WITHDRAWN** (non-monotone
bins; `k_loc` is a sharpness proxy; viscous floors force margins in a regular truncation). **(iii) The
demanded FEED-denominator recomputation is the sharpest datum:** against the machine-verified actual growth
source of λ₃ — `¼(|ω|²−(ω·e₃)²)`, per the sign-check derivation — the margin **evaporates to R_feed =
0.98–1.03 (marginal)**; the comfortable 2.4 was substantially an artifact of the λ₃² denominator (the
self-*damping* term). Single snapshot / fixture / resolution throughout — *suggestive only*; any future
domination probe must measure against the FEED, with an N-trend and a second fixture, before any reading.
**TWO GUARDS (do NOT over-read — this is the over-reach-prone entry):** (a) the depletion **SIGN convention**
(`e₃ᵀ∇²p e₃>0 ⇒ depletes`) — **Required Check now CLOSED, see below**; (b) a regular truncation
has **no singular set** — `R_int>1` is a *suggestive prior*, NOT the inequality and NOT progress. **NS-046
stays `:open`; this sharpens only WHERE the difficulty sits (small scales).**

**Sign Required-Check — CLOSED (2026-06-11, `scripts/ns046_dlambda3_sign_check.{py,jl}` + `.out.txt`;
evidence class: algebraic).** The full derivation chain is machine-verified exactly: **I1** gradient-of-NS
`DA/Dt = −A² − ∇²p + νΔA` (symbolic identity, sympy); **I2** `sym(A²) = S² + Ω²`; **I3**
`Ω² = ¼(ω⊗ω − |ω|²I)`; **I4** the eigen-derivative lemma `dλ₃/dt = e₃ᵀ(dS/dt)e₃` (λ₃ simple —
Hellmann–Feynman, rotation terms cancel exactly); independently corroborated in Julia (`Rational{BigInt}`
exact zeros for I2/I3; FD convergence rate 4.00 for I4; assembly to machine-ε). Conclusion:

> `Dλ₃/Dt = −λ₃² + ¼(|ω|² − (ω·e₃)²) − e₃ᵀ(∇²p)e₃ + ν e₃ᵀ(ΔS)e₃`

so the pressure-Hessian projection enters with coefficient **−1**: `e₃ᵀ∇²p e₃ > 0 ⇒ DEPLETES` — **the
probes' adopted convention is CORRECT.** *Honest sharpening surfaced by the derivation* (recorded, not
over-read): for λ₃ *itself* the `−λ₃²` term is **self-damping**, and the growth **feed** is the vorticity
term `¼(|ω|²−(ω·e₃)²)` (maximal for `ω ⊥ e₃`); the probes' ratio `R = e₃ᵀ∇²p e₃/λ₃²` remains a sensible
*magnitude* comparison (λ₃² is the dynamics' scale), but the §2 phrase "strain self-amplification *of* λ₃"
is loose — the self-amplification of the *production* `ω·Sω` runs through ω-growth fed by λ₃>0, not through
λ₃'s own square. Caveat: the lemma needs λ₃ simple (a.e.; crossings excluded). Matches the published
eigenframe dynamics (Meneveau, Annu. Rev. Fluid Mech. 2011 — C2, statement-level). `:proved`=0.

## 4. Kill criteria (§11 of the write-up — what would retire this framing)

- a critical-norm control **independent of the production/enstrophy** (self-contained critical-Besov or
  concentration-compactness) ⇒ NS-036-centrality / P-centrism retired;
- a harmonic-analytic route that **bypasses the vortex-direction geometry** ⇒ the geometric framing is a
  side-channel (NS-047 already showed the route is *live*; this would show it *bypasses*);
- supercriticality and the Casimir deficit **coming apart** under a sharper formulation ⇒ the §5 "same
  bottleneck" reading fails;
- the happy one: any `Scope: PDE`, `:proved` result.

## 5. Dependencies / supporting entries

NS-001 (problem), NS-002/034 (supercriticality), NS-005 (critical-norm criterion), NS-006 (CKN
localization), NS-008 (energy-only no-go), NS-036 (criticality–Casimir hinge → the enstrophy rung),
NS-045 (Beltramization — the complementary depletion at high helicity), NS-047 (the LP-route is
live, BKM-escaped; C2 = the uniformity gap). Brian's extension notes (2026-06-05) + CCATT
(`docs/ccatt_reference.md`).
