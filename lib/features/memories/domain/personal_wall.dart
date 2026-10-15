/// A named wall of one's own besides "My wall" (Premium), e.g. "Travel 2025".
class PersonalWall {
  const PersonalWall({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  final String id;
  final String name;
  final DateTime createdAt;
}
