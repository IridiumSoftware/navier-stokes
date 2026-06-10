# NS-050 direction 1 — DSS profile + modulation: the ansatz and the spectral question

**Date:** 2026-06-09. **Status: `:open` analytical setup — a precise statement of the object and the
prerequisite spectral problem, NOT a construction or a result.** `Scope: PDE-analysis`. **`:proved`=0;
distance to the prize UNTOUCHED.** Develops direction 1 of `ns050_modulation_type2_scope.md`: replace the
*exact* self-similar profile (killed by G3 / NS-007) with a **discretely self-similar (DSS)** one, which G3
does not obviously exclude, and write down what a modulation analysis around it would require. Every
literature scope is **C1** (verify before citing).

---

## 1. Why DSS, precisely

**Exact backward self-similarity** is `u(x,t) = (1/λ(t)) U(x/λ(t))` with `λ(t)=√(2a(T−t))` and `U` a steady
profile of the rescaled equation. **NRŠ + Tsai (G3 / NS-007)** kill this in `L³` / the local-energy class:
no nontrivial backward `(−1/2)`-self-similar profile, and asymptotically-self-similar singularities too.

**Discrete self-similarity (DSS)** weakens "scale-invariant" to **invariant under one discrete scaling**:
for a fixed factor `μ>1`,

```
  u(x,t) = μ · u(μ x, μ² t)          for all (x,t)        (backward DSS, singularity-producing)
```

Equivalently, in the rescaled variables of `ns050_modulation_type2_scope.md` §2
(`y = (x−x₀)/λ`, `τ = ∫λ⁻²ds`, `u = λ⁻¹ U(y,τ)`), DSS ⟺ **`U(y,τ)` is periodic in `τ`** with period
`T_per = log μ`:

```
  U(y, τ + log μ) = U(y, τ).
```

So the DSS profile is a **time-periodic solution of the rescaled equation**, not a steady one. G3 excludes
the *steady* (`∂_τ U=0`) profile; it says nothing direct about a genuinely `τ`-periodic `U`. **That is the
entire reason to look here** — DSS is the smallest enlargement of the profile class that steps around G3's
specific exclusion. *(Tier: that G3 does not extend to backward DSS is C1 — NRŠ/Tsai are stated for the
self-similar and asymptotically-self-similar classes; the backward-DSS singular case is, to our knowledge,
open. Verify before relying on it.)*

**Literature anchor (C1):** forward DSS Leray solutions were constructed by **Jia–Šverák** (large DSS data)
and studied by **Tsai**; those are *forward / regularizing*, not the *backward / singularity-producing*
profile we need. The backward singular DSS profile is **not known to exist and not known to be excluded** —
the honest status of M1 for this direction.

---

## 2. The rescaled equation and the profile problem

From §2 of the scope doc, with `U=U(y,τ)` and the modulation triple `(λ,x₀,R)`:

```
  ∂_τ U = −P[(U·∇)U] + a(τ)(1 + y·∇)U + b(τ)·∇U + Ω(τ)×U + λ²ν ΔU,
          a = λλ̇ (scaling),  b = R^T ẋ₀/λ (translation),  Ω = R^T Ṙ (rotation),
          P = Leray projection,  pressure slaved:  −ΔΠ = ∂_iU_j ∂_jU_i.
```

**A DSS profile `Q`** is a `τ`-periodic solution of this system with the modulation coefficients
`(a,b,Ω)(τ)` *also* `log μ`-periodic (and `a` averaging to `−1/2` over a period, fixing the mean rate).

**The viscous degeneration (a load-bearing observation).** For the critical scaling `λ² ∼ (T−t)`, the
viscous coefficient `λ²ν → 0` as `τ→∞`. **So the rescaled NS equation limits to the rescaled EULER
equation**, and a backward DSS NS profile is, to leading order, a **DSS Euler profile** with viscosity as a
**singular perturbation**. This is consistent with — and explains — why *every* construction in the prior
art (MRRS, Elgindi, Chen–Hou) builds an **Euler** profile first: at the singular scale, NS *is* Euler plus a
vanishing-viscosity correction, and that correction is exactly what turns exact-self-similar into **Type-II**
(MRRS). **Consequence for us:** M1 reduces to "a backward DSS *Euler* profile (boundaryless, ≥`C^{1,α}`)",
and the Type-II rate is the *viscous modulation* of it.

---

## 3. The linearized operator — and why DSS forces Floquet, not eigenvalues

Linearize the rescaled RHS at the profile, `U = Q + ε`:

```
  ∂_τ ε = L(τ) ε + N(ε),     L(τ) ε = −P[(Q·∇)ε + (ε·∇)Q] + a(τ)(1+y·∇)ε + b·∇ε + Ω×ε + λ²ν Δε.
```

Two structural facts decide the difficulty:

1. **`L` is non-self-adjoint and nonlocal.** The Leray projection `P` and the slaved pressure make
   `(ε·∇)Q ↦ P[(ε·∇)Q]` a **nonlocal** (singular-integral) operator; there is no variational/self-adjoint
   structure (unlike NLS, where `L` is a Schrödinger operator with real spectrum up to the soliton modes).
   The pressure-Hessian `−e^T(∇²Π)e` that the static frontier NS-046 fights reappears *here* as part of `L`.

