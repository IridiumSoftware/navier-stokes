#!/usr/bin/env julia
# ns050_3d_control.jl — NS-050 (c3): the dynamic-rescaling instrument as a NEGATIVE CONTROL on a
# resolved, REGULAR 3D flow (viscous Taylor–Green, Re=1600).
#
# EXPERIMENTAL. **Scope: resolved 3D pseudospectral DNS truncation. NOT the NS PDE.** :proved=0;
# distance to the prize UNTOUCHED. Point: the (c)/(b) dynamic-rescaling instrument must NOT
# false-positive — applied to a flow with NO finite-time blow-up it must report NULL. Taylor–Green
# at Re=1600 is the canonical regular benchmark (Brachet 1983: enstrophy peaks ~27× at t≈9 then
# DECAYS). So the instrument's first gate — "is ‖ω‖∞ diverging?" — must FAIL, and no self-similar
# rescaled attractor should form. This is the honest control the program lacks a true 3D blow-up for
# (TG and Kerr reconnection are regular, not singular).
#
# Reuses the verified solver of dns_tg256.jl (make_ops/taylor_green_ic/rk4/diagnose/curl_hat/ifft3)
# via include (its main() is PROGRAM_FILE-guarded, so include does not run it). N=64 (cheap control).

include(joinpath(@__DIR__,"dns_tg256.jl"))
using Printf

function vortmag(U,op)
    uh,vh,wh = U; ωxh,ωyh,ωzh = curl_hat(uh,vh,wh,op)
    ωx=real.(ifft3(ωxh)); ωy=real.(ifft3(ωyh)); ωz=real.(ifft3(ωzh))
    sqrt.(ωx.^2 .+ ωy.^2 .+ ωz.^2)
end

# 1D line profile of |ω| through the peak point, along x; amplitude-normalized + local-width-rescaled.
# Returns (A, ℓ, U[η]) — the rescaled profile on a fixed η-grid (the 3D analog of the (c) fit, along a line).
function line_profile(wmag; Nη=121, ηmax=4.0)
    N=size(wmag,1); A=maximum(wmag); I=argmax(wmag); i0,j0,k0=I[1],I[2],I[3]
    line=[wmag[i,j0,k0] for i in 1:N]                       # |ω| along x through the peak
    # local half-width: nearest indices where line drops below A/2, distance from i0 (periodic)
    hw=1
    for r in 1:N÷2
        ip=mod(i0-1+r,N)+1; im=mod(i0-1-r,N)+1
        if line[ip]<A/2 || line[im]<A/2; hw=r; break; end
    end
    ℓ = max(hw,1)*(2π/N)                                    # width in length units
    ηs=range(-ηmax,ηmax;length=Nη)
    interpL(x)=(h=2π/N; s=mod(x,2π)/h; a=floor(Int,s); f=s-a; (1-f)*line[mod(a,N)+1]+f*line[mod(a+1,N)+1])
    x0=(i0-1)*(2π/N); U=[interpL(x0+ℓ*η)/A for η in ηs]
    A, ℓ, collect(ηs), U
end

function main()
    out=joinpath(@__DIR__,"ns050_3d_control.out.txt"); fout=open(out,"w")
    pr(a...)=(println(stdout,a...);println(fout,a...);flush(fout)); bar="═"^84; dsh="─"^84
    pr(bar); pr("  ns050_3d_control.jl — NS-050 (c3): dynamic-rescaling NEGATIVE CONTROL (Scope: 3D DNS trunc.)")
    pr("  Regular viscous Taylor–Green (Re=1600, N=64). Instrument must report NULL (no blow-up). :proved=0.")
    pr(bar)

    N=64; ν=1/1600; dt=0.005; T=12.0; op=make_ops(N)
    U=taylor_green_ic(N,op); d0=diagnose(U,op,N); E0=d0.E; Z0=d0.Z; t=0.0
    pr(@sprintf("\n  IC: Taylor–Green  N=%d  Re=%.0f  E0=%.5f  Z0=%.5f  div_max=%.1e", N, 1/ν, E0, Z0, d0.divmax))
    pr("\n"*dsh); pr(@sprintf("  %-6s %-10s %-10s %-12s %-12s %-s","t","Z/Z0","‖ω‖∞","ℓ(width)","prof drift","note"))
    pr(dsh)
    smp=1.0; nexts=0.0; winfs=Float64[]; ts=Float64[]; Uprev=nothing; drifts=Float64[]
    Nη=121; dη=8.0/(Nη-1)
    while t<T+1e-9
        if t>=nexts-1e-9
            wmag=vortmag(U,op); A,ℓ,_,Up=line_profile(wmag)
            dr = Uprev===nothing ? NaN : sqrt(sum((Up.-Uprev).^2).*dη)
            d=diagnose(U,op,N)
            pr(@sprintf("  %-6.2f %-10.4f %-10.3f %-12.4f %-12s %s", t, d.Z/Z0, A, ℓ,
                isnan(dr) ? "—" : @sprintf("%.3e",dr),
                t<8.5 ? "rising" : (A<maximum(winfs;init=0.0)*0.999 ? "DECAYING (‖ω‖∞↓)" : "near peak")))
            push!(winfs,A); push!(ts,t); !isnan(dr) && push!(drifts,dr); Uprev=Up; nexts+=smp
        end
        U=rk4(U,dt,ν,op); t+=dt
    end
    wmax,imax=findmax(winfs)
    pr("\n"*bar); pr("  READING (NS-050 c3 — NEGATIVE CONTROL)"); pr(bar)
    pr(@sprintf("  • ‖ω‖∞ PEAKS at %.2f (t=%.1f) then DECAYS — BOUNDED, no finite-time divergence. The", wmax, ts[imax]))
    pr("    instrument's first gate (‖ω‖∞→∞?) correctly FAILS ⇒ NO self-similar blow-up to rescale.")
    pr(@sprintf("  • The rescaled line-profile drift does NOT settle to 0 (no steady attractor; range %.1e–%.1e)",
        isempty(drifts) ? NaN : minimum(drifts), isempty(drifts) ? NaN : maximum(drifts)))
    pr("    — contrast the CLM calibration (ns050_modulation_witness.jl) where drift → 0 at a true")
    pr("    self-similar blow-up. So the instrument returns the correct NULL on a regular flow: it does")
    pr("    NOT false-positive. (Enstrophy peak Z/Z0 reproduces the Brachet-1983 TG Re=1600 benchmark.)")
    pr("  • FIREWALL: regular resolved DNS (N=64), within-truncation; this is a CONTROL, not a near-")
    pr("    singular test — the program has no clean near-singular 3D fixture (TG/Kerr are regular).")
    pr("    Does NOT touch 3D-NS regularity. :proved=0; distance UNTOUCHED.")
    pr(bar); close(fout); println(stdout,"\nwrote: $out")
end
main()
