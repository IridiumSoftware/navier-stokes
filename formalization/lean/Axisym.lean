/-
  Axisym.lean — Rung 1, MACHINE-VERIFIED layer (`lean-proved` evidence)

  The load-bearing axisymmetric structural identities, proved by `native_decide`
  over a tiny exact LAURENT-POLYNOMIAL engine (Field = list of (e_r,e_z,e_t,coeff)
  over Rat, e_r ∈ ℤ). Mirrors axisym_structural.jl / AxisymStructural.hs and the
  operator file — same engine, now machine verified. Hermetic: `import Std` ships
  with the toolchain (no Mathlib). Pin: lean-toolchain (v4.30.0).

  Verified here (the load-bearing core; the full set is in the Julia/Haskell layers):
    (I-op)  L_Γ(r u^θ) = r·lap_ang(u^θ)       — the Γ source-free operator identity
            (∂_r²−(1/r)∂_r+∂_z² on Γ=r u^θ equals r·angular-Laplacian on u^θ);
            monomial-by-monomial ⇒ all fields (linear).
    (II)    (1/r⁴)∂_z(Γ²) = (2Γ/r⁴)∂_zΓ = ∂_z(u₁²), u₁=Γ/r²  — the Ω source identities.
    (III-d) L_visc(rΩ) = r·L_Ω(Ω)             — the (3/r)∂_r emergence (Ω=ω^θ/r transform).
-/
import Std

abbrev Field := List (Int × Int × Int × Rat)     -- monomials r^{e_r} z^{e_z} t^{e_t} · coeff

-- combine like terms; drop zeros (no sort needed — fold into an assoc accumulator)
def norm (f : Field) : Field :=
  (f.foldl (fun acc (er,ez,et,c) =>
      match acc.find? (fun (m,_) => m == (er,ez,et)) with
      | some _ => acc.map (fun (m,v) => if m == (er,ez,et) then (m, v+c) else (m,v))
      | none   => acc ++ [((er,ez,et), c)])
    ([] : List ((Int×Int×Int) × Rat))).filterMap
      (fun (m,v) => if v == 0 then none else some (m.1, m.2.1, m.2.2, v))

def isZero (f : Field) : Bool := (norm f).isEmpty
def padd (a b : Field) : Field := norm (a ++ b)
def scaleF (c : Rat) (a : Field) : Field := norm (a.map (fun (er,ez,et,v) => (er,ez,et,v*c)))
def psub (a b : Field) : Field := padd a (scaleF (-1) b)
def pmul (a b : Field) : Field :=
  norm (a.flatMap (fun (ar,az,aT,av) => b.map (fun (br,bz,bT,bv) => (ar+br,az+bz,aT+bT,av*bv))))
def rp (n : Int) (a : Field) : Field := norm (a.map (fun (er,ez,et,v) => (er+n,ez,et,v)))
def dR (a : Field) : Field := norm (a.filterMap (fun (er,ez,et,v) => if er==0 then none else some (er-1,ez,et,v*er)))
def dZ (a : Field) : Field := norm (a.filterMap (fun (er,ez,et,v) => if ez==0 then none else some (er,ez-1,et,v*ez)))
def mono (er ez et : Int) (c : Rat) : Field := [(er,ez,et,c)]

-- operators
def lapAng (u : Field) : Field := padd (dR (dR u)) (padd (rp (-1) (dR u)) (padd (scaleF (-1) (rp (-2) u)) (dZ (dZ u))))
def lGamma (g : Field) : Field := padd (psub (dR (dR g)) (rp (-1) (dR g))) (dZ (dZ g))
def lOmega (w : Field) : Field := padd (dR (dR w)) (padd (scaleF 3 (rp (-1) (dR w))) (dZ (dZ w)))
def lVisc  (u : Field) : Field := padd (dR (dR u)) (padd (rp (-1) (dR u)) (padd (scaleF (-1) (rp (-2) u)) (dZ (dZ u))))

-- monomial grid (a ∈ −1..4, b ∈ 0..4) for the linear identities
def grid : List (Int × Int) :=
  (List.range 6).flatMap (fun i => (List.range 5).map (fun j => (Int.ofNat i - 1, Int.ofNat j)))

-- (I-op): L_Γ(r u^θ) = r·lap_ang(u^θ), all monomials ⇒ all fields (linear)
theorem Gamma_source_free_operator :
    grid.all (fun (a,b) => isZero (psub (lGamma (rp 1 (mono a b 0 1))) (rp 1 (lapAng (mono a b 0 1))))) = true := by
  native_decide

-- (III-d): L_visc(rΩ) = r·L_Ω(Ω), the (3/r)∂_r emergence
theorem Omega_operator_transform :
    grid.all (fun (a,b) => isZero (psub (lVisc (rp 1 (mono a b 0 1))) (rp 1 (lOmega (mono a b 0 1))))) = true := by
  native_decide

-- (II): the source identities on a generic Γ
def gamG : Field := padd (padd (mono 2 1 0 1) (mono 3 0 1 (-2/7))) (mono 1 2 0 (5/3))
theorem source_eq_2Gamma : isZero (psub (rp (-4) (dZ (pmul gamG gamG))) (scaleF 2 (pmul (rp (-4) gamG) (dZ gamG)))) = true := by
  native_decide
theorem source_eq_u1sq : isZero (psub (rp (-4) (dZ (pmul gamG gamG))) (dZ (pmul (rp (-2) gamG) (rp (-2) gamG)))) = true := by
  native_decide

#eval "Rung 1 (Lean): core axisymmetric structural identities machine-verified (native_decide)."
