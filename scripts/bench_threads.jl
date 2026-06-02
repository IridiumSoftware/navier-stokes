#!/usr/bin/env julia
# bench_threads.jl — thread-scaling of the 3D pseudospectral solver step-time.
# The FFT is memory-bandwidth-bound, so more threads may saturate before all cores help.
# Run at several `julia -t N` to find the real ceiling (which sets the cost of future DNS).
# BENCH_SMOKE=1 → N=64 only (a fast validation that the script runs, minimal contention).

using Base.Threads, Printf
include(joinpath(@__DIR__, "spectral_3d_control.jl"))

function fft3(Ar); A=ComplexF64.(Ar); N=size(A,1)
    @threads for c in 1:N; for b in 1:N; r=A[:,b,c]; fft!(r); A[:,b,c]=r; end; end
    @threads for c in 1:N; for a in 1:N; r=A[a,:,c]; fft!(r); A[a,:,c]=r; end; end
    @threads for b in 1:N; for a in 1:N; r=A[a,b,:]; fft!(r); A[a,b,:]=r; end; end; A; end
function ifft3(A); B=copy(A); N=size(B,1)
    @threads for c in 1:N; for b in 1:N; r=B[:,b,c]; fft!(r;inv=true); B[:,b,c]=r; end; end
    @threads for c in 1:N; for a in 1:N; r=B[a,:,c]; fft!(r;inv=true); B[a,:,c]=r; end; end
    @threads for b in 1:N; for a in 1:N; r=B[a,b,:]; fft!(r;inv=true); B[a,b,:]=r; end; end; B; end

function bench(N; nsteps=5)
    op = make_ops(N); U = taylor_green_ic(N, op)
    U = rk4(U, 0.005, 1/1600, op)                 # warm up / compile
    t0 = time()
    for _ in 1:nsteps; U = rk4(U, 0.005, 1/1600, op); end
    (time() - t0) / nsteps
end

Ns = get(ENV,"BENCH_SMOKE","")=="1" ? (64,) : (128, 256)
for N in Ns
    sps = bench(N)
    @printf("threads=%-3d N=%-4d %.3f s/step   (T=10 viscous, 2000 steps ⇒ %.2f h)\n",
            nthreads(), N, sps, sps*2000/3600)
end
