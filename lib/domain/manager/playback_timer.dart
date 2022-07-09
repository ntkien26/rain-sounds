import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rain_sounds/common/configs/app_cache.dart';
import 'package:rain_sounds/presentation/utils/duration_util.dart';
import 'package:rxdart/rxdart.dart';

class PlaybackTimer extends ChangeNotifier {
  Timer? timer;
  final AppCache appCache;

  final BehaviorSubject<int> _remainingTime = BehaviorSubject<int>.seeded(1800);
  ValueStream<int> get remainingTime => _remainingTime.stream;

  int startTime = 1800;
  Status status = Status.idle;
  final interval = const Duration(seconds: 1);

  PlaybackTimer({required this.appCache});

  pause() {
    final time = appCache.getTimer();
    if (time == "off") {
      status = Status.off;
      return;
    }

    if (status == Status.running) {
      if (timer?.isActive == true) {
        timer?.cancel();
        timer = null;
        startTime = _remainingTime.value;
      }
    }
    status = Status.pause;
  }

  start() {
    final time = appCache.getTimer();
    if (time == "off") {
      status = Status.off;
      return;
    }

    if (status == Status.idle) {
      Duration duration = parseTime(
          time ?? const Duration(minutes: 30).toString());
        timer = Timer.periodic(interval, (timer) {
          _remainingTime.add(duration.inSeconds - timer.tick);
        notifyListeners();
      });
    } else if (status == Status.pause) {
      timer = Timer.periodic(interval, (timer) {
        _remainingTime.add(startTime - timer.tick);
        notifyListeners();
      });
    }
    status = Status.running;
  }

  reset() {
    final time = appCache.getTimer();
    if (time == "off") {
      return;
    }
    Duration duration = parseTime(
        time ?? const Duration(minutes: 30).toString());
    _remainingTime.add(duration.inSeconds);
    startTime = duration.inSeconds;
    status = Status.idle;
    timer?.cancel();
    timer = null;
    notifyListeners();
  }

  off() {
    timer?.cancel();
    timer = null;
    status = Status.off;
    notifyListeners();
  }
}

enum Status { idle, running, pause, off }
