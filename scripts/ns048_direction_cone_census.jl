#!/usr/bin/env julia
# ns048_direction_cone_census.jl — litmap §4.3: the Lei–Ren–Tian double-cone hypothesis vs held data.
#
# LRT (arXiv:2501.08976, C2): if the vorticity DIRECTIONS ω̂ in high-|ω| regions lie in a double cone
# (half-angle < 90°), the solution is regular — equivalently, at a singularity the directions must
# intersect EVERY great circle. The litmap's expect-kill asked whether resolved intense cores already
# violate cone-confinement. The held δ_Λ / |∇ξ|² are SECOND-MOMENT diagnostics — the honest check needs
# the SUPPORT object: the smallest double cone containing the core directions,
#     θ*(q) = arccos( max_e min_{i ∈ top-q} |ω̂_i · e| ).
# θ* < 90° ⇒ some double cone confines the set (LRT-compatible, "regular-side" geometry);
# θ* ≈ 90° ⇒ no double cone — the directions reach every great circle (the singular-compatible config).
# Outlier-robustness: also report the 99%-mass cone θ*₉₉ (1st percentile of |ω̂·e| at the optimal e) —
# distinguishes "bulk genuinely spread" from "a few stray vectors".
#
# Data: the held GPU snapshots (tubes @ t=6.00 enstrophy peak, N=256 + N=512; T-12-validated bridge).
# Scope: resolved-DNS truncation witness; vacuity-capped; :proved=0. A regular flow's cores violating
# cone-confinement says the hypothesis is NON-DISCRIMINATING in the resolved regime (the NS-049/CF-family
# pattern) — it does NOT refute the theorem. -- STABLE
using Printf, LinearAlgebra, Statistics
include(joinpath(@__DIR__, "load_gpu_snapshot.jl"))   # load_snapshot + dns_tg256 chain (guarded)

# Fibonacci sphere directions (axis candidates)
function fib_sphere(n)
    pts = Vector{NTuple{3,Float64}}(undef, n)
    ga = π * (3 - sqrt(5))
    for i in 0:n-1
        z = 1 - 2(i + 0.5) / n
        r = sqrt(max(0, 1 - z^2)); t = ga * i
        pts[i+1] = (r * cos(t), r * sin(t), z)
    end
    pts
end

function census(path; qs=(0.001, 0.01), naxes=4000)
    s = load_snapshot(path); N = s.N; op = make_ops(N)
    ωxh, ωyh, ωzh = curl_hat(s.U[1], s.U[2], s.U[3], op)
    ωx = vec(real.(ifft3(ωxh))); ωy = vec(real.(ifft3(ωyh))); ωz = vec(real.(ifft3(ωzh)))
    w = sqrt.(ωx.^2 .+ ωy.^2 .+ ωz.^2)
    @printf("\n# %s  N=%d t=%.2f  winf=%.2f\n", basename(path), N, s.t, maximum(w))
    println("    top-q      n_pts    θ* (strict)   θ*₉₉ (99%-mass)   δ_Λ    verdict vs double-cone")
    out = NamedTuple[]
    for q in qs
        thr = partialsort(w, max(1, round(Int, q * length(w))); rev=true)
        idx = findall(w .>= thr)
        ux = ωx[idx] ./ w[idx]; uy = ωy[idx] ./ w[idx]; uz = ωz[idx] ./ w[idx]
        # δ_Λ for continuity
        M = zeros(3, 3)
        for i in eachindex(idx)
            wi = w[idx[i]]^2
            M[1,1] += wi*ux[i]^2; M[2,2] += wi*uy[i]^2; M[3,3] += wi*uz[i]^2
            M[1,2] += wi*ux[i]*uy[i]; M[1,3] += wi*ux[i]*uz[i]; M[2,3] += wi*uy[i]*uz[i]
        end
        M[2,1]=M[1,2]; M[3,1]=M[1,3]; M[3,2]=M[2,3]
        δΛ = 1 - eigmax(Symmetric(M)) / tr(M)
        # smallest enclosing double cone: maximize over axes e the (min, 1st-pct) of |ω̂·e|
        best_min = -1.0; best_p1 = -1.0
        # coarse axes + the eigenvector of M (the natural best-axis candidate)
        F = eigen(Symmetric(M)); eM = F.vectors[:, 3]
        axes = push!(collect(fib_sphere(naxes)), (eM[1], eM[2], eM[3]))
        for e in axes
            d = abs.(ux .* e[1] .+ uy .* e[2] .+ uz .* e[3])
            mn = minimum(d)
            if mn > best_min
                best_min = mn
                best_p1 = quantile(d, 0.01)
            end
        end
        θs = acosd(clamp(best_min, 0, 1)); θ99 = acosd(clamp(best_p1, 0, 1))
        verdict = θs > 89 ? (θ99 > 80 ? "NO cone — bulk-spread (hits every great circle)" :
                                       "NO strict cone (outlier-driven; bulk within $(round(θ99))°)") :
                            "confined (θ*<90°)"
        @printf("    %6.2f%%   %8d     %6.1f°        %6.1f°        %.3f   %s\n",
                100q, length(idx), θs, θ99, δΛ, verdict)
        push!(out, (q=q, n=length(idx), θs=θs, θ99=θ99, δΛ=δΛ))
    end
    out
end

println("="^78)
println("  Direction-cone census (litmap §4.3) — LRT double-cone hypothesis vs held cores")
println("  θ* = smallest enclosing double-cone half-angle at top-q |ω|; θ*≈90° ⇒ no cone")
println("  Scope: resolved-DNS witness; vacuity-capped; :proved=0")
println("="^78)
# run census directly; capture with shell tee
for p in ("metal/snap_N256_tubes_t6.00.bin", "metal/snap_N512_tubes_t6.00.bin")
    census(p)
end
println("\n# READ: θ*≈90° at the cores ⇒ the LRT double-cone hypothesis is violated in the resolved")
println("# intense regions (non-discriminating in this regime — the CF-family pattern); θ*₉₉ separates")
println("# bulk spread from outliers. Witness only; does NOT refute the theorem. :proved=0")
