import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rain_sounds/common/configs/app_cache.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/presentation/base/base_stateful_widget.dart';
import 'package:rain_sounds/presentation/base/navigation_service.dart';
import 'package:rain_sounds/presentation/screens/main/main_screen.dart';
import 'package:rain_sounds/presentation/screens/more/widget/timer_picker_spinner.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';
import 'package:rain_sounds/presentation/utils/styles.dart';

class BedTimeReminderScreen extends StatefulWidget {
  const BedTimeReminderScreen({Key? key}) : super(key: key);
  static const String routePath = 'bedTimeReminderScreen';

  @override
  State<BedTimeReminderScreen> createState() => _BedTimeReminderScreenState();
}

class _BedTimeReminderScreenState extends State<BedTimeReminderScreen> {
  final AppCache appCache = getIt.get();
  ValueNotifier<TimeOfDay> timeOfDay =
      ValueNotifier(const TimeOfDay(hour: 21, minute: 30));
  DateTime now = DateTime.now();
  ValueNotifier<bool> reminderTime = ValueNotifier(false);
  ValueNotifier<bool> bedtimeReminderSwitch = ValueNotifier(false);

  final List<ListOfDayModel> listOfDays = [
    ListOfDayModel('S', 'Sun', 7, false),
    ListOfDayModel('M', 'Mon', 1, false),
    ListOfDayModel('T', 'Tues', 2, false),
    ListOfDayModel('W', 'Wed', 3, false),
    ListOfDayModel('Th', 'Thus', 4, false),
    ListOfDayModel('F', 'Fri', 5, false),
    ListOfDayModel('SA', 'Sat', 6, false),
  ];

