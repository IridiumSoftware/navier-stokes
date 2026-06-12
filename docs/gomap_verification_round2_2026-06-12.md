# Go-Map verification — round 2 (the ancient-Liouville wave + the NS-053 instruments) — 2026-06-12

**The cross-repo verification artifact for the second Grok wave** (A7 pattern, same protocol as round 1
`docs/gomap_verification_2026-06-12.md`): GO-013..017 (the ancient-Liouville opportunities wave) +
GO-023/024/025 (the NS-053 continuation instruments cited by the merged NS-053 SPEC entry — this round
clears that entry's "re-verification pending" flag for what passes). **substrate_source: `grok-test@8e0e066`**
(clean tree at re-run time). `:proved`=0; every row Scope ≠ PDE; distance UNTOUCHED.

## Protocol

All Python probes (stdlib) + both Julia probes re-run on this machine (`NS_REPO` read-only includes);
outputs overwrite in place; **`git diff` vs the pin grades reproduction** (empty diff = byte-identical).
The two Lean halves (GO-014's `AxisymColumnarBridge.lean`, GO-016's `CarlemanEssBridge.lean`) are
**NOT re-verified** — their verify-scripts invoke `lean` through the symlinked **live** navier-stokes
Lean directory (the round-1 `.lake` hazard; the concurrent Carleman session is active) — recorded as
grok-claimed (LEAN_EXIT=0 logs committed in grok-test), pending an isolated build. GO-018..021 remain
queued (nothing to verify).

## Results — ALL NINE BYTE-IDENTICAL (the strongest grade, across the whole wave)

| GO | Claim (as ledgered in grok-test) | Re-run | Grade |
|---|---|---|---|
| GO-013 | saturating `\|x₃\|^α` ancient candidate **fails** necessary conditions (LIVE — conjecture survives) | exit 0 | **byte-identical** |
| GO-014 | columnar collapse `S≡0 ⇒ Γ≡0` holds in the tested class (Python half) | exit 0 | **byte-identical** |
| GO-015 | CLM/HL modulation clocks pass the Type-I `I<∞` proxies | exit 0 | **byte-identical** |
| GO-016 | ESS-Carleman bridge witness (statement tier; Python half) | exit 0 | **byte-identical** |
| GO-017 | blow-down scaling calculator **reproduces the route-i exponents** | exit 0 | **byte-identical** |
| GO-023 (py + HL jl) | Hou n-proxy kill #1 (CLM min n≈2.75; HL n_obs→1.09) | exit 0 ×2 | **byte-identical** |
| GO-024 | α-only continuation: transition ≈1.08, precedes the 5/4 rail | exit 0 | **byte-identical** |
| GO-025 | kill #2 panel: TG/HL @1.07 vs CLM @1 gaps 0.55/0.26 — not met | exit 0 | **byte-identical** |

Every output rewritten in place at re-run time (mtimes confirmed fresh) with `git diff` empty against the
`8e0e066` pin — deterministic stdlib/seeded code reproducing exactly on this machine.

## Claim-level notes (what each verdict means for this ledger)

- **GO-013 (LIVE — the saturating `|x₃|^α` ancient candidate FAILS necessary conditions):** supports the
  in-repo port-conjecture's survival (the candidate route to *falsifying* it is blocked at witness level);
  complements `ns048_anisotropic_z_port.md` §3.
- **GO-014 (LIVE — columnar collapse holds in the tested class):** numerically supports the in-repo C8
  columnar reduction (`S≡0 ⇒ Γ≡0` through the coupled dynamics in the tested class) — the Lean half
  (AxisymColumnarBridge) is the unverified part.
- **GO-015 (LIVE — CLM/HL clocks pass the Type-I `I<∞` proxies):** connects the modulation clocks to the
  Albritton–Barker class — relevant to litmap §4.1; proxy-level only.
- **GO-016 (LIVE, statement-tier):** the ESS-Carleman bridge witness — the Python half only; the Lean half
  unverified (hazard). Connects to the litmap §4.1 Carleman-synergy note.
- **GO-017 (LIVE — the blow-down scaling calculator reproduces the route-i exponents):** an INDEPENDENT
  reproduction of this repo's route-i breaks (`Γ_λ` amplification `λ^{1−α}`; the LZZ-vs-axial contrast) —
  a genuine cross-code check of `ns048_route_i_blowdown.md` §3.
- **GO-023 (`:falsified` — the Hou n-proxy kill #1) + GO-024 (LIVE — α transition ≈1.08) + GO-025 (LIVE —
  kill #2 not met; gaps 0.55/0.26):** the grok-side witnesses of the merged NS-053 entry; verification
  here clears the entry's pending flag for these (the Lean-free parts).

## Catches / flags

**No new catches this round** — the wave reproduces exactly, and its claims were ledgered with honest
scope tags. Standing flags only: (1) the **two Lean halves remain unverified** (the `.lake` hazard;
isolated build still pending); (2) GO-015's Type-I check is **proxy-level** (a scaled-energy surrogate,
not the AB `I` functional — fine as ledgered, do not over-cite); (3) GO-024/025's α≈1.07–1.08 transition
uses the **rigidity/stability instrument**, distinct from the navier-stokes blow-up/decay bisection
(α*_eff(ν=0.2)≈0.93) — the two bracket the asymptotic α*=1 and **must not be conflated as one number**.

**Cross-code confirmations gained for in-repo work:** GO-017 independently reproduces the route-i
blow-down breaks (`ns048_route_i_blowdown.md` §3); GO-014 numerically supports the C8 columnar
reduction; GO-015 ties the modulation clocks to the litmap §4.1 (Albritton–Barker) edge.

## Firewall

Witness-tier throughout; the Lean halves stay explicitly unverified pending an isolated grok-test build
(the standing `.lake` hazard). `:proved`=0; distance UNTOUCHED.
