// metal/dns_gpu.swift — GPU spectral NS DNS (MPSGraph). Stages 2+3+4.
// rhs (rotational form) + RK4 entirely in MPSGraph; fields as (re,im) real-tensor pairs;
// complex only at FFT boundaries; NO hand-written Metal kernels.
// Time-loop ping-pongs GPU-resident tensors across steps (no per-step CPU readback);
// scalar diagnostics (E,H,Z,‖ω‖∞) read only at sample times.
// Env: NS_N NS_T NS_DT NS_NU NS_SAMPLE NS_IC(tg|abc).  Validation gate: Brachet TG Re=1600
// enstrophy peak at t≈9 (cross-check vs the CPU run); ABC inviscid stays stationary.
// Build: swiftc -O dns_gpu.swift -o dns_gpu -framework Metal -framework MetalPerformanceShadersGraph -framework Foundation
import Foundation
import Metal
import MetalPerformanceShadersGraph

let env = ProcessInfo.processInfo.environment
let N   = Int(env["NS_N"] ?? "256")!
let T   = Float(env["NS_T"] ?? "10")!
let dt  = Float(env["NS_DT"] ?? "0.005")!
let nu  = Float(env["NS_NU"] ?? String(1.0/1600.0))!
let smp = Float(env["NS_SAMPLE"] ?? "0.5")!
let ic  = env["NS_IC"] ?? "tg"
let snapTimes = (env["NS_SNAP"] ?? "").split(separator: ",").compactMap { Float($0) }  // times to dump spectral field

// Output: unbuffer stdout AND mirror to a flushed file (Swift block-buffers piped stdout —
// a prior run lost all output). log() prints + appends+flushes per line ⇒ live-monitorable.
setvbuf(stdout, nil, _IONBF, 0)
let outPath = env["NS_OUT"] ?? "dns_gpu_N\(N)_\(ic).out.txt"
FileManager.default.createFile(atPath: outPath, contents: nil)
let fh = FileHandle(forWritingAtPath: outPath)!
func log(_ s: String) { print(s); fh.write((s + "\n").data(using: .utf8)!) }

let dev = MTLCreateSystemDefaultDevice()!
let g = MPSGraph()
func dimsN() -> [NSNumber] { [NSNumber(value:N), NSNumber(value:N), NSNumber(value:N)] }

struct CX { let re: MPSGraphTensor; let im: MPSGraphTensor }
func mul(_ a: MPSGraphTensor, _ b: MPSGraphTensor) -> MPSGraphTensor { g.multiplication(a, b, name: nil) }
func add(_ a: MPSGraphTensor, _ b: MPSGraphTensor) -> MPSGraphTensor { g.addition(a, b, name: nil) }
func sub(_ a: MPSGraphTensor, _ b: MPSGraphTensor) -> MPSGraphTensor { g.subtraction(a, b, name: nil) }
func neg(_ a: MPSGraphTensor) -> MPSGraphTensor { g.negative(with: a, name: nil) }
func addC(_ a: CX, _ b: CX) -> CX { CX(re: add(a.re,b.re), im: add(a.im,b.im)) }
func subC(_ a: CX, _ b: CX) -> CX { CX(re: sub(a.re,b.re), im: sub(a.im,b.im)) }
func scaleR(_ c: CX, _ r: MPSGraphTensor) -> CX { CX(re: mul(c.re,r), im: mul(c.im,r)) }
func mulIK(_ c: CX, _ k: MPSGraphTensor) -> CX { CX(re: neg(mul(c.im,k)), im: mul(c.re,k)) }
func scaleS(_ c: CX, _ s: Float) -> CX { let sc = g.constant(Double(s), dataType: .float32); return CX(re: mul(c.re, sc), im: mul(c.im, sc)) }
func fft(_ c: CX, inverse: Bool) -> CX {
    let z = g.complexTensor(realTensor: c.re, imaginaryTensor: c.im, name: nil)
    let d = MPSGraphFFTDescriptor(); d.inverse = inverse; d.scalingMode = inverse ? .size : .none
    let y = g.fastFourierTransform(z, axes: [0,1,2], descriptor: d, name: nil)
    return CX(re: g.realPartOfTensor(tensor: y, name: nil), im: g.imaginaryPartOfTensor(tensor: y, name: nil))
}

