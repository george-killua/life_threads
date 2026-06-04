import AppKit
import AVFoundation
import Foundation

struct Scene {
    let imageName: String?
    let duration: Double
    let headline: String
    let subline: String
    let tag: String
}

enum RenderError: Error, CustomStringConvertible {
    case missingAsset(String)
    case missingPixelBufferPool
    case writerFailed(String)
    case exportFailed(String)

    var description: String {
        switch self {
        case .missingAsset(let path): return "Missing asset: \(path)"
        case .missingPixelBufferPool: return "Could not create pixel buffer pool."
        case .writerFailed(let message): return "Video writer failed: \(message)"
        case .exportFailed(let message): return "Audio export failed: \(message)"
        }
    }
}

final class LifeThreadsAdRenderer {
    private let rootURL: URL
    private let outputSize = CGSize(width: 1080, height: 1920)
    private let fps: Int32 = 30
    private let icon: NSImage
    private let screenshots: [String: NSImage]
    private let scenes: [Scene] = [
        Scene(
            imageName: "01_wall.png",
            duration: 3.0,
            headline: "Your memories,\nnot just photos.",
            subline: "A private wall for moments you want to keep.",
            tag: "Private memory wall"
        ),
        Scene(
            imageName: "02_create_memory.png",
            duration: 3.0,
            headline: "Save the full story.",
            subline: "Photos, notes, people, dates, and places in one memory.",
            tag: "Capture"
        ),
        Scene(
            imageName: "03_memory_chapter.png",
            duration: 3.0,
            headline: "Connect what belongs together.",
            subline: "Build threads between people, places, and chapters.",
            tag: "Life threads"
        ),
        Scene(
            imageName: "04_timeline.png",
            duration: 3.0,
            headline: "Rediscover by time.",
            subline: "Move through your life as a visual timeline.",
            tag: "Timeline"
        ),
        Scene(
            imageName: "05_map.png",
            duration: 3.0,
            headline: "Remember where it happened.",
            subline: "Use photo location details when they exist.",
            tag: "Places"
        ),
        Scene(
            imageName: "01_wall.png",
            duration: 3.0,
            headline: "Show your board anywhere.",
            subline: "Scan a QR code and open the wall on another screen.",
            tag: "QR display"
        ),
        Scene(
            imageName: nil,
            duration: 4.0,
            headline: "LifeThreads",
            subline: "Save what matters before it fades.",
            tag: "Try LifeThreads"
        ),
    ]

    init(rootURL: URL) throws {
        self.rootURL = rootURL
        let iconURL = rootURL.appendingPathComponent("assets/brand/lifethreads_app_icon_1024.png")
        guard let icon = NSImage(contentsOf: iconURL) else {
            throw RenderError.missingAsset(iconURL.path)
        }
        self.icon = icon

        var loadedScreenshots: [String: NSImage] = [:]
        let screenshotDir = rootURL.appendingPathComponent("store_listing_assets/play_screenshots/phone")
        for name in ["01_wall.png", "02_create_memory.png", "03_memory_chapter.png", "04_timeline.png", "05_map.png"] {
            let url = screenshotDir.appendingPathComponent(name)
            guard let image = NSImage(contentsOf: url) else {
                throw RenderError.missingAsset(url.path)
            }
            loadedScreenshots[name] = image
        }
        self.screenshots = loadedScreenshots
    }

    var duration: Double {
        scenes.reduce(0) { $0 + $1.duration }
    }

    func render(videoURL: URL, previewURL: URL, videoCheckURL: URL) throws {
        try? FileManager.default.removeItem(at: videoURL)
        try? FileManager.default.removeItem(at: previewURL)
        try? FileManager.default.removeItem(at: videoCheckURL)

        try renderFrame(at: 0.4).writePNG(to: previewURL)

        let writer = try AVAssetWriter(outputURL: videoURL, fileType: .mp4)
        let outputSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: Int(outputSize.width),
            AVVideoHeightKey: Int(outputSize.height),
            AVVideoCompressionPropertiesKey: [
                AVVideoAverageBitRateKey: 8_000_000,
                AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel,
            ],
        ]
        let input = AVAssetWriterInput(mediaType: .video, outputSettings: outputSettings)
        input.expectsMediaDataInRealTime = false

