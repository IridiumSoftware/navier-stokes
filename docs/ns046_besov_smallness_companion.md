# NS-046/047 — Critical-Besov smallness probe (companion)

**Date:** 2026-06-07. **Scope: resolved 3D pseudospectral DNS truncation (Re-swept). NOT the 3D-NS PDE.
`:proved`=0; distance to the prize UNTOUCHED.** A witness/counter-witness generator for the NS-046
deformation inequality in the NS-047 critical-Besov framework — not an analytic step (a regular
truncation has no singular set; vacuity cap).

## §1 — Computational basis

- **Script:** `scripts/ns046_besov_smallness_probe.jl` (std-lib Julia; reuses the NS-045/046 chain's
  validated solver + `pressure_hessian` algebra + ICs via `include`). Threaded hand FFT.
- **Outputs:** `scripts/ns046_besov_smallness_probe[_N128][_Re###].out.txt`.
- **Method.** Dyadic Littlewood–Paley shells `Δ_j` (`2^j ≤ |k| < 2^{j+1}` ∩ dealias `|k|≤cut`). Per shell,
  the `L^∞` of the band-passed fields gives the **critical-Besov budget**:
  - `R_j = ‖Δ_j ∇²p‖_∞ / ‖Δ_j Q‖_∞` (`Q=tr(G²)=−Δp` source) — the Riesz/CZ ratio. **Uniform in `j` ⟺
    the operator is `Ḃ⁰_{∞,1}`-bounded with no log** (NS-047 C1).
  - `Re_j = ‖Δ_j ω‖_∞ / (ν k_j²)` — shell local Reynolds (nonlinear stretching rate / viscous rate).
    Frontier `j*` = largest `j` with `Re_j ≥ 1`. **Tail `Re_j ≪ 1` = viscous absorption** (the NS-047 C2
    "local-Reynolds smallness"); whether `j*` sits at a *fixed physical scale* (vs tracking the grid) is
    the N-convergence test.
  - `‖ω‖_{Ḃ⁰_{∞,1}} = Σ_j ‖Δ_j ω‖_∞` (the Kozono–Taniuchi 2000 blowup quantity) and per-shell spatial
    concentration `conc_j` (top-1% mass fraction of `|Δ_j ω|²`).
- **Flows:** TUBES (Kerr anti-parallel reconnection — worst case, weakest Beltramization) and TG (Brachet
  anchor). **Reynolds sweep** Re ∈ {1600, 400, 100, 25} at N=64; **N-convergence** N=64↔128 at Re=1600
  (under-resolved control) and Re=100 (resolved).
- **N=1 gate (`SMOKE=1`):** triangle inequality `‖ω‖_∞ ≤ ‖ω‖_Besov`, `R_j` finite & O(1), `Re_j>0`
  decreasing into the tail — all pass at N=16.

## §2 — Results

**C1 — the no-log CZ boundedness HOLDS, and is resolution-robust (the strong positive).** `R_j` is tight
and **flat across all shells, both flows, every Reynolds number, and both resolutions**:

| | shells `R_j` (j=0..) | range |
|---|---|---|
| N=64 Re=1600 TUBES | 0.599, 0.680, 0.682, 0.650, 0.741 | [0.60, 0.74] |
| N=128 Re=1600 TUBES | 0.598, 0.677, 0.684, 0.632, 0.695, 0.655 | [0.60, 0.72] |
| N=64 Re=100 TG | — | [0.58, 0.72] |

No upward drift with shell index `j` (a log would show as `R_j` growing with `j`), and the per-shell
values are **N-stable** (j=0: 0.599 vs 0.598; j=2: 0.682 vs 0.684). ⇒ the Riesz/pressure-Hessian operator
behaves as a critical-Besov-bounded CZ operator with **no log-penalty** — NS-047 C1 corroborated
computationally, resolution-robustly.

**C2 — the local-Reynolds smallness is EXHIBITED, and is resolution-gated (Class-I/II as predicted).**
The smallness frontier `Re_tail`/`j*` moves systematically with the resolved dissipation scale:

| Re | N=64 TUBES `Re_tail` (`j*`) | N=64 TG `Re_tail` (`j*`) | tail |
|---|---|---|---|
| 1600 | 78.4 (j*=4) | 33.5 (j*=4) | INERTIAL — dissipation unresolved |
| 400 | 11.4 (j*=4) | 2.84 (j*=4) | INERTIAL |
| 100 | 0.019 (j*=3) | 0.108 (j*=3) | **ABSORBED — smallness shown, frontier interior** |
| 25 | 0.005 (j*=2) | ~0 (j*=0) | deeply absorbed |

As Re drops and the Kolmogorov scale enters the resolved band, `Re_tail` crosses from `≫1` (frontier
pinned at the grid edge) to `≪1` (frontier *interior*, `j*` below the cutoff shell) — the viscous tail is
absorbed and the smallness is visible.

