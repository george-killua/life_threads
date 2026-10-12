import Flutter
import UIKit

/// Method-channel front end. Each session encodes on its own serial queue;
/// results are always delivered back on the main thread.
public class StoryVideoEncoderPlugin: NSObject, FlutterPlugin {
  private var sessions: [Int: VideoEncoderSession] = [:]  // main thread only
  private var nextId = 1

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "dev.gkcoding.lifethreads/story_video_encoder",
      binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(StoryVideoEncoderPlugin(), channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any] ?? [:]
    switch call.method {
    case "start":
      start(args, result)
    case "addFrame":
      guard let session = session(args, result) else { return }
      guard let index = (args["index"] as? NSNumber)?.int64Value,
        let rgba = args["rgba"] as? FlutterStandardTypedData
      else {
        return result(EncoderError.encoder("addFrame: missing index or rgba").flutter)
      }
      session.addFrame(index: index, rgba: rgba.data) { error in
        self.reply(result, error) {
          if error != nil { self.sessions[session.id] = nil }
          return nil
        }
      }
    case "finish":
      guard let session = session(args, result) else { return }
      sessions[session.id] = nil
      session.finish { error, path in
        self.reply(result, error) { path }
      }
    case "cancel":
      guard let session = session(args, result) else { return }
      sessions[session.id] = nil
      session.cancel {
        self.reply(result, nil) { nil }
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func start(_ args: [String: Any], _ result: @escaping FlutterResult) {
    guard let outputPath = args["outputPath"] as? String,
      let width = (args["width"] as? NSNumber)?.intValue,
      let height = (args["height"] as? NSNumber)?.intValue,
      let fps = (args["fps"] as? NSNumber)?.int32Value,
      let bitRate = (args["bitRate"] as? NSNumber)?.intValue
    else {
      return result(EncoderError.encoder("start: missing arguments").flutter)
    }
    let config = SessionConfig(
      outputURL: URL(fileURLWithPath: outputPath),
      width: width,
      height: height,
      fps: fps,
      bitRate: bitRate,
      audioURL: (args["audioPath"] as? String).map { URL(fileURLWithPath: $0) },
      audioStartUs: (args["audioStartUs"] as? NSNumber)?.int64Value ?? 0,
      fadeOutUs: (args["fadeOutUs"] as? NSNumber)?.int64Value ?? 0)
    let id = nextId
    nextId += 1
    let session = VideoEncoderSession(id: id, config: config)
    sessions[id] = session
    session.start { error in
      self.reply(result, error) {
        if error != nil { self.sessions[id] = nil }
        return id
      }
    }
  }

  private func session(_ args: [String: Any], _ result: FlutterResult) -> VideoEncoderSession? {
    let id = (args["id"] as? NSNumber)?.intValue ?? -1
    guard let session = sessions[id] else {
      result(EncoderError.invalidSession("Unknown session \(id)").flutter)
      return nil
    }
    return session
  }

  /// Hops to the main thread, runs [onMain] and answers Flutter.
  private func reply(
    _ result: @escaping FlutterResult, _ error: Error?, onMain: @escaping () -> Any?
  ) {
    DispatchQueue.main.async {
      let value = onMain()
      if let error = error {
        result(EncoderError.wrap(error).flutter)
      } else {
        result(value)
      }
    }
  }
}

/// Errors with the codes the Dart side maps to typed exceptions.
struct EncoderError: Error {
  let code: String
  let message: String

  static func unsupportedSize(_ m: String) -> EncoderError { .init(code: "unsupported_size", message: m) }
  static func encoder(_ m: String) -> EncoderError { .init(code: "encoder_failure", message: m) }
  static func audio(_ m: String) -> EncoderError { .init(code: "audio_failure", message: m) }
  static func invalidSession(_ m: String) -> EncoderError { .init(code: "invalid_session", message: m) }

  static func wrap(_ error: Error) -> EncoderError {
    error as? EncoderError ?? .encoder(error.localizedDescription)
  }

  var flutter: FlutterError { FlutterError(code: code, message: message, details: nil) }
}

struct SessionConfig {
  let outputURL: URL
  let width: Int
  let height: Int
  let fps: Int32
  let bitRate: Int
  let audioURL: URL?
  let audioStartUs: Int64
  let fadeOutUs: Int64
}
