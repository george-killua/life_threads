/// Encodes frames rendered by Flutter into an H.264 MP4, optionally with an
/// AAC music track, using only platform media APIs (Android MediaCodec /
/// MediaMuxer, iOS AVFoundation). No FFmpeg, no GPL code.
library;

export 'src/exceptions.dart';
export 'src/story_video_encoder.dart';
