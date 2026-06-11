# Triad verdict — NS-046 integral finding + NS-013 consolidated reduction (two-part brief)

**Seats:** Grok (edge-witness Φ, cold/adversarial) + ChatGPT (synthesis seat). Brief:
`docs/ns046_ns013_triad_brief.md`. **Outcome: every strong reading trimmed or refuted; both seats' central
demands were then RUN and empirically vindicated.** Applied per the NS-024 pattern (verdicts recorded
faithfully, claims trimmed). `:proved`=0; distance UNTOUCHED.

## Consolidated verdicts (harsher seat governs)

| Claim | Synthesis | Grok Φ | **Applied** |
|---|---|---|---|
| **P1-C1** weighting-artifact | NOT ESTABLISHED | NOT ESTABLISHED (strong reading refuted) | **REFUTED as worded** → *"weight-sensitive integral reconciliation: enstrophy weighting emphasizes coherent cores"*; "the form the inequality actually takes" was an unargued assertion |
| **P1-C2** scale-margin locus | NOT ESTABLISHED | **REFUTED** | **WITHDRAWN** — non-monotone bins; `k_loc` = sharpness proxy, not spectral scale; viscous floors force margins in a regular truncation ("the probe may be rediscovering that regular truncations regularize") |
| **P1-C3** single-everything | CORRECT | CORRECT (as criticism) | **unconverged single-point witness** — no reading beyond "suggestive" before N-trend + 2nd fixture + multiple times |
| **P1-C4** λ₃ sharpening | CORRECT w/ caveat | NOT ESTABLISHED (the R/λ₃² save) | algebra **stands** (machine-verified); the "R/λ₃² remains sensible" save **does not** — the feed-denominator recomputation was demanded (and run, below) |
| **P2-C1** scramble non-trivial | NOT ESTABLISHED | NOT ESTABLISHED | survives only as *"quadratic invariants are insufficient"* — close to textbook triple-correlation phenomenology; a negative (production surviving) would have been the surprise |
| **P2-C2** ξ smooth in cores | NOT ESTABLISHED | **REFUTED** | **REFUTED** — (a) the 1%→0.1% uptick is load-bearing ("singular concern lives at the edge"); (b) single-N; (c) **kinematic confound**: high-`|ω|` sets in a tube fixture are organized *by construction* ("the probe may be rediscovering that vortex tubes are tube-like") |
| **P2-C3** the reduction | NOT ESTABLISHED | **REFUTED (relabeling)** | **REFUTED as a reduction** — CFM is a necessary condition for *any* NS flow; "protection reduces to CFM" adds no discriminating content; the complex-data angle contributes almost nothing (the 1D Fourier-support mechanism does not transfer); elimination-by-exhaustion ≠ reduction |
| **P2-C4** status wording | CORRECT (downgraded) | NOT ESTABLISHED (as worded) | **downgraded**: `:argued` + **two adjacent, non-diagnostic witnesses** — neither touches the load-bearing step |

**The stable landing (synthesis seat's wording, adopted):**
> *Reality's phase/Hermitian structure alone does not appear protective; geometric organization remains the
> leading surviving candidate — but the reduction to CFM is **argued, not witnessed**.*

## Empirical confirmations (run after the verdicts; the seats were right twice over)

**1. P2-C2's N-lift — CONFIRMED BY THE GPU N-TREND.** While the brief was out, the deferred ξ N-trend ran
(`scripts/ns013_cfm_gpu_trend.jl`, tubes @ t=6.00 enstrophy peak): core/bulk `⟨|∇ξ|²⟩_w` ratio
**0.57 (N=64) → 2.62 (N=256)** — the "smoother in cores" headline **reverses under refinement** (the NS-039
lift pattern, predicted by the seats from the uptick alone). δ_Λ ride-along: 0.49 at N=256 — the NS-049
multi-directionality verdict **holds at scale**. (N=512 pending; it decides whether the *roughening* is
converged — either way the N=64 headline is dead.)

**2. P1-C1/C4's demanded recomputation — RUN (probe extended, same snapshot; single-point caveats apply):**

| weight `w` | `R_int` (vs λ₃²) | `R_feed` (vs ¼(\|ω\|²−(ω·e₃)²)) |
|---|---|---|
| `\|ω\|²` (original) | **+2.42** | **+0.98** |
| `\|ω·Sω\|` (production) | +1.53 | +1.03 |
| `\|λ₃\|\|ω\|²` | +1.48 | — |
| `\|S\|²` (strain energy) | **+0.21** | — |

- **Weight-sensitivity confirmed:** the strain-energy weight **flips the verdict below 1** (0.21) — exactly
  Grok's prediction that "a different but equally motivated weight could make the margin disappear." The
  production weight keeps a modest margin (1.53). No weight is canonical; no domination claim survives
  weight-independently.
- **The feed-ratio is MARGINAL (≈1):** against the machine-verified actual growth source of λ₃, the
  comfortable 2.4 margin **evaporates to 0.98–1.03**. The R_int≥1 comfort was substantially an artifact of
  the λ₃² denominator (the self-*damping* term). Recorded with the cap: single snapshot, regular truncation —
  this does NOT establish that the analytic inequality is marginal in the limit; it establishes that the
  *probe's* favorable margin was denominator- and weight-dependent, as the seats said.

## Ledger actions applied

- `docs/ns046_target.md` integral-probe paragraph: trimmed to the weight-sensitive reading; locus reading
  withdrawn; feed-marginality recorded.
- `docs/ns013_complex_real_obstruction.md` §Consolidation: rewritten to the stable landing; claim-2 witness
  marked REVERSED-under-refinement; status `:argued` + adjacent non-diagnostic witnesses.
- Registry NS-046 + NS-013 rows, dashboard P1 + NS-013 lines: same trims.
- Probe report regenerated verdict-compliant (`ns046_integral_cancellation_probe.out.txt`).

**What survives, honestly:** the sign Required-Check (machine-verified, both seats accept); a weight-sensitive
single-point integral observation worth an N-trend *if* pursued; the phase-scramble as a calibration that
quadratic invariants are insufficient; the GPU N-trend instrument; and a sharpened sense that the *feed*
`¼(|ω|²−(ω·e₃)²)`, not λ₃², is the quantity any future domination probe must measure against. `:proved`=0.
