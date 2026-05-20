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
}
