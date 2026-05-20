import '../../../memories/domain/memory_category.dart';

enum WallFilter {
  all('All'),
  family('Family'),
  travel('Travel'),
  personal('Personal');

  const WallFilter(this.label);

  final String label;

  bool matches(MemoryCategory category) {
    return switch (this) {
      WallFilter.all => true,
      WallFilter.family => category == MemoryCategory.family,
      WallFilter.travel => category == MemoryCategory.travel,
      WallFilter.personal => category == MemoryCategory.personal,
    };
  }
}
