# Physical Invariants Reference — 3D incompressible Navier–Stokes

**Compiled 2026-05-31, v0.1.0.** Lineage: the same stratified-constraint
discipline as `physical_invariants.md` (closure-v5 `BUSINESS/`, the SM-constants
reference) and `geophysical_invariants.md` (possibilistic-inversion, the tiered
inverse-obstruction constraint set). This file is the **invariant constraint set**
for the NS obstruction program: which quantities any solution *must* respect
(hard), which are regime-dependent phenomenology (soft), and which are the fixed
established facts. Cross-referenced to `SPEC.md` NS-IDs.

The stratification (after the geophysical file):
- **Tier 1 — frame-independent / hard.** True invariants and no-go constraints;
  hold for *every* smooth solution regardless of Reynolds number, forcing, or
  modeling choice. The feasible-set boundary. Used freely.
- **Tier 2 — frame-dependent / convergence targets.** Statistical / phenomeno-
  logical regularities that depend on regime (high-Re, inertial range, a specific
  scenario). **Soft priors only. Using a Tier-2 item as a hard constraint is the
  "anchoring" anti-pattern** — the NS analog of treating K41 as a theorem.
- **Tier 3 — observational / established end.** Proven theorems and known facts;
  the fixed "given" against which the open obstruction question is posed.

Scope: 3D incompressible NS, `∂_t u + (u·∇)u = −∇p + νΔu + f`, `∇·u = 0`, on 𝕋³
or ℝ³. Where a quantity behaves differently for Euler (`ν=0`) or in 2D, that is
stated — those differences are load-bearing.

---

## 1. Tier 1 — Frame-independent / hard (the no-gos any proof must respect)

| Invariant / constraint | Statement | Behavior | SPEC |
|---|---|---|---|
| **Incompressibility** | `∇·u = 0` | exact, all `t` (the constraint defining the equation; enforced by the Leray projection) | NS-001 |
| **Energy (Leray) inequality** | `½‖u(t)‖₂² + ν∫₀ᵗ‖∇u‖₂² ≤ ½‖u₀‖₂² (+forcing)` | **non-increasing** (unforced); the *only* coercive global control | NS-003 |
| **Momentum** | `∫u dx` conserved (unforced, 𝕋³; decays on ℝ³) | exact | — |
| **Scaling symmetry** | `u↦u_λ(x,t)=λu(λx,λ²t)`, `p↦λ²p` solves NS at fixed `ν` | exact structural symmetry — **and the source of supercriticality** (`‖u_λ‖₂²=λ^{-1}‖u‖₂²`) | **NS-002** |
| **Galilean / translation / rotation invariance** | solutions map to solutions under these | exact symmetries | — |
| **Helicity** `H=∫u·ω` | linking of vortex lines | **Euler: conserved (topological).** NS: `dH/dt=−2ν∫ω·(∇×ω)` (decays) | — |
| **Circulation (Kelvin)** `Γ=∮_C u·dl` | around a material loop | **Euler: conserved.** NS: viscously modified | — |
| **Enstrophy** `Ω=∫|ω|²` | — | **2D: `dΩ/dt=−ν∫|∇ω|²≤0` — coercive ⇒ global regularity. 3D: `dΩ/dt=∫ω·(∇u)·ω − ν∫|∇ω|²` — the vortex-stretching term can be positive and unbounded ⇒ NOT coercive.** | NS-004 (via BKM) |
| **Blowup ⇒ unbounded vorticity (BKM)** | smooth past `T` iff `∫₀ᵀ‖ω‖_∞ dt < ∞` | hard criterion any singularity must satisfy | NS-004 |

**The load-bearing reading (the 2D/3D gap is an invariant-tier story).**
The decisive difference between the *solved* 2D problem and the *open* 3D problem
is **which invariants are Tier-1 coercive**:
- In **2D**, enstrophy is a Tier-1 coercive control (no vortex stretching:
  `ω·∇u ≡ 0`), and it sits on the *right* side of the scaling — hence global
  regularity.
- In **3D**, enstrophy drops out of Tier 1 into the **battleground**: vortex
  stretching can amplify it without an a priori bound, and the only surviving
  Tier-1 coercive control is energy — which is **supercritical** (NS-002) and
  therefore useless at small scales. *3D is open precisely because it has one
  fewer coercive Tier-1 invariant than 2D, and the one it keeps is the wrong-
  scaling one.*

---

## 2. Tier 2 — Frame-dependent / convergence targets (phenomenology; soft only)

Regime-dependent statistical regularities. **Never hard constraints.** Promoting
any of these to Tier 1 is the **anchoring anti-pattern** (the NS analog of the
geophysical "Tier-2 clamp").

