-- Scaling.hs — Rung 0 of the formalization ladder (TYPE-CHECKED / categorical evidence)
--
-- The Navier–Stokes scaling-criticality calculus, encoded in TYPES. The point of
-- this rung (vs the Julia algebraic rung) is definitional precision: the norm
-- TAXONOMY is a total sum type, the scaling exponent is a total function on it,
-- and criticality is the (kernel-structured) classification of the exponent. If
-- the structure were inconsistent it would not type-check; the value-level checks
-- then verify the same EXACT rational identities Julia did, plus one cross-family
-- coherence the types make explicit (Ḣ⁰ = L²). base only (Data.Ratio), hermetic.
--
-- CONVENTIONS (declared, identical to scaling_criticality.jl):
--   u_λ(x,t) = λ^f u(λx, λ²t);  ‖u_λ‖_X = λ^[X] ‖u‖_X;
--   critical ⇔ [X]=0 ; subcritical ⇔ [X]>0 ; supercritical ⇔ [X]<0 (NS-002).

module Main where

import Data.Ratio (Rational, (%))
import System.Exit (exitFailure, exitSuccess)

-- A Lebesgue exponent is a finite rational or ∞ (with the convention 1/∞ = 0).
data LebExp = Fin Rational | Inf  deriving (Eq, Show)

invExp :: LebExp -> Rational            -- 1/p with 1/∞ = 0
invExp Inf      = 0
invExp (Fin p)  = 1 / p

-- The norm taxonomy as a total sum type (this is the "definition" pinned by types).
data Norm
  = LebesgueW { fieldPow :: Rational      -- field scaling power f (1 for velocity)
              , weight   :: Rational      -- axial weight α in |x₃|^α
              , pSpace   :: LebExp        -- spatial Lebesgue p
              , qTime    :: LebExp }      -- time Lebesgue q
  | Sobolev   { fieldPow :: Rational
              , sIndex   :: Rational }    -- homogeneous Ḣ^s
  deriving (Eq, Show)

-- The scaling exponent [X] (lives in the additive group (ℚ,+)). Total on Norm.
-- Lebesgue:  [‖|x₃|^α u‖_{L^q_t L^p_x}] = f − α − 3/p − 2/q   (derived in the .jl).
-- Sobolev :  [Ḣ^s] = s + f − 3/2.
scalingExponent :: Norm -> Rational
scalingExponent (LebesgueW f a p q) = f - a - 3 * invExp p - 2 * invExp q
scalingExponent (Sobolev   f s)     = s + f - 3 % 2

data Criticality = Subcritical | Critical | Supercritical  deriving (Eq, Show)

classify :: Rational -> Criticality
classify e | e == 0    = Critical
           | e >  0    = Subcritical
           | otherwise = Supercritical

-- convenience constructors (velocity field, f = 1)
lp  :: Rational -> Norm                  -- spatial L^p (q = ∞)
lp p = LebesgueW 1 0 (Fin p) Inf
lpInf :: Norm                            -- L^∞ spatial
lpInf = LebesgueW 1 0 Inf Inf
hs  :: Rational -> Norm                  -- Ḣ^s
hs s = Sobolev 1 s
wlqp :: Rational -> Rational -> LebExp -> Norm  -- |x₃|^α in L^q_t L^p_x
wlqp a p q = LebesgueW 1 a (Fin p) q

-- ----------------------------------------------------------------------------
type Check = (String, Bool, String)

checks :: [Check]
checks =
  [ ("[L^p] = 1 − 3/p (p=6)",   scalingExponent (lp 6) == 1 - 3%6,
        "[L^6]=" ++ show (scalingExponent (lp 6)))
  , ("L^3 is CRITICAL",          let e = scalingExponent (lp 3)
                                 in e == 0 && classify e == Critical, "[L^3]=0")
  , ("L^2 (energy) SUPERcritical",let e = scalingExponent (lp 2)
                                 in e == (-1%2) && classify e == Supercritical, "[L^2]=-1/2  (NS-002)")
  , ("L^∞ SUBcritical",          let e = scalingExponent lpInf
                                 in e == 1 && classify e == Subcritical, "[L^∞]=1")
  , ("Ḣ^{1/2} is CRITICAL",      scalingExponent (hs (1%2)) == 0, "[Ḣ^{1/2}]=0")
  -- cross-family COHERENCE (categorical): Ḣ^0 and L^2 are the same object ⇒ same exponent
  , ("coherence Ḣ^0 = L^2",      scalingExponent (hs 0) == scalingExponent (lp 2),
        "[Ḣ^0]=[L^2]=" ++ show (scalingExponent (hs 0)))
  , ("energy gap [L^2]−[Ḣ^{1/2}] = −1/2",
        scalingExponent (lp 2) - scalingExponent (hs (1%2)) == (-1%2), "the σ=−1 vs σ=0 wall")
  -- anisotropic |x₃|^α criticality IFF  [X]=0 ⇔ 2/q+3/p = 1−α, exact, on 3 triples
  ] ++ [ anisoCheck a p q | (a,p,q) <-
           [ (1%4, 6, Fin 8)     -- CRITICAL weighted: 2/8+3/6 = 3/4 = 1−1/4
           , (0,   3, Inf)       -- CRITICAL Serrin   : 0+1   = 1   = 1−0
           , (1%8, 4, Fin 8) ] ] -- CONTROL           : 2/8+3/4 = 1 ≠ 7/8
  where
    anisoCheck a p q =
      let e   = scalingExponent (wlqp a p q)
          lhs = 2 * invExp q + 3 * invExp (Fin p)
          rhs = 1 - a
          iff = (e == 0) == (lhs == rhs)            -- the criticality IFF, exact
      in ("|x₃|^α iff (α=" ++ show a ++ ",p=" ++ show p ++ ")", iff,
          "2/q+3/p=" ++ show lhs ++ ", 1−α=" ++ show rhs ++ ", [X]=" ++ show e
             ++ " ⇒ " ++ show (classify e))

main :: IO ()
main = do
  putStrLn "Rung 0 — scaling-criticality calculus (Haskell; type-checked / categorical evidence)\n"
  let render (n, ok, d) = (if ok then "  PASS  " else "  FAIL  ") ++ pad 42 n ++ d
      pad k s = s ++ replicate (max 1 (k - length s)) ' '
  mapM_ (putStrLn . render) checks
  putStrLn ""
  if all (\(_,ok,_) -> ok) checks
     then putStrLn "ALL EXACT IDENTITIES TYPE-CHECK + VERIFY — Rung 0." >> exitSuccess
     else putStrLn "FAILURE — an identity did not close." >> exitFailure
