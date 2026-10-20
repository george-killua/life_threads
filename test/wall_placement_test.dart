import 'package:flutter_test/flutter_test.dart';
import 'package:life_threads/features/memories/data/memory_seed_data.dart';
import 'package:life_threads/features/wall/domain/wall_placement.dart';

void main() {
  bool overlaps(Offset a, Offset b) =>
      (a & WallPlacement.card).overlaps(b & WallPlacement.card);

  test('the demo wall hangs every card apart', () {
    final positions = [
      for (final event in MemorySeedData.events) event.wallPosition,
    ];
    for (var i = 0; i < positions.length; i++) {
      for (var j = i + 1; j < positions.length; j++) {
        expect(
          overlaps(positions[i], positions[j]),
          isFalse,
          reason: 'cards $i and $j',
        );
      }
    }
  });

  test('a new memory goes to the next free spot, not onto a card', () {
    final demo = [for (var i = 0; i < 9; i++) WallPlacement.slot(i)];
    final next = WallPlacement.freeSpot(demo);
    expect(next, WallPlacement.slot(9));
    for (final card in demo) {
      expect(overlaps(next, card), isFalse);
    }
  });

  test('a gap left by a deleted memory is filled first', () {
    final cards = [
      for (var i = 0; i < 9; i++)
        if (i != 4) WallPlacement.slot(i),
    ];
    expect(WallPlacement.freeSpot(cards), WallPlacement.slot(4));
  });

  test('cards moved by hand are avoided too', () {
    // Someone dragged a card onto the next spot of the pattern.
    final cards = [
      for (var i = 0; i < 9; i++) WallPlacement.slot(i),
      WallPlacement.slot(9) + const Offset(30, 20),
    ];
    final next = WallPlacement.freeSpot(cards);
    for (final card in cards) {
      expect(overlaps(next, card), isFalse);
    }
  });

  test('the first memory on an empty wall starts the pattern', () {
    expect(WallPlacement.freeSpot(const []), WallPlacement.slot(0));
  });

  test('a quick photo starts near the middle of the screen, off the cards', () {
    final cards = [for (var i = 0; i < 9; i++) WallPlacement.slot(i)];
    // The middle of the screen is on the middle card.
    final near = WallPlacement.slot(4) + const Offset(20, 30);
    final spot = WallPlacement.freeSpotNear(cards, near);
    for (final card in cards) {
      expect(overlaps(spot, card), isFalse);
    }
    expect((spot - near).distance, lessThan(600));
    // A free middle is used as it is.
    expect(WallPlacement.freeSpotNear(const [], near), near);
  });
}
