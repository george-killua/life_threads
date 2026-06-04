import '../../../l10n/generated/app_localizations.dart';
import '../domain/memory_category.dart';
import '../domain/memory_feeling.dart';
import '../domain/memory_type.dart';

extension MemoryTypeL10n on MemoryType {
  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      MemoryType.moment => l10n.memoryTypeMoment,
      MemoryType.trip => l10n.memoryTypeTrip,
      MemoryType.person => l10n.memoryTypePerson,
      MemoryType.place => l10n.memoryTypePlace,
      MemoryType.note => l10n.memoryTypeNote,
    };
  }

  String localizedDescription(AppLocalizations l10n) {
    return switch (this) {
      MemoryType.moment => l10n.memoryTypeMomentDescription,
      MemoryType.trip => l10n.memoryTypeTripDescription,
      MemoryType.person => l10n.memoryTypePersonDescription,
      MemoryType.place => l10n.memoryTypePlaceDescription,
      MemoryType.note => l10n.memoryTypeNoteDescription,
    };
  }
}

extension MemoryCategoryL10n on MemoryCategory {
  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      MemoryCategory.personal => l10n.categoryPersonal,
      MemoryCategory.family => l10n.categoryFamily,
      MemoryCategory.travel => l10n.categoryTravel,
    };
  }
}

extension MemoryFeelingL10n on MemoryFeeling {
  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      MemoryFeeling.warm => l10n.feelingWarm,
      MemoryFeeling.nostalgic => l10n.feelingNostalgic,
      MemoryFeeling.proud => l10n.feelingProud,
      MemoryFeeling.calm => l10n.feelingCalm,
      MemoryFeeling.important => l10n.feelingImportant,
    };
  }

  String localizedDescription(AppLocalizations l10n) {
    return switch (this) {
      MemoryFeeling.warm => l10n.feelingWarmDescription,
      MemoryFeeling.nostalgic => l10n.feelingNostalgicDescription,
      MemoryFeeling.proud => l10n.feelingProudDescription,
      MemoryFeeling.calm => l10n.feelingCalmDescription,
      MemoryFeeling.important => l10n.feelingImportantDescription,
    };
  }
}
