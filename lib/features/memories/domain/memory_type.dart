enum MemoryType {
  moment('Moment', 'A small scene worth keeping'),
  trip('Trip', 'A journey or day away'),
  person('Person', 'Someone important'),
  place('Place', 'A location that carries meaning'),
  note('Note', 'A thought, quote, or reminder');

  const MemoryType(this.label, this.description);

  final String label;
  final String description;

  static MemoryType fromName(String value) {
    return MemoryType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => MemoryType.moment,
    );
  }
}