  @override
  void initState() {
    super.initState();
    bedtimeReminderSwitch.value = appCache.isEnableReminder();
    listOfDays[0].onCheck =
        appCache.isEnableDayForReminder(listOfDays[0].fullName);
    listOfDays[1].onCheck =
        appCache.isEnableDayForReminder(listOfDays[1].fullName);
    listOfDays[2].onCheck =
        appCache.isEnableDayForReminder(listOfDays[2].fullName);
    listOfDays[3].onCheck =
        appCache.isEnableDayForReminder(listOfDays[3].fullName);
    listOfDays[4].onCheck =
        appCache.isEnableDayForReminder(listOfDays[4].fullName);
    listOfDays[5].onCheck =
        appCache.isEnableDayForReminder(listOfDays[5].fullName);
    listOfDays[6].onCheck =
        appCache.isEnableDayForReminder(listOfDays[6].fullName);

    final reminderTime = appCache.getReminder();

    if (reminderTime != null) {
      timeOfDay.value = TimeOfDay(
          hour: int.parse(reminderTime.split(":")[0]),
          minute: int.parse(reminderTime.split(":")[1]));
    } else {
      timeOfDay.value = const TimeOfDay(hour: 21, minute: 30);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(ImagePaths.bgOnBoarding), fit: BoxFit.fill)),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 32,
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Bedtime reminder setup',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                      textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  )),
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  border: Border.all(
                    color: k202968,
                    width: 2,
                  ),
                  gradient: const LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    transform: GradientRotation(5.50),
                    colors: [
                      k181E4A,
                      k202968,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Bedtime reminder',
                          style: TextStyleConstant.songTitleTextStyle,
                        ),
                        ValueListenableBuilder(
                            valueListenable: bedtimeReminderSwitch,
                            builder: (context, valueSwitch, _) {
                              return Transform.scale(
                                  scale: 0.9,
                                  child: Switch(
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    onChanged: (value) {
                                      bedtimeReminderSwitch.value = value;
                                    },
                                    value: bedtimeReminderSwitch.value,
                                    activeColor: k1f79f1,
                                    activeTrackColor: k1e346a,
                                    inactiveThumbColor: kFirstPrimaryColor,
                                    inactiveTrackColor: kGreyColor,
                                  ));
                            }),
                      ],
                    ),
                    Text(
                      'Regular bedtime helps from healthy\nsleep habits',
                      style: TextStyleConstant.textTextStyle
                          .copyWith(fontSize: 13, color: k8f8b9a),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    SizedBox(
                        child: ValueListenableBuilder<bool>(
                      valueListenable: bedtimeReminderSwitch,
                      builder: (context, switchValue,_){
                        return ImageFiltered(
                          enabled: !bedtimeReminderSwitch.value,
                          imageFilter: ImageFilter.blur(
                              sigmaX: 2, sigmaY: 2, tileMode: TileMode.decal),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          reminderTime.value = !reminderTime.value;
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Reminder Time',
                                              style: TextStyleConstant
                                                  .songTitleTextStyle,
                                            ),
                                            SvgPicture.asset(reminderTime.value
                                                ? IconPaths.icUp
                                                : IconPaths.icDown),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      ValueListenableBuilder(
                                          valueListenable: timeOfDay,
                                          builder: (context, time, _) {
                                            return Text(
                                              '${timeOfDay.value.hour.toString()}:${timeOfDay.value.minute.toString()}',
                                              style: TextStyleConstant.textTextStyle
                                                  .copyWith(
                                                  fontSize: 13, color: k8f8b9a),
                                            );
                                          }),
                                      ValueListenableBuilder<bool>(
                                        valueListenable: reminderTime,
                                        builder: (context, reminderValue, _) {
                                          return AnimatedContainer(
                                            duration:
                                            const Duration(milliseconds: 500),
                                            child: reminderTime.value
                                                ? TimerPickerSpinnerWidget(
                                              onCancelClick: () {
                                                reminderTime.value = false;
                                                timeOfDay.value =
                                                const TimeOfDay(
                                                    hour: 21, minute: 30);
                                              },
                                              onConfirmClick: (dateTime) {
                                                timeOfDay.value = TimeOfDay(
                                                    hour: dateTime.hour,
                                                    minute: dateTime.minute);
                                                reminderTime.value = false;
                                              },
                                            )
                                                : const SizedBox(),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                ],
                              ),
                              Text(
                                'Repeat',
                                style: TextStyleConstant.songTitleTextStyle,
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                    7,
                                        (index) => GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          listOfDays[index].onCheck =
                                          !listOfDays[index].onCheck;
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: listOfDays[index].onCheck
                                                ? k293379
                                                : k7F65F0,
                                            width: 1,
                                          ),
                                          color: listOfDays[index].onCheck
                                              ? k293379
                                              : k5C40DF,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            listOfDays[index].shortName,
                                            style: TextStyleConstant
                                                .songTitleTextStyle
                                                .copyWith(
                                              color: listOfDays[index].onCheck
                                                  ? k70679A
                                                  : kFFFFFF,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        );
                      },
                    ),),
                  ],
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () async {
                  await appCache.setReminder(
                      '${timeOfDay.value.hour.toString()}:${timeOfDay.value.minute.toString()}');
                  await appCache.enableReminder(bedtimeReminderSwitch.value);
                  for (var element in listOfDays) {
                    await appCache.enableReminderFor(
                        element.fullName, element.onCheck);
                  }
                  await setUpReminder();
                  if (appCache.isFirstLaunch()) {
                    appCache.setIsFirstLaunch(false);
                    getIt<NavigationService>().navigateToAndRemoveUntil(
                      MainScreen.routePath,
                      (Route<void> route) => false,
                    );
                  } else {
                    getIt<NavigationService>().pop();
                  }
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
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Submit',
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> setUpReminder() async {
    // if (!appCache.isEnableReminder()) {
    //   await notificationService.cancelScheduledNotifications();
    //   return;
    // } else {
    //   final daysChecked = listOfDays.where((element) => element.onCheck);
    //   await notificationService.cancelScheduledNotifications();
    //   for (var element in daysChecked) {
    //     await notificationService.createReminderNotification(
    //         NotificationWeekAndTime(
    //             dayOfTheWeek: element.weekDay,
    //             timeOfDay: timeOfDay ?? const TimeOfDay(hour: 21, minute: 30)));
    //   }
    // }
  }
}

class ListOfDayModel {
  String shortName;
  String fullName;
  int weekDay;
  bool onCheck;

  ListOfDayModel(this.shortName, this.fullName, this.weekDay, this.onCheck);
}
