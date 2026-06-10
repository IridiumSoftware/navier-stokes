# NS-050 — Modulation theory for the Type-II frontier (scoping map; NOT a result)

**Date:** 2026-06-09. **Status: `:open`, candidate direction — a MAP of the attack shape + verified prior
art + a sub-obstruction checklist for NS-048(c) (the Type-II branch).** `Scope: PDE-analysis`.
**`:proved`=0; distance to the prize UNTOUCHED.** No exclusion, Liouville theorem, construction, or rate
result is claimed here. Theorem statements/scopes are named at the lineage level and **C-tier-flagged**
(don't-bluff rule) — verify before citing as established. This sharpens NS-048's Type-II sub-target the way
`ns_blowup_generator_class.md` sharpened the whole frontier: from "fully open" to "open with a structured
prerequisite list and a precise reason it is hard."

> **The one finding (a genuine compression, §4):** modulation theory is the *construction* engine, and its
> prerequisite — a self-similar profile to modulate around — is **exactly the object the self-similar no-go
> (G3 / NS-007) removes** in the smooth / finite-energy / no-boundary category. So the modulation route to
> Type-II is *naturally a disproof tool* and is blocked before it starts; the Clay (exclusion) direction
> does **not** use modulation at all. This links G3 to the Type-II branch, which the map did not have.

---

## 1. The two engines (modulation is only one of them)

Type-II has two attack lines, and they are not the same tool:

| | engine | mechanism | direction it serves |
|---|---|---|---|
| **Construct** | **modulation / dynamic rescaling** | shadow a (discretely-)self-similar profile `Q`; control the linearized flow via a **spectral gap** + finitely many modulation parameters | **disproves** regularity (build a counterexample) |
| **Exclude** | **ancient-solution Liouville + Euler-scaling** | rescale a hypothetical singularity, show the rescaled limit is trivial | **proves** regularity (the Clay direction) |

**The Clay problem needs the right column.** Modulation lives in the left. This is the first thing to be
honest about: the spectacular recent modulation successes are *constructions*, and a construction for
incompressible NS would be a **disproof of global regularity**, not a proof. Exclusion-via-modulation is
not a standard move and is not known to be available.

---

## 2. The modulation ansatz for incompressible NS (abstract setup)

Write the solution near a putative singularity `(x₀,T)` in **dynamic-rescaling (self-similar) variables**.
With a free scale `λ(t)>0`, center `x₀(t)`, and (optionally) rotation `R(t)∈SO(3)`:

```
  τ = ∫₀ᵗ λ(s)⁻² ds        (rescaled "log" time; τ→∞ as t→T for Type-I-like rates)
  y = R(t)ᵀ (x − x₀(t)) / λ(t)
  u(x,t) = (1/λ(t)) · R(t) · U(y,τ)         (the exact NS scaling, σ=0)
```

Substituting into incompressible NS gives the **rescaled equation** for `U`:

```
  ∂_τ U  =  −P[ (U·∇)U ]  +  (λλ̇)·(1 + y·∇)U  +  ẋ₀-transport  +  Ω_R × U  +  λ² ν ΔU
            └ nonlinearity ┘   └ modulation (scaling) ┘  └ translation ┘ └ rotation ┘ └ viscosity ┘
```

with `P` the Leray projection (the pressure is slaved: `−ΔP_press = ∂_iU_j ∂_jU_i`). The **modulation
parameters** `(λ,x₀,R)` are then fixed by **orthogonality conditions** — demand the remainder
`ε = U − Q` be orthogonal to the symmetry directions (the generators of scaling/translation/rotation acting
on the profile `Q`). That is exactly enough constraints to pin `(λ̇,ẋ₀,Ω_R)` as **modulation ODEs**, whose
leading term gives the blow-up rate.

**The targets:**
- **exact self-similar** ⟺ `U` is `τ`-independent (a steady profile `Q` of the rescaled equation) with
  `λλ̇ = −1/2` (the `(T−t)^{1/2}` rate). **Killed in `L³` by NRŠ = our G3.**
- **discretely self-similar (DSS)** ⟺ `U(y,τ)` is **periodic in `τ`** (period `log μ`) — a log-time-periodic
  solution of the rescaled equation. *Not* killed by G3 (G3 excludes the exact-self-similar profile, not the
  log-periodic one). This is the natural object for §6-direction-1, developed in `ns050_dss_modulation.md`.
- **Type-II** ⟺ a degeneracy in the scaling modulation ODE (`λλ̇ → 0` slower than self-similar), typically
  yielding a **log-corrected rate** `λ(t) ∼ (T−t)^{1/2}/|log(T−t)|^α`. This is what the viscous correction
  produces when it shadows an inviscid self-similar core (the MRRS mechanism, §3).

The whole method then rests on the **linearized operator** `L = D𝓕(Q)` (the rescaled RHS linearized at the
profile): a **non-self-adjoint, nonlocal** (Leray-projected, pressure-coupled) operator. Modulation works iff
`L` has a usable spectral structure: a few unstable modes (killed by the modulation parameters / a
topological argument), the neutral symmetry modes (killed by orthogonality), and a stable remainder
(**spectral gap**). See the M1–M5 checklist (§5).

---

## 3. Verified prior art — where modulation has and has not cracked fluid blowup

(C-tier flags: C1 = named/abstract from the literature, not line-verified here.)

| work | equation | profile / regularity | role of modulation | transfers to incompressible smooth NS? |
|---|---|---|---|---|
| **Merle–Raphaël–Rodnianski–Szeftel** ([1912.11009](https://arxiv.org/abs/1912.11009); [Annals 2022 I](https://annals.math.princeton.edu/2022/196-2/p03)/[II](https://www.ljll.fr/szeftel/fluids-final-part2.pdf); non-radial [2310.05325](https://arxiv.org/pdf/2310.05325)) | **compressible** Euler & NS | smooth self-similar imploding profile at **quantized** speeds + **spectral-gap** of the linearized flow | the core engine; the **NS** singularities they build are **Type-II** (viscous shadow of an inviscid self-similar core) | **No** — implosion needs *density*; incompressible has none. **C1** |
| **Elgindi** ([Annals of PDE](https://link.springer.com/article/10.1007/s40818-025-00214-2); orig. 2019) | 3D axisym **Euler**, no swirl | `C^∞(ℝ³∖{0})∩C^{1,α}∩L²` — **degraded** (Hölder gradient) | self-similar profile + stability | profile exists only at **low regularity**; not the smooth Clay category. **C1** |
| **Chen–Hou** ([2210.07191](https://arxiv.org/abs/2210.07191) Analysis; [2305.05660](https://arxiv.org/abs/2305.05660) Rigorous Numerics; SIAM MMS) | 2D Boussinesq & 3D axisym **Euler**, **with boundary**, **smooth** data | numerically-constructed approximate self-similar profile | **nonlinear stability in the dynamic-rescaling equations** = modulation made rigorous (interval arithmetic) | profile needs a **boundary** (Hou–Luo geometry); not the boundaryless Clay setting. **C1** |
| stability of Elgindi's profile ([2206.01296](https://arxiv.org/abs/2206.01296), CMP 2024) | 3D Euler / 2D Boussinesq | `C^{1,α}` singular solutions | stability/instability analysis | same `C^{1,α}` degradation. **C1** |
| **Type-II EXCLUSION** ([2304.04045](https://arxiv.org/pdf/2304.04045); [2507.08733](https://arxiv.org/html/2507.08733)) | **incompressible** NS | — | **none** — uses **ancient-Euler Liouville + Euler-scaling + generalized LPS** | *this* is the Clay-direction line; **conditional, scenario-specific.** = NS-048 Hole-B machinery. **C1** |
| near-self-similar numerics ([Hou, 2405.10916](https://arxiv.org/pdf/2405.10916)) | generalized axisym **NS** | numerical near-self-similar profile | dynamic rescaling (numerical) | a candidate **seed** for a DSS profile (§6-1). **C1 / numerical** |

**Pattern:** every modulation *construction* success is (i) **compressible** (MRRS), or (ii) **Euler not
NS**, or (iii) **degraded regularity** (`C^{1,α}`), or (iv) **with boundary** (Chen–Hou). The clean
incompressible-NS / smooth / finite-energy / no-boundary profile — the Clay category — is **absent**. The
*exclusion* line for incompressible NS exists but does **not** use modulation; it uses the ancient-Liouville
machinery the program already tracks in NS-048.

---

## 4. The finding: modulation's prerequisite is what G3 deletes

A modulation construction needs a **profile `Q`** to modulate around. The verified landscape (§3) says: in
the smooth / finite-energy / no-boundary incompressible category, **no such `Q` is known, and the cleanest
candidate (exact self-similar) is exactly what G3 / NS-007 (Nečas–Růžička–Šverák + Tsai) excludes.** Two
consequences, both new to the map:

1. **The construction route is blocked at the G3 wall.** G3 was logged as a Type-I constraint (no
   self-similar ancient solution). It *also* removes the seed a modulation construction would need — so G3
   constrains the Type-II construction route too. The only escapes are the degradations the literature
   actually used: lower regularity (`C^{1,α}`, Elgindi) or a boundary (Chen–Hou) — neither admissible for
   Clay. **The honest open sub-question:** does a **DSS** (log-periodic) profile survive where the exact
   self-similar one dies? G3 does not obviously kill DSS. → `ns050_dss_modulation.md` (direction 1).
2. **Incompressibility removes the MRRS mechanism.** MRRS's Type-II NS singularity rides an *imploding*
   compressible self-similar core; implosion is a *density* phenomenon. Incompressible NS has `ρ=const`
   (cf. the material-cause trivialization in `ns_efficient_closure_categorical.md` §3) — there is **no
   implosion to shadow.** The MRRS template does not transfer; the analogy ends at "modulation around a
   self-similar core."

**Net (the compression):** modulation theory clarifies *why* Type-II is hard rather than supplying a route.
For the disproof direction it is blocked at the missing smooth profile (= the G3 wall + no implosion); for
the Clay (proof) direction it is the wrong tool, and the right tool (ancient-Liouville) is already the open
NS-048 Hole B. This is a **map of an assumption-wall**, not progress — `:proved`=0.

---

## 5. Sub-obstruction checklist (M1–M5 — what a Type-II modulation analysis needs, and its status)

| | ingredient | status for incompressible smooth NS |
|---|---|---|
| **M1** | a **profile `Q`** (self-similar or DSS solution of the rescaled equation) | **MISSING.** Exact self-similar killed by G3; only `C^{1,α}` (Elgindi) or with-boundary (Chen–Hou) known. **DSS untested** (direction 1). |
| **M2** | the **linearized operator `L=D𝓕(Q)`** and its **spectrum / spectral gap** | unavailable — depends on M1; `L` is non-self-adjoint + nonlocal (Leray/pressure); spectrum unknown. Dissipation `λ²νΔ` is *stabilizing* but `→0` at the singular scale (supercriticality, S1). |
| **M3** | **orthogonality / normalization** conditions killing the neutral symmetry modes | standard *once* M1/M2 exist (scaling/translation/rotation generators). |
| **M4** | control of the **finitely many unstable modes** (topological/Brouwer for construct; impossibility for exclude) | unaddressed; orientation depends on construct-vs-exclude. |
| **M5** | the **remainder coercivity** estimate (`ε` stays small) | unaddressed; needs M2's gap. |

The chain is gated at **M1**. Everything downstream is conditional on a profile that, in the Clay category,
is not known to exist and is partly excluded (G3).

---

## 6. The three live sub-directions

1. **DSS profile + modulation** (`ns050_dss_modulation.md`, direction (b)). Replace exact self-similar with
   **discretely self-similar** (log-`τ`-periodic). G3 does not kill DSS. Set up the log-periodic ansatz and
   the linearized-operator/spectral-gap question; identify Hou's numerical near-self-similar axisym NS
   ([2405.10916](https://arxiv.org/pdf/2405.10916)) as the candidate seed.
2. **Dynamic-rescaling WITNESS** (`ns050_modulation_witness_*`, direction (c)). On a resolved near-singular
   fixture, test the decomposition `u ≈ λ(t)⁻¹ Q(y)`: does the flow organize as a fixed profile carried by a
   drifting scale `λ(t)`, and what is `λ̇/λ`? **Within-truncation** (vacuity cap — a resolved flow has no
   singular limit); it witnesses *structure*, never certifies. Calibrated on a model with known self-similar
   blow-up first (N=1).
3. **Constrain `Q` by the generator class.** Any admissible Type-II profile must satisfy **G2** (≤1-D
   concentrated), **S2** (unbounded production `∫ω·Sω`), **W1** (small-scale phase coherence). Intersect
   these onto the modulation profile — a "what must `Q` be" object, MDAGC applied to the seed.

---

## 7. Honest scope + spec impact

**Reorganization + a literature engagement, not progress.** The single deliverable is the **compression**
(§4: modulation is a disproof engine blocked at the G3 wall; the Clay direction needs ancient-Liouville, not
modulation) and the **M1–M5 checklist** that turns NS-048(c) from "fully open" into a gated prerequisite
list. Whether this is genuine compression or coherent narrative is decided by independent uptake
(structured-local-coherence hazard, accepted).

**Over-reach caps.** (1) No claim that DSS profiles exist or that modulation can exclude — only that DSS
*evades G3's specific exclusion* and is therefore worth setting up. (2) The within-truncation witness (§6-2)
cannot reach the singular limit; any organization it sees is heuristic. (3) Prior-art scopes are C1 —
verify before citing as established.

**Proposed spec entry (for the user's call — not yet written to `SPEC.md`):**
`NS-050 — Modulation/dynamic-rescaling map of the Type-II frontier. Logic: framing/reduction.
Evidence: manual (map) + external-spec-reference (prior art, C1). Status: :open. Depends_on:
NS-007 (G3), NS-048 (dynamic frontier), NS-002/036 (S1/S2). Scope: PDE-analysis.`

**Pointers:** `ns048_exclusion_frontier.md` (the dynamic frontier this sub-targets);
`ns_blowup_generator_class.md` (G3, S2, W1 the profile must satisfy); `ns050_dss_modulation.md` (direction
1); `ns050_modulation_witness_companion.md` (direction 2).
