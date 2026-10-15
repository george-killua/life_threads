import '../../../l10n/generated/app_localizations.dart';

/// Features that need Premium. New features check access through
/// `requirePremium` instead of reading the entitlement themselves.
enum PremiumFeature {
  onThisDay,
  storyImage,
  storyVideo,
  threadOfTheYear,
  familyWall,
  walls;

  String label(AppLocalizations l10n) => switch (this) {
    PremiumFeature.onThisDay => l10n.onThisDayTitle,
    PremiumFeature.storyImage => l10n.premiumFeatureStoryImage,
    PremiumFeature.storyVideo => l10n.premiumFeatureStoryVideo,
    PremiumFeature.threadOfTheYear => l10n.premiumFeatureThreadOfTheYear,
    PremiumFeature.familyWall => l10n.premiumFeatureFamilyWall,
    PremiumFeature.walls => l10n.premiumFeatureWalls,
  };
}
