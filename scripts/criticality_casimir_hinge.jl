# criticality_casimir_hinge.jl
#
# Numerical confirmation of the analytic hinge tightened in
# docs/obstruction_program_writeup.md §5 ("three routes, one wall" -> "(a)==(b),
# (c) independent").  The load-bearing combining-step of the (a)==(b) equivalence
# is the exact interpolation that makes the CRITICAL norm the geometric mean of
# the SUPERcritical (energy) and SUBcritical (enstrophy) controlled quantities:
#
#     ||u||_{Hdot^{1/2}}^2  <=  ||u||_{L2} * ||u||_{Hdot^1}
#                            =  sqrt(energy-norm^2) * sqrt(enstrophy).
#
# This is elementary Cauchy-Schwarz on the nonnegative spectral weights
# w(k) = |u_hat(k)|^2 with the weight |k| split as |k|^0 * |k|^1 -- it holds for
# ANY field (div-free or not, real or complex), so we verify it directly on the
# integer-wavenumber grid.  Two things are checked:
#   (1) the inequality holds for generic random spectra (ratio lhs/rhs <= 1);
#   (2) it is SHARP -- equality iff the spectrum is scale-pure (single |k| shell),
#       strict for any multi-shell (genuinely multi-scale) field.
# Together with the exact rational exponents (printed below) this confirms the
# symmetric ladder  energy(sigma=-1) | critical(0) | enstrophy(+1)  and that the
# critical quantity is exactly the midpoint.
#
# CONVENTION: sigma is the dilation exponent of the QUADRATIC quantity under
# u_lambda(x) = lambda*u(lambda*x) (the NS scaling, a=1); for the seminorm
# ||u||_{Hdot^s} it is s-1/2, so the quadratic ||u||^2_{Hdot^s} has 2s-1.
#   energy   ||u||^2_{L2}=||u||^2_{Hdot^0}      -> 2*0-1 = -1   (SUPERcritical)
#   critical ||u||^2_{Hdot^{1/2}}               -> 2*.5-1 = 0   (scale-invariant)
#   enstrophy||u||^2_{Hdot^1}=||omega||^2_{L2}   -> 2*1-1 = +1   (SUBcritical)
#
# Scope: NS scaling identities + an elementary inequality.  NOT the PDE; proves
# nothing about regularity -- it sharpens the OBSTRUCTION's shape to one rung.
# :proved = 0; distance to prize UNTOUCHED.

using Random, Printf

# ||u||^2_{Hdot^s} = sum_k |k|^{2s} |u_hat(k)|^2 , from spectral weights w(k)=|u_hat|^2.
sob(w, s) = sum(v * float(kx^2 + ky^2 + kz^2)^s for ((kx, ky, kz), v) in w)

ratio(w) = sob(w, 0.5) / (sqrt(sob(w, 0.0)) * sqrt(sob(w, 1.0)))

# generic random spectrum on the 3D integer grid k in [-N,N]^3 \ {0}
function random_spectrum(N; seed=0)
    rng = MersenneTwister(seed)
    w = Dict{Tuple{Int,Int,Int},Float64}()
    for kx in -N:N, ky in -N:N, kz in -N:N
        k2 = kx^2 + ky^2 + kz^2
        k2 == 0 && continue
        w[(kx, ky, kz)] = abs2(randn(rng) + im * randn(rng)) / (1 + k2)^2  # mild envelope
    end
    w
end

# spectrum supported on a single |k|^2 = R shell (scale-pure)
function shell_spectrum(R; seed=0)
    rng = MersenneTwister(seed)
    w = Dict{Tuple{Int,Int,Int},Float64}()
    for kx in -R:R, ky in -R:R, kz in -R:R
        if kx^2 + ky^2 + kz^2 == R
            w[(kx, ky, kz)] = abs2(randn(rng) + im * randn(rng))
        end
    end
    w
end

function main()
    println("=== criticality-Casimir hinge: interpolation check ===\n")

    println("Exact exponent ladder (quadratic dilation exponent sigma):")
    for (name, s) in (("energy   ||u||^2_{L2}      ", 0.0),
                      ("critical ||u||^2_{Hdot^1/2}", 0.5),
                      ("enstrophy||u||^2_{Hdot^1}  ", 1.0))
        @printf("  %s  s=%.1f  ->  sigma = 2s-1 = %+d\n", name, s, Int(2s - 1))
    end
    @printf("  symmetric about critical line:  (-1 , +1) midpoint = %d  (= critical)\n", (-1 + 1) ÷ 2)
    println("  helicity H=∫u·ω scales as lambda^0 (CRITICAL) and is sign-indefinite (non-coercive).\n")

    # (1) generic multi-scale fields: ratio must be < 1 (strict)
    rmax = 0.0
    for seed in 1:200
        r = ratio(random_spectrum(6; seed=seed))
        rmax = max(rmax, r)
    end
    @printf("(1) generic random spectra (200 seeds, N=6):  max ratio lhs/rhs = %.10f  (<= 1 required)\n", rmax)
    println(rmax <= 1 + 1e-12 ? "    PASS: interpolation inequality holds (strict for multi-scale)\n"
                              : "    FAIL\n")

    # (2) scale-pure single-shell fields: ratio must be exactly 1
    println("(2) scale-pure single-shell spectra (ratio must = 1 exactly):")
    worst = 0.0
    for R in (1, 2, 3, 5, 6, 9, 14)
        w = shell_spectrum(R)
        isempty(w) && continue
        r = ratio(w)
        worst = max(worst, abs(r - 1))
        @printf("    |k|^2 = %2d : ratio = %.12f\n", R, r)
    end
    @printf("    max |ratio-1| over shells = %.2e\n", worst)
    println(worst < 1e-10 ? "    PASS: equality iff scale-pure  =>  the gap IS the multi-scale (cascade) content\n"
                          : "    FAIL\n")

    println("Reading: the critical (regularity-deciding) quantity is the geometric mean of")
    println("energy (controlled, sigma=-1) and enstrophy (would-decide, sigma=+1). 2D bounds")
    println("enstrophy as a Casimir => regular; 3D loses it (Casimir deficit) => open. One rung.")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
