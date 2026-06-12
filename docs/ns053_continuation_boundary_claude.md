# NS-053 — The (d, α) continuation boundary: the independent (Claude) attack

**Date:** 2026-06-12. **Status: `:open` (target) + tier pass + first instrument witness. Scope:
PDE-analysis (≠ the PDE); the probe is 1D-model witness.** `:proved`=0; distance UNTOUCHED.
**Independence note:** built from Aaron's seed draft only — the parallel Grok thread (including
`docs/ns053_continuation_boundary.md`, present in-tree but **unread**) was deliberately not consulted;
the two attacks are meant to be compared after the fact.

## 1. The frame (with one sharpening of the seed)

Two continuation families embed true NS = **(d, α) = (3, 1)** as a point in a plane: spatial dimension
**d** and dissipation order **α** (`(−Δ)^α`). The plane has a **rigorous spine** (tier-checked, §2): the
energy-critical line

> **α_c(d) = (d+2)/4  ⇔  d_c(α) = 4α − 2**

— regularity on/above it, and even *logarithmically below* (Tao). Two readings of the same line: at d=3
the critical order is **5/4**; at α=1 the critical dimension is **2**. True NS sits at margin **1/4 in α ≡
1 in d**. **Sharpening the seed:** the blow-up side of the plane is *empty of rigorous NS points* near
(3,1) — the rigorous content is one-sided (the regularity rail); the only anchors below the line are
numerical (Hou) and model-level. So NS-053 is an instrument-and-map program, and the honest target is the
**failure mode** of constructibility approaching (3,1), not the curve itself.

## 2. Tier pass (the seed's gate — executed)

- **α-rail, Tao arXiv:0906.3070 — C1→C2 (statement read, verbatim):** global regularity for symbol
  `m(ξ) ≥ |ξ|^{(d+2)/4}/g(|ξ|)` with `∫ds/(s·g⁴)=∞`, covering `|ξ|^{(d+2)/4}/log^{1/4}(2+|ξ|)`; regularity
  in the "critical and subcritical regimes `α ≥ (d+2)/4`". **The rail is log-soft** — "onset" cannot mean a
  hard wall. (Katz–Pavlović 2002 lineage: C1, named only.)