        let pixelAttributes: [String: Any] = [
            kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA),
            kCVPixelBufferWidthKey as String: Int(outputSize.width),
            kCVPixelBufferHeightKey as String: Int(outputSize.height),
            kCVPixelBufferCGImageCompatibilityKey as String: true,
            kCVPixelBufferCGBitmapContextCompatibilityKey as String: true,
        ]
        let adaptor = AVAssetWriterInputPixelBufferAdaptor(
            assetWriterInput: input,
            sourcePixelBufferAttributes: pixelAttributes
        )

        guard writer.canAdd(input) else {
            throw RenderError.writerFailed("Could not add video input.")
        }
        writer.add(input)

        guard writer.startWriting() else {
            throw RenderError.writerFailed(writer.error?.localizedDescription ?? "Unknown startWriting error.")
        }
        writer.startSession(atSourceTime: .zero)

        let totalFrames = Int(duration * Double(fps))
        for frame in 0..<totalFrames {
            while !input.isReadyForMoreMediaData {
                usleep(1_000)
            }

            try autoreleasepool {
                guard let pool = adaptor.pixelBufferPool else {
                    throw RenderError.missingPixelBufferPool
                }
                var pixelBuffer: CVPixelBuffer?
                CVPixelBufferPoolCreatePixelBuffer(nil, pool, &pixelBuffer)
                guard let buffer = pixelBuffer else {
                    throw RenderError.missingPixelBufferPool
                }

                let time = Double(frame) / Double(fps)
                let image = renderFrame(at: time)
                image.copy(to: buffer, size: outputSize)
                let presentationTime = CMTime(value: CMTimeValue(frame), timescale: fps)
                if !adaptor.append(buffer, withPresentationTime: presentationTime) {
                    throw RenderError.writerFailed(writer.error?.localizedDescription ?? "Could not append frame \(frame).")
                }
            }
        }

        input.markAsFinished()
        let semaphore = DispatchSemaphore(value: 0)
        writer.finishWriting {
            semaphore.signal()
        }
        semaphore.wait()

        guard writer.status == .completed else {
            throw RenderError.writerFailed(writer.error?.localizedDescription ?? "Unknown finishWriting error.")
        }

        try extractFrame(from: videoURL, to: videoCheckURL)
    }

    private func renderFrame(at time: Double) -> NSImage {
        let image = NSImage(size: outputSize)
        image.lockFocus()
        defer { image.unlockFocus() }

        drawBaseBackground()

        let (sceneIndex, sceneStart, scene) = sceneAt(time)
        let localTime = time - sceneStart
        let crossfadeDuration = 0.45
        let remaining = scene.duration - localTime

        if remaining < crossfadeDuration, sceneIndex + 1 < scenes.count {
            let next = scenes[sceneIndex + 1]
            let fade = CGFloat(1 - (remaining / crossfadeDuration))
            draw(scene: scene, progress: localTime / scene.duration, alpha: 1 - fade)
            draw(scene: next, progress: 0, alpha: fade)
        } else {
            let fadeIn = min(1, CGFloat(localTime / 0.35))
            draw(scene: scene, progress: localTime / scene.duration, alpha: fadeIn)
        }

        return image
    }

    private func sceneAt(_ time: Double) -> (Int, Double, Scene) {
        var cursor = 0.0
        for (index, scene) in scenes.enumerated() {
            if time < cursor + scene.duration {
                return (index, cursor, scene)
            }
            cursor += scene.duration
        }
        return (scenes.count - 1, duration - scenes.last!.duration, scenes.last!)
    }

    private func drawBaseBackground() {
        let rect = NSRect(origin: .zero, size: outputSize)
        NSColor(calibratedRed: 0.06, green: 0.045, blue: 0.055, alpha: 1).setFill()
        rect.fill()

        NSGradient(colors: [
            NSColor(calibratedRed: 0.18, green: 0.10, blue: 0.13, alpha: 1),
            NSColor(calibratedRed: 0.03, green: 0.03, blue: 0.035, alpha: 1),
        ])?.draw(in: rect, angle: -28)

        NSColor(calibratedWhite: 1, alpha: 0.035).setStroke()
        for x in stride(from: 0, through: Int(outputSize.width), by: 96) {
            NSBezierPath.strokeLine(from: NSPoint(x: CGFloat(x), y: 0), to: NSPoint(x: CGFloat(x), y: outputSize.height))
        }
        for y in stride(from: 0, through: Int(outputSize.height), by: 96) {
            NSBezierPath.strokeLine(from: NSPoint(x: 0, y: CGFloat(y)), to: NSPoint(x: outputSize.width, y: CGFloat(y)))
        }
    }

    private func draw(scene: Scene, progress: Double, alpha: CGFloat) {
        guard alpha > 0 else { return }

        let rect = NSRect(origin: .zero, size: outputSize)
        if let imageName = scene.imageName, let screenshot = screenshots[imageName] {
            let zoom = 1.02 + CGFloat(progress) * 0.035
            let imageRect = rect.insetBy(dx: -outputSize.width * (zoom - 1) / 2, dy: -outputSize.height * (zoom - 1) / 2)
            screenshot.draw(in: imageRect, from: .zero, operation: .sourceOver, fraction: alpha)
            NSColor(calibratedWhite: 0, alpha: 0.58 * alpha).setFill()
            rect.fill()
            drawVignette(alpha: alpha)
        } else {
            drawFinalBrand(alpha: alpha)
        }

        drawBrandHeader(alpha: alpha)
        drawCopy(scene: scene, alpha: alpha)
    }

    private func drawVignette(alpha: CGFloat) {
        NSGradient(colors: [
            NSColor(calibratedWhite: 0, alpha: 0.94 * alpha),
            NSColor(calibratedWhite: 0, alpha: 0.16 * alpha),
        ])?.draw(in: NSRect(x: 0, y: 0, width: outputSize.width, height: 780), angle: 90)
        NSGradient(colors: [
            NSColor(calibratedWhite: 0, alpha: 0.88 * alpha),
            NSColor(calibratedWhite: 0, alpha: 0.10 * alpha),
        ])?.draw(in: NSRect(x: 0, y: 1240, width: outputSize.width, height: 680), angle: -90)
    }

    private func drawFinalBrand(alpha: CGFloat) {
        let halo = NSBezierPath(ovalIn: NSRect(x: 162, y: 502, width: 756, height: 756))
        NSColor(calibratedRed: 0.85, green: 0.62, blue: 0.20, alpha: 0.18 * alpha).setFill()
        halo.fill()

        let iconRect = NSRect(x: 330, y: 670, width: 420, height: 420)
        drawRounded(image: icon, in: iconRect, radius: 92, alpha: alpha)
    }

    private func drawBrandHeader(alpha: CGFloat) {
        let headerRect = NSRect(x: 52, y: 1698, width: 506, height: 126)
        let headerPath = NSBezierPath(roundedRect: headerRect, xRadius: 42, yRadius: 42)
        NSColor(calibratedWhite: 0, alpha: 0.46 * alpha).setFill()
        headerPath.fill()

        let iconRect = NSRect(x: 70, y: 1722, width: 84, height: 84)
        drawRounded(image: icon, in: iconRect, radius: 18, alpha: alpha)
        drawText(
            "LifeThreads",
            in: NSRect(x: 174, y: 1732, width: 620, height: 64),
            font: .systemFont(ofSize: 42, weight: .bold),
            color: NSColor.white.withAlphaComponent(0.96 * alpha)
        )
    }

    private func drawCopy(scene: Scene, alpha: CGFloat) {
        let panelRect = NSRect(x: 46, y: 124, width: 988, height: 468)
        let panelPath = NSBezierPath(roundedRect: panelRect, xRadius: 42, yRadius: 42)
        NSColor(calibratedWhite: 0, alpha: 0.58 * alpha).setFill()
        panelPath.fill()

        let tagRect = NSRect(x: 70, y: 510, width: 480, height: 56)
        let tagPath = NSBezierPath(roundedRect: tagRect, xRadius: 28, yRadius: 28)
        NSColor(calibratedRed: 0.87, green: 0.65, blue: 0.28, alpha: 0.92 * alpha).setFill()
        tagPath.fill()
        drawText(
            scene.tag.uppercased(),
            in: NSRect(x: 96, y: 525, width: 430, height: 28),
            font: .systemFont(ofSize: 22, weight: .bold),
            color: NSColor(calibratedRed: 0.08, green: 0.055, blue: 0.045, alpha: alpha),
            letterSpacing: 1.2
        )

        drawText(
            scene.headline,
            in: NSRect(x: 70, y: 280, width: 940, height: 210),
            font: .systemFont(ofSize: scene.imageName == nil ? 96 : 72, weight: .heavy),
            color: NSColor.white.withAlphaComponent(0.98 * alpha),
            lineSpacing: 6
        )
        drawText(
            scene.subline,
            in: NSRect(x: 72, y: 172, width: 900, height: 82),
            font: .systemFont(ofSize: 34, weight: .semibold),
            color: NSColor(calibratedWhite: 1, alpha: 0.78 * alpha),
            lineSpacing: 4
        )
    }

    private func drawRounded(image: NSImage, in rect: NSRect, radius: CGFloat, alpha: CGFloat) {
        NSGraphicsContext.saveGraphicsState()
        NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius).addClip()
        image.draw(in: rect, from: .zero, operation: .sourceOver, fraction: alpha)
        NSGraphicsContext.restoreGraphicsState()
    }

    private func drawText(
        _ text: String,
        in rect: NSRect,
        font: NSFont,
        color: NSColor,
        lineSpacing: CGFloat = 0,
        letterSpacing: CGFloat = 0
    ) {
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byWordWrapping
        style.lineSpacing = lineSpacing
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: style,
            .kern: letterSpacing,
        ]
        NSAttributedString(string: text, attributes: attributes).draw(in: rect)
    }
}

