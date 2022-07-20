import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:rain_sounds/common/configs/app_cache.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/domain/service/sound_service.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';

class SetCustomTimer extends StatefulWidget {
  const SetCustomTimer({Key? key, this.customMode = CustomMode.media, this.timeOfDay})
      : super(key: key);

  final CustomMode customMode;
  final TimeOfDay? timeOfDay;

  @override
  State<SetCustomTimer> createState() => _SetCustomTimerState();
}

class _SetCustomTimerState extends State<SetCustomTimer> {
  final AppCache appCache = getIt.get();
  final SoundService soundService = getIt.get();
  late DateTime dateTime;

  @override
  void initState() {
    super.initState();
    if (widget.customMode == CustomMode.media) {
      dateTime = DateTime(0, 0, 0, 0, 15);
    } else if (widget.timeOfDay != null){
      dateTime = DateTime(0, 0, 0, widget.timeOfDay!.hour, widget.timeOfDay!.minute);
    } else {
      dateTime = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF201936),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                const Text(
                  'Custom',
                  style: TextStyle(color: Colors.white38, fontSize: 18),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 16,
                    ),
                    const Text(
                      'Hour',
                      style: TextStyle(color: Colors.white38, fontSize: 18),
                    ),
                    TimePickerSpinner(
                        time: dateTime,
                        highlightedTextStyle:
                            const TextStyle(color: Colors.white, fontSize: 28),
                        normalTextStyle: const TextStyle(
                            color: Colors.white38, fontSize: 22),
                        isShowSeconds: false,
                        onTimeChange: (time) {
                          setState(() {
                            dateTime = time;
                          });
                        }),
                    const SizedBox(
                      width: 16,
                    ),
                    const Text(
                      'Minute',
                      style: TextStyle(color: Colors.white38, fontSize: 18),
                    ),
                  ],
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    if (widget.customMode == CustomMode.media) {
                      resetTimer(Duration(
                          hours: dateTime.hour, minutes: dateTime.minute));
                      int count = 0;
                      Navigator.of(context).popUntil((_) => count++ >= 2);
                    } else {
                      Navigator.of(context)
                          .pop(TimeOfDay.fromDateTime(dateTime));
                    }
                  },
                  child: SvgPicture.asset(
                    IconPaths.icChecked,
                    height: 80,
                    width: 80,
                  ),
                ),
                const SizedBox(
                  height: 48,
                )
              ],
            )));
  }

  void resetTimer(Duration duration) {
    appCache.setTimer(duration.toString());
    if (soundService.isPlaying.value) {
      soundService.playbackTimer.reset();
      soundService.playbackTimer.start();
    } else {
      soundService.playbackTimer.reset();
    }
  }
}

enum CustomMode { media, bedtime }
