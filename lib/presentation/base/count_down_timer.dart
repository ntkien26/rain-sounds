import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/domain/manager/playback_timer.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';
import 'package:rain_sounds/presentation/utils/duration_util.dart';

class CountDownTimer extends StatelessWidget {
  CountDownTimer({Key? key, required this.isNowPlayScreen, this.fontSize = 14})
      : super(key: key);

  final PlaybackTimer _playbackTimer = getIt<PlaybackTimer>();
  final bool isNowPlayScreen;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _playbackTimer.remainingTime,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (isNowPlayScreen == true) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),

                // child: Text(
                //   _playbackTimer.status != Status.off
                //       ? formatHHMMSS(snapshot.data as int)
                //       : "Timer",
                //   style: TextStyle(fontSize: fontSize, color: Colors.white),
                // ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '00:00',
                          style: TextStyle(fontSize: 13, color: k8489B0),
                        ),
                        Text(
                          _playbackTimer.status != Status.off
                              ? formatHHMMSS(snapshot.data as int)
                              : "Timer",
                          style: const TextStyle(fontSize: 13, color: k8489B0),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ProgressBar(
                      progress: Duration(
                          seconds: _playbackTimer.status != Status.off
                              ? snapshot.data as int
                              : 0),
                      baseBarColor: Colors.white.withOpacity(0.24),
                      bufferedBarColor: Colors.white.withOpacity(0.24),
                      thumbColor: Colors.white,
                      barHeight: 4.0,
                      progressBarColor: Colors.white,
                      thumbRadius: 8.0,
                      // buffered: Duration(milliseconds: 2000),
                      total: Duration(seconds: _playbackTimer.startTime),
                      onSeek: (duration) {
                        print('User selected a new time: $duration');
                      },
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Text(
                  _playbackTimer.status != Status.off
                      ? formatHHMMSS(snapshot.data as int)
                      : "Timer",
                  style: TextStyle(fontSize: fontSize, color: Colors.white),
                ),
              );
            }
          } else {
            return const SizedBox();
          }
        });
  }
}
