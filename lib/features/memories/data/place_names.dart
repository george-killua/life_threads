import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';

/// Turns photo coordinates into a place name such as "Split, Croatia",
/// using the phone's own geocoder (Apple on iOS, Google on Android).
abstract class PlaceNameLookup {
  /// The place name in [locale], or null when offline or unknown.
  Future<String?> nameFor(double latitude, double longitude, Locale locale);
}

final placeNameLookupProvider = Provider<PlaceNameLookup>(
  (ref) => PlatformPlaceNameLookup(),
);

class PlatformPlaceNameLookup implements PlaceNameLookup {
  Geocoding? _geocoding;

  @override
  Future<String?> nameFor(
    double latitude,
    double longitude,
    Locale locale,
  ) async {
    try {
      final geocoding = _geocoding ??= Geocoding();
      final places = await geocoding
          .placemarkFromCoordinates(latitude, longitude, locale: locale)
          .timeout(const Duration(seconds: 5));
      if (places.isEmpty) return null;
      return placeNameFrom(places.first);
    } catch (_) {
      // Offline, rate-limited, or no geocoder on this device.
      return null;
    }
  }
}

/// "Split, Croatia": the town (or the nearest area) and the country.
String? placeNameFrom(Placemark place) {
  String? clean(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  final town =
      clean(place.locality) ??
      clean(place.subAdministrativeArea) ??
      clean(place.administrativeArea) ??
      clean(place.name);
  final country = clean(place.country);
  if (town == null) return country;
  if (country == null || country == town) return town;
  return '$town, $country';
}

/// The fallback label when no place name is known: "43.50810, 16.44032".
String coordinateLabel(double latitude, double longitude) =>
    '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';

/// True for labels that are only coordinates, such as [coordinateLabel]'s.
bool isCoordinateLabel(String label) =>
    RegExp(r'^\s*-?\d{1,3}\.\d+\s*,\s*-?\d{1,3}\.\d+\s*$').hasMatch(label);

/// The place name for a memory's coordinates, or the coordinates themselves
/// when the name can't be found (for example offline).
Future<String> placeLabelFor(
  PlaceNameLookup lookup,
  double? latitude,
  double? longitude,
  Locale locale,
) async {
  if (latitude == null || longitude == null) return '';
  return await lookup.nameFor(latitude, longitude, locale) ??
      coordinateLabel(latitude, longitude);
}
