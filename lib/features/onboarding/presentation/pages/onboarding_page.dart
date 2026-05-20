import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../media/data/photo_library_service.dart';
import '../../onboarding_preferences.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  bool _isRequesting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.wallInk, AppColors.wallDeep],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 56),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.42),
                  ),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.gold,
                  size: 36,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Build your living wall.',
                style: TextStyle(
                  fontSize: 38,
                  height: 1.05,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Your memories stay private. Connect moments with emotional threads and turn photos into a wall that feels alive.',
                style: TextStyle(
                  color: AppColors.muted,
                  fontSize: 17,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              const _PrivacyPoint(
                icon: Icons.lock_rounded,
                text:
                    'Your memories stay private: no account and no cloud upload in this MVP.',
              ),
              const _PrivacyPoint(
                icon: Icons.photo_library_rounded,
                text: 'Connect moments with threads after you create them.',
              ),
              const _PrivacyPoint(
                icon: Icons.place_rounded,
                text:
                    'Build your living wall with photos, places, and stories.',
              ),
              const SizedBox(height: 34),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isRequesting ? null : _continue,
                  icon: _isRequesting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.arrow_forward_rounded),
                  label: const Text('Start private wall'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _continue() async {
    setState(() => _isRequesting = true);
    final service = ref.read(photoLibraryServiceProvider);
    final permission = await service.requestPermission();
    await ref.read(onboardingPreferencesProvider).markCompleted();

    if (!mounted) return;
    setState(() => _isRequesting = false);

    if (!permission.hasAccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You can still explore the wall and enable photos later.',
          ),
        ),
      );
    }
    context.go(RouteNames.wall);
  }
}

class _PrivacyPoint extends StatelessWidget {
  const _PrivacyPoint({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, color: AppColors.gold, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: AppColors.text, height: 1.35),
            ),
          ),
        ],
      ),
    );
  }
}
