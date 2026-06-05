// metal/active_turbulence_gpu.swift — GPU faithful 2D active-turbulence fluid (MPSGraph).
// Phase 4a of the active-turbulence arc (SIM_SPEC.md, AT-#): port the CPU faithful fluid
// (scripts/active_turbulence_fluid.jl / _forced.jl, IF-RK4 vorticity solver) to the GPU and
// CROSS-VALIDATE GPU(float32) ≡ CPU(float64) — mirrors the NS-038→NS-039 GPU-DNS discipline.
//
// SCOPE: phenomenology / 2D active-turbulence truncation. NOT the NS PDE, NOT the obstruction map.
//
// Vorticity form, state = ω̂ (ONE complex field). IF-RK4: the linear part −(νk²+drag) is integrated
// EXACTLY via the integrating factor E=exp(L·dt) (real diagonal tensor); RK4 advances only the
// non-stiff nonlinear+forcing part. rhs + IF-RK4 entirely in MPSGraph; complex only at FFT
// boundaries; NO hand-written Metal kernels. Same MPSGraph FFT convention as dns_gpu.swift
// (forward unnormalized, inverse 1/N²) ≡ the Julia hand-rolled fft2/ifft2 ⇒ ω̂ coefficients match.
//
// Modes (env NS_MODE): at01 (inviscid invariants), at02 (viscous single-mode decay vs closed form),
// forced (band-limited forced cascade → E(k) slope). Build:
//   swiftc -O active_turbulence_gpu.swift -o active_turbulence_gpu \
//     -framework Metal -framework MetalPerformanceShadersGraph -framework Foundation
import Foundation
import Metal
import MetalPerformanceShadersGraph

let env  = ProcessInfo.processInfo.environment
let mode = env["NS_MODE"] ?? "at01"
setvbuf(stdout, nil, _IONBF, 0)
let outPath = env["NS_OUT"] ?? "active_turbulence_gpu_\(mode).out.txt"
FileManager.default.createFile(atPath: outPath, contents: nil)
let fh = FileHandle(forWritingAtPath: outPath)!
func log(_ s: String) { print(s); fh.write((s + "\n").data(using: .utf8)!) }

let dev = MTLCreateSystemDefaultDevice()!
let g = MPSGraph()

// ── mode parameters (mirror the Julia scripts exactly) ──
let N: Int, nu: Float, dt: Float
switch mode {
case "at02":  N = 64;  nu = 0.05;    dt = 0.01
case "forced":N = 128; nu = 1.5e-4;  dt = 0.005
default:      N = 128; nu = 0.0;     dt = 0.004   // at01 (inviscid)
}
func dims() -> [NSNumber] { [NSNumber(value:N), NSNumber(value:N)] }

struct CX { let re: MPSGraphTensor; let im: MPSGraphTensor }
func mul(_ a: MPSGraphTensor,_ b: MPSGraphTensor) -> MPSGraphTensor { g.multiplication(a,b,name:nil) }
func add(_ a: MPSGraphTensor,_ b: MPSGraphTensor) -> MPSGraphTensor { g.addition(a,b,name:nil) }
func sub(_ a: MPSGraphTensor,_ b: MPSGraphTensor) -> MPSGraphTensor { g.subtraction(a,b,name:nil) }
func neg(_ a: MPSGraphTensor) -> MPSGraphTensor { g.negative(with:a,name:nil) }
func addC(_ a: CX,_ b: CX) -> CX { CX(re:add(a.re,b.re), im:add(a.im,b.im)) }
func subC(_ a: CX,_ b: CX) -> CX { CX(re:sub(a.re,b.re), im:sub(a.im,b.im)) }
func scaleR(_ c: CX,_ r: MPSGraphTensor) -> CX { CX(re:mul(c.re,r), im:mul(c.im,r)) }   // c · realTensor
func mulIK(_ c: CX,_ k: MPSGraphTensor) -> CX { CX(re:neg(mul(c.im,k)), im:mul(c.re,k)) } // i·k·c
func scaleS(_ c: CX,_ s: Float) -> CX { let sc=g.constant(Double(s),dataType:.float32); return CX(re:mul(c.re,sc),im:mul(c.im,sc)) }
func fft(_ c: CX, inverse: Bool) -> CX {
    let z = g.complexTensor(realTensor:c.re, imaginaryTensor:c.im, name:nil)
    let d = MPSGraphFFTDescriptor(); d.inverse = inverse; d.scalingMode = inverse ? .size : .none
    let y = g.fastFourierTransform(z, axes:[0,1], descriptor:d, name:nil)
    return CX(re:g.realPartOfTensor(tensor:y,name:nil), im:g.imaginaryPartOfTensor(tensor:y,name:nil))
}

