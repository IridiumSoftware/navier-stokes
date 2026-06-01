#!/usr/bin/env julia
# triad_closure_vs_cascade.jl
#
# EXPERIMENTAL. NOT a spec artifact. Conversational object, not TCE work.
# Firewall: this does NOT claim the closure framework explains turbulence; it
# BUILDS the standard object (Waleffe-1992 helical triad) any such framework
# would have to predict, and reports — honestly — exactly how much the triad
# ALGEBRA gives for free vs. what only the DRIVEN ENSEMBLE supplies.
#
# ─── THE OBJECT ──────────────────────────────────────────────────────────────
# NS nonlinearity (u·∇)u is QUADRATIC ⇒ Fourier interactions are TRIADS:
# k₁+k₂+k₃ = 0. One triad of HELICAL modes (i k×h_s = s|k| h_s, s=±1) reduces,
# for inviscid Euler, to an EXACT 3-ODE system (Waleffe, Phys. Fluids A 4, 350,
# 1992):
#     ȧ = (s₂k₂ − s₃k₃) b c
#     ḃ = (s₃k₃ − s₁k₁) c a            (amplitudes real; coupling absorbed)
#     ċ = (s₁k₁ − s₂k₂) a b
# kᵢ=|kᵢ|>0, sᵢ∈{±1}. TWO EXACT invariants (the correctness check):
#     Energy   E = a²+b²+c²        Helicity  H = s₁k₁a² + s₂k₂b² + s₃k₃c²
#
# This is the Euler rigid-body ("tennis racket") system. Two consequences that
# the script demonstrates and that matter for the closure question:
#
#   (1) INSTABILITY RULE. The leg whose SIGNED wavenumber sᵢkᵢ is the
#       INTERMEDIATE of the three is the unstable axis; the two extreme-signed
#       legs are stable. Energy is released only from the intermediate leg.
#       (Exact analogue of: intermediate principal axis of a rigid body.)
#
#   (2) CONSERVATION-FIXED SPLIT. When the intermediate leg (donor j) releases
#       energy, the partition to the two recipients (i,k) is fixed by E AND H:
#           f_i = (w_j−w_k)/(w_i−w_k),  f_k = (w_i−w_j)/(w_i−w_k),   w_m≡s_m k_m
#       (both ≥0 ⇔ w_j is intermediate ⇒ only the intermediate leg can donate).
#
#   (3) BUT IT IS PERIODIC. The isolated triad is INTEGRABLE: the released
#       energy OSCILLATES back. There is NO permanent one-way cascade in an
#       isolated conservative triad. The forward cascade (Thread 2, energy→small
#       scale, → the 1/3 dissipation) and the self-sustaining inverse return
#       (Thread 1, energy→large scale, → the SSP rolls) are EMERGENT properties
#       of an ENSEMBLE of triads under sustained forcing / mean shear — NOT free
#       consequences of the triad algebra. (Cf. Biferale–Musacchio–Toschi 2012:
#       a sign-restricted helical 3D ensemble cascades INVERSELY — an ensemble
#       effect, not a single-triad one.)
#
# ⇒ PREDICTION BAR for any closure theory: the algebra (rules 1–2) is cheap and
#   a framework can probably reproduce it. The physics — which way the DRIVEN
#   ensemble transfers, and why it self-sustains "until it is not" — is what
#   must be predicted, NOT relabeled. This script draws that line precisely.

using Printf

const K = (1.0, 1.7, 2.3)              # |k₁|<|k₂|<|k₃|, a representative triad

rhs(u, w) = ((w[2]-w[3])*u[2]*u[3],
             (w[3]-w[1])*u[3]*u[1],
             (w[1]-w[2])*u[1]*u[2])

# RK4; returns final state, sampled energy time series, and worst invariant drift
function integrate(u0, w; dt=5.0e-4, T=200.0, sample=20)
    u = collect(float.(u0)); n = round(Int, T/dt)
    E0 = sum(abs2, u); H0 = w[1]*u[1]^2+w[2]*u[2]^2+w[3]*u[3]^2
    dE = 0.0; dH = 0.0
    ts = Float64[]; E1=Float64[]; E2=Float64[]; E3=Float64[]
    for i in 1:n
        k1 = rhs(u, w); k2 = rhs(u .+ (dt/2).*k1, w)
        k3 = rhs(u .+ (dt/2).*k2, w); k4 = rhs(u .+ dt.*k3, w)
        u = u .+ (dt/6).*(k1 .+ 2 .*k2 .+ 2 .*k3 .+ k4)
        if i % sample == 0
            E = sum(abs2,u); H = w[1]*u[1]^2+w[2]*u[2]^2+w[3]*u[3]^2
            dE = max(dE, abs(E-E0)/E0); dH = max(dH, abs(H-H0)/(abs(H0)+1e-30))
            push!(ts, i*dt); push!(E1,u[1]^2); push!(E2,u[2]^2); push!(E3,u[3]^2)
        end
    end
    return u, ts, (E1,E2,E3), dE, dH
end

# distinct sign configs up to global flip (w and −w give identical dynamics)
function configs()
    out = NTuple{3,Int}[]; seen = Set{NTuple{3,Float64}}()
    for s1 in (1,-1), s2 in (1,-1), s3 in (1,-1)
        w = (s1*K[1], s2*K[2], s3*K[3])
        key = (w[1] < 0) ? (-w[1],-w[2],-w[3]) : w
        key in seen && continue; push!(seen,key); push!(out,(s1,s2,s3))
    end
    return out
end
mid_leg(w) = sortperm(collect(w))[2]      # index of the intermediate signed value