func keff(_ i: Int) -> Float { Float(i <= N/2 ? i : i - N) }
func cgrid(_ f: (Int,Int,Int)->Float) -> MPSGraphTensor {
    var a = [Float](repeating: 0, count: N*N*N)
    for i in 0..<N { for j in 0..<N { for k in 0..<N { a[(i*N+j)*N+k] = f(i,j,k) } } }
    let data = a.withUnsafeBufferPointer { Data(buffer: $0) }
    return g.constant(data, shape: dimsN(), dataType: .float32)
}
let cut = N/3
let KX = cgrid { i,_,_ in keff(i) }, KY = cgrid { _,j,_ in keff(j) }, KZ = cgrid { _,_,k in keff(k) }
let K2 = cgrid { i,j,k in keff(i)*keff(i)+keff(j)*keff(j)+keff(k)*keff(k) }
let INV = cgrid { i,j,k in let s = keff(i)*keff(i)+keff(j)*keff(j)+keff(k)*keff(k); return s==0 ? 0 : 1/s }
let DEAL = cgrid { i,j,k in (abs(keff(i))<=Float(cut) && abs(keff(j))<=Float(cut) && abs(keff(k))<=Float(cut)) ? 1 : 0 }
let ZERO = cgrid { _,_,_ in 0 }
let NUK2 = cgrid { i,j,k in nu*(keff(i)*keff(i)+keff(j)*keff(j)+keff(k)*keff(k)) }   // ν|k|²

func curl(_ uh: CX, _ vh: CX, _ wh: CX) -> (CX,CX,CX) {
    (subC(mulIK(wh, KY), mulIK(vh, KZ)),     // ω̂_x = i(ky ŵ − kz v̂)
     subC(mulIK(uh, KZ), mulIK(wh, KX)),     // ω̂_y = i(kz û − kx ŵ)
     subC(mulIK(vh, KX), mulIK(uh, KY)))     // ω̂_z = i(kx v̂ − ky û)
}
func rhs(_ uh: CX, _ vh: CX, _ wh: CX) -> (CX,CX,CX) {
    let (wxh,wyh,wzh) = curl(uh,vh,wh)
    let u = fft(uh, inverse:true).re, v = fft(vh, inverse:true).re, w = fft(wh, inverse:true).re
    let ox = fft(wxh, inverse:true).re, oy = fft(wyh, inverse:true).re, oz = fft(wzh, inverse:true).re
    let cx = sub(mul(v,oz), mul(w,oy)), cy = sub(mul(w,ox), mul(u,oz)), cz = sub(mul(u,oy), mul(v,ox))
    var Cx = fft(CX(re:cx, im:ZERO), inverse:false); Cx = scaleR(Cx, DEAL)
    var Cy = fft(CX(re:cy, im:ZERO), inverse:false); Cy = scaleR(Cy, DEAL)
    var Cz = fft(CX(re:cz, im:ZERO), inverse:false); Cz = scaleR(Cz, DEAL)
    let kdotC = addC(addC(scaleR(Cx,KX), scaleR(Cy,KY)), scaleR(Cz,KZ))
    let t = scaleR(kdotC, INV)
    let rx = subC(subC(Cx, scaleR(t, KX)), scaleR(uh, NUK2))   // P[C] − ν k² û
    let ry = subC(subC(Cy, scaleR(t, KY)), scaleR(vh, NUK2))
    let rz = subC(subC(Cz, scaleR(t, KZ)), scaleR(wh, NUK2))
    return (rx, ry, rz)
}
func axpy(_ U:(CX,CX,CX), _ a: Float, _ k:(CX,CX,CX)) -> (CX,CX,CX) {
    (addC(U.0, scaleS(k.0,a)), addC(U.1, scaleS(k.1,a)), addC(U.2, scaleS(k.2,a)))
}
func sel(_ t:(CX,CX,CX),_ i:Int)->CX { i==0 ? t.0 : i==1 ? t.1 : t.2 }
func rk4(_ U:(CX,CX,CX)) -> (CX,CX,CX) {
    let k1 = rhs(U.0,U.1,U.2)
    let a2 = axpy(U, dt/2, k1); let k2 = rhs(a2.0,a2.1,a2.2)
    let a3 = axpy(U, dt/2, k2); let k3 = rhs(a3.0,a3.1,a3.2)
    let a4 = axpy(U, dt,   k3); let k4 = rhs(a4.0,a4.1,a4.2)
    func comp(_ i:Int) -> CX {
        let s = addC(addC(sel(k1,i), scaleS(sel(k2,i),2)), addC(scaleS(sel(k3,i),2), sel(k4,i)))
        return addC(sel(U,i), scaleS(s, dt/6))
    }
    return (comp(0), comp(1), comp(2))
}
// diagnostics: E=½⟨|u|²⟩, H=⟨u·ω⟩, Z=½⟨|ω|²⟩, ‖ω‖∞
func diag(_ uh: CX, _ vh: CX, _ wh: CX) -> (MPSGraphTensor,MPSGraphTensor,MPSGraphTensor,MPSGraphTensor) {
    let (wxh,wyh,wzh) = curl(uh,vh,wh)
    let u = fft(uh, inverse:true).re, v = fft(vh, inverse:true).re, w = fft(wh, inverse:true).re
    let ox = fft(wxh, inverse:true).re, oy = fft(wyh, inverse:true).re, oz = fft(wzh, inverse:true).re
    let e2 = add(add(mul(u,u),mul(v,v)),mul(w,w))
    let E = mul(g.mean(of: e2, axes:[0,1,2], name:nil), g.constant(0.5, dataType:.float32))
    let h = add(add(mul(u,ox),mul(v,oy)),mul(w,oz)); let H = g.mean(of: h, axes:[0,1,2], name:nil)
    let o2 = add(add(mul(ox,ox),mul(oy,oy)),mul(oz,oz))
    let Z = mul(g.mean(of: o2, axes:[0,1,2], name:nil), g.constant(0.5, dataType:.float32))
    let winf = g.squareRoot(with: g.reductionMaximum(with: o2, axes:[0,1,2], name:nil), name:nil)
    return (E,H,Z,winf)
}
// divergence k·û (Fourier) — must be ~0 (Leray). Returns RELATIVE max: max|k·û| / max|û|.
// The FFT is unnormalized, so energy-mode coefficients are ~N³/8 (≈3e4 at N=64, ∝N³).
// An absolute k·û of O(0.06) against |û|~3e4 is a RELATIVE divergence ~1e-6 = float32 eps:
// the field is div-free to float32. The relative form is the N-independent, honest check.
func divMaxTensor(_ uh: CX,_ vh: CX,_ wh: CX) -> MPSGraphTensor {
    let dre = add(add(mul(KX,uh.re),mul(KY,vh.re)),mul(KZ,wh.re))
    let dim = add(add(mul(KX,uh.im),mul(KY,vh.im)),mul(KZ,wh.im))
    let dmax = g.squareRoot(with: g.reductionMaximum(with: add(mul(dre,dre),mul(dim,dim)), axes:[0,1,2], name:nil), name:nil)
    let umag = add(add(add(mul(uh.re,uh.re),mul(uh.im,uh.im)),
                       add(mul(vh.re,vh.re),mul(vh.im,vh.im))),
                   add(mul(wh.re,wh.re),mul(wh.im,wh.im)))
    let umax = g.squareRoot(with: g.reductionMaximum(with: umag, axes:[0,1,2], name:nil), name:nil)
    return g.division(dmax, umax, name:nil)   // relative divergence
}