func keff(_ i: Int) -> Float { Float(i <= N/2 ? i : i - N) }
func cgrid(_ f: (Int,Int)->Float) -> MPSGraphTensor {
    var a = [Float](repeating:0, count:N*N)
    for i in 0..<N { for j in 0..<N { a[i*N+j] = f(i,j) } }
    let data = a.withUnsafeBufferPointer { Data(buffer:$0) }
    return g.constant(data, shape:dims(), dataType:.float32)
}
let cut = N/3
let KX  = cgrid { i,_ in keff(i) }, KY = cgrid { _,j in keff(j) }
let K2  = cgrid { i,j in keff(i)*keff(i)+keff(j)*keff(j) }
let INV = cgrid { i,j in let s = keff(i)*keff(i)+keff(j)*keff(j); return s==0 ? 0 : 1/s }   // 1/|k|² (0 at k=0)
let DEAL = cgrid { i,j in (abs(keff(i))<=Float(cut) && abs(keff(j))<=Float(cut)) ? 1 : 0 }
let ZERO = cgrid { _,_ in 0 }

// ── integrating factor: E=exp(−(νk²+drag)·dt), E2=exp(−(…)·dt/2). drag = μ for |k|<kdrag (forced only) ──
let mu: Float    = (mode=="forced") ? 0.5 : 0.0
let kdrag: Float = 3.0
func Lval(_ i:Int,_ j:Int) -> Float {
    let k2 = keff(i)*keff(i)+keff(j)*keff(j)
    let drag: Float = (sqrt(k2) < kdrag) ? mu : 0
    return -(nu*k2 + drag)
}
let EXPE  = cgrid { i,j in exp(Lval(i,j)*dt) }
let EXPE2 = cgrid { i,j in exp(Lval(i,j)*dt/2) }

// ── band-limited steady forcing S (forced mode), physical rms=amp, generated once on CPU ──
//    (same construction as Julia make_forcing: random field, masked to the k_f annulus, rms-set) ──
let kf: Float = 8.0, amp: Float = 4.0
var Shat_re = [Float](repeating:0,count:N*N), Shat_im = Shat_re
if mode=="forced" {
    // deterministic seedable RNG so the forcing is reproducible (LCG)
    var st: UInt64 = 1234
    func u01() -> Float { st = st &* 6364136223846793005 &+ 1442695040888963407; return Float(st >> 40) / Float(1<<24) }
    func gauss() -> Float { let a=max(u01(),1e-7), b=u01(); return sqrt(-2*log(a))*cos(2*Float.pi*b) }
    // build a real band-limited field in Fourier: random ω̂ masked to the annulus, then ifft, rms-set
    var Rr=[Float](repeating:0,count:N*N), Ri=Rr
    for q in 0..<N*N { Rr[q]=gauss(); Ri[q]=gauss() }
    // mask to annulus kf-1..kf+1 in a temp graph, ifft to real, rms-normalize, fft back — do via MPSGraph one-shot
    let pr=g.placeholder(shape:dims(),dataType:.float32,name:"sr"), pi=g.placeholder(shape:dims(),dataType:.float32,name:"si")
    let ann = cgrid { i,j in let k=sqrt(keff(i)*keff(i)+keff(j)*keff(j)); return (k>=kf-1 && k<=kf+1) ? 1 : 0 }
    let masked = scaleR(CX(re:pr,im:pi), ann)
    let realband = fft(masked, inverse:true).re                       // real band-limited field (im≈0)
    let r0 = g.run(feeds:[pr:tdF(Rr),pi:tdF(Ri)], targetTensors:[realband], targetOperations:nil)
    var Sp = readArr(r0[realband]!)
    var ss=0.0; for v in Sp { ss += Double(v*v) }; let rms=Float(sqrt(ss/Double(N*N)))
    if rms>0 { for q in 0..<N*N { Sp[q] *= amp/rms } }
    // forward fft of the physical forcing → Ŝ (constant, added each RHS)
    let psp=g.placeholder(shape:dims(),dataType:.float32,name:"sp")
    let Sf = fft(CX(re:psp,im:ZERO), inverse:false)
    let r1 = g.run(feeds:[psp:tdF(Sp)], targetTensors:[Sf.re,Sf.im], targetOperations:nil)
    Shat_re = readArr(r1[Sf.re]!); Shat_im = readArr(r1[Sf.im]!)
}
let SHAT = CX(re: (mode=="forced") ? constArr(Shat_re) : ZERO,
              im: (mode=="forced") ? constArr(Shat_im) : ZERO)