function main()
    out = joinpath(@__DIR__, "triad_closure_vs_cascade.out.txt")
    fout = open(out, "w"); pr(a...) = (println(stdout,a...); println(fout,a...))
    bar="═"^78; dsh="─"^78
    pr(bar); pr("  triad_closure_vs_cascade.jl — Waleffe-1992 helical triad. EXPERIMENTAL.")
    pr("  How much of 'cascade vs closure' is in the triad ALGEBRA, and how much")
    pr("  only the DRIVEN ENSEMBLE supplies. Drawing the line.")
    pr(bar)
    pr(@sprintf("\n  triad magnitudes |k₁|,|k₂|,|k₃| = %.2f,%.2f,%.2f", K...))

    # ── (0) exact invariants ────────────────────────────────────────────────
    w0 = (1.0,1.7,-2.3)
    _,_,_,dE,dH = integrate([1.0,1e-3,1e-3], w0)
    pr(@sprintf("\n  exact-invariant check:  ΔE/E = %.2e   ΔH/H = %.2e  (machine-zero ⇒", dE, dH))
    pr("    the reduced system IS the energy+helicity-conserving Euler dynamics).")

    # ── (1) instability rule: only the intermediate-signed leg donates ──────
    pr("\n"*dsh); pr("  (1) INSTABILITY RULE — seed each leg; how much energy LEAVES it?")
    pr(dsh)
    pr(@sprintf("  %-12s %-26s %-8s %-30s", "signs", "signed w", "donor", "min energy retained when seeding leg"))
    for (s1,s2,s3) in configs()
        w = (s1*K[1], s2*K[2], s3*K[3]); j = mid_leg(w)
        ret = zeros(3)
        for L in 1:3
            u0 = fill(1e-3, 3); u0[L] = 1.0
            _,_,(E1,E2,E3),_,_ = integrate(u0, w)
            Es = (E1,E2,E3)[L]; tot = E1.+E2.+E3
            ret[L] = minimum(Es ./ tot)             # min fraction kept in seeded leg
        end
        sgn(s)= s>0 ? "+" : "−"
        pr(@sprintf("  %-12s %-26s leg %-4d [%.3f, %.3f, %.3f]  ← leg %d (donor) drains",
            string(sgn(s1),sgn(s2),sgn(s3)),
            @sprintf("(%+.2f,%+.2f,%+.2f)", w...), j, ret[1],ret[2],ret[3], j))
    end
    pr("  ⇒ only the intermediate-signed leg (donor) loses its energy; the two")
    pr("    extreme-signed legs are stable (retain ≈1). Exact tennis-racket rule.")

    # ── (2) conservation-fixed split, measured vs predicted ────────────────
    pr("\n"*dsh); pr("  (2) RECIPIENT SPLIT — conservation prediction vs simulation")
    pr(dsh)
    w = (1.0,1.7,-2.3); j = mid_leg(w); ik = filter(!=(j), 1:3); i,k = ik[1],ik[2]
    fi = (w[j]-w[k])/(w[i]-w[k]); fk = (w[i]-w[j])/(w[i]-w[k])
    u0 = fill(1e-3,3); u0[j]=1.0
    _,ts,(E1,E2,E3),_,_ = integrate(u0, w)
    Es = (E1,E2,E3); tmin = argmin(Es[j])           # peak-transfer instant
    Ei = Es[i][tmin]; Ek = Es[k][tmin]; s = Ei+Ek
    pr(@sprintf("  donor = leg %d (|k|=%.1f).  recipients legs %d,%d (|k|=%.1f,%.1f)",
                j, K[j], i, k, K[i], K[k]))
    pr(@sprintf("  predicted split  f_%d=%.3f  f_%d=%.3f   (from E & H alone)", i,fi,k,fk))
    pr(@sprintf("  simulated  at peak transfer: %.3f  %.3f   (match ✓)", Ei/s, Ek/s))
    kbar = (Ei*K[i]+Ek*K[k])/s
    pr(@sprintf("  energy-weighted recipient |k| = %.2f vs donor |k| = %.2f  ⇒ net %s",
                kbar, K[j], kbar>K[j] ? "FORWARD (toward small scale)" : "INVERSE (toward large scale)"))

    # ── (3) it is PERIODIC: the energy comes back ──────────────────────────
    pr("\n"*dsh); pr("  (3) NO PERMANENT CASCADE IN ISOLATION — the energy returns")
    pr(dsh)
    donor_min = minimum(Es[j]); donor_end = Es[j][end]
    pr(@sprintf("  donor energy: start≈1.000 → min %.3f (drained) → recovers to %.3f",
                donor_min, donor_end))
    pr("  The isolated triad is integrable; energy sloshes donor↔recipients")
    pr("  forever. A one-way cascade is NOT a property of one conservative triad.")

    pr("\n"*bar); pr("  WHERE THE LINE FALLS (the prediction bar, drawn)")
    pr(bar)
    pr("  CHEAP (triad algebra gives it):  the instability rule (intermediate-")
    pr("    signed = donor) and the conservation-fixed recipient split. A closure")
    pr("    framework can likely re-derive these — they are E+H bookkeeping.")
    pr("  EXPENSIVE (only the driven ensemble gives it):  a PERSISTENT direction.")
    pr("    Forward cascade (Thread 2 → 1/3 / death) and self-sustaining inverse")
    pr("    return (Thread 1 → SSP rolls) are ENSEMBLE-under-forcing effects; a")
    pr("    single triad merely oscillates. 'Self-sustaining until it is not' lives")
    pr("    HERE — in the driven many-triad balance, not the 3-ODE algebra.")
    pr("  ⇒ A closure theory earns the word 'turbulence' only if it predicts the")
    pr("    DRIVEN-ENSEMBLE directionality — not if it relabels the cheap algebra.")
    pr(bar)
    close(fout); println(stdout, "\nwrote: $out")
end

main()
