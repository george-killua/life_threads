import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/localization/app_localizations_x.dart';

/// The memory search bar of Create Story, styled like the rest of the wall:
/// a soft dark pill with a gold cursor, a search icon and a clear button.
class StorySearchField extends StatefulWidget {
  const StorySearchField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  State<StorySearchField> createState() => _StorySearchFieldState();
}

class _StorySearchFieldState extends State<StorySearchField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onChanged('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(22),
      borderSide: BorderSide(color: AppColors.line),
    );
    return TextField(
      key: const ValueKey('story-search'),
      controller: _controller,
      cursorColor: AppColors.gold,
      textInputAction: TextInputAction.search,
      style: const TextStyle(fontWeight: FontWeight.w700),
      onChanged: (value) {
        widget.onChanged(value);
        setState(() {});
      },
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: AppColors.panel.withValues(alpha: 0.85),
        hintText: context.l10n.storySearchHint,
        hintStyle: TextStyle(color: AppColors.muted),
        prefixIcon: Icon(Icons.search_rounded, color: AppColors.gold),
        suffixIcon: _controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
                icon: Icon(Icons.close_rounded, color: AppColors.muted),
                onPressed: _clear,
              ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: border,
        enabledBorder: border,
        focusedBorder: border.copyWith(
          borderSide: BorderSide(color: AppColors.gold, width: 1.5),
        ),
      ),
    );
  }
}