// ---- buffers ----
func buf(_ a:[Float]) -> MTLBuffer { a.withUnsafeBufferPointer { dev.makeBuffer(bytes:$0.baseAddress!, length:$0.count*4, options:.storageModeShared)! } }
func td(_ b: MTLBuffer) -> MPSGraphTensorData { MPSGraphTensorData(b, shape: dimsN(), dataType:.float32) }
func scal(_ d: MPSGraphTensorData) -> Float { var a=[Float](repeating:0,count:1); d.mpsndarray().readBytes(&a, strideBytes:nil); return a[0] }
func readF(_ d: MPSGraphTensorData) -> [Float] { var a=[Float](repeating:0,count:N*N*N); d.mpsndarray().readBytes(&a, strideBytes:nil); return a }

// ---- IC ----
// tg / abc: build velocity (u0,v0,w0) directly. tubes (Kerr anti-parallel vortex tubes, the
// reconnection / near-singular IC, NS-038 case C): build the SEED VORTICITY ωx in real space
// (two anti-parallel Gaussian tubes with a sinusoidal perturbation; ωy=ωz=0), carried in u0;
// the velocity is recovered in-graph (Leray-project ω, then û = i k×ω̂/|k|²) and energy-
// normalized to E=0.125 — mirrors scripts/dns_tg256.jl vortex_tube_ic (a=0.30,b=0.80,ε=0.30,kx=1).
let twoPi = Float.pi*2
var u0=[Float](repeating:0,count:N*N*N), v0=u0, w0=u0
let tubeA:Float=0.30, tubeB:Float=0.80, tubeEps:Float=0.30, tubeKx:Float=1.0, y0=Float.pi
for i in 0..<N { for j in 0..<N { for k in 0..<N {
    let x=twoPi*Float(i)/Float(N), y=twoPi*Float(j)/Float(N), z=twoPi*Float(k)/Float(N); let q=(i*N+j)*N+k
    if ic=="abc" { u0[q]=sin(z)+cos(y); v0[q]=sin(x)+cos(z); w0[q]=sin(y)+cos(x) }
    else if ic=="abcpert" {   // ABC Beltrami (steady, ρ_H≈1) + small non-Beltrami perturbation ⇒ cascades
        u0[q]=sin(z)+cos(y) + 0.1*sin(2*y)*cos(3*z)
        v0[q]=sin(x)+cos(z) + 0.1*sin(2*z)*cos(3*x)
        w0[q]=sin(y)+cos(x) + 0.1*sin(2*x)*cos(3*y)
    }
    else if ic=="tubes" {
        let dz=tubeEps*sin(tubeKx*x); let zp=Float.pi+tubeB+dz, zm=Float.pi-tubeB-dz
        let rp2=(y-y0)*(y-y0)+(z-zp)*(z-zp), rm2=(y-y0)*(y-y0)+(z-zm)*(z-zm)
        u0[q]=(exp(-rp2/(tubeA*tubeA))-exp(-rm2/(tubeA*tubeA)))/(Float.pi*tubeA*tubeA)   // = ωx seed
    }
    else if ic=="helical" || ic=="helicalc" { }   // built below in a separate k-set sum
    else { u0[q]=sin(x)*cos(y)*cos(z); v0[q] = -cos(x)*sin(y)*cos(z); w0[q]=0 }   // Taylor–Green
}}}
// Strongly-helical ICs (NS option B). Superpose +helical Beltrami waves over a low-k set:
//   v_k(x) = e₁ cos(k·x) − s·e₂ sin(k·x),  with {e₁,e₂,k/|k|} right-handed orthonormal.
// Each v_k satisfies curl v_k = +|k| v_k (Beltrami) for s=+1 ⇒ helicity-density positive ⇒ ρ_H≈+1
// (the multi-shell sum is slightly below 1 by Cauchy–Schwarz). "helical": s=+1 every mode.
// "helicalc" (CONTROL): s alternates ±1 ⇒ equal ± helical content ⇒ ρ_H≈0 at the SAME energy
// spectrum — the matched non-helical comparison. Each real cosine wave already carries the k,−k
// Hermitian pair, so only the upper-half k-set is summed.
if ic=="helical" || ic=="helicalc" {
    let kmax2 = 6   // low-k shells |k|² ∈ {1..6}
    var mode = 0
    for kx in -2...2 { for ky in -2...2 { for kz in 0...2 {
        let k2 = kx*kx + ky*ky + kz*kz
        if k2 < 1 || k2 > kmax2 { continue }
        if kz==0 && (ky<0 || (ky==0 && kx<=0)) { continue }   // upper half ⇒ no k/−k double count
        let kfx=Float(kx), kfy=Float(ky), kfz=Float(kz), kn=sqrt(Float(k2))
        // e₁ = normalize(k × ẑ) = normalize((ky,−kx,0)); if k∥ẑ use x̂
        var e1x:Float=1, e1y:Float=0, e1z:Float=0; let perp=sqrt(Float(kx*kx+ky*ky))
        if perp > 1e-6 { e1x=kfy/perp; e1y = -kfx/perp; e1z=0 }
        // e₂ = (k × e₁)/|k|
        let e2x=(kfy*e1z-kfz*e1y)/kn, e2y=(kfz*e1x-kfx*e1z)/kn, e2z=(kfx*e1y-kfy*e1x)/kn
        let s:Float = (ic=="helicalc" && mode%2==1) ? -1 : 1
        mode += 1
        for i in 0..<N { for j in 0..<N { for kk in 0..<N {
            let x=twoPi*Float(i)/Float(N), y=twoPi*Float(j)/Float(N), z=twoPi*Float(kk)/Float(N)
            let th = kfx*x + kfy*y + kfz*z; let c=cos(th), sn=sin(th); let q=(i*N+j)*N+kk
            u0[q] += e1x*c - s*e2x*sn; v0[q] += e1y*c - s*e2y*sn; w0[q] += e1z*c - s*e2z*sn
        }}}
    }}}
}
// CPU energy-normalize the option-B ICs to E=½⟨|u|²⟩=0.125 (TG/abc are already O(1); tubes
// normalizes in-graph). One-time scaling of the real-space field before the IC FFT.
if ic=="helical" || ic=="helicalc" || ic=="abcpert" {
    var e2sum=0.0; for q in 0..<N*N*N { e2sum += Double(u0[q]*u0[q]+v0[q]*v0[q]+w0[q]*w0[q]) }
    let sc = Float(sqrt(0.125 / (0.5*e2sum/Double(N*N*N))))
    for q in 0..<N*N*N { u0[q]*=sc; v0[q]*=sc; w0[q]*=sc }
}
let pu=g.placeholder(shape:dimsN(),dataType:.float32,name:"pu"), pv=g.placeholder(shape:dimsN(),dataType:.float32,name:"pv"), pw=g.placeholder(shape:dimsN(),dataType:.float32,name:"pw")
let UH:CX, VH:CX, WH:CX
if ic=="tubes" {
    let wxh=fft(CX(re:pu,im:ZERO),inverse:false)               // ω̂x  (ω̂y=ω̂z=0)
    let wyh=CX(re:ZERO,im:ZERO), wzh=CX(re:ZERO,im:ZERO)
    let kdw=addC(addC(scaleR(wxh,KX),scaleR(wyh,KY)),scaleR(wzh,KZ))   // k·ω̂
    let tp=scaleR(kdw,INV)
    let wxP=subC(wxh,scaleR(tp,KX)), wyP=subC(wyh,scaleR(tp,KY)), wzP=subC(wzh,scaleR(tp,KZ))  // Leray-project ω div-free
    let (cu,cv,cw)=curl(wxP,wyP,wzP)                           // curl returns i k×(·) ⇒ = i k×ω̂
    let uR=scaleR(cu,INV), vR=scaleR(cv,INV), wR=scaleR(cw,INV) // û = i k×ω̂/|k|² (INV=0 at k=0 ⇒ mean removed)
    let ur=fft(uR,inverse:true).re, vr=fft(vR,inverse:true).re, wr=fft(wR,inverse:true).re
    let e=g.mean(of: add(add(mul(ur,ur),mul(vr,vr)),mul(wr,wr)), axes:[0,1,2], name:nil)  // ⟨|u|²⟩
    let s=g.squareRoot(with: g.division(g.constant(0.25,dataType:.float32), e, name:nil), name:nil) // E=½⟨|u|²⟩→0.125 ⇒ s=√(0.25/⟨|u|²⟩)
    UH=CX(re:mul(uR.re,s),im:mul(uR.im,s)); VH=CX(re:mul(vR.re,s),im:mul(vR.im,s)); WH=CX(re:mul(wR.re,s),im:mul(wR.im,s))
} else {
    UH=fft(CX(re:pu,im:ZERO),inverse:false); VH=fft(CX(re:pv,im:ZERO),inverse:false); WH=fft(CX(re:pw,im:ZERO),inverse:false)
}
let icr = g.run(feeds:[pu:td(buf(u0)),pv:td(buf(v0)),pw:td(buf(w0))], targetTensors:[UH.re,UH.im,VH.re,VH.im,WH.re,WH.im], targetOperations:nil)
var cur:[MPSGraphTensorData] = [icr[UH.re]!,icr[UH.im]!,icr[VH.re]!,icr[VH.im]!,icr[WH.re]!,icr[WH.im]!]

