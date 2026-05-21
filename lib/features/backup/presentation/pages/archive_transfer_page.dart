import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../wall/presentation/widgets/wall_background.dart';

class ArchiveTransferPage extends StatelessWidget {
  const ArchiveTransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WallBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 34),
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Open on another device',
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.8,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.panelWarm.withValues(alpha: 0.94),
                      AppColors.wallInk.withValues(alpha: 0.9),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(34),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.2),
                  ),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.enhanced_encryption_rounded,
                      color: AppColors.amber,
                      size: 38,
                    ),
                    SizedBox(height: 14),
                    Text(
                      'Move your memories between devices safely.',
                      style: TextStyle(
                        fontSize: 30,
                        height: 1.05,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.9,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Premium Archive creates a portable encrypted zip with your memories, photos, notes, ropes, wall positions, and metadata. Cloud sync is planned later, but it is not active now.',
                      style: TextStyle(
                        color: AppColors.muted,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const _StepCard(
                number: '1',
                title: 'Export an archive',
                body:
                    'Open Settings, choose Export Archive, and add a password if you want password protection.',
                icon: Icons.ios_share_rounded,
              ),
              const _StepCard(
                number: '2',
                title: 'Move the zip',
                body:
                    'Transfer it with AirDrop, USB, Drive, email, or any method you trust. LifeThreads does not upload it for you.',
                icon: Icons.devices_rounded,
              ),
              const _StepCard(
                number: '3',
                title: 'Import safely',
                body:
                    'Install LifeThreads on the other device, choose Import Archive, enter the password if needed, and restore without deleting existing data.',
                icon: Icons.restore_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.number,
    required this.title,
    required this.body,
    required this.icon,
  });

  final String number;
  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.panel.withValues(alpha: 0.82),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 23,
            backgroundColor: AppColors.gold,
            child: Text(
              number,
              style: const TextStyle(
                color: AppColors.paperInk,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon, color: AppColors.amber, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: const TextStyle(
                    color: AppColors.muted,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
