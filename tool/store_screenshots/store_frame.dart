import 'package:flutter/material.dart';
import 'package:life_threads/app/theme/app_colors.dart';

enum DeviceKind { iphone, androidPhone, ipad, androidTablet }

/// One store slot: the exact pixel size the store asks for and the device
/// whose screen is shown inside it.
class StoreSize {
  const StoreSize(this.name, this.pixels, this.device, this.screen);

  final String name;
  final Size pixels;
  final DeviceKind device;

  /// Logical screen size of the device the app is laid out for.
  final Size screen;

  bool get isTablet =>
      device == DeviceKind.ipad || device == DeviceKind.androidTablet;
  bool get isIos => device == DeviceKind.iphone || device == DeviceKind.ipad;

  /// Logical width of the whole store image; text and frame sizes are
  /// designed against it.
  double get canvasWidth => isTablet ? 820 : 440;
  double get pixelRatio => pixels.width / canvasWidth;

  EdgeInsets get safeArea => switch (device) {
    DeviceKind.iphone => const EdgeInsets.only(top: 59, bottom: 34),
    DeviceKind.androidPhone => const EdgeInsets.only(top: 30, bottom: 16),
    DeviceKind.ipad => const EdgeInsets.only(top: 24, bottom: 20),
    DeviceKind.androidTablet => const EdgeInsets.only(top: 28, bottom: 16),
  };
}

const storeSizes = [
  StoreSize(
    'play-phone',
    Size(1080, 1920),
    DeviceKind.androidPhone,
    Size(412, 892),
  ),
  StoreSize(
    'play-tablet-7',
    Size(1200, 1920),
    DeviceKind.androidTablet,
    Size(600, 960),
  ),
  StoreSize(
    'play-tablet-10',
    Size(1600, 2560),
    DeviceKind.androidTablet,
    Size(800, 1280),
  ),
  StoreSize('ios-6.9', Size(1320, 2868), DeviceKind.iphone, Size(440, 956)),
  StoreSize('ios-6.5', Size(1242, 2688), DeviceKind.iphone, Size(414, 896)),
  // App Store Connect's 6.1"/6.3" slot (iPhone 16/17 Pro).
  StoreSize('ios-6.3', Size(1206, 2622), DeviceKind.iphone, Size(402, 874)),
  // An 11" iPad layout (same 3:4 shape): at the 13" size the wall and lists
  // look sparse in a still image.
  StoreSize('ios-ipad-13', Size(2064, 2752), DeviceKind.ipad, Size(834, 1112)),
];

/// The store image: caption on top, the live app screen in a device frame
/// below, on the app's dark wall colours with a warm glow.
class StoreFrame extends StatelessWidget {
  const StoreFrame({
    super.key,
    required this.size,
    required this.tag,
    required this.headline,
    required this.subtitle,
    required this.rtl,
    required this.glowRight,
    required this.screen,
  });

  final StoreSize size;
  final String tag;
  final String headline;
  final String subtitle;
  final bool rtl;
  final bool glowRight;
  final Widget screen;

