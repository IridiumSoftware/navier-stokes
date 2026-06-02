#!/usr/bin/env julia
# bench_threads.jl — thread-scaling + FFT-backend comparison for the 3D solver.
# Times a single forward 3D FFT (the per-step bottleneck; a step is ~12–15 of these) for
# (a) the threaded hand-rolled radix-2 and (b) FFTW (tuned, MKL/FFTW backend). Run at
# several `julia --project=. -t N` to find the thread ceiling AND the FFTW speedup.
# Needs --project=. (FFTW). BENCH_SMOKE=1 → N=64 only (fast validation).

using Base.Threads, Printf, FFTW
include(joinpath(@__DIR__, "spectral_3d_control.jl"))

function fft3_hand(Ar); A=ComplexF64.(Ar); N=size(A,1)
    @threads for c in 1:N; for b in 1:N; r=A[:,b,c]; fft!(r); A[:,b,c]=r; end; end
    @threads for c in 1:N; for a in 1:N; r=A[a,:,c]; fft!(r); A[a,:,c]=r; end; end
    @threads for b in 1:N; for a in 1:N; r=A[a,b,:]; fft!(r); A[a,b,:]=r; end; end; A; end

function bench_hand(N; reps=8)
    A = rand(Float64, N,N,N); fft3_hand(A)                 # warmup
    t0=time(); for _ in 1:reps; fft3_hand(A); end; (time()-t0)/reps
end
function bench_fftw(N; reps=8)
    FFTW.set_num_threads(nthreads())
    P = plan_fft(zeros(ComplexF64,N,N,N); flags=FFTW.MEASURE)
    A = ComplexF64.(rand(Float64, N,N,N)); P*A             # warmup
    t0=time(); for _ in 1:reps; P*A; end; (time()-t0)/reps
end

Ns = get(ENV,"BENCH_SMOKE","")=="1" ? (64,) : (128, 256)
for N in Ns
    h = bench_hand(N); f = bench_fftw(N)
    @printf("threads=%-3d N=%-4d  hand=%.4f  fftw=%.4f s/fft3   speedup=%.1fx   (step≈12·fft3 ⇒ hand %.2f h / fftw %.2f h for T=10)\n",
            nthreads(), N, h, f, h/f, h*12*2000/3600, f*12*2000/3600)
end