extension NSImage {
    func writePNG(to url: URL) throws {
        guard let cgImage = cgImage(forProposedRect: nil, context: nil, hints: nil) else { return }
        let rep = NSBitmapImageRep(cgImage: cgImage)
        guard let data = rep.representation(using: .png, properties: [:]) else { return }
        try data.write(to: url)
    }

    func copy(to pixelBuffer: CVPixelBuffer, size: CGSize) {
        CVPixelBufferLockBaseAddress(pixelBuffer, [])
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, []) }

        guard
            let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer),
            let context = CGContext(
                data: baseAddress,
                width: Int(size.width),
                height: Int(size.height),
                bitsPerComponent: 8,
                bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer),
                space: CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
            ),
            let cgImage = cgImage(forProposedRect: nil, context: nil, hints: nil)
        else {
            return
        }

        context.clear(CGRect(origin: .zero, size: size))
        context.draw(cgImage, in: CGRect(origin: .zero, size: size))
    }
}

func extractFrame(from videoURL: URL, to outputURL: URL) throws {
    let asset = AVURLAsset(url: videoURL)
    let generator = AVAssetImageGenerator(asset: asset)
    generator.appliesPreferredTrackTransform = true
    generator.requestedTimeToleranceBefore = .zero
    generator.requestedTimeToleranceAfter = .zero
    let image = try generator.copyCGImage(at: CMTime(seconds: 0.4, preferredTimescale: 600), actualTime: nil)
    let rep = NSBitmapImageRep(cgImage: image)
    guard let data = rep.representation(using: .png, properties: [:]) else { return }
    try data.write(to: outputURL)
}

