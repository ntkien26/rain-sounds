import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rain_sounds/common/configs/app_cache.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/domain/service/sound_service.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';
import 'package:rain_sounds/presentation/utils/styles.dart';

class SetCustomAmbience extends StatefulWidget {
  const SetCustomAmbience(
      {Key? key, this.timeOfDay, required this.onConfirmClick})
      : super(key: key);

  final TimeOfDay? timeOfDay;
  final Function() onConfirmClick;

  @override
  State<SetCustomAmbience> createState() => _SetCustomAmbienceState();
}

class _SetCustomAmbienceState extends State<SetCustomAmbience> {
  final AppCache appCache = getIt.get();
  final SoundService soundService = getIt.get();
  ValueNotifier<DateTime> dateTime = ValueNotifier(DateTime.now());
  final Shader linearGradient = LinearGradient(
    colors: <Color>[
      kF2EFFF,
      kF2EFFF.withOpacity(0),
    ],
  ).createShader(
      Rect.fromCenter(center: const Offset(20, 0), width: 80, height: 80));

  @override
  void initState() {
    super.initState();
    if (widget.timeOfDay != null) {
      dateTime.value =
          DateTime(0, 0, 0, widget.timeOfDay!.hour, widget.timeOfDay!.minute);
    } else {
      dateTime.value = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 32,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hour',
              style: TextStyleConstant.smallTextStyle.copyWith(
                fontWeight: FontWeight.w400,
                color: k8489B0,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 4,
            ),
            Text(
              'Minute',
              style: TextStyleConstant.smallTextStyle.copyWith(
                fontWeight: FontWeight.w400,
                color: k8489B0,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 4,
            ),
            Text(
              'Second',
              style: TextStyleConstant.smallTextStyle.copyWith(
                fontWeight: FontWeight.w400,
                color: k8489B0,
              ),
            ),
          ],
        ),
        // ),
        Stack(
          children: [
            TimePickerSpinner(
              is24HourMode: true,
              normalTextStyle: TextStyle(
                  fontSize: 24, foreground: Paint()..shader = linearGradient),
              highlightedTextStyle: const TextStyle(
                fontSize: 36,
                color: kFFFFFF,
              ),
              spacing: MediaQuery.of(context).size.width / 4,
              alignment: Alignment.center,
              itemHeight: MediaQuery.of(context).size.width / 8,
              isForce2Digits: true,
              minutesInterval: 1,
              onTimeChange: (time) {
                dateTime.value = time;
              },
              isShowSeconds: true,
            ),
            Positioned(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width / 8,
                  ),
                  const SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          ":",
                          style: TextStyle(
                              fontSize: 36,
                              color: kFFFFFF,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ":",
                          style: TextStyle(
                              fontSize: 36,
                              color: kFFFFFF,
                              fontWeight: FontWeight.bold),
                        ), /**/
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        // const Spacer(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextButton(
            onPressed: () async {
              widget.onConfirmClick();
              resetTimer(Duration(
                  hours: dateTime.value.hour,
                  minutes: dateTime.value.minute,
                  seconds: dateTime.value.second));
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              side: const BorderSide(
                color: k7F65F0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: Ink(
              padding: EdgeInsets.zero,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: <Color>[
                    k5C40DF,
                    k7F65F0,
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 32,
                  child: Text(
                    'Done',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
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
// InkWell(
//   onTap: () {
//     if (widget.customMode == CustomMode.media) {
//       resetTimer(Duration(
//           hours: dateTime.hour, minutes: dateTime.minute));
//       int count = 0;
//       Navigator.of(context).popUntil((_) => count++ >= 2);
//     } else {
//       Navigator.of(context)
//           .pop(TimeOfDay.fromDateTime(dateTime));
//     }
//   },
//   child: SvgPicture.asset(
//     IconPaths.icChecked,
//     height: 80,
//     width: 80,
//   ),
// ),
