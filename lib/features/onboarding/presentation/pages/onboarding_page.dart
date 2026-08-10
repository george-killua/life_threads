import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../onboarding_preferences.dart';
import '../widgets/onboarding_demo_wall_preview.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  static const _pageCount = 5;

  final _pageController = PageController();
  final _nameController = TextEditingController();
  final _nameFocus = FocusNode();

  int _pageIndex = 0;
  bool _isContinuing = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  String get _trimmedName => _nameController.text.trim();

  bool get _canAdvanceFromName => _trimmedName.isNotEmpty;

  bool get _isLastPage => _pageIndex == _pageCount - 1;

  bool get _isNamePage => _pageIndex == 2;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 1.2,
            colors: [AppColors.wallPlum, AppColors.wallInk],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 18, 22, 8),
                child: Row(
                  children: [
                    const _BrandMark(),
                    const Spacer(),
                    Text(
                      '${_pageIndex + 1}/$_pageCount',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() => _pageIndex = index);
                    if (index == 2) {
                      _nameFocus.requestFocus();
                    } else {
                      _nameFocus.unfocus();
                    }
                  },
                  children: [
                    _WelcomeStep(headline: l10n.onboardingHeadline, body: l10n.onboardingBody),
                    _HowItWorksStep(
                      title: l10n.howItWorks,
                      cards: [
                        (
                          Icons.auto_awesome_rounded,
                          l10n.storyWallTitle,
                          l10n.storyWallText,
                        ),
                        (
                          Icons.hub_rounded,
                          l10n.storyConnectTitle,
                          l10n.storyConnectText,
                        ),
                        (
                          Icons.lock_rounded,
                          l10n.storyPrivacyTitle,
                          l10n.onboardingPrivacyShort,
                        ),
                      ],
                    ),
                    _NameStep(
                      controller: _nameController,
                      focusNode: _nameFocus,
                      title: l10n.onboardingNameTitle,
                      hint: l10n.onboardingNameHint,
                      preview: _trimmedName.isEmpty
                          ? null
                          : l10n.onboardingNiceToMeetYou(_trimmedName),
                    ),
                    _PrivacyStep(
                      title: l10n.storyPrivacyTitle,
                      body: l10n.onboardingPrivacy,
                    ),
                    _GetStartedStep(
                      title: l10n.onboardingGetStartedTitle,
                      body: l10n.onboardingGetStartedBody,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 18),
                child: Column(
                  children: [
                    _PageDots(count: _pageCount, index: _pageIndex),
                    const SizedBox(height: 16),
                    if (_isLastPage) ...[
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _isContinuing
                              ? null
                              : () => _continue(useDemoWall: true),
                          icon: _isContinuing
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.preview_rounded),
                          label: Text(l10n.previewDemoWall),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _isContinuing
                              ? null
                              : () => _continue(useDemoWall: false),
                          icon: const Icon(Icons.add_rounded),
                          label: Text(l10n.startFresh),
                        ),
                      ),
                      TextButton(
                        onPressed: _isContinuing ? null : _goBack,
                        child: Text(l10n.back),
                      ),
                    ] else
                      Row(
                        children: [
                          if (_pageIndex > 0)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _isContinuing ? null : _goBack,
                                child: Text(l10n.back),
                              ),
                            ),
                          if (_pageIndex > 0) const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton(
                              onPressed: _isContinuing ||
                                      (_isNamePage && !_canAdvanceFromName)
                                  ? null
                                  : _goNext,
                              child: Text(l10n.onboardingNext),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _goNext() async {
    if (_isNamePage && !_canAdvanceFromName) return;
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _goBack() async {
    await _pageController.previousPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _continue({required bool useDemoWall}) async {
    if (!_canAdvanceFromName) {
      await _pageController.animateToPage(
        2,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
      return;
    }

    setState(() => _isContinuing = true);
    final name = _trimmedName;
    await ref
        .read(onboardingPreferencesProvider)
        .markCompleted(useDemoWall: useDemoWall, displayName: name);
    ref.invalidate(userDisplayNameProvider);

    if (!mounted) return;
    setState(() => _isContinuing = false);
    context.go(RouteNames.wall);
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.38)),
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            color: AppColors.gold,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'LifeThreads',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.4,
          ),
        ),
      ],
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: i == index ? 22 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: i == index
                  ? AppColors.gold
                  : AppColors.gold.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
      ],
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep({required this.headline, required this.body});

  final String headline;
  final String body;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 12),
      children: [
        Text(
          headline,
          style: const TextStyle(
            fontSize: 36,
            height: 1.05,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.1,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          body,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 16,
            height: 1.45,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 22),
        const OnboardingDemoWallPreview(),
      ],
    );
  }
}

class _HowItWorksStep extends StatelessWidget {
  const _HowItWorksStep({required this.title, required this.cards});

  final String title;
  final List<(IconData, String, String)> cards;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 12),
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 18),
        for (final card in cards) ...[
          _FeatureCard(icon: card.$1, title: card.$2, text: card.$3),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.panel.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppColors.gold),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  text,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.muted,
                    height: 1.35,
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

class _NameStep extends StatelessWidget {
  const _NameStep({
    required this.controller,
    required this.focusNode,
    required this.title,
    required this.hint,
    required this.preview,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String title;
  final String hint;
  final String? preview;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 12),
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: controller,
          focusNode: focusNode,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.panel.withValues(alpha: 0.72),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.gold.withValues(alpha: 0.24)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: AppColors.gold.withValues(alpha: 0.24)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: AppColors.gold, width: 1.4),
            ),
          ),
        ),
        if (preview != null) ...[
          const SizedBox(height: 18),
          Text(
            preview!,
            style: const TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.w900,
              fontSize: 18,
              height: 1.3,
            ),
          ),
        ],
      ],
    );
  }
}

class _PrivacyStep extends StatelessWidget {
  const _PrivacyStep({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 12),
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.gold.withValues(alpha: 0.32)),
          ),
          child: const Icon(Icons.lock_rounded, color: AppColors.gold, size: 34),
        ),
        const SizedBox(height: 22),
        Text(
          title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          body,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 17,
            height: 1.45,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _GetStartedStep extends StatelessWidget {
  const _GetStartedStep({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 12),
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          body,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 16,
            height: 1.45,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 22),
        const OnboardingDemoWallPreview(),
      ],
    );
  }
}
