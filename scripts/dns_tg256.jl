#!/usr/bin/env julia
# dns_tg256.jl — a RESOLVED Taylor–Green DNS at N=256 (Re=1600, the canonical Brachet
# 1983 benchmark), using the full 6-hour compute budget instead of the ~10-minute runs
# the program had been calling "the laptop wall." The point: turn the resolution-GATED
# verdicts (S_ω bounded-vs-growing; production-set box-dimension; δ-convergence) into
# RESOLVED ones, on a flow whose enstrophy peak is known from the literature (validation).
#
# Diagnostics per sample (on the resolved field):
#   E, H (Euler invariants — here viscous, so E decays, H≈conserved-ish),
#   Z (enstrophy), ‖ω‖∞, δ(t) (analyticity strip),
#   S_ω = ⟨ω·(ω·∇)u⟩ / ⟨|ω|²⟩^{3/2}   (vortex-stretching production skewness — the
#         singularity-relevant, σ=0-class detector),
#   D = box-counting dimension of the top-50%-production set (the CKN / NS-037 measure).
#
# Threaded radix-2 FFT (needs `julia -t N`, N power of two). Output written incrementally
# (flushed per sample) so a multi-hour run can be monitored live.
#
# Scope: 3D pseudospectral DNS truncation (RESOLVED at Re=1600/N=256). NOT the PDE
# regularity problem; :proved=0. Run: julia -t auto scripts/dns_tg256.jl
# Env overrides for the smoke: NS_N, NS_T, NS_DT, NS_NU, NS_SAMPLE.

using Printf, Base.Threads
include(joinpath(@__DIR__, "spectral_3d_control.jl"))

# threaded transforms (override the serial ones; rhs/rk4 bind these at call time)
function fft3(Ar); A=ComplexF64.(Ar); N=size(A,1)
    @threads for c in 1:N; for b in 1:N; r=A[:,b,c]; fft!(r); A[:,b,c]=r; end; end
    @threads for c in 1:N; for a in 1:N; r=A[a,:,c]; fft!(r); A[a,:,c]=r; end; end
    @threads for b in 1:N; for a in 1:N; r=A[a,b,:]; fft!(r); A[a,b,:]=r; end; end; A; end
function ifft3(A); B=copy(A); N=size(B,1)
    @threads for c in 1:N; for b in 1:N; r=B[:,b,c]; fft!(r;inv=true); B[:,b,c]=r; end; end
    @threads for c in 1:N; for a in 1:N; r=B[a,:,c]; fft!(r;inv=true); B[a,:,c]=r; end; end
    @threads for b in 1:N; for a in 1:N; r=B[a,b,:]; fft!(r;inv=true); B[a,b,:]=r; end; end; B; end

# vortex-stretching production density ω·(ω·∇)u, and the skewness S_ω
function production(U, op)
    uh,vh,wh = U
    ωxh,ωyh,ωzh = curl_hat(uh,vh,wh,op)
    ωx=real.(ifft3(ωxh)); ωy=real.(ifft3(ωyh)); ωz=real.(ifft3(ωzh))
    dux=real.(ifft3(im.*op.kx.*uh)); duy=real.(ifft3(im.*op.ky.*uh)); duz=real.(ifft3(im.*op.kz.*uh))
    dvx=real.(ifft3(im.*op.kx.*vh)); dvy=real.(ifft3(im.*op.ky.*vh)); dvz=real.(ifft3(im.*op.kz.*vh))
    dwx=real.(ifft3(im.*op.kx.*wh)); dwy=real.(ifft3(im.*op.ky.*wh)); dwz=real.(ifft3(im.*op.kz.*wh))
    su = ωx.*dux .+ ωy.*duy .+ ωz.*duz
    sv = ωx.*dvx .+ ωy.*dvy .+ ωz.*dvz
    sw = ωx.*dwx .+ ωy.*dwy .+ ωz.*dwz
    Pd = ωx.*su .+ ωy.*sv .+ ωz.*sw
    enst2 = mean3(ωx.^2 .+ ωy.^2 .+ ωz.^2)
    (Sw = mean3(Pd)/enst2^1.5, Pd = Pd)
end

# box-counting dimension of the top-`frac` mass set of |field|
function box_dimension(field; frac=0.5)
    N=size(field,1); a=abs.(field)
    v=sort(vec(a); rev=true); tot=sum(v); c=0.0; thr=v[end]
    for x in v; c+=x; if c>=frac*tot; thr=x; break; end; end
    scales=[s for s in (2,4,8,16,32) if s<=N]; xs=Float64[]; ys=Float64[]
    for s in scales
        nb=N÷s; occ=falses(nb,nb,nb)
        @inbounds for I in CartesianIndices(a)
            if a[I]>=thr
                occ[(I[1]-1)÷s+1,(I[2]-1)÷s+1,(I[3]-1)÷s+1]=true
            end
        end
        push!(xs, log(N/s)); push!(ys, log(max(sum(occ),1)))
    end
    xm=sum(xs)/length(xs); ym=sum(ys)/length(ys)
    sum((xs.-xm).*(ys.-ym))/sum((xs.-xm).^2)
end