func mux(videoURL: URL, audioURL: URL, outputURL: URL) throws {
    try? FileManager.default.removeItem(at: outputURL)

    let composition = AVMutableComposition()
    let videoAsset = AVURLAsset(url: videoURL)
    let audioAsset = AVURLAsset(url: audioURL)
    let fullRange = CMTimeRange(start: .zero, duration: videoAsset.duration)

    guard
        let sourceVideoTrack = videoAsset.tracks(withMediaType: .video).first,
        let compositionVideoTrack = composition.addMutableTrack(
            withMediaType: .video,
            preferredTrackID: kCMPersistentTrackID_Invalid
        )
    else {
        throw RenderError.exportFailed("Could not load video track.")
    }
    try compositionVideoTrack.insertTimeRange(fullRange, of: sourceVideoTrack, at: .zero)
    compositionVideoTrack.preferredTransform = sourceVideoTrack.preferredTransform

    if
        let sourceAudioTrack = audioAsset.tracks(withMediaType: .audio).first,
        let compositionAudioTrack = composition.addMutableTrack(
            withMediaType: .audio,
            preferredTrackID: kCMPersistentTrackID_Invalid
        )
    {
        let audioRange = CMTimeRange(start: .zero, duration: min(audioAsset.duration, videoAsset.duration))
        try compositionAudioTrack.insertTimeRange(audioRange, of: sourceAudioTrack, at: .zero)
    }

    guard let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality) else {
        throw RenderError.exportFailed("Could not create export session.")
    }
    exporter.outputURL = outputURL
    exporter.outputFileType = .mp4
    exporter.shouldOptimizeForNetworkUse = true

    let semaphore = DispatchSemaphore(value: 0)
    exporter.exportAsynchronously {
        semaphore.signal()
    }
    semaphore.wait()

    guard exporter.status == .completed else {
        throw RenderError.exportFailed(exporter.error?.localizedDescription ?? "Unknown export error.")
    }
}

let rootURL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let outputDir = rootURL.appendingPathComponent("store_listing_assets/ad", isDirectory: true)
try FileManager.default.createDirectory(at: outputDir, withIntermediateDirectories: true)

let videoOnlyURL = outputDir.appendingPathComponent("lifethreads_ad_vertical_video.mp4")
let finalURL = outputDir.appendingPathComponent("lifethreads_ad_vertical.mp4")
let previewURL = outputDir.appendingPathComponent("lifethreads_ad_preview.png")
let videoCheckURL = outputDir.appendingPathComponent("lifethreads_ad_video_check.png")
let voiceURL = outputDir.appendingPathComponent("lifethreads_ad_voice.m4a")

let renderer = try LifeThreadsAdRenderer(rootURL: rootURL)
try renderer.render(videoURL: videoOnlyURL, previewURL: previewURL, videoCheckURL: videoCheckURL)

if FileManager.default.fileExists(atPath: voiceURL.path) {
    try mux(videoURL: videoOnlyURL, audioURL: voiceURL, outputURL: finalURL)
    try? FileManager.default.removeItem(at: videoOnlyURL)
} else {
    try? FileManager.default.removeItem(at: finalURL)
    try FileManager.default.copyItem(at: videoOnlyURL, to: finalURL)
}

print("Video: \(finalURL.path)")
print("Preview: \(previewURL.path)")
print("Video check: \(videoCheckURL.path)")
