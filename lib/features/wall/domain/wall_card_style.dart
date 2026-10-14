import 'package:flutter/material.dart';

/// How memory cards look on a wall. Carried on the app theme as an extension,
/// so cards pick it up with `WallCardStyle.of(context)`.
@immutable
class WallCardStyle extends ThemeExtension<WallCardStyle> {
  const WallCardStyle({
    required this.paper,
    required this.radius,
    required this.photoRadius,
    required this.padding,
    required this.ink,
    required this.accentInk,
    required this.tape,
    required this.edge,
    required this.texture,
  });

  /// Top-left, middle and bottom-right colours of the card paper.
  final List<Color> paper;
  final double radius;
  final double photoRadius;
  final EdgeInsets padding;
  final Color ink;

  /// Footnotes and small highlights on the card.
  final Color accentInk;

  /// The two colours of the tape strip holding the card.
  final List<Color> tape;
  final Color edge;

  /// Colour of the faint ruled lines across the paper; transparent for none.
  final Color texture;

  static const classic = WallCardStyle(
    paper: [Color(0xFFFFF7E7), Color(0xFFFFF1D8), Color(0xFFEBD6AF)],
    radius: 19,
    photoRadius: 13,
    padding: EdgeInsets.all(10),
    ink: Color(0xFF261C17),
    accentInk: Color(0xFFA87442),
    tape: [Color(0xFFFFF1D8), Color(0xFFE7C995)],
    edge: Color(0x8AFFFFFF),
    texture: Color(0x0B8A6A32),
  );

  /// Cool museum index card.
  static const archive = WallCardStyle(
    paper: [Color(0xFFF6F8FB), Color(0xFFE6ECF4), Color(0xFFCCD6E4)],
    radius: 12,
    photoRadius: 8,
    padding: EdgeInsets.all(10),
    ink: Color(0xFF1B2436),
    accentInk: Color(0xFF4F6A8F),
    tape: [Color(0xFFDCE6F2), Color(0xFFB8C7DA)],
    edge: Color(0x99FFFFFF),
    texture: Color(0x103A5A8A),
  );

  /// Soft cream paper with ruled lines and almost square corners.
  static const creamPaper = WallCardStyle(
    paper: [Color(0xFFFFFAEE), Color(0xFFF7EBD0), Color(0xFFEBD9B6)],
    radius: 5,
    photoRadius: 3,
    padding: EdgeInsets.all(11),
    ink: Color(0xFF3B2A1A),
    accentInk: Color(0xFF9A6634),
    tape: [Color(0xFFE9D6B0), Color(0xFFD3B98C)],
    edge: Color(0x66FFFFFF),
    texture: Color(0x1C8A6A32),
  );

  /// White instant-photo frame: square photo, wide bottom margin.
  static const polaroid = WallCardStyle(
    paper: [Color(0xFFFFFFFF), Color(0xFFF9F7F2), Color(0xFFEDE9E0)],
    radius: 3,
    photoRadius: 1,
    padding: EdgeInsets.fromLTRB(11, 11, 11, 16),
    ink: Color(0xFF26221E),
    accentInk: Color(0xFFB0473A),
    tape: [Color(0xFFF3E6C4), Color(0xFFE0CB98)],
    edge: Color(0xB3FFFFFF),
    texture: Color(0x00000000),
  );

  /// Brown kraft paper.
  static const kraft = WallCardStyle(
    paper: [Color(0xFFE9C9A0), Color(0xFFD8B184), Color(0xFFC49A6A)],
    radius: 8,
    photoRadius: 5,
    padding: EdgeInsets.all(10),
    ink: Color(0xFF2E1A0C),
    accentInk: Color(0xFF8A3B1E),
    tape: [Color(0xFFF2DDB5), Color(0xFFDDBF8C)],
    edge: Color(0x55FFFFFF),
    texture: Color(0x1A5A3414),
  );

  /// Icy white with a blue edge.
  static const frost = WallCardStyle(
    paper: [Color(0xFFFFFFFF), Color(0xFFEFF6FA), Color(0xFFD5E6EF)],
    radius: 16,
    photoRadius: 11,
    padding: EdgeInsets.all(10),
    ink: Color(0xFF14232E),
    accentInk: Color(0xFF3E7896),
    tape: [Color(0xFFE6F2F8), Color(0xFFC5DDEA)],
    edge: Color(0xCCDDF1FA),
    texture: Color(0x00000000),
  );

  /// Pale pink paper.
  static const blossom = WallCardStyle(
    paper: [Color(0xFFFFF7F9), Color(0xFFFBE7EE), Color(0xFFF0CFDC)],
    radius: 18,
    photoRadius: 12,
    padding: EdgeInsets.all(10),
    ink: Color(0xFF3A1E2A),
    accentInk: Color(0xFFB0577A),
    tape: [Color(0xFFFFFFFF), Color(0xFFF6D6E2)],
    edge: Color(0x99FFFFFF),
    texture: Color(0x0E8A3A5A),
  );

  /// Pale green paper.
  static const meadow = WallCardStyle(
    paper: [Color(0xFFFAFFF5), Color(0xFFEAF5DE), Color(0xFFD3E6C0)],
    radius: 14,
    photoRadius: 9,
    padding: EdgeInsets.all(10),
    ink: Color(0xFF1C2E17),
    accentInk: Color(0xFF557A3A),
    tape: [Color(0xFFF7F3D9), Color(0xFFE2DAA6)],
    edge: Color(0x99FFFFFF),
    texture: Color(0x0E3A5A2A),
  );

  static WallCardStyle of(BuildContext context) =>
      Theme.of(context).extension<WallCardStyle>() ?? classic;

  @override
  WallCardStyle copyWith() => this;

  @override
  WallCardStyle lerp(covariant WallCardStyle? other, double t) =>
      t < 0.5 || other == null ? this : other;
}