// ---- step + diag graphs (shared placeholders) ----
let ur=g.placeholder(shape:dimsN(),dataType:.float32,name:"ur"), ui=g.placeholder(shape:dimsN(),dataType:.float32,name:"ui")
let vr=g.placeholder(shape:dimsN(),dataType:.float32,name:"vr"), vi=g.placeholder(shape:dimsN(),dataType:.float32,name:"vi")
let wr=g.placeholder(shape:dimsN(),dataType:.float32,name:"wr"), wi=g.placeholder(shape:dimsN(),dataType:.float32,name:"wi")
let ph=[ur,ui,vr,vi,wr,wi]
let U=(CX(re:ur,im:ui),CX(re:vr,im:vi),CX(re:wr,im:wi))
let Un=rk4(U); let UnT=[Un.0.re,Un.0.im,Un.1.re,Un.1.im,Un.2.re,Un.2.im]
let (Et,Ht,Zt,Wt)=diag(U.0,U.1,U.2)
let Dt=divMaxTensor(U.0,U.1,U.2)   // relative max|k·û|/max|û| — GPU's own div check (~float32 eps)
func feeds()->[MPSGraphTensor:MPSGraphTensorData]{ var d=[MPSGraphTensor:MPSGraphTensorData](); for i in 0..<6 { d[ph[i]]=cur[i] }; return d }
func sample(_ t:Float,_ E0:Float,_ Z0:Float){ let r=g.run(feeds:feeds(),targetTensors:[Et,Ht,Zt,Wt,Dt],targetOperations:nil)
    let E=scal(r[Et]!),H=scal(r[Ht]!),Z=scal(r[Zt]!),W=scal(r[Wt]!),D=scal(r[Dt]!)
    log(String(format:"  %-6.2f E/E0=%-9.6f Z/Z0=%-9.4f H=%-11.3e winf=%-8.2f divRel=%-9.2e",t,E/E0,Z/Z0,H,W,D)) }

