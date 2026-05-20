enum MemoryCategory {
  personal('Personal'),
  family('Family'),
  travel('Travel');

  const MemoryCategory(this.label);

  final String label;

  static MemoryCategory fromName(String value) {
    return MemoryCategory.values.firstWhere(
      (category) => category.name == value,
      orElse: () => MemoryCategory.personal,
    );
  }
}