| Quantity | Typical form | Why frame-dependent |
|---|---|---|
| Kolmogorov K41 spectrum | `E(k) ~ ε^{2/3} k^{−5/3}` (inertial range) | statistical, high-Re, isotropic; not an exact law |
| K41 increment law | `δu(ℓ) ~ (εℓ)^{1/3}` | dimensional; corrected by intermittency |
| Anomalous dissipation ("zeroth law") | `ε → ` finite as `ν→0`, `ε ~ U³/L` | empirically robust but not a theorem for NS; sets the cascade scale |
| Intermittency corrections | multifractal / She–Leveché deviations from K41 exponents | structure-dependent; the open statistical question |
| Reynolds-number transition thresholds | `Re_c` for transition / sustained turbulence | geometry- and perturbation-dependent (cf. the MFE saddle, NS-021) |
| Specific blowup scenarios | Hou–Luo type axisymmetric-with-boundary candidates | conjectural / numerical; not established for the open problem |

**One robust soft kernel.** Among Tier-2 items, the *constant flux through the
inertial range* (Kolmogorov's 4/5 law, `⟨δu_∥³⟩=−⅘εℓ`) is the most robust — it is
*derivable* from NS under homogeneity/isotropy/stationarity, and its exponent is
the root of the Onsager `1/3` (NS-009). Treat the 4/5 **law** as near-Tier-1 (it
has a derivation), the `−5/3` **spectrum** as Tier-2 (statistical).

---

## 3. Tier 3 — Observational / established end (the fixed theorems)

The proven facts; the "given" end of the obstruction question ("given these, what
is forced about the open case?"). All cited in `SPEC.md`.

| Established fact | SPEC |
|---|---|
| **2D NS: global regularity** (smooth ∀t) | (2D control; NS-004 reading) |
| Local-in-time existence + uniqueness of smooth 3D solutions | NS-001 |
| Global Leray–Hopf weak solutions exist (maybe non-unique / non-smooth) | NS-003 |
| Conditional regularity: critical-norm bound ⇒ smooth (Prodi–Serrin–ESS) | NS-005 |
| CKN partial regularity: singular set has parabolic dim ≤ 1 | NS-006 |
| No nontrivial exact self-similar blowup (Nečas–Růžička–Šverák) | NS-007 |
| Averaged-NS blows up ⇒ energy-only methods cannot resolve NS (Tao) | NS-008 |
| Onsager `1/3`: conservation above (CET), dissipative Euler below (Isett, BDLSV) | NS-009 |
| Complex-data 3D NS blows up in finite time (Li–Sinai) | NS-012 |

---

## 4. The tier-confusion / anchoring anti-pattern (NS form = the Scope firewall)

The discipline this file enforces, stated as the failure it prevents — the exact
analog of the geophysical "Tier-2 values used as Tier-1 clamps":

- **Treating Tier-2 phenomenology as Tier-1 no-go.** E.g. assuming K41 scaling, an
  enstrophy bound, or anomalous-dissipation rates *as given* to argue regularity
  or blowup. K41 is a statistical regularity, not a constraint a proof may invoke.
- **Treating a Tier-2 scenario / numerical near-event as a Tier-3 fact.** A
  computed near-blowup in a truncation is `Scope: ODE-truncation` (NS-021), not
  evidence about the PDE. This is `CLAUDE.md`'s Scope firewall, in invariant terms.
- **Our own calibration.** The falsified homology approach (NS-020) failed because
  it sought a *topological* invariant where the binding constraint is the **Tier-1
  scaling symmetry** (supercriticality) — it looked at the wrong invariant. And the
  MFE / autopoietic results (NS-021/023) are Tier-2 phenomenology / a separate
  domain — recorded as such, never promoted.

**Net rule.** Only **Tier-1** invariants may be used as hard constraints in an
obstruction argument; **Tier-3** facts are the fixed observational end; **Tier-2**
is soft prior / target. A result that survives only by leaning on a Tier-2 item is
*regime-dependent*, not *forced* — a finding, not a foundation.

---

## 5. Status / verification flags

- Tier 1 incompressibility / energy inequality / momentum / scaling / symmetries /
  BKM / the 2D-vs-3D enstrophy dichotomy — **unconditional** (standard, cited).
- Helicity & circulation rows — exact for *Euler*; for NS they decay (stated). Do
  not cite as NS conservation laws.
- Tier 2 — all soft; the 4/5 law's near-Tier-1 status rests on its homogeneity/
  isotropy/stationarity derivation (flag if those are not met).
- Tier 3 — proven theorems; page-level citations to be tightened (dashboard
  priority 2) before any write-up.
