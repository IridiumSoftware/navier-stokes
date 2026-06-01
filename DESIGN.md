# DESIGN.md — strategy of the Navier–Stokes obstruction program

## 1. What this program is, and is not

**Is:** a disciplined map of a hard problem — the obstructions that block a proof,
the diagnostics that detect blowup, the approaches already falsified, the
approaches still live, and our own computations, each scoped honestly.

**Is not:** an attempt to claim a proof, nor a place to let elegant analogies
inflate into "progress." The prize is measured only in rigorous PDE results
(`:proved`, `Scope: PDE`), and we have none. The `dashboard.md` distance-to-prize
is, and should remain, "untouched" until a real PDE result lands.

## 2. The terrain (why the problem is hard), in one paragraph

The 3D incompressible NS nonlinearity is quadratic; the only coercive global
control is energy (NS-003); and energy is **supercritical** for the scaling
symmetry (NS-002) — useless at small scales. Regularity reduces to controlling a
*critical* norm (NS-005), which we cannot do a priori; equivalently, blowup
requires unbounded vortex stretching (NS-004). The cleanest backward construction
(exact self-similarity) is dead (NS-007); and energy-only methods are provably
insufficient (Tao's averaged blowup, NS-008). What survives: partial-regularity
control (singular set ≤ 1D, NS-006), the inviscid-limit/Onsager picture (1/3,
NS-009), and — the live analytic handle — the **complex plane**.

## 3. The live attack: the complex plane

This is the program's primary forward direction, and the rigorous form of the
"assume it blows up and work backward" instinct.

- **Analyticity strip (NS-010).** A smooth solution extends analytically to a
  complex strip of width `δ(t)`, equal to the Fourier-spectrum decay rate.
  `δ(t)→0` = blowup. Directly computable.
- **Complex-singularity tracking (NS-011).** Blowup = the nearest complex-space
  singularity reaching the real axis.
- **Why it's credible (NS-012).** Li–Sinai *proved* finite-time blowup for
  **complex-data** 3D NS. The backward path works in the complex setting; the
  open question is whether/what it implies for real data (NS-013).

**Plan of computation (staged, each with explicit Scope):**
1. **Burgers (1D), exact.** Cole–Hopf gives explicit complex poles; viscosity
   holds them off the real axis (regular), inviscid lets them hit it (shock).
   Watch `δ(t)`. Scope: 1D-model. Purpose: *see* the mechanism, validate the
   diagnostic against closed form (TEST_SPEC).
2. **Spectral Euler/NS truncation.** Track `δ(t)` via spectrum decay in a
   Fourier–Galerkin truncation of a candidate near-blowup flow. Scope:
   ODE-truncation. Purpose: exercise the diagnostic on the real nonlinearity at
   finite resolution; honestly flag truncation ≠ PDE.
3. **Read the obstructions back.** Relate measured `δ(t)`, BKM integral
   (NS-004), and critical-norm growth (NS-005) — do they co-move as the theory
   demands? Scope: ODE-truncation diagnostics.

The firewall line is explicit: steps 1–3 are **diagnostics in models**. A
statement about the PDE would require a convergence/limit argument we are not
making. Crossing that line is a separate, flagged event.

## 4. What the prior arc contributed (honest accounting)

The turbulence/closure arc (NS-020..024) produced: a falsified approach
(homology), useful re-diagnosis (the difficulty is the norm), and a self-contained
result in a *different* domain (autopoietic closure / the (M,R) rotation-covariant
gate). It produced **no** PDE result, and the closure↔turbulence bridge was
externally witnessed down to "broad/generic, no analytic purchase" (NS-024). These
are kept as the program's record and as a cautionary calibration of how much an
elegant analogy is worth here (little, until witnessed and scoped).

## 5. Cross-project framing (CFS, closure-quotient, possibilistic-inversion)

Aaron's standing programs share a methodological spine with this one. The transfer
is in **two tiers, and only the first is guaranteed:**

- **Tier 1 — method (transfers):** the evidence-tiered obstruction ledger, the
  Scope firewall, and external witnessing of convergences. NS is the cleanest
  *hard-problem testbed* for this discipline precisely because it is unforgiving —
  it will expose any place the discipline is lax. Lessons here (e.g., "witness
  every cross-domain convergence"; "a model result is not a PDE result") harden
  the method everywhere.
- **Tier 2 — substance (transfers only when witnessed + scoped):** any *content*
  connecting NS to CFS/quotient/possibilistic-inversion must clear the same bar
  NS-024 was held to. The closure↔turbulence link did **not** clear it as more
  than broad kinship, so it must not be imported elsewhere as a substantive
  bridge. Future genuine bridges (if any) get their own witnessed spec entries.

The honest version of "NS progress informs the other projects": **the discipline
informs them now; the mathematics will inform them only if and when a scoped,
witnessed result earns it.**

## 6. Success criteria (so we never fool ourselves)

- **Program success:** the ledger stays honest and complete; diagnostics are
  validated against known closed forms; falsified paths are recorded; the firewall
  holds. (Achievable, and the real near-term goal.)
- **Problem progress:** a rigorous PDE statement (`:proved`, `Scope: PDE`). None
  yet; this is the prize and is not expected from computation alone.
- **Failure mode to avoid:** a `:tested` model result quietly migrating into prose
  as "evidence about Navier–Stokes." The Scope line exists to prevent exactly this.
