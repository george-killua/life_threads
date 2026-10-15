import 'package:flutter/material.dart';

import '../../../../core/widgets/top_bar_page.dart';
import '../../../../core/localization/app_localizations_x.dart';
import '../../../../app/theme/app_colors.dart';
import '../widgets/wall_background.dart';
import '../widgets/wall_theme_picker.dart';

/// Every wall theme in one place: Auto, the year-round themes, this
/// season's themes and the seasons still to come.
class ThemesPage extends StatelessWidget {
  const ThemesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: WallBackground(
        child: SafeArea(
          child: TopBarPage(
            title: l10n.themeTitle,
            body: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    l10n.themeBody,
                    style: TextStyle(
                      color: AppColors.muted,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                const WallThemePicker(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
