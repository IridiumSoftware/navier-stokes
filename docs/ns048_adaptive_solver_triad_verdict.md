# Triad verdict — adaptive / moving-mesh swirl solver decision

**Seats:** Grok (edge-witness Φ, cold/adversarial) + ChatGPT (synthesis seat, integrative). Brief:
`docs/ns048_adaptive_solver_triad_brief.md`. **Outcome: do NOT build (A); the (C0) gate was RUN and DECIDES:
bank (B).** `:proved`=0; distance UNTOUCHED.

## (C0) RESULT (run 2026-06-11, `scripts/ns048_c0_boundary_transfer.jl`) — DECISION: bank (B)

The synthetic boundary-transfer test settled C2 experimentally, with a nuance that decides the whole call:

| scenario | β (true 2.00) | reading |
|---|---|---|
| interior (baseline) | **1.999** (0.0%) | estimator re-confirmed |
| **wall-pinned (clean)** | **1.997** (0.2%) | **the fixed wall does NOT break the two-scale estimator** — `ℓ/s^c` flat at 0.4289 |
| wall + competing **fixed scale** | 2.65 (all-s) / **3.04** (deep) | a non-collapsing fixed length-scale **contaminates** the fit (32–52%); the amplitude crossover pollutes even the deep subset |

**Resolution of the seat disagreement:** the **synthesis was right** on the technical point (boundary pins β,
does not destroy it — Grok's "likely invalid" was too strong); but **Grok's bottom line (bank B) holds**, by a
*sharper* route than his — not estimator-invalidity but **data-starvation**: (C) needs a clean self-similar
window where the collapse dominates all fixed scales, and the real wall DNS has competing fixed scales (domain
`R`, IC width, viscous scale) **and** only ~2–3 resolved timesteps before it goes unresolved. It cannot feed
(C) a clean window.

**DECISION — bank (B):** cells (ii)/(iii) stay **RESOLUTION-LIMITED** (mechanism confirmed; reproduces why
Chen–Hou adaptivity is needed). **(C) is estimator-LICENSED but DATA-STARVED** on the current fixture — it is
*unlocked for the future* should a cleaner / better-resolved collapse ever be produced (which loops back to
the resolution problem (A) would solve — i.e. (C) and (A) are complements, not substitutes, in the limit).
**(A) remains dominated** for the stated witness objective. No build authorized.

## Per-claim consensus

| Claim | Grok (Φ) | Synthesis | Integrated verdict |
|---|---|---|---|
| **C1** (A) is the right path | REFUTED | REFUTED (for the stated objective) | **REFUTED** — (A) is an *infrastructure* project disguised as a witness-completion project; dominated for completing one cell |
| **C2** (C) valid & cheaper | NOT ESTABLISHED, "likely invalid" | NOT ESTABLISHED, **"plausibly salvageable, cheaply testable"** | **NOT ESTABLISHED — gated on (C0)**; the boundary does *not* destroy β (Chen–Hou shows wall-pinned self-similarity exists), it may only invalidate the *current estimator* |
| **C3** scope ceiling | CORRECT | CORRECT | **CORRECT** — witness-tier; any "closing in on the singularity" reading is a category error |
| **C4** completing improves the map | NOT ESTABLISHED (marginal) | NOT ESTABLISHED | **NOT ESTABLISHED** — incremental unless it changes the witness verdict *qualitatively* (a no-stable-window outcome would be more informative than a clean exponent) |
| **C5** recommendation | (B) bank it | CORRECT-modified: **(C0 → C-if-valid → else B)** | **(C0 → C / B)** — the extra gate is the key synthesis move |

## Where the seats differed (and how I resolve it — verified, not rubber-stamped)

- **Grok: "(C) likely invalid → just bank (B)."** **Synthesis: "(C) is cheaply *testable*; the boundary
  pins β, doesn't destroy it; settle it by experiment."** I side with the **synthesis**: my own a-priori
  check agrees that the two-scale ratio `ℓ = ‖f‖∞/‖∂f‖∞` scales as the collapse scale λ regardless of where
  the structure sits (interior or wall-pinned), *provided the profile is genuinely self-similar* — so the
  wall is an anchor, not necessarily a contaminant. The honest move is therefore not to assert (in)validity
  but to **run the cheap test**. This replaces *both* of my flagged biases (tool-attachment + sunk-cost-stop)
  with a falsifiable experiment — exactly the discipline's intent.
- **Both seats independently flagged my tool-attachment-to-NS-050 bias as dominant.** Accepted. The (C0)
  gate is the corrective: it makes (C) earn its place rather than be reached for because it is mine.

## Two over-reach traps the seats named (fold into the program's language)

1. **(C3, synthesis):** *"condition X is vacuous in near-singular flow"* must NOT be allowed to smuggle
   *"therefore irrelevant to PDE truth."* It supports only *"may be non-discriminating in this truncation
   regime."* → **action: audit the vacuity map's wording for this slippage** (it already carries a heavy
   vacuity cap, but the *"plausibly vacuous for the actual mechanism"* phrasing is exactly the kind to tighten
   to *"non-discriminating in the resolved truncation"*).
2. **(C1):** *"if we resolve the wall concentration we learn something about the NS singularity"* — false;
   we learn about a known intensification regime under truncation. Name it in any (A)/(C) write-up.

## The decision — and what to do next

**Run (C0): a boundary-transfer feasibility test (days, not weeks; minimal prototype, no integration).**

> Does the NS-050 two-scale estimator **recover** a *known* self-similar exponent under **wall-pinned**
> rescaling — within calibration tolerance — and specifically, does a *fixed wall* contaminate the estimate
> versus the validated interior case?

Concretely (synthetic, no PDE solve): build a field `f(r,t) = A(t)·Φ((R−r)/λ(t))` with a fixed wall at
`r=R` (Φ pinned), known exponents (`A=(T−t)^{−1}`, `λ=(T−t)^{c}`, true β=c), and check the two-scale fit
recovers `c` — both wall-pinned and interior-centered, head-to-head. **Recover, not "qualitatively track."**

**Decision tree:**
- **(C0) passes** (estimator transfers, wall ≈ interior within tolerance) → **(C) is licensed**; the next
  question is data-sufficiency (is the wall DNS's *resolved* phase long enough / self-similar enough to read
  β before it goes unresolved). Likely dominates (A).
- **(C0) fails cleanly** (the fixed wall corrupts ℓ) → **(C) is dead → bank (B):** record cells (ii)/(iii)
  as resolution-limited (mechanism confirmed; reproduces why Chen–Hou adaptivity is needed). Already honest.
- **(A)** is approved ONLY if the goal is explicitly *re-defined* as building reusable adaptive
  infrastructure for multiple NS-048 routes — argued honestly as an infrastructure investment, not as
  "finishing these witness cells." For the stated objective, it stays dominated.

`:proved`=0; Scope: resolved-DNS / within-truncation witness throughout. No build authorized beyond the (C0)
prototype.