2. **Because `Q` is `τ`-periodic, `L(τ)` is `τ`-periodic ⇒ the spectral object is the FLOQUET / monodromy
   operator**, not a fixed eigenvalue problem:

   ```
   M  =  𝒯-exp ∫₀^{log μ} L(τ) dτ        (the period-map / monodromy of the linearized flow)
   ```

   Stability is a condition on the **Floquet multipliers** (spectrum of `M`): the construction needs
   **finitely many multipliers outside the closed unit disk** (the unstable modes, to be killed by the
   modulation parameters), the **symmetry zero-modes on the unit circle** (neutral — see §4), and the
   **rest strictly inside** (the spectral gap / contraction). This is the DSS analogue of MRRS's spectral
   gap, and it is **genuinely harder**: a monodromy of a nonlocal non-self-adjoint periodic operator, an
   object with essentially no worked NS precedent.

**Where dissipation helps and doesn't.** `λ²νΔ` contributes a `−λ²ν|k|²` damping — *stabilizing* the high-`y`
(small-scale) modes — but `λ²ν→0` (S1 supercriticality), so the damping vanishes in the limit exactly where
the unstable modes concentrate. Viscosity controls the *tail* but not the *core*; the gap must come from the
Euler-profile structure, not from dissipation.

---

## 4. The symmetry zero-modes (the one piece that is clean)

Differentiating the DSS family by its own symmetry parameters yields **exact neutral modes** of `M`
(multiplier `=1`), i.e. the kernel the orthogonality conditions must quotient:

- **scaling:** `(1 + y·∇)Q` — generator of `λ`;
- **translation (3):** `∂_{y_i} Q` — generator of `x₀`;
- **rotation (3):** `(e_j × y)·∇Q − e_j×Q` — generator of `R`;
- (and the `τ`-translation mode `∂_τ Q`, from the autonomy of the period).

`M3` (orthogonality) is therefore concrete and standard *once `Q` exists*: impose `⟨ε, g_k⟩=0` against these
`≤8` generators, which fixes `(λ̇,ẋ₀,Ω,` period-phase`)`. **This is the only M-ingredient that is not
blocked** — and it is blocked-adjacent, since it presupposes M1.

---

## 5. The orientation problem (the honest wall)

Even granting a DSS profile and its Floquet gap, the machinery as set up **constructs**: given `Q` with
finitely many unstable directions, the modulation parameters + a Brouwer/topological argument produce a
solution shadowing `Q` ⇒ a **Type-II singularity** ⇒ a **disproof** of regularity. To serve the **Clay
(exclusion)** direction one would need the opposite — *that no admissible DSS `Q` can arise as a rescaled
limit* — and modulation/Floquet is **not** a non-existence engine. The exclusion of DSS limits, if it
comes, comes from the **ancient-Liouville** line (NS-048 Hole B; the conditional Type-II exclusions
[2304.04045](https://arxiv.org/pdf/2304.04045), [2507.08733](https://arxiv.org/html/2507.08733)), not from
this construction.

**So the disciplined reading of direction 1:** it is a **disproof-side** setup. Its value is (i) it shows
DSS *steps around G3's specific exclusion* (so "no self-similar profile" does not by itself close Type-II),
and (ii) it pins the prerequisite to a sharp, checkable object — **a backward DSS Euler profile** — and a
sharp spectral problem — **the Floquet gap of a nonlocal periodic operator**. It does not advance the prize
in either direction; `:proved`=0.

---

## 6. The program constraints the profile must satisfy (MDAGC on `Q`)

Any admissible backward profile — exact or DSS — must lie in the generator class
(`ns_blowup_generator_class.md`):

- **G2 (≤1-D):** in `y`-variables `Q` must be **filamentary / sheet-like**, not space-filling — its high-`|ω|`
  set is `≤1`-dimensional. A DSS `Q` that thickens period-to-period is inadmissible.
- **S2 (unbounded production):** the rescaled production `𝒫_Q(τ)=∫_y ω_Q·S_Q ω_Q` must be the driver — `Q`
  with bounded rescaled enstrophy and no production growth across a period cannot blow enstrophy.
- **W1 (phase coherence):** the production must be carried by **phase coherence** that **persists across the
  log-period** — a concrete, falsifiable demand on a candidate `Q`: a phase-scramble of `Q` (preserving
  `|Q̂(k)|`) should collapse `𝒫_Q`, and that collapse should recur each period. This is the one place the
  program's own W1 witness gives a *test* a numerical DSS-profile search could run.

---

## 7. The concrete next experiment (research-grade; not run here)

Extend a **dynamic-rescaling numerical search** (à la Hou's near-self-similar axisym NS,
[2405.10916](https://arxiv.org/pdf/2405.10916)) to seek a **backward, boundaryless, `τ`-periodic** (DSS)
axisymmetric Euler profile — i.e. relax the search from a *steady* rescaled state to a *log-periodic* one,
and measure the leading Floquet multipliers of the linearization. **Honest priors:** (i) it may find nothing
(no boundaryless DSS Euler profile — the boundary in Chen–Hou may be essential); (ii) if it finds one, it is
a **disproof candidate**, to be treated with the full vacuity/structured-coherence caution; (iii) numerics
cannot certify either way — they seed analysis. `:proved`=0; distance UNTOUCHED.

**Pointers:** `ns050_modulation_type2_scope.md` (the map, M1–M5); `ns050_modulation_witness_companion.md`
(the within-truncation dynamic-rescaling witness, direction 2); `ns_blowup_generator_class.md` (G2/S2/W1).
