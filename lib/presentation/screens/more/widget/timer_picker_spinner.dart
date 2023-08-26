import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';

class TimerPickerSpinnerWidget extends StatelessWidget {
  TimerPickerSpinnerWidget(
      {Key? key, required this.onCancelClick, required this.onConfirmClick})
      : super(key: key);

  ValueNotifier<DateTime> dateTime = ValueNotifier(DateTime.now());
  final VoidCallback onCancelClick;
  final Function(DateTime) onConfirmClick;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            onCancelClick();
          },
          child: SvgPicture.asset(IconPaths.icCancel),
        ),
        hourMinute12HCustomStyle(),
        GestureDetector(
          onTap: () {
            onConfirmClick(dateTime.value);
          },
          child: SvgPicture.asset(IconPaths.icConfirmGreen),
        ),      ],
    );
  }

  Widget hourMinute12HCustomStyle() {
    final Shader linearGradient = LinearGradient(
      colors: <Color>[
        kF2EFFF,
        kF2EFFF.withOpacity(0),
      ],
    ).createShader(
        Rect.fromCenter(center: const Offset(20, 0), width: 80, height: 80));
    return ValueListenableBuilder<DateTime>(
        valueListenable: dateTime,
        builder: (context, value, _) {
          return TimePickerSpinner(
            is24HourMode: true,
            normalTextStyle: TextStyle(
                fontSize: 24, foreground: Paint()..shader = linearGradient),
            highlightedTextStyle: const TextStyle(
              fontSize: 36,
              color: kFFFFFF,
            ),
            spacing: 80,
            alignment: Alignment.center,
            itemHeight: 60,
            isForce2Digits: true,
            minutesInterval: 1,
            onTimeChange: (time) {
              dateTime.value = time;
            },
          );
        });
  }
}
