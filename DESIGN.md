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
NS-009). The analytic handles, tried in turn: first the **complex plane** (§3, validated but no PDE
result), now the **σ=0 vortex-stretching production** at the two frontiers the obstruction map funnels
everything to (§3, §7).

## 3. The attack: from the complex plane to the two frontiers

**The program's strategy is generator-class reduction (the MDAGC, `docs/ns_blowup_generator_class.md`):**
assemble every no-go into one positive object — *what any finite-time singularity must be* — and let the
intersection localize where a live attack must go. The intersection is non-empty and pinned to **two
frontiers** (NS-046 static / NS-048 dynamic, below), which are now the live attack. The **complex plane**
(this section) was the *first* analytic handle tried — the rigorous form of the "assume it blows up and
work backward" instinct; it is validated and produced no PDE result.

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

**Status — this plan is EXECUTED (and returned no PDE result, as designed).** Step 1
(Burgers, NS-010 T-01) validated δ(t) against the exact Cole–Hopf closed form. Step 2
(spectral 3D control NS-010 + the gated inviscid-TG blowup hunt NS-032) ran to **N=256↔512**
on the GPU (§7) with the full T-06/T-08 gate ⇒ **INCONCLUSIVE / regular-leaning** — δ declines
but the full-band fit is not N-converged and does not co-move with BKM, so the gate correctly
refuses a resolution-artifact δ→0. Step 3 (obstruction co-movement, T-06) is the gate itself.
The complex-plane diagnostic is now *validated and applied*; it has produced no PDE result, and
the program has since broadened well beyond this one plan — see §7.

