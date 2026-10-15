import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// A page with a fixed top bar (back button, title, actions) above a
/// scrolling [body]. The bar stays put while the body scrolls; a thin line
/// under it shows once content has scrolled beneath.
class TopBarPage extends StatefulWidget {
  const TopBarPage({
    super.key,
    required this.title,
    required this.body,
    this.actions = const [],
    this.onBack,
  });

  final String title;

  /// The scrolling content, without the title row. Its padding should start
  /// a little below the bar (about 8 pt).
  final Widget body;
  final List<Widget> actions;

  /// Defaults to popping the page.
  final VoidCallback? onBack;

  @override
  State<TopBarPage> createState() => _TopBarPageState();
}

class _TopBarPageState extends State<TopBarPage> {
  var _scrolled = false;

  bool _onScroll(ScrollNotification notification) {
    if (notification.depth != 0) return false;
    final scrolled = notification.metrics.pixels > 0.5;
    if (scrolled != _scrolled) setState(() => _scrolled = scrolled);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: _scrolled ? AppColors.line : Colors.transparent,
              ),
            ),
          ),
          child: Semantics(
            container: true,
            child: Row(
              children: [
                IconButton(
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  onPressed:
                      widget.onBack ?? () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      widget.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.8,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
                ...widget.actions,
              ],
            ),
          ),
        ),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: _onScroll,
            child: widget.body,
          ),
        ),
      ],
    );
  }
}
