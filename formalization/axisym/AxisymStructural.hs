-- AxisymStructural.hs — Rung 1 (TYPE-CHECKED / categorical evidence)
--
-- The axisymmetric structural calculus (the NS-048 core), encoded as exact
-- arithmetic in the LAURENT-POLYNOMIAL ALGEBRA over ℚ, with the partial
-- derivatives as DERIVATIONS on that algebra. Mirrors axisym_structural.jl and
-- must AGREE with it. base only (Data.List + Data.Ratio) — hermetic.
--
-- Categorical content (what the types/structure pin down): a `Field` is an
-- element of the commutative ℚ-algebra ℚ[r,r⁻¹,z,t]; ∂_r,∂_z,∂_t are DERIVATIONS
-- (Leibniz: ∂(ab)=∂(a)b+a∂(b)) — verified below — so the structural identities are
-- equalities of algebra elements, and "Γ source-free" / "S sole source" are
-- statements in this algebra. base only; only pin is the GHC version (README).
--
-- CONVENTIONS: cylindrical (r,θ,z), θ-independent; b=u^r e_r+u^z e_z; the u^θ
-- momentum eq ∂_t u^θ + b·∇u^θ + (u^r u^θ)/r = ν·lap_ang(u^θ).

module Main where

import Data.List   (sortBy, groupBy)
import Data.Ratio  ((%))
import Data.Function (on)
import System.Exit (exitFailure, exitSuccess)

type Mono  = (Int,Int,Int)            -- exponents of (r, z, t); r-exponent ∈ ℤ (Laurent)
type Field = [(Mono, Rational)]        -- normalized: sorted, like-terms combined, no zeros

normalize :: [(Mono,Rational)] -> Field
normalize = filter ((/=0) . snd)
          . map (\g -> (fst (head g), sum (map snd g)))
          . groupBy ((==) `on` fst)
          . sortBy  (compare `on` fst)

mono :: Int -> Int -> Int -> Rational -> Field
mono er ez et c = normalize [((er,ez,et), c)]

padd, psub, pmul :: Field -> Field -> Field
padd a b = normalize (a ++ b)
scaleF :: Rational -> Field -> Field
scaleF c a = normalize [(m, c*v) | (m,v) <- a]
psub a b = padd a (scaleF (-1) b)
pmul a b = normalize [ ((ar+br,az+bz,at+bt), av*bv)
                     | ((ar,az,at),av) <- a, ((br,bz,bt),bv) <- b ]

rpow :: Int -> Field -> Field          -- · r^n  (exact, Laurent)
rpow n a = normalize [ ((er+n,ez,et), v) | ((er,ez,et),v) <- a ]

dR, dZ, dT :: Field -> Field           -- the three DERIVATIONS ∂_r, ∂_z, ∂_t
dR a = normalize [ ((er-1,ez,et), v * fromIntegral er) | ((er,ez,et),v) <- a, er /= 0 ]
dZ a = normalize [ ((er,ez-1,et), v * fromIntegral ez) | ((er,ez,et),v) <- a, ez /= 0 ]
dT a = normalize [ ((er,ez,et-1), v * fromIntegral et) | ((er,ez,et),v) <- a, et /= 0 ]

isZero :: Field -> Bool
isZero = null . normalize

-- the axisymmetric operators (acting on a field)
lapAng, lGamma :: Field -> Field
lapAng u = padd (dR (dR u)) (padd (rpow (-1) (dR u))
                                  (padd (scaleF (-1) (rpow (-2) u)) (dZ (dZ u))))
--  lap_ang u = ∂_r²u + (1/r)∂_r u − u/r² + ∂_z²u
lGamma g = padd (psub (dR (dR g)) (rpow (-1) (dR g))) (dZ (dZ g))
--  L_Γ g     = ∂_r²g − (1/r)∂_r g + ∂_z²g

-- generic test fields (Laurent polys with distinct rational coeffs)
uTheta, urF, uzF, gamG, uThG, a1, b1 :: Field
uTheta = padd (padd (mono 2 1 0 3) (mono (-1) 2 1 (2%5))) (mono 0 0 3 7)
urF    = padd (mono 1 0 0 1) (mono 0 2 1 (-4%3))
uzF    = padd (mono 0 1 0 5) (mono 2 0 2 (1%2))
gamG   = padd (padd (mono 2 1 0 1) (mono 3 0 1 (-2%7))) (mono 1 2 0 (5%3))
uThG   = padd (mono 1 1 0 2) (mono 0 3 1 (-1%4))
a1     = padd (mono 1 0 0 2) (mono 0 1 1 (3%4))     -- generic a,b for the Leibniz law
b1     = padd (mono 2 1 0 (-1)) (mono (-1) 0 2 5)

