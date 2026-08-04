import 'package:flutter/scheduler.dart';

import 'capsule_cinema_script.dart';

class CapsuleCinemaController {
  CapsuleCinemaController({
    required this.script,
    required void Function() onTick,
  }) : _onTick = onTick;

  final CapsuleCinemaScript script;
  final void Function() _onTick;

  Ticker? _ticker;
  var _beatIndex = 0;
  var _showingInvite = false;
  var _disposed = false;

  int get beatIndex => _beatIndex;
  bool get showingInvite => _showingInvite;
  CapsuleCinemaBeat get currentBeat => script.beats[_beatIndex];

  void start(TickerProvider vsync) {
    _ticker?.dispose();
    _ticker = vsync.createTicker(_handleTick)..start();
  }

  void skipToInvite() {
    final inviteIndex = script.beats.indexWhere(
      (beat) => beat.kind == CapsuleCinemaBeatKind.invite,
    );
    if (inviteIndex < 0) return;
    _beatIndex = inviteIndex;
    _showingInvite = true;
    _ticker?.stop();
    _onTick();
  }

  void dispose() {
    _disposed = true;
    _ticker?.dispose();
    _ticker = null;
  }

  void _handleTick(Duration elapsed) {
    if (_disposed || _showingInvite || script.beats.isEmpty) return;

    var cursor = Duration.zero;
    for (var i = 0; i < script.beats.length; i++) {
      final next = cursor + script.beats[i].duration;
      if (elapsed < next || i == script.beats.length - 1) {
        if (_beatIndex != i) {
          _beatIndex = i;
          _onTick();
        }
        if (script.beats[i].kind == CapsuleCinemaBeatKind.invite) {
          _showingInvite = true;
          _ticker?.stop();
          _onTick();
        }
        return;
      }
      cursor = next;
    }
  }
}
