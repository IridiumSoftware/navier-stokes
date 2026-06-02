# Companion — can the hard layer bound the intermittency exponent μ from above?

**2026-06-02.** The sharp test of the inverse-Born approach (after `turbulence_inverse_born.jl`):
can a *frame-dependent number* (μ≈0.2) be promoted to a *structural inequality* using only
frame-independent invariants? **Answer: μ ∈ [0,1], rigorously and tightly — but no tighter;
the gap to the observed ≈0.2 is frame-dependent and cannot be imported as structure.**
Scope: empirical phenomenology + the exact 4/5 law + realizability. NOT the PDE; `:proved`=0.

## §1 — Computational basis

- **Source (new):** `scripts/mu_hard_bound.jl` (+ `.out.txt`). Std-lib Julia (`Printf`, `Random`).
- **Setup:** `μ = 2 − ζ_6` (the ζ_6 deficit; = the dissipation-correlation exponent under
  refined similarity). Bounding μ above ⟺ bounding ζ_6 below. Hard invariants used: `ζ_3=1`
  (4/5, exact), `ζ_p` nondecreasing (bounded velocity, regular flow), `ζ_p` concave
  (Lyapunov/Hölder), `D(h)∈[0,3]`, CKN. **No measured number is anchored on.**
- **Run:** `julia scripts/mu_hard_bound.jl`.

## §2 — Results

**The two elementary bounds (the answer):**
- **μ ≤ 1** — monotonicity: `ζ_6 ≥ ζ_5 ≥ ζ_4 ≥ ζ_3 = 1`. (Rigorous for any regular flow,
  `‖u‖_∞ < ∞`; the inertial-range limit of bounded-increment moment inequalities.)
- **μ ≥ 0** — concavity: 3 is the midpoint of 0 and 6, so `ζ_3 ≥ (ζ_0+ζ_6)/2` ⟹ `ζ_6 ≤ 2`.

So the frame-independent invariants force **μ ∈ [0, 1]**.

**Tightness (both ends saturated by admissible spectra):**

| spectrum | admissible? | ζ_6 | μ |
|---|---|---|---|
| K41 (linear ζ_p = p/3) | yes | 2.000 | **0.000** |
| ramp-then-flat (slope ⅓ on [0,3], 0 after) | yes | 1.000 | **1.000** |

Both are concave, nondecreasing, and hit ζ_3=1 — so [0,1] is **tight at both ends**.

**CKN does not tighten.** CKN bounds the dimension of *genuine* singularities (`h<0`,
unbounded velocity). A regular turbulent flow has `‖u‖_∞<∞` ⟹ `h≥0` everywhere ⟹ **no
singular set** ⟹ CKN is vacuous on the spectrum. (The ramp-flat extremal has `D(0)=2`,
which CKN would only forbid if `h=0` were a genuine singularity — it isn't.) Any
codim≥2 requirement can be deferred to large p, leaving `ζ_6→1` (`μ→1`). `D≤3` and
concavity likewise permit μ all the way to 1.

**Honest flag (confirmation-bias guard).** The random search over 10⁴ concave-monotone
admissible spectra returned `μ ∈ [0.200, 0.738]` — and the lower end **0.200 coincides
with the observed μ**. This is a **sampling artifact** of the generator (uniform iid
sorted-descending slopes biases toward the interior), **NOT a structural bound**. The true
structural lower end is **0** (K41), exhibited above. The coincidence is recorded precisely
so it is not mistaken for a derivation — exactly the trap the methodology's §9 warns against.

## §3 — Verification

**Type — algebraic + computed.**
- *Algebraic (exact, the actual bounds):* `μ ≤ 1` from `ζ_6 ≥ ζ_3 = 1` (monotonicity);
  `μ ≥ 0` from `ζ_6 ≤ 2ζ_3 = 2` (midpoint concavity). Two-line proofs, frame-independent.
- *Computed (tightness + non-violation):* the two extremal spectra are admissible and
  saturate μ=0 and μ=1; a 10⁴-sample random ensemble of admissible spectra never leaves
  [0,1]. The CKN-vacuity is argued (h≥0 for regular flow) and illustrated (`D(0)=2` on the
  μ=1 extremal).
- *Anti-anchoring:* no measured value entered the bounds; the random-min/observed-μ
  coincidence is flagged as artifact, not used.

**Honest scope.** This is a real but **loose** structural bound (factor ~5 above the
observed μ). The looseness is the point: μ's specific value is protected by **no**
frame-independent invariant, so the methodology brackets it and stops. A tighter bound
would require a frame-dependent input (a measured ζ_p, or a model ansatz) — forbidden here.

## §4 — Spec impact

Strengthens the deferred candidate **NS-037** with a concrete inverse-Born *result*: the
hard layer promotes μ to the structural inequality `μ ∈ [0,1]` (tight), and **honestly
cannot tighten it** — a clean demonstration of the forced/frame-dependent boundary. Still
deferred as a formal entry (owner's call); for now this companion + script. If formalized:
evidence algebraic + computed; Status `:argued`; Depends_on NS-009 (4/5), NS-006 (CKN),
NS-036.

*Firewall: empirical phenomenology + exact 4/5 + realizability; not the PDE; `:proved`=0.
Methodology: closure-v5 `inverse_born_methodology.md` (anti-anchoring §9). Metabolized by
Claude, 2026-06-02.*