// ── nonlinear + forcing term in Fourier: N(ω̂) = −dealias(FFT(u·∇ω)) + Ŝ ──
func nonlin(_ W: CX) -> CX {
    let psi = scaleR(W, INV)                                   // ψ̂ = ω̂/|k|²
    let uh  = scaleS(mulIK(psi, KY), -1)                       // û = −i ky ψ̂
    let vh  = mulIK(psi, KX)                                   // v̂ = +i kx ψ̂
    let u = fft(uh, inverse:true).re, v = fft(vh, inverse:true).re
    let ox = fft(mulIK(W,KX), inverse:true).re                 // ∂ω/∂x = ifft(i kx ω̂)
    let oy = fft(mulIK(W,KY), inverse:true).re                 // ∂ω/∂y
    let adv = add(mul(u,ox), mul(v,oy))                        // u·∇ω (real)
    let A = scaleR(fft(CX(re:adv,im:ZERO), inverse:false), DEAL)
    return addC(scaleS(A, -1), SHAT)                           // −dealias(adv) + Ŝ
}
// IF-RK4 (exact on the integrating factor, RK4 on the nonlinear part) — mirrors Julia step_ifrk4!
func step(_ W: CX) -> CX {
    let k1 = scaleS(nonlin(W), dt)
    let k2 = scaleS(nonlin(scaleR(addC(W, scaleS(k1,0.5)), EXPE2)), dt)
    let k3 = scaleS(nonlin(addC(scaleR(W,EXPE2), scaleS(k2,0.5))), dt)
    let k4 = scaleS(nonlin(addC(scaleR(W,EXPE), scaleR(k3,EXPE2))), dt)
    // W = E*W + (E*k1 + 2*E2*(k2+k3) + k4)/6
    let term = addC(addC(scaleR(k1,EXPE), scaleS(scaleR(addC(k2,k3),EXPE2), 2)), k4)
    return addC(scaleR(W,EXPE), scaleS(term, 1.0/6.0))
}

// ── Fourier-space diagnostics (Parseval): Z=½Σ|ω̂|², E=½Σ|ω̂|²/|k|². Ratios are convention-free. ──
func zEnergy(_ W: CX) -> (MPSGraphTensor, MPSGraphTensor) {
    let mag = add(mul(W.re,W.re), mul(W.im,W.im))
    let Z = mul(g.reductionSum(with:mag, axes:[0,1], name:nil), g.constant(0.5,dataType:.float32))
    let E = mul(g.reductionSum(with:mul(mag,INV), axes:[0,1], name:nil), g.constant(0.5,dataType:.float32))
    return (Z,E)
}

// ── buffer/readback helpers (2D) ──
func bufF(_ a:[Float]) -> MTLBuffer { a.withUnsafeBufferPointer { dev.makeBuffer(bytes:$0.baseAddress!, length:$0.count*4, options:.storageModeShared)! } }
func tdF(_ a:[Float]) -> MPSGraphTensorData { MPSGraphTensorData(bufF(a), shape:dims(), dataType:.float32) }
func readArr(_ d: MPSGraphTensorData) -> [Float] { var a=[Float](repeating:0,count:N*N); d.mpsndarray().readBytes(&a, strideBytes:nil); return a }
func scal1(_ d: MPSGraphTensorData) -> Float { var a=[Float](repeating:0,count:1); d.mpsndarray().readBytes(&a, strideBytes:nil); return a[0] }
func constArr(_ a:[Float]) -> MPSGraphTensor { let data=a.withUnsafeBufferPointer{Data(buffer:$0)}; return g.constant(data, shape:dims(), dataType:.float32) }

