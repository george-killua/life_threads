import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../../core/widgets/app_toast.dart';

class WallDisplayScannerPage extends StatefulWidget {
  const WallDisplayScannerPage({super.key});

  @override
  State<WallDisplayScannerPage> createState() => _WallDisplayScannerPageState();
}

class _WallDisplayScannerPageState extends State<WallDisplayScannerPage> {
  final _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  var _handled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.wallDeep,
      appBar: AppBar(title: Text(context.l10n.scanDisplayQr)),
      // The camera on top, the steps below it: the steps never cover the
      // frame, also on small phones.
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final frame = (constraints.biggest.shortestSide - 48).clamp(
                    140.0,
                    260.0,
                  );
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      MobileScanner(
                        controller: _controller,
                        onDetect: _onDetect,
                      ),
                      IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                Colors.transparent,
                                AppColors.wallDeep.withValues(alpha: 0.74),
                              ],
                              radius: 0.78,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: frame,
                          height: frame,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: AppColors.gold, width: 3),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            // With large text the steps scroll, so the camera keeps room.
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.6,
              ),
              child: const SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
                child: _ScannerHint(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    for (final barcode in capture.barcodes) {
      final raw = barcode.rawValue?.trim();
      if (raw == null || raw.isEmpty) continue;
      final uri = Uri.tryParse(raw);
      if (uri == null) continue;
      _handled = true;
      Navigator.of(context).pop(uri);
      return;
    }
  }
}

/// The page on the other screen that shows the QR code.
const wallDisplayPageUrl = 'https://lifethreads.gkcoding.dev/display';
const _wallDisplayPageLabel = 'lifethreads.gkcoding.dev/display';

/// Where the QR code comes from, step by step, and the page's address to
/// send to the other screen (AirDrop, a message) or copy.
class _ScannerHint extends StatelessWidget {
  const _ScannerHint();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final steps = [
      l10n.scannerStep1,
      l10n.scannerStep2(_wallDisplayPageLabel),
      l10n.scannerStep3,
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.wallInk.withValues(alpha: 0.86),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.18)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(Icons.qr_code_scanner_rounded, color: AppColors.gold),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.scannerHintTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      height: 1.25,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            for (var i = 0; i < steps.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          color: AppColors.wallInk,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        steps[i],
                        style: const TextStyle(height: 1.35),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 2),
            _LinkButtons(onShare: _share, onCopy: _copy),
          ],
        ),
      ),
    );
  }

  Future<void> _share(BuildContext context) async {
    // The share popover points at the button on iPad.
    final box = context.findRenderObject() as RenderBox?;
    await SharePlus.instance.share(
      ShareParams(
        uri: Uri.parse(wallDisplayPageUrl),
        sharePositionOrigin: box == null
            ? null
            : box.localToGlobal(Offset.zero) & box.size,
      ),
    );
  }

  Future<void> _copy(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final copied = context.l10n.scannerLinkCopied;
    await Clipboard.setData(const ClipboardData(text: wallDisplayPageUrl));
    messenger.showToast(copied, kind: ToastKind.success);
  }
}

/// Send link (wide, its label always fits) and Copy link (an icon).
class _LinkButtons extends StatelessWidget {
  const _LinkButtons({required this.onShare, required this.onCopy});

  final Future<void> Function(BuildContext context) onShare;
  final Future<void> Function(BuildContext context) onCopy;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: Builder(
            builder: (context) => FilledButton.tonalIcon(
              key: const ValueKey('display-share-link'),
              onPressed: () => onShare(context),
              icon: const Icon(Icons.ios_share_rounded, size: 18),
              label: Text(l10n.scannerShareLink),
            ),
          ),
        ),
        const SizedBox(width: 10),
        IconButton.outlined(
          key: const ValueKey('display-copy-link'),
          tooltip: l10n.scannerCopyLink,
          onPressed: () => onCopy(context),
          icon: const Icon(Icons.copy_rounded, size: 20),
        ),
      ],
    );
  }
}

Future<Uri?> showWallDisplayScanner(BuildContext context) {
  return Navigator.of(context).push<Uri>(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => const WallDisplayScannerPage(),
    ),
  );
}
