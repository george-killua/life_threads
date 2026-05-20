import AppKit

let output = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "assets/brand/lifethreads_app_icon_1024.png"
let size: CGFloat = 1024
let rect = NSRect(x: 0, y: 0, width: size, height: size)
let image = NSImage(size: rect.size)

func color(_ hex: UInt32, _ alpha: CGFloat = 1) -> NSColor {
    let r = CGFloat((hex >> 16) & 0xff) / 255
    let g = CGFloat((hex >> 8) & 0xff) / 255
    let b = CGFloat(hex & 0xff) / 255
    return NSColor(calibratedRed: r, green: g, blue: b, alpha: alpha)
}

func fillRoundedRect(_ rect: NSRect, radius: CGFloat, color: NSColor) {
    color.setFill()
    NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius).fill()
}

func strokePath(_ path: NSBezierPath, color: NSColor, width: CGFloat) {
    path.lineCapStyle = .round
    path.lineJoinStyle = .round
    path.lineWidth = width
    color.setStroke()
    path.stroke()
}

image.lockFocus()
NSGraphicsContext.current?.shouldAntialias = true

let bgGradient = NSGradient(colors: [
    color(0x08070B),
    color(0x171018),
    color(0x2A1E22)
])!
bgGradient.draw(in: rect, angle: -42)

let roseGlow = NSGradient(colors: [color(0xE59A8D, 0.23), color(0xE59A8D, 0.0)])!
roseGlow.draw(fromCenter: NSPoint(x: 235, y: 800), radius: 0, toCenter: NSPoint(x: 235, y: 800), radius: 640, options: [])
let goldGlow = NSGradient(colors: [color(0xD2A24A, 0.18), color(0xD2A24A, 0.0)])!
goldGlow.draw(fromCenter: NSPoint(x: 850, y: 190), radius: 0, toCenter: NSPoint(x: 850, y: 190), radius: 560, options: [])

color(0xFFF1D8, 0.045).setStroke()
for i in stride(from: CGFloat(116), through: size, by: 116) {
    let v = NSBezierPath()
    v.move(to: NSPoint(x: i, y: 0))
    v.line(to: NSPoint(x: i, y: size))
    v.lineWidth = 2
    v.stroke()
    let h = NSBezierPath()
    h.move(to: NSPoint(x: 0, y: i))
    h.line(to: NSPoint(x: size, y: i))
    h.lineWidth = 2
    h.stroke()
}

let thread = NSBezierPath()
thread.move(to: NSPoint(x: 226, y: 642))
thread.curve(to: NSPoint(x: 506, y: 474), controlPoint1: NSPoint(x: 300, y: 860), controlPoint2: NSPoint(x: 484, y: 762))
thread.curve(to: NSPoint(x: 774, y: 644), controlPoint1: NSPoint(x: 532, y: 205), controlPoint2: NSPoint(x: 748, y: 342))
thread.curve(to: NSPoint(x: 506, y: 710), controlPoint1: NSPoint(x: 793, y: 826), controlPoint2: NSPoint(x: 584, y: 830))
thread.curve(to: NSPoint(x: 226, y: 642), controlPoint1: NSPoint(x: 429, y: 592), controlPoint2: NSPoint(x: 315, y: 493))
strokePath(thread, color: color(0x000000, 0.36), width: 58)
strokePath(thread, color: color(0xA87442), width: 42)
strokePath(thread, color: color(0xF2C86B, 0.72), width: 13)

let ctx = NSGraphicsContext.current!.cgContext
ctx.saveGState()
ctx.translateBy(x: 382, y: 246)
ctx.rotate(by: -0.14)

let shadow = NSShadow()
shadow.shadowColor = color(0x000000, 0.44)
shadow.shadowBlurRadius = 42
shadow.shadowOffset = NSSize(width: 0, height: -18)
shadow.set()

let card = NSRect(x: 0, y: 0, width: 342, height: 414)
let cardPath = NSBezierPath(roundedRect: card, xRadius: 58, yRadius: 58)
color(0xFFF1D8).setFill()
cardPath.fill()
NSShadow().set()

let photo = NSRect(x: 38, y: 132, width: 266, height: 226)
let photoPath = NSBezierPath(roundedRect: photo, xRadius: 36, yRadius: 36)
let photoGradient = NSGradient(colors: [color(0xD2A24A), color(0xE59A8D), color(0x8EA7C6)])!
photoGradient.draw(in: photoPath, angle: 28)

color(0x261C17, 0.12).setStroke()
for y in stride(from: CGFloat(54), through: CGFloat(108), by: CGFloat(16)) {
    let line = NSBezierPath()
    line.move(to: NSPoint(x: 50, y: y))
    line.line(to: NSPoint(x: 292, y: y))
    line.lineWidth = 3
    line.stroke()
}

ctx.restoreGState()

let tapeRect = NSRect(x: 433, y: 616, width: 160, height: 54)
fillRoundedRect(tapeRect, radius: 16, color: color(0xE7C995, 0.78))
color(0xFFFFFF, 0.24).setStroke()
NSBezierPath(roundedRect: tapeRect, xRadius: 16, yRadius: 16).stroke()

let nailCenter = NSPoint(x: 512, y: 724)
let nailShadow = NSBezierPath(ovalIn: NSRect(x: nailCenter.x - 28, y: nailCenter.y - 33, width: 56, height: 56))
color(0x000000, 0.28).setFill()
nailShadow.fill()
let nail = NSBezierPath(ovalIn: NSRect(x: nailCenter.x - 26, y: nailCenter.y - 26, width: 52, height: 52))
let nailGradient = NSGradient(colors: [color(0xFFE1A0), color(0xD2A24A), color(0x80531E)])!
nailGradient.draw(in: nail, angle: -35)
color(0xFFFFFF, 0.5).setStroke()
nail.lineWidth = 4
nail.stroke()

let sparkle = NSBezierPath()
sparkle.move(to: NSPoint(x: 244, y: 782))
sparkle.line(to: NSPoint(x: 244, y: 834))
sparkle.move(to: NSPoint(x: 218, y: 808))
sparkle.line(to: NSPoint(x: 270, y: 808))
strokePath(sparkle, color: color(0xF2C86B, 0.7), width: 10)

image.unlockFocus()

let rep = NSBitmapImageRep(data: image.tiffRepresentation!)!
let png = rep.representation(using: .png, properties: [:])!
try! FileManager.default.createDirectory(atPath: (output as NSString).deletingLastPathComponent, withIntermediateDirectories: true)
try! png.write(to: URL(fileURLWithPath: output))
