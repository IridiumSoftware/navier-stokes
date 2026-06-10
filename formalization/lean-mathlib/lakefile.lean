/-
  lakefile — NS scaling-criticality, UNIVERSAL (∀-quantified) theorems against Mathlib.

  Opt-in, heavy (pulls Mathlib, multi-GB). The hermetic Lean track at
  `../lean/` (zero deps, `native_decide` at exemplar triples) is the default;
  THIS sub-project upgrades Rung 0 to universally-quantified theorems via
  Mathlib's `linarith`/`norm_num`.

  Pinned to the SAME Mathlib rev + toolchain as the TCE `src/lean4-cv` project
  (Mathlib 5d69f04…, leanprover/lean4 v4.30.0-rc2 — see lake-manifest.json), so
  the populated global Mathlib cache is reused:
      lake exe cache get      # fetch the prebuilt Mathlib oleans (no rebuild)
      lake build              # exits 0 iff ScalingUniversal type-checks
  (This file was verified via `lake env lean` against that built Mathlib.)
-/
import Lake
open Lake DSL

package «ns-scaling-mathlib» where
  leanOptions := #[⟨`autoImplicit, false⟩, ⟨`relaxedAutoImplicit, false⟩]

require mathlib from git
  "https://github.com/leanprover-community/mathlib4.git"

@[default_target]
lean_lib «ScalingUniversal» where
  srcDir := "."

@[default_target]
lean_lib «AxisymUniversal» where
  srcDir := "."

@[default_target]
lean_lib «WeakLp» where
  srcDir := "."

@[default_target]
lean_lib «LittlewoodPaley» where
  srcDir := "."