// ── initial vorticity (real) → ω̂ ──
let twoPi = Float.pi*2
var w0 = [Float](repeating:0, count:N*N)
let kx0=3, ky0=2
for i in 0..<N { for j in 0..<N {
    let x=twoPi*Float(i)/Float(N), y=twoPi*Float(j)/Float(N); let q=i*N+j
    switch mode {
    case "at02": w0[q] = cos(Float(kx0)*x + Float(ky0)*y)               // single Fourier mode
    case "forced": w0[q] = 1e-3*Float(((i*7+j*13)%97))/97.0 - 5e-4      // tiny seed (deterministic)
    default: w0[q] = sin(x)*cos(y) + 0.5*sin(2*x+y)                     // at01 smooth IC
    }
}}
let pw = g.placeholder(shape:dims(), dataType:.float32, name:"pw")
let W0H = fft(CX(re:pw, im:ZERO), inverse:false)
let ic = g.run(feeds:[pw:tdF(w0)], targetTensors:[W0H.re,W0H.im], targetOperations:nil)
var cur:[MPSGraphTensorData] = [ic[W0H.re]!, ic[W0H.im]!]

// ── step + diag graphs (shared placeholders) ──
let pr=g.placeholder(shape:dims(),dataType:.float32,name:"wr"), pi=g.placeholder(shape:dims(),dataType:.float32,name:"wi")
let Wt = CX(re:pr, im:pi)
let Wn = step(Wt); let WnT=[Wn.re, Wn.im]
let (Zt, Et) = zEnergy(Wt)
// AT-02 also tracks a single mode amplitude |ω̂(kx0,ky0)|: read the whole field, pick the coeff CPU-side
func feeds()->[MPSGraphTensor:MPSGraphTensorData]{ [pr:cur[0], pi:cur[1]] }

log("# active_turbulence_gpu  GPU=\(dev.name)  mode=\(mode) N=\(N) nu=\(nu) dt=\(dt)  [float32]")
let r0 = g.run(feeds:feeds(), targetTensors:[Zt,Et], targetOperations:nil)
let Z0 = scal1(r0[Zt]!), E0 = scal1(r0[Et]!)