- **d-anchor, Hou arXiv:2405.10916 — C1→C2+formulation (full-text extraction):** the dimension `n` enters
  as **operator coefficients** (`Γ_rr + ((n−4)/r)Γ_r + ((6−2n)/r²)Γ + Γ_zz`; stream function
  `−(∂_r² + (n/r)∂_r + ∂_z²)ψ₁ = ω₁`; `r^{n−2}` velocity weights) — a generalized-axisymmetric family,
  **not** an ambient-space change. Dynamic law: **`n = 1 + 2R(t)/Z(t)`** (max-vorticity location), chosen
  so radial and axial advection share one scaling — verbatim: *"preventing formation of two-scale solution
  structure."* "Solution-dependent viscosity" = `ν = ν₀‖u₁(t)‖∞ Z(t)²` (ν₀=0.006), a scaling-invariant
  stretching/diffusion balance. Stabilized value **n≈3.188**; **no sensitivity analysis reported** (the
  seed's d* sensitivity question stays open at this tier). *Witness-tier interpretation (ours):* at fixed
  n=3 the profile fails by **two-scale anisotropy** (R/Z separation); the n-dial buys back single-scale
  self-similarity that d=3 refuses. In line coordinates: Hou's (3.188, 1) sits at supercriticality margin
  ≈1.19 (vs NS's 1.0 at α=1, where d_c=2) — **+0.19 above true NS**.
- **Seed kill-criterion #1 status:** *"is the d-continuation a pure numerical regularizer?"* — at this
  tier it is a **structured family** (clean operator coefficients, scaling-invariant choices), not an
  obvious artifact — but the dynamic `n(t)` law ties the dial to the solution itself, so the d→3 limit is
  *not* a fixed-parameter continuation. The honest reading: the d-anchor survives the gate but the limit's
  mechanism question (what breaks as n→3: the two-scale anisotropy re-asserting) is **the** question.

## 3. The α-onset probe on a ground-truth model (`scripts/ns053_alpha_onset_clm.jl` + `.out.txt`)

**Family:** dissipative CLM `ω_t = ωHω − νΛ^α ω` (the canonical 1D vortex-stretching model; in-repo exact
ground truth at ν=0: t*=2, T-03/T-04). **Self-derived scaling prediction** (the testable spine):
nonlinearity ~ (t*−t)⁻², dissipation ~ ν(t*−t)^{−1−α} ⇒ the model's critical line is **α* = 1**,
ν-independent to leading order — the 1D analog of α_c=(d+2)/4.

**The anchor gate earned its keep twice before any result was read:** run 1 (W_BLOW=200) failed — the
threshold sat *outside* the resolved envelope (under-resolution stalls the collapse; fake t*≈6, tail 0.47);
run 2 still failed — which exposed a genuine **bit-reversal off-by-one in a freshly written FFT** (caught
by a 20-line DFT cross-check); fixed by importing the **validated** T-03 `fft!` verbatim. Lesson logged:
*reuse validated kernels; fresh re-implementations must pass a DFT check before any physics is read.*

**Results (the licensed run, `scripts/ns053_alpha_onset_clm.out.txt`):**

| ν | α*_eff (bisected) | blow-up-side trace | regular-side trace |
|---|---|---|---|
| 0.20 | **∈ (0.9297, 0.9320)** | t\*(α) **diverges**: 3.41 → 3.64 → 4.01 → 4.43 → 5.19 approaching α\* | transient peak **diverges**: 43.7 just above α\* → 3.1 → 1.6 away |
| 0.05 | **> 1.6** (outside sweep) | t\* ≈ 2.5–2.8 throughout, still crossing the threshold | — |

1. **The failure mode — the entry's central question — answers crisply at ν=0.20: a MARGINAL-STATE
   (saddle-node-like) boundary.** Both signatures present simultaneously: critical slowing of t\* from
   the blow-up side AND a diverging long-lived transient from the regular side (a near-singular "ghost"
   reaching 43.7 = 55% of the blow-up threshold before decaying). The blow-up dies by the collapse
   **stalling against a marginal state** — not by an abrupt mechanism switch. *In NS-053 terms: the
   model-level candidate exclusion mechanism at the boundary is profile-marginalization (the blow-up
   profile and a decaying path merging), the structure a Liouville-side argument would need to capture.*
2. **α*_eff(0.20) ≈ 0.93 sits near but below the scaling prediction 1** — finite-ν prefactor effects
   shift the effective boundary below the asymptotic line, as expected for a witness-level measurement.
3. **The ν=0.05 "failure" is itself the methodological finding.** α*_eff > 1.6 there, violating the
   predicted ν-independence — diagnosis: **a finite-amplitude threshold cannot see the asymptotic
   boundary for α > 1.** Large transients cross W_BLOW=80 long before asymptotic dissipation bites
   (and on the periodic domain the IR floor — k=1 feels exactly ν regardless of α — weakens the dial's
   reach). This is the **1D mirror of the repo's own 3D Step-2 gate lesson (T-06)**: blow-up-onset
   mapping in (d, α) requires **asymptotic-regime certificates (co-moving gates — δ→0 with BKM-type
   co-divergence, profile convergence), not amplitude thresholds.** Learned cheaply on the model; it is
   a hard instrument requirement for every future cell of the (d, α) map, including any d-dial run.
4. *Cosmetic script note:* when the coarse range contains no regular endpoint (the ν=0.05 row) the
   bisection prints `Inf/undecided` lines — visible, harmless, retained so the committed script matches
   the committed artifact.

## 4. What this buys, and the next rungs

(i) The instrument is validated on a family whose boundary is predictable (α*=1); (ii) the measured
**failure mode** at the model boundary — critical slowing (t*→∞) vs amplitude gating (transient peak
saturating) — is the template question for (3,1); (iii) next rungs: the same α-dial on the **Hou–Luo
model** (where the HQWW exact self-similar profiles + our β=2.47 calibration live), then the **d-dial**
via Hou's generalized-axisym coefficients on our validated `(r,z)` solver (`ns048_axisym_swirl_dns.jl` —
the `(n−1)/r`-type coefficient generalizations are small, and the solver's validation gate ports).

## 5. Firewall

The seed's declined over-reaches are adopted verbatim: no "NS is fractal-dimensional" (subsets of ℝ³ have
dim ≤3; n≈3.188 is a stabilization parameter, not a measurement); the Clay statement is exactly ℝ³/𝕋³;
all (d,α) work is **instrument only** — prize relevance requires landing at (3,1) with Scope: PDE +
`:proved`. `:proved`=0; distance UNTOUCHED.
