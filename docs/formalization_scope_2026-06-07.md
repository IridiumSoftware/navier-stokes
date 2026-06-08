# Formalization target — scoping the Python → Julia → Haskell → Lean ladder

**Date:** 2026-06-07. Scopes the verification ladder for hardening the NS obstruction program's foundations
past the C5 social-verification floor. **This is a SCOPING doc — not the formalization.** `:proved`=0 and
stays 0 for the PDE: machine-verifying the *tractable* pieces hardens **definitions + algebraic structure**,
not the deep analytic theorems (which stay socially-verified until the substrate exists). The ladder maps
onto the program's existing evidence-type discipline: **Julia = exact-arithmetic *algebraic* evidence;
Haskell = *type-checked / categorical* evidence; Lean = *machine-verified*.**

**The methodology (the user's, adopted):** walk *back* from exploration to verification —
**Python** (explore) → **Julia** (express algebraically, exact arithmetic) → **Haskell** (express
categorically, types carry the spec) → **Lean** (machine-check). The Julia/Haskell rungs exist to **pin
down every variable, constant, and operator precisely** before Lean — that definitional precision is the
deliverable even if Lean is never reached.

---

## 1. What fits the ladder vs what is a multi-year effort

| Class | Examples (from the C5 black boxes) | Fits the algebra→category→Lean ladder? |
|---|---|---|
| **Algebraic / differential IDENTITIES** | the scaling-criticality calculus; the axisymmetric `Γ`/`Ω`/source identities; the NRŠ `H`-functional identity | **YES** — exact-symbolic in Julia, typeable/categorical in Haskell, provable in Lean (no analysis substrate needed) |
| **INEQUALITIES (the deep cores)** | anisotropic Hardy–Sobolev; fractional GN; Tao's Carleman estimates; the triple/double-log rate bounds | **NO (not yet)** — analysis, not algebra; needs Lorentz/Besov spaces, fractional Sobolev, parabolic theory in mathlib — **none exists**; multi-year, field-wide |

**Decisive point:** the C5 pass's irreducible black boxes are *inequalities*, which do **not** fit the
algebraic/categorical rungs and have **no** Lean substrate. **So the ladder's tractable target is the
IDENTITIES** — the exact structural backbone that the inequalities operate *on*. Formalizing those pins
down the definitions (the user's goal) and machine-hardens the algebraic skeleton, while the analytic
content remains the honest long-horizon.

---

## 2. Recommended staged plan

### Rung 0 (warm-up — establishes the 4-language pipeline on a cheap, load-bearing target): the **scaling-criticality calculus** (= NS-034)

Pure **rational-exponent algebra**. Objects: the NS rescaling `u_λ(x,t)=λ u(λx,λ²t)`; the scaling dimension
of each norm; criticality `σ=0`. Identities to verify:
- `‖u_λ‖_{L^p}=λ^{1−3/p}‖u‖_{L^p}` ⇒ critical iff `p=3`; `‖u_λ‖_{Ḣ^s}=λ^{s−1/2}‖u‖` ⇒ critical iff `s=1/2`;
- `‖|x₃|^α u^θ‖_{L^q_tL^p_x}` scale-invariant **iff `2/q+3/p=1−α`** (the `|x₃|^α` criticality);
- energy is **supercritical** (`σ=−1`) vs the critical `σ=0` (= NS-002, the central obstruction).

**Why first:** trivially tractable (exact `Rational` arithmetic), and **load-bearing for everything** —
criticality underpins the rate bounds, the `|x₃|^α` criterion, and supercriticality. It de-risks the
pipeline before the substantive target. *Effort: days–weeks.*

### Rung 1 (the substantive target): the **axisymmetric structural calculus** (the NS-048 core)

Cylindrical `(r,θ,z)`, `θ`-independent `u=u^r e_r+u^θ e_θ+u^z e_z`, `Γ=r u^θ`, `Ω=ω^θ/r`, `u₁=Γ/r²`. The
**differential identities** the entire NS-048 arc rests on:
- `∂_tΓ + b·∇Γ = ν(∂_r²−\tfrac1r∂_r+∂_z²)Γ` — **source-free** (the maximum principle's basis);
- `∂_tΩ + b·∇Ω = ν(∂_r²+\tfrac3r∂_r+∂_z²)Ω + S` with the **sole source** `S=(1/r⁴)∂_z(Γ²)=(2Γ/r⁴)∂_zΓ=∂_z(u₁²)`;
- Biot–Savart `−(∂_r²+\tfrac1r∂_r−\tfrac1{r²}+∂_z²)ψ=ω^θ`.

**Why this:** it is the program's **own load-bearing object** (every NS-048 attack lives on `S`), already
C4-re-derived by the verification agents (so we *know* it's right — formalizing is the C5→machine step),
and **walking the ladder pins down the exact definitions of `Γ`, `Ω`, `u₁`, the source, and every
cylindrical operator** — precisely the "understand the variables and constants" goal. *Effort: Julia/Haskell
weeks; Lean weeks–months (needs cylindrical vector calculus formalized).*

### Rung 2+ (the honest long-horizon, flagged NOT-now): the **inequalities**

Anisotropic Hardy–Sobolev, fractional GN, Carleman, the rate bounds. Require building the mathlib analysis
substrate first. *Effort: years; field-wide; not a session/near-term target.* Recorded so the ceiling is
explicit, not to be started.

---

## 3. The ladder, per language (what each rung does + what it pins down)

For each identity (Rung 0/1):
- **Python (explore):** numerical sanity check + a symbolic prototype (sympy) — confirm the identity holds,
  discover the right form. *Evidence class: computational (exploration only).*
- **Julia (algebraic proof):** exact verification — `Rational{BigInt}` for the scaling exponents (Rung 0);
  `Symbolics.jl` to *derive and verify* the differential identities symbolically (Rung 1), checking they
  close **exactly** (no dropped term). *Evidence class: `algebraic` (exact-arithmetic = proof, per the
  program's rule).* **Pins down:** the exact constants and that the algebra closes with nothing hidden.
- **Haskell (type / categorical):** encode the objects as **types** — a `ScalingDimension` type with the
  rescaling as a typed group action (Rung 0); the axisymmetric fields + differential operators as
  morphisms on a typed function-space, the identities as typed equations (Rung 1). Type-checking ⇒ the
  structure is internally consistent; the categorical phrasing pins down *what the operators are*. *Evidence
  class: `type-checked`.* **Pins down:** the definitions-as-types; composition/direction conventions
  (exactly the kind of thing the Haskell prototype lost a day to — `getSourceEntity`).
- **Lean (machine-verified):** the identity as a **theorem** — the criticality conditions (Rung 0); the
  source-free `Γ` equation and the `S` identity (Rung 1), against cylindrical vector calculus. *Evidence
  class: `lean-proved`.* **Pins down:** everything; ground truth.

Each rung is a **gate**: an identity that fails to close exactly in Julia, or fails to type-check in
Haskell, is caught *before* the expensive Lean step — the whole point of walking back.

---

## 4. Where it lives + infrastructure

- **Recommendation:** a self-contained formalization sub-track in `~/Desktop/navier-stokes`
  (`julia/`, `haskell/`, `lean4/` dirs), **reusing the TCE scaffolding** where it fits — the
  `triadic-coordination-engine` already has a Lean4 `Category` typeclass (`src/lean4/Category.lean`,
  no-Mathlib default path + a Mathlib opt-in), an exact-arithmetic Julia discipline, and a categorical
  Haskell core. Rung 1's Haskell can mirror the TCE categorical core; Rung 0's Lean can start
  Mathlib-free.
- **Lockfile discipline (per CLAUDE.md package-management):** Julia `Manifest.toml`; Haskell
  `cabal.project.freeze`; Lean `lean-toolchain` + `lake-manifest.json`. Pin everything; no `latest`.
- **Spec integration:** each machine-verified identity gets a spec entry promoted to its true evidence type
  (`algebraic` / `type-checked` / `lean-proved`) — the first NS entries that could legitimately leave
  `:argued`/`:tested` for a *higher* tier (still **not** `:proved` for the PDE — these are identities, not
  the regularity theorem).

---

## 5. Honest firewall + effort

- **Completing Rungs 0–1 machine-hardens the DEFINITIONS + the algebraic/differential skeleton** of the
  NS-048 arc — a real, citable increment (the program's *own* structural identities become `lean-proved`).
  It does **NOT** make any PDE conclusion `:proved`: the load-bearing *inequalities* (the C5 black boxes)
  remain socially-verified until Rung 2's substrate exists. The scaling/source identities are *necessary
  scaffolding* the analysis stands on, not the analysis.
- **Effort ladder:** Rung 0 ≈ days–weeks (cheap, do first); Rung 1 ≈ weeks (Julia/Haskell) to months
  (Lean); Rung 2 ≈ years (do not start). The **Julia/Haskell portion of Rungs 0–1 is the immediate,
  achievable, high-value work** — it delivers the definitional precision the user is after, independent of
  whether Lean is reached.

---

## 6. Recommendation + decision points

**Recommended:** start **Rung 0** (scaling-criticality calculus) to stand up the Python→Julia→Haskell→Lean
pipeline on a cheap, load-bearing, purely-algebraic target; then **Rung 1** (axisymmetric structural
calculus) as the substantive goal. Treat Rung 2 (inequalities) as the explicit long-horizon, not a task.

**Decision points for you:**
1. **Target/order:** confirm Rung 0 → Rung 1 (or jump straight to Rung 1, the axisymmetric core).
2. **Depth this pass:** all four languages, or stop at Julia+Haskell (definitional precision) and defer
   Lean?
3. **Home:** new `navier-stokes` sub-track reusing TCE scaffolding (recommended), or build inside TCE.
4. **First artifact:** I can begin with the Rung-0 Julia (exact-`Rational` scaling-criticality verifier) —
   the cheapest concrete first step that establishes the pipeline.