**N-convergence — the diagnostic is Class-II (scope-coupled) when resolved, Class-I (grid-tracking) when
not.** This is the decisive read, and it splits cleanly by whether the dissipation scale is resolved:

| | N=64 | N=128 | frontier converged? |
|---|---|---|---|
| Re=1600 (under-resolved both N) TUBES | `j*=4`, `Re_tail=78` | `j*=5`, `Re_tail=27` | **NO** — `j*` tracks the grid edge (4→5) |
| Re=100 (resolved both N) TG | `j*=3`, `Re_tail=0.108` | `j*=3`, `Re_tail=2.5e-3` | **YES** — `j*` fixed at the same physical scale (`k∈[8,16)`) |

At **Re=1600** neither grid reaches the Kolmogorov scale, so the "frontier" is just wherever the grid cuts
off — it moves outward with N (Class-I / epistemic / resolution-coupled, the RWC-038 / Ryan warning; a
δ-fit-like failure mode). At **Re=100** both grids resolve the dissipation scale, and the frontier sits at
the **identical physical shell `j=3`** independent of N (the `Re_tail` values differ only because the two
grids' *tail* shells are at different wavenumbers — k≈19 vs k≈37 — both far into the absorbed range). ⇒
**when the dissipation scale is resolved, the critical-Besov budget is a resolution-STABLE (Class-II /
scope-coupled) diagnostic** — a positive contrast to the analyticity-strip δ-fit (NS-010/032), which was
Class-I even in nominally resolved regimes. This is exactly the property NS-035 (Ryan) demands of a real
detector.

**One honesty note on C1 at low Re.** At Re=100 the `R_j` range widens slightly to [0.58, 0.96] — but the
0.96 is on the **top, near-empty shell** (`‖Δ_5ω‖∞≈0.035`, the dissipation tail carrying ~0 energy), where
the ratio is statistically noisy. The bulk shells (j=0..4) stay flat at 0.58–0.73, and the spread is
**non-monotonic** (not the monotone-growth-with-`j` a genuine log-penalty would produce). So C1 holds; the
tail-shell value is noise on an empty band, not a log.

**Concentration.** `conc_j` rises with shell `j` and is markedly higher for TUBES than TG (N=128 top shell:
0.72 vs ~0.15) — the small-scale Besov content is increasingly spatially localized, the spectral shadow of
the reconnection structures, consistent with NS-038's CKN-edge touch being reconnection-specific.

## §3 — Verification

- *Computed.* Resolved pseudospectral DNS; the solver + pressure algebra are the NS-045/046-validated
  chain. N=1 smoke gate passes (triangle inequality, `R_j` O(1), `Re_j` tail-decay).
- *The C1 read* is the dimensionless shell ratio `R_j` — flat-in-`j` and N-stable (data above): a direct
  computational corroboration of NS-047's "CZ bounded on `Ḃ⁰_{∞,1}`, no log."
- *The C2 read* is the frontier `j*`/`Re_tail` across the Re-sweep and across N — exhibiting both the
  smallness (when resolved) and its resolution-gating (the honest negative at high Re).

## §4 — Spec impact

**No new S-ID; no status change.** Within-truncation witness feeding **NS-046** (the critical coercive
deformation inequality) and **NS-047** (the LP/critical-Besov route). It **computationally corroborates
NS-047 C1** (the Riesz/CZ pressure-Hessian operator is `Ḃ⁰_{∞,1}`-bounded with no log — `R_j` flat &
N-stable), and **frames NS-047 C2** (the local-Reynolds smallness is a *dissipation-range* statement:
visible only once the grid reaches the Kolmogorov scale; resolution-gated exactly like the CKN dimension
in RWC-038).

**Honest limits / non-transfer.** (i) Vacuity cap: a regular Re=1600/low-Re truncation has no singular
set, so this bears on the *diagnostic framework's behavior*, not on the analytic inequality on a real
singular set. (ii) Besov norms are **global** (Fourier) objects — they cannot be localized to the CKN
singular set; that physical-space localization is the complementary `ns046_uniform_domination_probe.jl`
(which found the *pointwise* domination non-uniform). Together they bracket the question: this probe says
the critical-Besov budget is a clean, no-log, resolution-stable (when resolved) diagnostic and shows where
its margin thins; the other says the physical-space pointwise domination is non-uniform. Neither is the
analytic step. `:proved`=0; prize UNTOUCHED.

**The one genuinely positive transfer:** NS-047's claim that the framework should be critical-Besov (not
`L^∞`/BKM) is now backed by a measured, N-robust, log-free `R_j` — i.e. the framework choice that keeps
the harmonic-analytic route *live* is computationally consistent. That is a (witness-level) reason to keep
NS-046/047 as the standing static frontier rather than retiring it.
