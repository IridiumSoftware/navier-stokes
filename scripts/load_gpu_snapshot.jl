#!/usr/bin/env julia
# load_gpu_snapshot.jl — read a Metal-GPU spectral-field snapshot (metal/dns_gpu.swift) and
# run the SAME validated Julia diagnostics (δ, S_ω, box-D30/50/70, alignment) used for the CPU
# DNS. This is the hybrid bridge: GPU does the heavy N=512 time-stepping (float32) + dumps
# snapshots; the verdict comes from the CPU-validated diagnostics — so N=512 cross-validates
# against the N=256 CPU baseline on identical measures.
#
# Snapshot format (little-endian): Int32 N, Float32 t, then 6×N³ Float32 in order
#   uh_re, uh_im, vh_re, vh_im, wh_re, wh_im   (Swift row-major (i*N+j)*N+k).
# Layout fix: Swift row-major → Julia column-major via permutedims(reshape(a,N,N,N),(3,2,1)).
# FFT convention matches Julia fft3 (forward unnormalized) so the spectral coefficients align.
#
# Usage: julia scripts/load_gpu_snapshot.jl <snapshot.bin>
using Printf
include(joinpath(@__DIR__, "dns_tg256.jl"))   # diagnose, field_diag, box_dimension, make_ops (guard prevents main())

function load_snapshot(path)
    io = open(path, "r")
    N = Int(read(io, Int32)); t = read(io, Float32)
    rd() = (a = Vector{Float32}(undef, N^3); read!(io, a); permutedims(reshape(a, N, N, N), (3,2,1)))
    uhr=rd(); uhi=rd(); vhr=rd(); vhi=rd(); whr=rd(); whi=rd(); close(io)
    uh = ComplexF64.(uhr) .+ im .* ComplexF64.(uhi)
    vh = ComplexF64.(vhr) .+ im .* ComplexF64.(vhi)
    wh = ComplexF64.(whr) .+ im .* ComplexF64.(whi)
    (N=N, t=Float64(t), U=(uh,vh,wh))
end

function main()
    path = length(ARGS) >= 1 ? ARGS[1] : error("usage: julia load_gpu_snapshot.jl <snapshot.bin>")
    s = load_snapshot(path); N = s.N; op = make_ops(N)
    d  = diagnose(s.U, op, N)
    # RELATIVE divergence max|k·û|/max|û|: the GPU FFT is unnormalized, so absolute div_max
    # (~0.05 at float32) scales with the ~N³ coefficients and is misleading; the relative
    # form is the N-independent, honest div-free check (~float32 eps ≈ 1e-6 ⇒ div-free).
    uh,vh,wh = s.U
    dvr = maximum(abs.(op.kx.*uh .+ op.ky.*vh .+ op.kz.*wh)) / maximum(sqrt.(abs2.(uh).+abs2.(vh).+abs2.(wh)))
    # δ-only fast mode (NS_DELTAONLY=1): skip the expensive field_diag (LAPACK eigen) +
    # box_dimension; emit only the analyticity-strip δ (same validated delta_shell) + E/Z/winf,
    # for the Step-2 δ(t) trajectory (G1/G2/G3). Box-D for T-08 is a separate full load at the peak.
    if get(ENV, "NS_DELTAONLY", "0") == "1"
        @printf("# GPU snapshot %s  N=%d  t=%.2f  (delta-only)\n", basename(path), N, s.t)
        @printf("  E=%.6f  Z=%.5f  winf=%.2f  delta=%.4f  div_rel=%.1e\n", d.E, d.Z, d.winf, d.δ, dvr)
        return
    end
    fd = field_diag(s.U, op)
    D30 = box_dimension(fd.Pd; frac=0.3); D50 = box_dimension(fd.Pd; frac=0.5); D70 = box_dimension(fd.Pd; frac=0.7)
    @printf("# GPU snapshot %s  N=%d  t=%.2f  (diagnostics via CPU-validated Julia)\n", basename(path), N, s.t)
    @printf("  E=%.6f  Z=%.5f  H=%.4e  winf=%.2f  delta=%.3f  div_rel=%.1e (abs=%.1e, unnormalized-FFT scale)\n", d.E, d.Z, d.H, d.winf, d.δ, dvr, d.divmax)
    @printf("  S_omega=%.4f  D30=%.3f  D50=%.3f  D70=%.3f  c2int=%.3f  c2max=%.3f\n", fd.Sw, D30, D50, D70, fd.cos2int, fd.cos2max)
end
if abspath(PROGRAM_FILE) == @__FILE__; main(); end
