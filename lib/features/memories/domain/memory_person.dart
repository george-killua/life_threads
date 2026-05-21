class MemoryPerson {
  const MemoryPerson({
    required this.id,
    required this.eventId,
    required this.name,
    required this.relationship,
    this.phone,
    this.email,
  });

  final String id;
  final String eventId;
  final String name;
  final String relationship;
  final String? phone;
  final String? email;
}
