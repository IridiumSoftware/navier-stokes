# Companion — the inverse-Born / possibilistic map of turbulence's measured constants

**2026-06-01.** A deliberate pivot off the prize: instead of mapping *necessity* (the
obstruction ledger — what is impossible), map the other two modes of the **physical**
phenomenon on its natural manifolds — *possibility* (what the no-go's don't exclude) and
*probability* (what turbulence actually does, the measured constants). The method is
Aaron's **inverse-Born / possibilistic inversion**, and here it is *literal*, not analogy.
**Scope: EMPIRICAL phenomenology + the one EXACT law (4/5) + the no-go constraints. NOT
the 3D-NS PDE; `:proved` = 0; the prize was deliberately not the target.**

## §1 — Computational basis

- **Source (new):** `scripts/turbulence_nogo_map.jl` (+ `.out.txt`). Std-lib Julia (`Printf`).
- **The literal inverse-Born.** The multifractal formalism (Parisi–Frisch) is a
  large-deviation/Born structure: increments scale as `δu_r ~ r^h` with each exponent `h`
  living on a set of dimension `D(h)`; moments are the saddle-point transform
  `ζ_p = inf_h[ p h + 3 − D(h)]`. So measured moments `ζ_p` (the "probabilities") are the
  Legendre transform of `D(h)` (the **possibility structure** = log-possibility of `h` =
  large-deviation rate function = `|amplitude|²` in the WKB sense). **Inverse-Born =
  inverse Legendre:** `D(h) = 3 − max_p[ζ_p − p h]` — recover the possibility structure
  from the observed moments. The no-go theorems become **constraints on the admissible
  `D(h)`** — the no-go map of the manifold.
- **Inputs:** consensus measured exponents `ζ_p` (Anselmet 1984 / She–Lévêque review,
  ±~0.03); the parameter-free She–Lévêque model `ζ_p = p/9 + 2[1−(2/3)^{p/3}]`; the von
  Kármán/transition constants for the wall panel.
- **Run:** `julia scripts/turbulence_nogo_map.jl`.

## §2 — Results

**Panel 1 — the inertial (h, D) manifold.** Measured `ζ_p` match She–Lévêque to ±0.02
(ζ₃=1 exact). Inverse-Legendre recovers `D(h)` with three landmarks:

| landmark | h | D(h) | meaning | tag |
|---|---|---|---|---|
| peak (most probable) | 0.381 | 3.000 | space-filling bulk | [MODEL/MEASURED] |
| **K41 / Onsager pivot** | 0.333 | 2.966 | ζ₃=1, h=1/3 ⟺ σ=0 | **[EXACT anchor]** |
| **CKN filament edge** | 0.111 | 1.000 | most-singular ≤ 1D | [no-go-saturating] |

The rendered map shows the spectrum sweeping from the peak `P` (D=3) down through the
pivot `K` (h=1/3) and **running all the way down to the CKN wall `C` (D=1 at h=1/9)**. The
forced/possible/probable decomposition:
- **Forced (□):** `D≤3` ceiling; concavity/realizability; `ζ₃=1` (the 4/5 law) pins a
  slope-3 tangent; CKN ⇒ the most-singular end cannot lift above `D=1` (≤1D filaments).
- **Possible (◇):** any concave `D(h)≤3` touching the 4/5 tangent with low-h endpoint ≤1.
- **Probable:** the measured spectrum — peak `D=3` @ h≈0.38, mean h=1/3, **saturating the
  CKN wall** at the singular end.

*Honest flag (anti-confirmation-bias):* the data "saturating CKN" is a **consistency, not
an identity** — She–Lévêque's most-intense structures are 1D vortex filaments; CKN bounds
a *hypothetical singular set* ≤1D. Same geometry (filaments), different objects (intense vs
singular). Stated as resonance, not theorem.

**Panel 2 — the σ-ladder overlay (contact with NS-036).** The local exponent `h` and the
global criticality `σ` meet at one rigorous point and orient the sides: `h>1/3` (smooth)
↔ `σ<0` (energy, controlled); `h=1/3` ↔ `σ=0` (critical: 4/5 ⟺ Onsager ⟺ Ḣ^{1/2}); `h<1/3`
(rough) ↔ `σ>0` (enstrophy side — where the intermittent/CKN-edge structures live). The
local spectrum and the global ladder **agree on where the difficulty is** (at/below the
critical exponent). Pivot rigorous; the sides qualitative.

**Panel 3 — the wall-bounded manifold (Re, y⁺).** A different structure (mean-profile, not
multifractal), with two Reynolds-keyed possibilistic boundaries: **onset** `Re_c` (pipe
≈2040, Couette ≈325) — laminar *forbidden→possible*, the NS-021 subcritical lifetime
regime; and the **log law** (`κ≈0.41`, `B≈5.0`) — forced in *form* by inner/outer overlap,
but the overlap *window* only opens as Re→∞ (so κ is probable, the window possible, empty
at low Re). Panel 3 says *when/where* turbulence exists; Panel 1 says *what it looks like*.

**Hinge — the dissipation anomaly.** `C_ε = εL/u'³ → ≈0.5` (Re→∞, ν-independent) is the
empirical face of Onsager (NS-009): finite ε as ν→0 forces the spectrum to reach `h=1/3`
— it is *why* the (h,D) manifold has a singular end at all, the probable reason the no-go
walls are approached rather than idle.

## §3 — Verification

**Type — algebraic + computed (empirical anchoring).**
- *Exact:* the 4/5 law ⇒ `ζ₃=1` (from NS under homogeneity+isotropy+stationarity); `D≤3`,
  concavity (realizability) — all forced. The Legendre duality is exact algebra.
- *Computed:* the inverse-Legendre `D(h)=3−max_p[ζ_p−p h]` evaluated on the measured `ζ_p`
  (recovers `D(1/3)=2.96`, `D(0.30)=2.90`, `D(0.20)=2.37`); the She–Lévêque parametric
  curve `(h(p), D(p))` with `D(1/9)=1.00` at `p→∞`; the rendered map.
- *Measured (literature, tagged):* `C_K≈1.6`, `ζ_p` (Anselmet/SL), `μ≈0.2`, `C_ε≈0.5`,
  `κ≈0.41`, `Re_c` (pipe 2040 / Couette 325).
- *Modeled (tagged):* the She–Lévêque ansatz; the h↔σ correspondence beyond the single
  rigorous pivot (sides are qualitative).

## §4 — Spec impact

Candidate new entry **NS-037 — "Possibilistic (inverse-Born) map of turbulence's measured
constants"** (Class: POSSIBILISTIC / empirical; evidence: algebraic + computed; Scope:
empirical phenomenology + exact 4/5; Status: `:argued`; Depends_on: NS-006 (CKN), NS-009
(Onsager), NS-034/036 (criticality/hinge), NS-021 (lifetimes)). **Deferred — owner's call**
(this is the first artifact of a new direction; the map is the deliverable, formalizing it
as a spec entry is a separate decision). For now it lives as this companion + script.

*Firewall: empirical phenomenology + the exact 4/5 law + the no-go constraints; not the
PDE; `:proved` = 0; the prize was deliberately not the target. Metabolized by Claude,
2026-06-01.*
