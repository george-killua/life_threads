import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:life_threads/features/memories/data/place_names.dart';

class _Lookup implements PlaceNameLookup {
  _Lookup(this.name);
  final String? name;

  @override
  Future<String?> nameFor(double latitude, double longitude, Locale locale) =>
      Future.value(name);
}

void main() {
  test('a place is named by its town and country', () {
    expect(
      placeNameFrom(Placemark(locality: 'Split', country: 'Croatia')),
      'Split, Croatia',
    );
    expect(
      placeNameFrom(
        Placemark(subAdministrativeArea: 'Zillertal', country: 'Austria'),
      ),
      'Zillertal, Austria',
    );
    expect(placeNameFrom(Placemark(country: 'Austria')), 'Austria');
    expect(
      placeNameFrom(Placemark(locality: 'Monaco', country: 'Monaco')),
      'Monaco',
    );
    expect(placeNameFrom(Placemark()), isNull);
  });

  test('coordinate labels are recognised', () {
    expect(isCoordinateLabel(coordinateLabel(43.5081, 16.44032)), isTrue);
    expect(isCoordinateLabel('-33.86882, 151.20930'), isTrue);
    expect(isCoordinateLabel('Split, Croatia'), isFalse);
    expect(isCoordinateLabel(''), isFalse);
  });

  test('offline, the coordinates stay as the place', () async {
    const en = Locale('en');
    expect(
      await placeLabelFor(_Lookup('Split, Croatia'), 43.5, 16.4, en),
      'Split, Croatia',
    );
    expect(
      await placeLabelFor(_Lookup(null), 43.5, 16.4, en),
      '43.50000, 16.40000',
    );
    expect(await placeLabelFor(_Lookup('x'), null, null, en), '');
  });
}
