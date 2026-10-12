import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:image/image.dart' as img;

import '../domain/family_models.dart';
import 'family_api_client.dart';

/// Turns a picked photo into the JPEG that gets encrypted and uploaded:
/// at most [maxDimension] px on the long side, quality [quality], with the
/// orientation applied and all metadata (EXIF, GPS) dropped.
abstract interface class FamilyPhotoProcessor {
  Future<Uint8List> prepare(String path);
}

class DefaultFamilyPhotoProcessor implements FamilyPhotoProcessor {
  const DefaultFamilyPhotoProcessor({
    this.maxDimension = 2048,
    this.quality = 85,
  });

  final int maxDimension;
  final int quality;

  @override
  Future<Uint8List> prepare(String path) async {
    final Uint8List source;
    try {
      source = await File(path).readAsBytes();
    } on FileSystemException {
      throw const FamilyException(FamilyErrorCodes.photoUnreadable);
    }
    final maxDimension = this.maxDimension;
    final quality = this.quality;
    // Decoding and re-encoding is CPU heavy; keep it off the UI isolate.
    final jpeg = await Isolate.run(
      () => resizeEncoded(source, maxDimension: maxDimension, quality: quality),
    );
    if (jpeg != null) return jpeg;

    // Formats the image package cannot read (HEIC from the iOS library):
    // let the platform decoder do it, scaled down while decoding.
    final rgba = await _platformDecode(source, maxDimension);
    if (rgba == null) {
      throw const FamilyException(FamilyErrorCodes.photoUnreadable);
    }
    return Isolate.run(
      () => img.encodeJpg(
        img.Image.fromBytes(
          width: rgba.width,
          height: rgba.height,
          bytes: rgba.bytes.buffer,
          numChannels: 4,
          order: img.ChannelOrder.rgba,
        ),
        quality: quality,
      ),
    );
  }

  /// Decodes with the `image` package, applies EXIF orientation, resizes
  /// and re-encodes; null if the format is not supported.
  static Uint8List? resizeEncoded(
    Uint8List source, {
    required int maxDimension,
    required int quality,
  }) {
    img.Image? decoded;
    try {
      decoded = img.decodeImage(source);
    } catch (_) {
      decoded = null;
    }
    if (decoded == null) return null;
    var image = img.bakeOrientation(decoded);
    final longest = max(image.width, image.height);
    if (longest > maxDimension) {
      image = image.width >= image.height
          ? img.copyResize(
              image,
              width: maxDimension,
              interpolation: img.Interpolation.average,
            )
          : img.copyResize(
              image,
              height: maxDimension,
              interpolation: img.Interpolation.average,
            );
    }
    // A fresh image carries no EXIF/GPS from the original.
    image.exif = img.ExifData();
    return img.encodeJpg(image, quality: quality);
  }

  static Future<({int width, int height, Uint8List bytes})?> _platformDecode(
    Uint8List source,
    int maxDimension,
  ) async {
    try {
      final buffer = await ui.ImmutableBuffer.fromUint8List(source);
      final descriptor = await ui.ImageDescriptor.encoded(buffer);
      final scale = min(
        1.0,
        maxDimension / max(descriptor.width, descriptor.height),
      );
      final codec = await descriptor.instantiateCodec(
        targetWidth: max(1, (descriptor.width * scale).round()),
        targetHeight: max(1, (descriptor.height * scale).round()),
      );
      final frame = await codec.getNextFrame();
      final data = await frame.image.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      );
      final result = data == null
          ? null
          : (
              width: frame.image.width,
              height: frame.image.height,
              bytes: data.buffer.asUint8List(),
            );
      frame.image.dispose();
      codec.dispose();
      descriptor.dispose();
      buffer.dispose();
      return result;
    } catch (_) {
      return null;
    }
  }
}
