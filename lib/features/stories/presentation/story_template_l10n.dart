import 'package:flutter/material.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../domain/music_track.dart';
import '../domain/story_template.dart';

/// The name of [template] in the app's language.
String storyTemplateLabel(AppLocalizations l10n, StoryTemplate template) {
  return switch (template) {
    StoryTemplate.single => l10n.storyTemplateSingle,
    StoryTemplate.thread => l10n.storyTemplateThread,
    StoryTemplate.collage => l10n.storyTemplateCollage,
    StoryTemplate.quote => l10n.storyTemplateQuote,
    StoryTemplate.polaroid => l10n.storyTemplatePolaroid,
    StoryTemplate.album => l10n.storyTemplateAlbum,
    StoryTemplate.filmstrip => l10n.storyTemplateFilmstrip,
    StoryTemplate.timeline => l10n.storyTemplateTimeline,
    StoryTemplate.postcard => l10n.storyTemplatePostcard,
    StoryTemplate.cinema => l10n.storyTemplateCinema,
    StoryTemplate.scrapbook => l10n.storyTemplateScrapbook,
    StoryTemplate.mosaic => l10n.storyTemplateMosaic,
    StoryTemplate.contactSheet => l10n.storyTemplateContactSheet,
    StoryTemplate.wallFlight => l10n.storyTemplateWallFlight,
    StoryTemplate.carousel => l10n.storyTemplateCarousel,
    StoryTemplate.journey => l10n.storyTemplateJourney,
  };
}

/// One line on what [template] does.
String storyTemplateHint(AppLocalizations l10n, StoryTemplate template) {
  return switch (template) {
    StoryTemplate.single => l10n.storyTemplateSingleHint,
    StoryTemplate.thread => l10n.storyTemplateThreadHint,
    StoryTemplate.collage => l10n.storyTemplateCollageHint,
    StoryTemplate.quote => l10n.storyTemplateQuoteHint,
    StoryTemplate.polaroid => l10n.storyTemplatePolaroidHint,
    StoryTemplate.album => l10n.storyTemplateAlbumHint,
    StoryTemplate.filmstrip => l10n.storyTemplateFilmstripHint,
    StoryTemplate.timeline => l10n.storyTemplateTimelineHint,
    StoryTemplate.postcard => l10n.storyTemplatePostcardHint,
    StoryTemplate.cinema => l10n.storyTemplateCinemaHint,
    StoryTemplate.scrapbook => l10n.storyTemplateScrapbookHint,
    StoryTemplate.mosaic => l10n.storyTemplateMosaicHint,
    StoryTemplate.contactSheet => l10n.storyTemplateContactSheetHint,
    StoryTemplate.wallFlight => l10n.storyTemplateWallFlightHint,
    StoryTemplate.carousel => l10n.storyTemplateCarouselHint,
    StoryTemplate.journey => l10n.storyTemplateJourneyHint,
  };
}

IconData storyTemplateIcon(StoryTemplate template) {
  return switch (template) {
    StoryTemplate.single => Icons.crop_portrait_rounded,
    StoryTemplate.thread => Icons.linear_scale_rounded,
    StoryTemplate.collage => Icons.grid_view_rounded,
    StoryTemplate.quote => Icons.format_quote_rounded,
    StoryTemplate.polaroid => Icons.photo_rounded,
    StoryTemplate.album => Icons.menu_book_rounded,
    StoryTemplate.filmstrip => Icons.movie_rounded,
    StoryTemplate.timeline => Icons.timeline_rounded,
    StoryTemplate.postcard => Icons.local_post_office_rounded,
    StoryTemplate.cinema => Icons.theaters_rounded,
    StoryTemplate.scrapbook => Icons.auto_stories_rounded,
    StoryTemplate.mosaic => Icons.dashboard_rounded,
    StoryTemplate.contactSheet => Icons.camera_roll_rounded,
    StoryTemplate.wallFlight => Icons.flight_rounded,
    StoryTemplate.carousel => Icons.view_carousel_rounded,
    StoryTemplate.journey => Icons.route_rounded,
  };
}

String musicMoodLabel(AppLocalizations l10n, MusicMood mood) {
  return switch (mood) {
    MusicMood.warm => l10n.storyMoodWarm,
    MusicMood.joyful => l10n.storyMoodJoyful,
    MusicMood.calm => l10n.storyMoodCalm,
    MusicMood.nostalgic => l10n.storyMoodNostalgic,
    MusicMood.epic => l10n.storyMoodEpic,
    MusicMood.emotional => l10n.storyMoodEmotional,
  };
}

/// A story page scaled into its box: the still image, or the film playing
/// in a loop when [animate] is on.
