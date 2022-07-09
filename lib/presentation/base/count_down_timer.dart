import 'package:flutter/material.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/domain/manager/playback_timer.dart';
import 'package:rain_sounds/presentation/utils/duration_util.dart';

class CountDownTimer extends StatelessWidget {
  CountDownTimer({Key? key, this.fontSize = 14}) : super(key: key);

  final PlaybackTimer _playbackTimer = getIt<PlaybackTimer>();
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _playbackTimer.remainingTime,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Text(
                _playbackTimer.status != Status.off
                    ? formatHHMMSS(snapshot.data as int)
                    : "Timer",
                style: TextStyle(fontSize: fontSize, color: Colors.white),
              ),
            );
          } else {
            return const SizedBox();
          }
        });
  }
}