let reStr = nu > 0 ? "Re=\(Int(1/nu))" : "Euler(ν=0)"   // nu=0 ⇒ inviscid; Int(1/0) would trap
log("# dns_gpu  GPU=\(dev.name)  N=\(N) IC=\(ic) \(reStr) dt=\(dt) T=\(T)  [float32]")
let r0=g.run(feeds:feeds(),targetTensors:[Et,Zt,Dt],targetOperations:nil); let E0=scal(r0[Et]!), Z0=scal(r0[Zt]!)
log(String(format:"# E0=%.6f Z0=%.6f divRel0=%.2e (relative max|k·û|/max|û|; ~float32 eps ⇒ div-free)", E0, Z0, scal(r0[Dt]!)))
// snapshot: dump spectral field (header Int32 N, Float32 t; then 6×N³ Float32 in order
// uh_re,uh_im,vh_re,vh_im,wh_re,wh_im) — read by scripts/load_gpu_snapshot.jl for the
// validated Julia diagnostics (δ, S_ω, box-D, alignment). Convention ≡ Julia fft3 (unnormalized).
func writeSnapshot(_ t: Float) {
    let path = "snap_N\(N)_\(ic)_t\(String(format:"%.2f", t)).bin"
    var data = Data()
    let n32 = [Int32(N)]; n32.withUnsafeBufferPointer { data.append(Data(buffer: $0)) }
    let tt = [Float(t)];  tt.withUnsafeBufferPointer  { data.append(Data(buffer: $0)) }
    for i in 0..<6 { let a = readF(cur[i]); a.withUnsafeBufferPointer { data.append(Data(buffer: $0)) } }
    try? data.write(to: URL(fileURLWithPath: path))
    log("# snapshot t=\(String(format:"%.2f", t)) → \(path) (\(data.count/1_000_000) MB)")
}
let nsteps=Int((T/dt).rounded()); var nexts:Float=0; var t:Float=0
let wall0=DispatchTime.now()
// autoreleasepool PER STEP is load-bearing: MPSGraph's g.run() autoreleases its intermediate
// MTLBuffers/MPSGraphTensorData; in a tight loop they never drain and memory grows unbounded
// (N=256 OOM-killed ~100 steps in without this). The pool drains each iteration; `cur` survives
// because the outer var holds strong refs to the new state tensors past the drain.
for step in 0...nsteps {
    autoreleasepool {
        if t >= nexts - 1e-6 {
            sample(t,E0,Z0); nexts += smp
            if snapTimes.contains(where: { abs($0 - t) < dt/2 }) { writeSnapshot(t) }
        }
        if step < nsteps {
            let r=g.run(feeds:feeds(),targetTensors:UnT,targetOperations:nil)
            cur = UnT.map { r[$0]! }            // GPU-resident ping-pong (no CPU readback)
            t += dt
        }
    }
}
let secs=Double(DispatchTime.now().uptimeNanoseconds-wall0.uptimeNanoseconds)/1e9
log(String(format:"# DONE %d steps in %.1f s (%.3f s/step). Validate: TG Re=1600 enstrophy peak ≈ t=9 vs Brachet/CPU.", nsteps, secs, secs/Double(nsteps)))