  @override
  Widget build(BuildContext context) {
    final u = size.isTablet ? 1.45 : 1.0;
    return Directionality(
      textDirection: rtl ? TextDirection.rtl : TextDirection.ltr,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF120C10), AppColors.wallInk, Color(0xFF1A1114)],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(glowRight ? 0.95 : -0.95, 0.15),
                    radius: 0.95,
                    colors: [
                      AppColors.gold.withValues(alpha: 0.30),
                      AppColors.gold.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -1.05),
                    radius: 0.8,
                    colors: [
                      AppColors.rose.withValues(alpha: 0.16),
                      AppColors.rose.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: 34 * u),
                _Caption(
                  tag: tag,
                  headline: headline,
                  subtitle: subtitle,
                  u: u,
                ),
                SizedBox(height: 22 * u),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 26 * u),
                    child: Center(
                      child: _Device(size: size, screen: screen),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Caption extends StatelessWidget {
  const _Caption({
    required this.tag,
    required this.headline,
    required this.subtitle,
    required this.u,
  });

  final String tag;
  final String headline;
  final String subtitle;
  final double u;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30 * u),
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              gradient: const LinearGradient(
                colors: [AppColors.amber, AppColors.gold],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.35),
                  blurRadius: 18 * u,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 14 * u,
                vertical: 6 * u,
              ),
              child: Text(
                tag,
                style: TextStyle(
                  color: const Color(0xFF241505),
                  fontSize: 13 * u,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
          SizedBox(height: 14 * u),
          Text(
            headline,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.text,
              fontSize: 33 * u,
              height: 1.12,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.6,
            ),
          ),
          SizedBox(height: 10 * u),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 16 * u,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _Device extends StatelessWidget {
  const _Device({required this.size, required this.screen});

  final StoreSize size;
  final Widget screen;

  @override
  Widget build(BuildContext context) {
    final tablet = size.isTablet;
    final screenRadius = switch (size.device) {
      DeviceKind.iphone => 56.0,
      DeviceKind.androidPhone => 34.0,
      _ => 22.0,
    };
    final bezel = tablet ? 16.0 : 11.0;

    // The device is drawn at its real logical size and scaled to fit, so
    // the app lays out exactly as on that device.
    return FittedBox(
      child: Container(
        width: size.screen.width + bezel * 2,
        height: size.screen.height + bezel * 2,
        padding: EdgeInsets.all(bezel),
        decoration: BoxDecoration(
          color: const Color(0xFF0C0A0C),
          borderRadius: BorderRadius.circular(screenRadius + bezel),
          border: Border.all(color: const Color(0xFF4A3A33), width: 2.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.55),
              blurRadius: 60,
              offset: const Offset(0, 28),
            ),
            BoxShadow(
              color: AppColors.gold.withValues(alpha: 0.10),
              blurRadius: 40,
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(screenRadius),
          child: SizedBox.fromSize(
            size: size.screen,
            child: Stack(
              children: [
                Positioned.fill(child: screen),
                // Scrolled content runs under the status bar on a phone; a
                // soft scrim keeps the clock readable in a still image.
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  height: size.safeArea.top + 14,
                  child: const IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xE6090709), Color(0x00090709)],
                          stops: [0.6, 1],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  height: size.safeArea.top,
                  child: _StatusBar(size: size),
                ),
                if (size.device == DeviceKind.iphone)
                  const Positioned(
                    top: 11,
                    left: 0,
                    right: 0,
                    child: Center(child: _DynamicIsland()),
                  ),
                if (size.safeArea.bottom > 0)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: size.isIos ? 8 : 5,
                    child: Center(
                      child: Container(
                        width: size.isIos ? 140 : 108,
                        height: size.isIos ? 5 : 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(9),
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

class _DynamicIsland extends StatelessWidget {
  const _DynamicIsland();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 124,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.size});

  final StoreSize size;

  @override
  Widget build(BuildContext context) {
    final ios = size.isIos;
    final style = TextStyle(
      color: Colors.white,
      fontSize: ios ? 17 : 14,
      fontWeight: ios ? FontWeight.w800 : FontWeight.w600,
      letterSpacing: -0.2,
    );
    final iconSize = ios ? 18.0 : 16.0;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: EdgeInsets.only(
          left: ios ? (size.isTablet ? 22 : 44) : 22,
          right: ios ? (size.isTablet ? 22 : 34) : 18,
          top: ios && !size.isTablet ? 6 : 0,
        ),
        child: Row(
          children: [
            Text('9:41', style: style),
            const Spacer(),
            Icon(
              Icons.signal_cellular_alt_rounded,
              color: Colors.white,
              size: iconSize,
            ),
            const SizedBox(width: 5),
            Icon(Icons.wifi_rounded, color: Colors.white, size: iconSize),
            const SizedBox(width: 5),
            ios
                ? const _IosBattery()
                : Icon(
                    Icons.battery_full_rounded,
                    color: Colors.white,
                    size: iconSize,
                  ),
          ],
        ),
      ),
    );
  }
}

class _IosBattery extends StatelessWidget {
  const _IosBattery();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 25,
          height: 12,
          padding: const EdgeInsets.all(1.5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.5),
            border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        Container(
          width: 1.5,
          height: 4,
          margin: const EdgeInsets.only(left: 1),
          color: Colors.white.withValues(alpha: 0.5),
        ),
      ],
    );
  }
}