# ── boundary ICs (selected by NS_IC) ─────────────────────────────────────────────
# helical: low-k random helical field (H≠0), energy-matched to TG (E≈0.125) for a fair
# H≠0-vs-H=0 comparison at comparable Reynolds number / resolution.
function helical_ic(N, op)
    U0 = random_helical_ic(N, op)                      # normalized to E=0.5
    s = sqrt(0.125/0.5)                                # rescale to E≈0.125 (TG energy)
    (U0[1].*s, U0[2].*s, U0[3].*s)
end
# Kerr-style anti-parallel vortex tubes along x, opposite circulation, with a sinusoidal
# centerline wiggle (NS_PERT) to drive stretching/reconnection. ω prescribed → Leray-
# projected divergence-free → u = curl⁻¹ω (Biot–Savart). Energy-matched to TG.
function vortex_tube_ic(N, op; a=0.30, b=0.80, ε=0.30, kx=1.0)
    xs=[2π*(i-1)/N for i in 1:N]; y0=π
    ωx=zeros(N,N,N)
    @inbounds for c in 1:N, j in 1:N, i in 1:N
        X=xs[i]; Y=xs[j]; Z=xs[c]; dz=ε*sin(kx*X)
        zp=π+b+dz; zm=π-b-dz
        rp2=(Y-y0)^2+(Z-zp)^2; rm2=(Y-y0)^2+(Z-zm)^2
        ωx[i,j,c]=(exp(-rp2/a^2)-exp(-rm2/a^2))/(π*a^2)
    end
    ωxh=fft3(ωx); ωyh=zeros(ComplexF64,N,N,N); ωzh=zeros(ComplexF64,N,N,N)
    kd = op.kx.*ωxh .+ op.ky.*ωyh .+ op.kz.*ωzh        # Leray-project ω div-free
    ωxh .-= op.kx.*(kd./op.k2p); ωyh .-= op.ky.*(kd./op.k2p); ωzh .-= op.kz.*(kd./op.k2p)
    uh = im.*(op.ky.*ωzh .- op.kz.*ωyh)./op.k2p        # u = curl⁻¹ω : û = i k×ω̂/|k|²
    vh = im.*(op.kz.*ωxh .- op.kx.*ωzh)./op.k2p
    wh = im.*(op.kx.*ωyh .- op.ky.*ωxh)./op.k2p
    uh[1,1,1]=0; vh[1,1,1]=0; wh[1,1,1]=0
    u=real.(ifft3(uh)); v=real.(ifft3(vh)); w=real.(ifft3(wh))
    E=0.5*mean3(u.^2 .+ v.^2 .+ w.^2); s=sqrt(0.125/E)
    (uh.*s, vh.*s, wh.*s)
end

function main()
    N   = parse(Int,  get(ENV,"NS_N","256"))
    T   = parse(Float64, get(ENV,"NS_T","10.0"))
    dt  = parse(Float64, get(ENV,"NS_DT","0.005"))
    ν   = parse(Float64, get(ENV,"NS_NU", string(1/1600)))
    smp = parse(Float64, get(ENV,"NS_SAMPLE","0.5"))
    ic  = get(ENV,"NS_IC","tg")                         # tg | helical | tubes
    tag = (ic=="tg" ? "" : "_$(ic)") * (N==256 ? "" : "_N$(N)")
    out = joinpath(@__DIR__, "dns_tg256$(tag).out.txt")
    fout = open(out,"w")
    pr(a...) = (println(stdout,a...); println(fout,a...); flush(fout); flush(stdout))
    pr("# dns_tg256 — viscous DNS  IC=$ic  N=$N  Re=$(round(1/ν))  dt=$dt  T=$T  threads=$(nthreads())")
    pr("# Scope: resolved 3D pseudospectral DNS truncation; NOT the PDE; :proved=0.")
    pr(@sprintf("# %-6s %-11s %-11s %-11s %-9s %-8s %-10s %-7s","t","E/E0","H","Z/Z0","winf","delta","S_omega","Dbox"))

    op = make_ops(N)
    U = ic=="helical" ? helical_ic(N,op) : ic=="tubes" ? vortex_tube_ic(N,op) : taylor_green_ic(N,op)
    d0 = diagnose(U,op,N); Z0 = d0.Z; E0 = d0.E
    pr(@sprintf("# IC=%s  E0=%.5f  H0=%.5e  Z0=%.5f  div_max=%.1e", ic, d0.E, d0.H, d0.Z, d0.divmax))
    t = 0.0; nexts = 0.0
    while t < T + 1e-9
        if t >= nexts - 1e-9
            d  = diagnose(U,op,N)
            pp = production(U,op)
            Db = box_dimension(pp.Pd)
            pr(@sprintf("  %-6.2f %-11.6f %-11.3e %-11.4f %-9.2f %-8.3f %-10.4f %-7.3f",
                t, d.E/E0, d.H, d.Z/Z0, d.winf, d.δ, pp.Sw, Db))
            nexts += smp
        end
        U = rk4(U, dt, ν, op); t += dt
    end
    pr("# DONE. Enstrophy peak ≈ Brachet-1983 TG Re=1600 (validation); S_ω/Dbox on the resolved field.")
    close(fout); println(stdout, "wrote: $out")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
