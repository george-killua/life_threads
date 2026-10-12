import 'package:flutter/services.dart';

/// Base class of every error reported by the native encoder.
///
/// Argument mistakes (odd sizes, wrong frame length, using a finished session)
/// are reported synchronously on the Dart side as [ArgumentError] /
/// [StateError] instead; these exceptions describe what the platform said.
class StoryVideoException implements Exception {
  const StoryVideoException(this.code, this.message, [this.details]);

  /// Machine-readable error code sent by the platform (see [fromPlatform]).
  final String code;

  /// Human-readable description (English, for logs; not for end users).
  final String message;

  /// Optional extra information from the platform (e.g. the codec name).
  final Object? details;

  /// Maps a [PlatformException] from the method channel to a typed exception.
  static StoryVideoException fromPlatform(PlatformException e) {
    final message = e.message ?? e.code;
    switch (e.code) {
      case UnsupportedVideoSizeException.errorCode:
        return UnsupportedVideoSizeException(message, e.details);
      case VideoEncoderException.errorCode:
        return VideoEncoderException(message, e.details);
      case AudioTrackException.errorCode:
        return AudioTrackException(message, e.details);
      case EncoderSessionException.errorCode:
        return EncoderSessionException(message, e.details);
      default:
        return StoryVideoException(e.code, message, e.details);
    }
  }

  @override
  String toString() => '$runtimeType($code): $message';
}

/// The device's H.264 encoder cannot encode the requested width × height
/// (or frame rate / bit rate). Retry with a smaller size, e.g. 720×1280.
class UnsupportedVideoSizeException extends StoryVideoException {
  const UnsupportedVideoSizeException(String message, [Object? details])
      : super(errorCode, message, details);
  static const errorCode = 'unsupported_size';
}

/// The video encoder or muxer failed while encoding or writing the file.
class VideoEncoderException extends StoryVideoException {
  const VideoEncoderException(String message, [Object? details])
      : super(errorCode, message, details);
  static const errorCode = 'encoder_failure';
}

/// The audio file could not be read, decoded, trimmed or muxed.
class AudioTrackException extends StoryVideoException {
  const AudioTrackException(String message, [Object? details])
      : super(errorCode, message, details);
  static const errorCode = 'audio_failure';
}

/// The native side no longer knows the session (e.g. it was cancelled, the
/// engine was restarted, or `finish` was called twice).
class EncoderSessionException extends StoryVideoException {
  const EncoderSessionException(String message, [Object? details])
      : super(errorCode, message, details);
  static const errorCode = 'invalid_session';
}
