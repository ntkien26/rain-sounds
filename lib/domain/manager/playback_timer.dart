import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rain_sounds/common/configs/app_cache.dart';
import 'package:rain_sounds/presentation/utils/duration_util.dart';

class PlaybackTimer extends ChangeNotifier {
  Timer? timer;
  final AppCache appCache;

  int remainingTime = 1800;
  int startTime = 1800;
  Status status = Status.idle;
  final interval = const Duration(seconds: 1);

  PlaybackTimer({required this.appCache});

  pause() {
    if (status == Status.running) {
      if (timer?.isActive == true) {
        timer?.cancel();
        timer = null;
        startTime = remainingTime;
      }
    }
    status = Status.pause;
  }

  start() {
    if (status == Status.idle) {
      Duration duration = parseTime(
          appCache.getTimer() ?? const Duration(minutes: 30).toString());
      timer = Timer.periodic(interval, (timer) {
        remainingTime = duration.inSeconds - timer.tick;
        notifyListeners();
      });
    } else if (status == Status.pause) {
      timer = Timer.periodic(interval, (timer) {
        remainingTime = startTime - timer.tick;
        notifyListeners();
      });
    }
    status = Status.running;
  }

  reset() {
    Duration duration = parseTime(
        appCache.getTimer() ?? const Duration(minutes: 30).toString());
    remainingTime = duration.inSeconds;
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