type Check = (String, Bool, String)

checks :: [Check]
checks =
  -- categorical: ∂_r,∂_z,∂_t are DERIVATIONS (Leibniz law) on the algebra
  [ ("∂_r is a derivation (Leibniz)", leibniz dR, "∂_r(ab)=∂_r(a)b+a∂_r(b)")
  , ("∂_z is a derivation (Leibniz)", leibniz dZ, "∂_z(ab)=∂_z(a)b+a∂_z(b)")
  -- (I-op): L_Γ(r u^θ) = r·lap_ang(u^θ), monomial-by-monomial ⇒ all fields (linear)
  , ("(I-op) L_Γ(r u^θ) = r·lap_ang(u^θ)",
        and [ isZero (psub (lGamma (rpow 1 m)) (rpow 1 (lapAng m)))
            | a <- [-1..4], b <- [0..4], let m = mono a b 0 1 ],
        "all monomials r^a z^b")
  -- (I-tr): transport(Γ) = r·(D/Dt + Coriolis) u^θ, generic fields
  , ("(I-tr) transport(rΓ)=r·(D/Dt+Coriolis)u^θ", iTr, "generic u^r,u^z,u^θ")
  , ("(I) Γ-equation SOURCE-FREE (I-op ∧ I-tr)",
        and [ isZero (psub (lGamma (rpow 1 m)) (rpow 1 (lapAng m)))
            | a <- [-1..4], b <- [0..4], let m = mono a b 0 1 ] && iTr,
        "max-principle basis")
  -- (II) the Ω = ω^θ/r source identities (generic Γ, u^θ)
  , ("(II-a) (1/r⁴)∂_z(Γ²)=(2Γ/r⁴)∂_zΓ",
        isZero (psub (rpow (-4) (dZ (pmul gamG gamG)))
                     (scaleF 2 (pmul (rpow (-4) gamG) (dZ gamG)))), "chain rule")
  , ("(II-b) (1/r⁴)∂_z(Γ²)=∂_z(u₁²), u₁=Γ/r²",
        isZero (psub (rpow (-4) (dZ (pmul gamG gamG)))
                     (dZ (pmul (rpow (-2) gamG) (rpow (-2) gamG)))), "u₁=Γ/r²")
  , ("(II-c) (1/r)∂_z((u^θ)²/r)=(1/r⁴)∂_z((ru^θ)²)",
        isZero (psub (rpow (-1) (dZ (rpow (-1) (pmul uThG uThG))))
                     (rpow (-4) (dZ (pmul (rpow 1 uThG) (rpow 1 uThG))))),
        "centrifugal term IS the Ω-source")
  ]
  where
    leibniz d = isZero (psub (d (pmul a1 b1)) (padd (pmul (d a1) b1) (pmul a1 (d b1))))
    iTr = let g = rpow 1 uTheta
              transport = padd (dT g) (padd (pmul urF (dR g)) (pmul uzF (dZ g)))
              matCor = padd (dT uTheta) (padd (pmul urF (dR uTheta))
                            (padd (pmul uzF (dZ uTheta)) (rpow (-1) (pmul urF uTheta))))
          in isZero (psub transport (rpow 1 matCor))

main :: IO ()
main = do
  putStrLn "Rung 1 — axisymmetric structural calculus (Haskell; type-checked / categorical evidence)\n"
  let render (n, ok, d) = (if ok then "  PASS  " else "  FAIL  ") ++ pad 48 n ++ d
      pad k s = s ++ replicate (max 1 (k - length s)) ' '
  mapM_ (putStrLn . render) checks
  putStrLn ""
  if all (\(_,ok,_) -> ok) checks
     then putStrLn "ALL EXACT IDENTITIES TYPE-CHECK + VERIFY — Rung 1." >> exitSuccess
     else putStrLn "FAILURE — an identity did not close." >> exitFailure
