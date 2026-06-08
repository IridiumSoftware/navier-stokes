# NS-049 — Does Lockwood's anisotropy defect `δ_Λ→0`? (internal probe companion)

**Date:** 2026-06-07. **Within-truncation witness for the NS-049 verification's sharpest question — "what
forces `δ_Λ→0` along a blow-up?"** Resolved-ish DNS (Re=1600, N=64), REGULAR flow. NOT the PDE; vacuity cap
(cannot reach `r→0`); `:proved`=0; distance UNTOUCHED.

## §1 — Computational basis

- **Script:** `scripts/ns049_anisotropy_defect_probe.jl` (reuses the validated `dns_tg256` chain). Output
  `scripts/ns049_anisotropy_defect_probe.out.txt`.
- **The object.** Lockwood's defect `δ_Λ = 1 − λ_max(M_Λ)/tr(M_Λ)`, `M_Λ = Σ_{|ω|≥Λ} ω⊗ω` (3×3, **sign-
  blind** — anti-parallel structures read as aligned). Eigen-ratios `λ_i/tr` read the structure:
  `(0,0,1)`=one-directional (δ=0), `(0,½,½)`=planar/sheet (δ=½), `(⅓,⅓,⅓)`=isotropic (δ=⅔). High-vorticity
  set taken intensity-adaptively = top-`q` fraction by `|ω|`, `q∈{1,0.1,0.01,0.001}`, per time.
- **N=1 gate (passed):** synthetic one-directional δ=0.000, isotropic δ=0.654 (≈⅔), planar δ=0.490 (≈½).
- **Flows:** TUBES (Kerr anti-parallel reconnection — the most singular-like event, NS-038's CKN-edge
  touch), TG (H=0), HELICAL (H≠0), through `t=0..6`.

## §2 — Results

**The dynamics drive `δ_Λ` UP at the intense events, not toward 0.**

| flow | peak (t, winf) | `δ@{100,10,1,0.1}%` at peak | core structure `(λmid/tr, λmax/tr)` | reading |
|---|---|---|---|---|
| **TUBES** | (5.5, 38) | (0.51, 0.48, 0.38, **0.35**) | rises rank-1→3D: 0.99 → 0.41 | reconnection **bridge drives δ UP** (0.016→0.35→0.59) |
| **TG** | (6.0, 19) | (0.65, 0.64, 0.63, **0.32**) | cores **planar/sheet** δ≈0.5 in the cascade | vortex sheets (rank-2), not 1-directional |
| **HELICAL** | (1.5, 59) | (0.65, 0.63, 0.60, **0.54**) | (0.32, 0.46) | genuinely 3D throughout |

- **TUBES is the decisive case.** It *starts* one-directional (anti-parallel tubes ⇒ rank-1 `M`, δ≈0.008
  at t=0, exploiting the sign-blindness in Lockwood's favour) and then `δ_Λ` **monotonically increases**
  through the reconnection: top-0.1% δ goes 0.008 → 0.35 (t=5.5, the winf peak) → 0.59 (t=6), structure
  collapsing from rank-1 (λmax/tr=0.99) toward 3D (0.41). The reconnection *bridge* adds the perpendicular
  directions — exactly the multi-directionality Lockwood's machinery excludes — at precisely the event
  where a singularity would form.
- **Even the most intense cores are not one-directional.** At peak intensity the top-0.1% `|ω|` set has
  δ ≈ 0.32 (TG) / 0.35 (TUBES) / 0.54 (HELICAL) — bounded well above 0, in the planar-to-isotropic range.
- **Consistent with NS-038** (vorticity aligns with the *intermediate* strain eigenvector, sheet/tube
  reconnection): the physically-realized intense geometry is multi-directional.

## §3 — Verification / honest scope

- *Computed* on the validated chain; N=1 gate passes (one-directional/planar/isotropic synthetics correct).
- **The internal answer to "what forces `δ_Λ→0`?":** in the resolved dynamics, **nothing — `δ_Λ` is pushed
  UP at the intense events** (the reconnection bridge, the vortex sheets, the helical tangle). The case
  Lockwood's program requires (`δ_Λ→0`, asymptotically one-directional) is not where the resolved dynamics
  go.
- **Vacuity cap (the steelman for Lockwood):** Re=1600 is REGULAR and cannot reach `r→0`. This is strong
  evidence that the *resolved* intense geometry is multi-directional — **not** proof that a true singular
  blow-up *profile* isn't one-directional (a genuine singularity could rescale to a one-directional ancient
  object even if resolved reconnections don't). That distinction — *resolved intense geometry* vs *singular
  rescaled limit* — is now the precise, fair question for him. N=64 (coarse; the qualitative trend — δ rising
  at reconnection — is physically robust, but a true verdict at the core would want N≥256).

## §4 — Bearing

Sharpens NS-049's central finding from "the `δ_Λ→0` hypothesis is assumed, not derived" to "**…and the DNS
says the resolved dynamics drive `δ_Λ` the other way at intense events** — so the hypothesis is not just
underived but appears to miss the physically-realized geometry, unless the singular rescaled limit
one-directionalizes in a way the resolved flow does not." The honest open question to put to Lockwood:
*does the Type-I/ancient rescaled blow-up limit have `δ_Λ→0` even though resolved reconnections drive it up?*
`:proved`=0; distance UNTOUCHED.
