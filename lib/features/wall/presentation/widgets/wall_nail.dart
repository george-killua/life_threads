import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../domain/wall_item.dart';

class WallNailWidget extends StatelessWidget {
  const WallNailWidget({
    super.key,
    required this.item,
    required this.isDragging,
    required this.onLongPress,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  final WallItem item;
  final bool isDragging;
  final VoidCallback onLongPress;
  final VoidCallback onDragStart;
  final ValueChanged<Offset> onDragUpdate;
  final VoidCallback onDragEnd;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: item.wallPosition.dx,
      top: item.wallPosition.dy,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        dragStartBehavior: DragStartBehavior.down,
        onLongPress: onLongPress,
        onTap: onLongPress,
        onPanStart: (_) => onDragStart(),
        onPanUpdate: (details) => onDragUpdate(details.delta),
        onPanEnd: (_) => onDragEnd(),
        onPanCancel: onDragEnd,
        child: AnimatedScale(
          scale: isDragging ? 1.2 : 1,
          duration: const Duration(milliseconds: 130),
          curve: Curves.easeOutCubic,
          child: SizedBox(
            width: 48,
            height: 58,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 15,
                  child: Container(
                    width: 4,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF6F4723),
                          AppColors.rope,
                          Color(0xFF4B2B18),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.42),
                          blurRadius: 11,
                          offset: const Offset(3, 7),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withValues(alpha: 0.25),
                    ),
                  ),
                ),
                Container(
                  width: 27,
                  height: 27,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      center: Alignment(-0.35, -0.45),
                      radius: 0.9,
                      colors: [
                        Color(0xFFFFE1A0),
                        Color(0xFFD2A24A),
                        Color(0xFF80531E),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.52),
                      width: 1.6,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gold.withValues(
                          alpha: isDragging ? 0.42 : 0.28,
                        ),
                        blurRadius: isDragging ? 28 : 20,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.38),
                        blurRadius: 14,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withValues(alpha: 0.24),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