**The current live attack — the two frontiers (the MDAGC's two non-empty holes).** Regularity ⟺ control a
σ=0 critical norm ⟸ bound enstrophy ⟸ control the vortex-stretching production `P=∫ω·Sω`. The map funnels
everything there, and `P` sits in `ker(E)` — invisible to the only coercive control (energy). The live
attack must engage it through one of two structures, two faces of one wall:
- **Static (NS-046).** A *critical coercive deformation inequality* — does the nonlocal pressure-Hessian
  counter-transport (plus viscosity) dominate the strain self-amplification at σ=0, in critical Besov on
  CKN sets? The difficulty is non-uniformity (depletion is core-concentrated, bulk-enhancing). Needs a
  genuine analytic idea the program does not have.
- **Dynamic (NS-048).** *Exclude the rescaled ancient solution* — assume a singularity, rescale, prove a
  Liouville theorem (Type-I-conditioned ⟺ Albritton–Barker; the unconditioned KNSS-with-swirl case is
  open) and handle the Type-II branch (no compact limit; modulation theory). Every session-scale attack
  reduces to two un-mechanized open cores.
Recent work (§7) engages these directly: NS-049 (a line-read of Lockwood's conditional anisotropy criterion)
and NS-050 (modulation/Type-II + a within-truncation instrument and reusable ℝ-variable tooling).

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

## 7. What the computation has produced beyond the complex-plane plan (NS-030..050)

The §3 plan was the *seed*; the program grew a substantial body of scoped computation around it.
None of it touches the prize (`:proved`=0, distance UNTOUCHED) — each is a model/truncation result
held to the firewall. The arc, in brief (see `SPEC.md` for the entries, `docs/*_companion.md` for
the records):

- **Geometric / analytic tour (NS-033..036).** A coadjoint-orbit + edge-manifold + SDiff(T²)
  curvature study (NS-033); the exact **scaling-exponent calculus** (NS-034) pinning the
  critical/super-critical classification and unifying NS-002↔NS-005; the **Ryan scope-principle**
  (NS-035, emergence coupled to scope not level); and the **criticality–Casimir hinge** (NS-036)
  joining supercriticality ≡ Casimir-deficit at enstrophy. Mostly `:argued`/`:tested` in models.

- **Possibilistic / inverse-Born map (NS-037, `:argued`).** An obstruction map of *real* turbulence
  on its manifolds — inverse-Legendre of the multifractal formalism — forcing ζ₃=1, a
  monotone-concave ζ_p, and a ≤1-D singular end; rules out log-normal (K62) structurally;
  touchability ranking (dissipation-rate > exponents > amplitude). EMPIRICAL scope, prize-focus
  deliberately dropped.

- **Resolved-DNS boundary program (NS-038, `:tested`).** Resolved N=256/Re=1600 pseudospectral DNS,
  FFTW-validated against Brachet (enstrophy peak t≈9), across three flows A (Taylor–Green) → B
  (helical) → C (anti-parallel vortex tubes / reconnection). Verdicts: S_ω bounded, δ bounded, the
  production-set box-dimension dynamic (floors >1 for A/B; C's reconnection transiently reads
  D30≈0.99 — flagged as the noisiest signal, needing N≥512).

- **Metal/GPU N=512 track (NS-039, NS-040, `:tested`).** A Swift + MPSGraph (Metal 4) spectral
  solver (`metal/dns_gpu.swift`, float32, validated ≡ the float64 CPU code to 5–6 digits) lifts the
  DNS to N=512 in ~40 min/run. **NS-039:** the C reconnection ≤1 box-dimension touch is a
  **resolution artifact** — it lifts 0.986 (N=256) → 1.426 (N=512), resolving RWC-038. **NS-040:**
  strong helicity **depletes (delays + concentrates) vortex stretching** — a matched-spectrum
  controlled pair (ρ_H 0.97 vs 0.05, identical E0/Z0) shows 2–4× slower enstrophy growth,
  resolution-robust. The GPU track also re-opened the gated Step-2 hunt at real resolution (§3).

- **Beltramization mechanism (NS-045, `:tested`).** A matched ± helical pair isolates the helicity-depletion
  mechanism as (b) **Beltramization** (u∥ω crushes the Lamb vector u×ω ~26×, switching off the nonlinear
  driver), not (a) ω–S alignment. Sharpens NS-040. Within-truncation; N-converged.

- **The MDAGC generator-class synthesis (the strategic centerpiece, `docs/ns_blowup_generator_class.md`).**
  The standalone no-gos assembled into one positive necessary-conditions object — *what any singularity must
  be*: `G1–G5` hard (others' theorems) ∧ `S1,S2` soft framings ∧ `W1,W2` within-truncation witnesses. This
  is the program's organizing move (§3): it declares what is **dead** (energy-/spectrum-only methods, exact
  self-similar, region-filling) and localizes the live attack to the two non-empty holes (NS-046/048). The
  phase-coherence/detector arc is folded in as a *sharpening of S1* — a counterexample family showing the
  production is not a function of the coercive invariants — **not** a new hard exclusion (over-reach
  declined). Reorganization, not progress; `:proved`=0.

- **The two frontiers, engaged (NS-049, NS-050, both `:open`).** **NS-049 (C0/C1):** an honest line-read of
  J. Lockwood's anisotropy-depletion CKN-deformation program — a *conditional* regularity criterion (every
  theorem assumes the anisotropy defect `δ_Λ→0`, never derived; a resolved-DNS probe drives `δ_Λ` the wrong
  way at reconnection), **not** the unconditional proof its framing implies. **NS-050:** modulation /
  dynamic-rescaling as the Type-II handle — the finding that the construction route's prerequisite
  self-similar profile is *exactly what G3 deletes* in the smooth/no-boundary category, plus a
  within-truncation **instrument** (a dynamic-rescaling fit calibrated on CLM β=1 **and** the faithful
  Hou–Luo model β=2.47 ∈ the proven Chen–Hou–Huang band (2,4.53), a 3D Taylor–Green negative control, a
  validated 2D-Boussinesq wall solver), and **reusable ℝ-variable numerical tooling** (cot-map dilation +
  line-Hilbert operators validated to machine precision — usable for any self-similar/DSS/ancient-profile
  analysis, incl. NS-048). The tuned-profile reconstruction is OPEN (four honest negatives, recorded). All
  within-truncation; `:proved`=0.

- **Adjacent infrastructure: a Lean formalization ladder + a citation-disproof arc.** A concurrent track
  machine-verifies real-analysis library lemmas (Marcinkiewicz interpolation, Littlewood–Paley, Bernstein,
  Young) — **library infrastructure, `:proved`=0 for the PDE**, fenced as such, not a regularity result.
  And the cited closed forms / transcribed identities were stress-tested by attempted disproof (sympy/numpy),
  catching real transcription errors (an NRŠ H-identity record error; a hardened Wang endpoint) — the
  verification that makes the obstruction atlas trustworthy and is the genuine, transferable value (§1, §5).

The firewall held throughout: every entry is scoped to a model/truncation, the Required Witness
Checks did their job (e.g. RWC-038 caught a numerical artifact at N=256), and the prize stays
untouched. The discipline (not the mathematics) is what transfers to the other programs (§5).
