class MemoryConnection {
  const MemoryConnection({
    required this.id,
    required this.fromEventId,
    required this.toEventId,
    required this.label,
  });

  final String id;
  final String fromEventId;
  final String toEventId;
  final String label;

  /// The user's own reason for the link, or '' when none was given. Older
  /// builds stored English placeholders instead of an empty label.
  String get reason {
    final clean = label.trim();
    return _placeholderLabels.contains(clean) ? '' : clean;
  }

  static const _placeholderLabels = {'connected memory', 'new thread'};
}
