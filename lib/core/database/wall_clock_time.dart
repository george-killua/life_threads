/// When a memory happened is a calendar date and clock time ("17 June 2023,
/// 18:30"), not an instant: it must read the same after the phone moves to
/// another time zone. The database keeps that wall-clock time encoded as if
/// it were UTC; backups, shared memories and the display keep using the
/// local instant, as before.
int encodeWallClock(DateTime value) {
  final local = value.isUtc ? value.toLocal() : value;
  return DateTime.utc(
    local.year,
    local.month,
    local.day,
    local.hour,
    local.minute,
    local.second,
    local.millisecond,
  ).millisecondsSinceEpoch;
}

/// The local date and time stored by [encodeWallClock].
DateTime decodeWallClock(int stored) {
  final utc = DateTime.fromMillisecondsSinceEpoch(stored, isUtc: true);
  return DateTime(
    utc.year,
    utc.month,
    utc.day,
    utc.hour,
    utc.minute,
    utc.second,
    utc.millisecond,
  );
}

/// [encodeWallClock] for an instant in milliseconds (a backup's value),
/// read in the phone's current time zone.
int encodeWallClockFromInstant(int millisecondsSinceEpoch) => encodeWallClock(
  DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch),
);