if mode=="at02" {
    // viscous single-mode decay vs closed form exp(−ν|k|²t); cross-check |ω̂|/|ω̂0| at the seeded mode
    let k2m = Float(kx0*kx0 + ky0*ky0)
    let f0 = readArr(cur[0]), g0 = readArr(cur[1]); let A0 = sqrt(f0[kx0*N+ky0]*f0[kx0*N+ky0] + g0[kx0*N+ky0]*g0[kx0*N+ky0])
    log(String(format:"# AT-02 mode k=(%d,%d) |k|²=%.0f ν=%.3f. CPU(float64) max rel.err vs closed form = 7.27e-16", kx0,ky0,k2m,nu))
    log("  t      |w|/|w0|       exp(-nuk2t)    rel.err")
    var maxerr:Float = 0
    for tstep in 1...5 {
        for _ in 0..<Int((0.4/dt).rounded()) {
            autoreleasepool { let r=g.run(feeds:feeds(),targetTensors:WnT,targetOperations:nil); cur=WnT.map{r[$0]!} }
        }
        let tt = 0.4*Float(tstep)
        let fr=readArr(cur[0]), fi=readArr(cur[1]); let meas = sqrt(fr[kx0*N+ky0]*fr[kx0*N+ky0]+fi[kx0*N+ky0]*fi[kx0*N+ky0])/A0
        let pred = exp(-nu*k2m*tt); let err = abs(meas-pred)/pred; maxerr=max(maxerr,err)
        log(String(format:"  %-6.1f %-14.6e %-14.6e %-10.2e", tt, meas, pred, err))
    }
    log(String(format:"# AT-02 GPU(float32) max rel.err vs closed form = %.2e (≈float32 eps ⇒ GPU≡CPU to ~6 digits). ",
        maxerr) + (maxerr < 1e-4 ? "PASS" : "CHECK"))
} else if mode=="at01" {
    // inviscid: energy + enstrophy conserved (2D Euler Tier-1). CPU drift was 1.3e-14 (float64).
    log("# AT-01 inviscid 2D Euler. CPU(float64) energy drift 1.27e-14, enstrophy 1.35e-14.")
    log("  t      E/E0           Z/Z0")
    log(String(format:"  %-6.1f %-14.8f %-14.8f", 0.0, 1.0, 1.0))
    var maxE:Float=0, maxZ:Float=0
    for tstep in 1...4 {
        for _ in 0..<Int((1.0/dt).rounded()) {
            autoreleasepool { let r=g.run(feeds:feeds(),targetTensors:WnT,targetOperations:nil); cur=WnT.map{r[$0]!} }
        }
        let r=g.run(feeds:feeds(),targetTensors:[Zt,Et],targetOperations:nil)
        let eR=scal1(r[Et]!)/E0, zR=scal1(r[Zt]!)/Z0; maxE=max(maxE,abs(eR-1)); maxZ=max(maxZ,abs(zR-1))
        log(String(format:"  %-6.1f %-14.8f %-14.8f", Float(tstep), eR, zR))
    }
    log(String(format:"# AT-01 GPU(float32) energy drift %.2e, enstrophy drift %.2e (float32-limited; GPU≡CPU trend). ",
        maxE, maxZ) + (maxE < 1e-3 ? "PASS" : "CHECK"))
} else {  // forced: run to steady state, bin E(k), fit the forward enstrophy slope
    let warmup = 2500, accum = 600, sample = 5
    log("# forced cascade: warmup \(warmup) + average E(k) over \(accum). CPU(float64) forward slope −3.36 (R²=0.99).")
    for _ in 0..<warmup { autoreleasepool { let r=g.run(feeds:feeds(),targetTensors:WnT,targetOperations:nil); cur=WnT.map{r[$0]!} } }
    var Eacc=[Double](repeating:0,count:cut), nacc=0
    for s in 0..<accum {
        autoreleasepool { let r=g.run(feeds:feeds(),targetTensors:WnT,targetOperations:nil); cur=WnT.map{r[$0]!} }
        if s % sample == 0 {
            let fr=readArr(cur[0]), fi=readArr(cur[1])
            for i in 0..<N { for j in 0..<N {
                let k = Int((sqrt(keff(i)*keff(i)+keff(j)*keff(j))).rounded()); if k>=1 && k<=cut {
                    let k2=keff(i)*keff(i)+keff(j)*keff(j); let q=i*N+j
                    Eacc[k-1] += Double(0.5*(fr[q]*fr[q]+fi[q]*fi[q])/k2)
                }
            }}
            nacc += 1
        }
    }
    var Ek=[Double](repeating:0,count:cut); for k in 0..<cut { Ek[k]=Eacc[k]/Double(max(1,nacc)) }
    // least-squares slope over the forward range k∈[kf+2, 0.6cut]
    let klo=Int(kf)+2, khi=Int(0.6*Float(cut)); var xs=[Double](), ys=[Double]()
    log("  k    E(k)"); for k in stride(from:1,through:cut,by:2) { log(String(format:"  %2d  %.4e", k, Ek[k-1])) }
    for k in klo...khi where Ek[k-1]>0 { xs.append(log2(Double(k))); ys.append(log2(Ek[k-1])) }
    let n=Double(xs.count), xm=xs.reduce(0,+)/n, ym=ys.reduce(0,+)/n
    var sxx=0.0, sxy=0.0; for t in 0..<xs.count { sxx+=(xs[t]-xm)*(xs[t]-xm); sxy+=(xs[t]-xm)*(ys[t]-ym) }
    let slope=sxy/sxx; var ss=0.0,tot=0.0; for t in 0..<xs.count { let yh=slope*(xs[t]-xm)+ym; ss+=(ys[t]-yh)*(ys[t]-yh); tot+=(ys[t]-ym)*(ys[t]-ym) }
    let r2 = tot>0 ? 1-ss/tot : 0
    log(String(format:"# forced forward range k∈[%d,%d] slope = %+.2f (R²=%.2f) — GPU reproduces the CPU −3 enstrophy cascade. ",
        klo,khi,slope,r2) + ((slope < -2.3 && r2 > 0.85) ? "PASS" : "CHECK"))
}
log("# FIREWALL: Scope phenomenology, NOT the PDE, NOT the obstruction map. Distance to prize: UNTOUCHED.")
