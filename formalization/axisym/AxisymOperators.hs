-- AxisymOperators.hs — Rung 1 completion (TYPE-CHECKED / categorical evidence)
--
-- The Ω = ω^θ/r evolution operator (ω^θ → Ω transform) + the Biot–Savart elliptic
-- operator, in the exact Laurent-polynomial algebra over ℚ. Mirrors
-- axisym_operators.jl and must AGREE with it. base only — hermetic.
--   (III) ω^θ → Ω: stretching (u^r/r)ω^θ cancels; viscous operator
--         ∂_r²+(1/r)∂_r−1/r²+∂_z² → ∂_r²+(3/r)∂_r+∂_z²; source → S=(1/r⁴)∂_z(Γ²);
--         pressure dropped because ∂_z,∂_r commute (derivations on a commutative algebra).
--   (IV)  Biot–Savart: ω^θ = −(∂_r²+(1/r)∂_r−1/r²+∂_z²)ψ; ∇·b = 0 identically.

module Main where

import Data.List   (sortBy, groupBy)
import Data.Ratio  ((%))
import Data.Function (on)
import System.Exit (exitFailure, exitSuccess)

type Mono  = (Int,Int,Int)
type Field = [(Mono, Rational)]

normalize :: [(Mono,Rational)] -> Field
normalize = filter ((/=0) . snd)
          . map (\g -> (fst (head g), sum (map snd g)))
          . groupBy ((==) `on` fst) . sortBy (compare `on` fst)

mono :: Int -> Int -> Int -> Rational -> Field
mono er ez et c = normalize [((er,ez,et), c)]
padd, psub, pmul :: Field -> Field -> Field
padd a b = normalize (a ++ b)
scaleF :: Rational -> Field -> Field
scaleF c a = normalize [(m, c*v) | (m,v) <- a]
psub a b = padd a (scaleF (-1) b)
pmul a b = normalize [ ((ar+br,az+bz,at+bt), av*bv) | ((ar,az,at),av)<-a, ((br,bz,bt),bv)<-b ]
rpow :: Int -> Field -> Field
rpow n a = normalize [ ((er+n,ez,et), v) | ((er,ez,et),v) <- a ]
dR, dZ, dT :: Field -> Field
dR a = normalize [ ((er-1,ez,et), v * fromIntegral er) | ((er,ez,et),v)<-a, er/=0 ]
dZ a = normalize [ ((er,ez-1,et), v * fromIntegral ez) | ((er,ez,et),v)<-a, ez/=0 ]
dT a = normalize [ ((er,ez,et-1), v * fromIntegral et) | ((er,ez,et),v)<-a, et/=0 ]
isZero :: Field -> Bool
isZero = null . normalize

lVisc, lOmega :: Field -> Field
lVisc u = padd (dR (dR u)) (padd (rpow (-1) (dR u))
                                 (padd (scaleF (-1) (rpow (-2) u)) (dZ (dZ u))))
lOmega w = padd (dR (dR w)) (padd (scaleF 3 (rpow (-1) (dR w))) (dZ (dZ w)))

-- generic test fields
omg, urF, uzF, pp, uTh, psF :: Field
omg = padd (padd (mono 2 1 0 3) (mono (-1) 2 1 (2%5))) (mono 1 0 2 7)
urF = padd (mono 1 0 0 1) (mono 0 2 1 (-4%3)); uzF = padd (mono 0 1 0 5) (mono 2 0 1 (1%2))
pp  = padd (padd (mono 2 1 0 4) (mono 1 3 1 (-5%3))) (mono 0 0 2 9)
uTh = padd (mono 1 1 0 2) (mono 0 3 1 (-1%4))
psF = padd (padd (mono 3 1 0 2) (mono 1 2 1 (-3%7))) (mono 2 0 2 (5%6))

gam :: Field
gam = rpow 1 uTh

type Check = (String, Bool, String)
checks :: [Check]
checks =
  [ ("(III-a) ∂_z∂_r p = ∂_r∂_z p", isZero (psub (dZ (dR pp)) (dR (dZ pp))),
        "pressure drops from the curl")
  , ("(III-b) ∂_z((u^θ)²/r) = (1/r³)∂_z(Γ²)",
        isZero (psub (dZ (rpow (-1) (pmul uTh uTh))) (rpow (-3) (dZ (pmul gam gam)))),
        "centrifugal → ω^θ source")
  , ("(III-c) stretching cancels: LHS = r(∂_t+b·∇)Ω", iIIIc, "(u^r/r)ω^θ vanishes under ω^θ=rΩ")
  , ("(III-d) L_visc(rΩ)=r·L_Ω(Ω) [(3/r)∂_r]",
        and [ isZero (psub (lVisc (rpow 1 m)) (rpow 1 (lOmega m)))
            | a<-[-1..4], b<-[0..4], let m = mono a b 0 1 ], "all monomials")
  , ("(III-e) (1/r)(1/r³)∂_z(Γ²)=(1/r⁴)∂_z(Γ²)=S",
        isZero (psub (rpow (-1) (rpow (-3) (dZ (pmul gam gam)))) (rpow (-4) (dZ (pmul gam gam)))),
        "Ω=ω^θ/r divide")
  , ("(IV-a) ω^θ = −(∂_r²+(1/r)∂_r−1/r²+∂_z²)ψ",
        and [ let urp = scaleF (-1) (dZ m)              -- u^r=−∂_zψ
                  uzp = rpow (-1) (dR (rpow 1 m))       -- u^z=(1/r)∂_r(rψ)
                  wm  = psub (dZ urp) (dR uzp)          -- ω^θ
              in isZero (psub wm (scaleF (-1) (lVisc m)))
            | a<-[-1..4], b<-[0..4], let m = mono a b 0 1 ], "stream function → ω^θ")
  , ("(IV-b) ∇·b = ∂_r u^r + u^r/r + ∂_z u^z = 0", ivb, "stream function ⇒ divergence-free")
  ]
  where
    iIIIc = let wth = rpow 1 omg
                lhs = psub (padd (dT wth) (padd (pmul urF (dR wth)) (pmul uzF (dZ wth))))
                           (rpow 0 (pmul urF omg))                 -- −(u^r/r)·rΩ = −u^rΩ
                rhs = rpow 1 (padd (dT omg) (padd (pmul urF (dR omg)) (pmul uzF (dZ omg))))
            in isZero (psub lhs rhs)
    ivb = let urp = scaleF (-1) (dZ psF); uzp = rpow (-1) (dR (rpow 1 psF))
              divb = padd (dR urp) (padd (rpow (-1) urp) (dZ uzp))
          in isZero divb

main :: IO ()
main = do
  putStrLn "Rung 1 completion — Ω-operator + Biot–Savart (Haskell; type-checked / categorical evidence)\n"
  let render (n, ok, d) = (if ok then "  PASS  " else "  FAIL  ") ++ pad 46 n ++ d
      pad k s = s ++ replicate (max 1 (k - length s)) ' '
  mapM_ (putStrLn . render) checks
  putStrLn ""
  if all (\(_,ok,_) -> ok) checks
     then putStrLn "ALL EXACT IDENTITIES TYPE-CHECK + VERIFY — Rung 1 completion." >> exitSuccess
     else putStrLn "FAILURE — an identity did not close." >> exitFailure
