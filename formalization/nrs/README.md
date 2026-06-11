# `formalization/nrs/` — the NRŠ H-identity rung (Lean→citation bridge, channel a)

The first firing of the **Lean→citation bridge** (NS-051 / `docs/citation_tiers.md`): walking the
**Nečas–Růžička–Šverák H-identity** — the algebraic core of the G3 self-similar exclusion (NS-007), and the
identity whose original in-repo record carried a transcription error caught by `disproof/nrs_h_identity.py` —
up the verification ladder.

**The corrected identity** (profile eq `−νΔU + aU + a(y·∇)U + (U·∇)U + ∇P = 0`, `div U = 0`;
`H := ½|U|² + P + a(y·U)`):

> `−νΔH + (U·∇)H + a(y·∇)H = −ν|ω|² ≤ 0`   (ω = ∇×U)

— the full self-similar operator **with the drift**, RHS manifestly ≤0 (the maximum principle NRŠ runs
through `H`). The original record was missing the drift term and off by exactly `−3a²ν`.

| Rung | File | Status |
|---|---|---|
| explore / symbolic | `disproof/nrs_h_identity.py` (sympy) | ✅ symbolic reduction to 0 (and the error exposed) |
| **algebraic (Julia, exact)** | `h_identity_exact.jl` (+`.out.txt`) | ✅ **CLOSED** — 200/200 exact `Rational{BigInt}` zeros (Schwartz–Zippel over ℚ) + **false-variant gate**: the original record reproduces its error EXACTLY (`3a²ν`), 200/200 |
| machine (Lean) | — | **HANDED to the formalization track** (the concurrent Lean session); on completion the NRŠ row in `docs/citation_tiers.md` gains a machine-verified core (close-out items vi+vii fire) |

Evidence class: `algebraic`. Scope: an identity of the NRŠ profile *system* — strengthens the **citation**
verification of NS-007/G3; **not** a regularity statement. `:proved`=0; distance UNTOUCHED.
