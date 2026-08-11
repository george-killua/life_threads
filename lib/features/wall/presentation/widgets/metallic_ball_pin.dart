import 'package:flutter/material.dart';

/// Satin bronze ball-head pin matching the physical pin reference.
class MetallicBallPin extends StatelessWidget {
  const MetallicBallPin({
    super.key,
    this.size = 27,
    this.showStem = true,
    this.elevated = false,
  });

  /// Diameter of the spherical pin head.
  final double size;

  /// When true, draws a thin metallic needle below the head (wall nails).
  final bool showStem;

  /// Slightly stronger shadow while dragging.
  final bool elevated;

  static const _highlight = Color(0xFFE6C78A);
  static const _mid = Color(0xFFB89255);
  static const _shadow = Color(0xFF6A4824);
  static const _deep = Color(0xFF4A3118);

  @override
  Widget build(BuildContext context) {
    final stemHeight = showStem ? size * 1.15 : 0.0;
    final totalHeight = size + (showStem ? stemHeight * 0.72 : 0);
    final totalWidth = size * 1.55;

    return SizedBox(
      width: totalWidth,
      height: totalHeight,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          if (showStem)
            Positioned(
              top: size * 0.55,
              child: _Stem(
                width: (size * 0.075).clamp(1.6, 2.4),
                height: stemHeight,
              ),
            ),
          // Soft contact shadow under the ball (like the photo).
          Positioned(
            top: size * 0.62,
            child: IgnorePointer(
              child: Container(
                width: size * 0.72,
                height: size * 0.28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: elevated ? 0.34 : 0.22,
                      ),
                      blurRadius: elevated ? 14 : 10,
                      spreadRadius: 0.5,
                      offset: const Offset(1.5, 3),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _BallHead(size: size, elevated: elevated),
        ],
      ),
    );
  }
}

class _BallHead extends StatelessWidget {
  const _BallHead({required this.size, required this.elevated});

  final double size;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final highlightSize = size * 0.22;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          center: Alignment(-0.38, -0.42),
          radius: 0.95,
          colors: [
            MetallicBallPin._highlight,
            MetallicBallPin._mid,
            MetallicBallPin._shadow,
            MetallicBallPin._deep,
          ],
          stops: [0.0, 0.38, 0.78, 1.0],
        ),
        border: Border.all(
          color: MetallicBallPin._deep.withValues(alpha: 0.35),
          width: size * 0.035,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: elevated ? 0.4 : 0.28),
            blurRadius: elevated ? 16 : 12,
            offset: const Offset(2, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Soft specular catch-light (not a hard white ring).
          Positioned(
            left: size * 0.18,
            top: size * 0.14,
            child: Container(
              width: highlightSize,
              height: highlightSize * 0.72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.55),
                    Colors.white.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          // Subtle lower-right shade crescent for volume.
          Positioned(
            right: size * 0.08,
            bottom: size * 0.1,
            child: Container(
              width: size * 0.42,
              height: size * 0.42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.18),
                    Colors.black.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stem extends StatelessWidget {
  const _Stem({required this.width, required this.height});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            MetallicBallPin._mid,
            MetallicBallPin._shadow,
            MetallicBallPin._deep,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.28),
            blurRadius: 6,
            offset: const Offset(1.5, 3),
          ),
        ],
      ),
    );
  }
}
