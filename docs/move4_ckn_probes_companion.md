# Companion — two probes: the reality stabilizer (Grok Move 4) + the M*↔CKN scope localization

**2026-06-01.** Two exploratory probes run back-to-back: Grok Oracle Move 4 (the
complex-data "reality stabilizer") and the Ryan-M\*↔CKN scope-localization handle.
**Scope: 1D-model / inviscid-3D-truncation — NOT the 3D-NS PDE. `:proved` = 0; prize
UNTOUCHED.** Both bear on the *complex / scope* side of the program (NS-012/013, NS-006,
NS-035).

## §1 — Grok Move 4: the reality stabilizer (`complex_burgers_reality_leakage.jl`)

**Testbed:** complex viscous Burgers — REAL data is heat-protected (Cole–Hopf `φ=e^{−U/2ν}>0`
⇒ regular), COMPLEX data can blow up (`φ` hits zero) — the exact 1D analog of Li–Sinai
(NS-012) with real-data regularity (NS-013 open). A tunable **reality leakage λ** damps
`Im(u)`; integrating-factor RK4 (the viscous term is stiff — explicit RK4 blew up
numerically; IFRK4 fixed it). Ground truth: with `φ₀=1+b e^{ix}`, blowup at `t*=ln(b)/ν`.

**Result (ν=0.2, b=3, t*=5.49):**

| λ | T*(λ) |
|---|---|
| 0 | **5.54** (vs Cole–Hopf 5.49 — solver validated ✓) |
| 0.005 | 5.78 |
| 0.02 | 6.77 (+22% delay) |
| ≥0.05 | **∞ (regular)** |

**CONFIRMED — reality protects, with a real boundary.** Below `λ_c∈(0.02,0.05)` the
leakage *delays* blowup (T* rises ~22%); above it the φ-zero is *prevented entirely*. So
Grok's "protection boundary" exists, with a gradual approach from below — close to his
conjecture. (Honesty notes: caught + fixed the stiff-viscous instability; corrected my
own first "sharp/discontinuous" reading once the fine λ-sweep showed the gradual delay.)

**Scope:** 1D-model. Illustrates the *mechanism* — reality (max principle / analyticity)
keeps the complex singularity off the real axis — and sharpens NS-013 ("does the conjugate
singularity pair collide on the real axis?"). Does NOT bear on 3D-NS. Bears on NS-012/013.

## §2 — M\*↔CKN scope localization (`ryan_ckn_scope_localization.jl`)

**Idea (Ryan NS-035 + CKN NS-006):** a novel (Class-II / ontological) singularity lives
at a minimal macrostate M\* — the smallest *scope* carrying it; CKN bounds the singular
set's Hausdorff dim ≤ 1. Track the localization of the vortex-stretching production density
`|P(x)|=|ω·(ω·∇)u|`: `f50/f90` = smallest volume fraction carrying 50/90% of `∫|P|`; the
participation ratio PR. One spectrally-embedded inviscid flow at N=32/64/128.

**Result:**
- **Intermittent from the start:** f50≈0.157 (16% of the volume carries half the stretching)
  — turbulence's known sheet/tube intermittency.
- **Localizes in the resolved window:** f50 shrinks 0.157→0.057 (t: 0→1.5, tail<1%); past
  the wall it grows back (resolution artifact — cascade at the cutoff spreads the numerical P).
- **Sharpens with resolution:** at fixed t, f50 *decreases* with N (t=1.5: 0.109/0.078/0.057
  for N=32/64/128) — the Class-II / ontological / CKN-≤1D **signature** (localization toward
  a smaller, possibly lower-dimensional set).

**HONEST CAVEAT (a Ryan-internal one):** `f50` is a volume *fraction* — itself a
**resolution-coupled** quantity. By Ryan's own logic, the conclusive test of a Class-II
(scope-coupled) localization is a **resolution-invariant** measure — the **box-counting
DIMENSION** of the high-production set (exactly what CKN bounds, ≤1). So f50-shrinking-with-N
is *suggestive* of localization toward a ≤1D set, but **not conclusive**: it could be genuine
localization, or higher N merely resolving sharper production peaks. The probe found
localization AND, via Ryan's principle, identified the better (scope-invariant) measure.

**Scope:** inviscid-3D-truncation. The right OBJECT (minimal scope of the production), the
right *signature* (localizing + sharpening with N), but the verdict is resolution-gated and
the resolution-invariant **dimension** is the principled refinement. Bears on NS-006, NS-035.

## §3 — Net

- Move 4: a clean, honestly-positive 1D confirmation of "reality protects" with a mappable
  boundary — sharpens the complex/real side (NS-012/013).
- M\*↔CKN: the production *localizes and sharpens with resolution* in the resolved window —
  the Ryan-Class-II / CKN signature — but `f50` is resolution-coupled, so the conclusive
  measure is a **box-counting dimension** (resolution-invariant, scope-coupled). It was run
  (next sub-section), and it CORRECTED the f50 reading.

## §4 — The close: box-counting dimension (`ryan_ckn_box_dimension.jl`)

The Ryan-correct, scope-invariant measure (box-counter validated: line→1, plane→2, volume→3).
Dimension D of the top-50%-production set:

| t | D (N=64) | D (N=128) |
|---|---|---|
| 0.0 | 2.32 | 2.39 |
| 0.5 | 2.22 | 2.31 |
| 1.0 | 2.23 | 2.25 |
| 1.5 | 2.34 | 2.30 |

- **D ≈ 2.3, RESOLUTION-ROBUST (N=64 vs 128 agree to ~0.09) and time-STABLE** — unlike f50,
  which dropped 0.16→0.06 and varied with N.
- **This CORRECTS the f50 reading.** f50's apparent "localization toward ≤1D" was a
  **resolution-coupled artifact** (a volume fraction: more cells at higher N mechanically
  shrinks it). The true (scope-invariant) **dimension does NOT drop**.
- The production lives on an **intermittent ~2.3-D fractal** (vortex sheets/tubes — exactly
  real turbulence's measured ~2.3–2.7 fractal dimension of intense structures): **neither a
  forming ≤1D singular set (Class-II) NOR a space-filling cascade (Class-I).** D>1 ⇒ **no
  resolved singular set**; consistent with CKN's ≤1 being a bound the resolved dynamics does
  not approach (the singular set, if any, lives below N=128).
- **Ryan validated, twice:** the framework told us *which measure to trust* (scope-invariant
  over resolution-coupled), and the trustworthy measure then *corrected* the misleading one —
  the f50 "localization" I floated was exactly the resolution artifact Ryan predicts.
- Honest: ~7 octaves (N=128) ⇒ a true ≤1D verdict needs N≳512; but D is the RIGHT measure,
  and at accessible resolution the answer is **intermittent ~2.3-D fractal, not a singularity.**

*Firewall: 1D-model / inviscid-3D-truncation; not the 3D-NS PDE. `:proved` = 0; distance to
the prize UNTOUCHED. Metabolized by Claude, 2026-06-01.*
