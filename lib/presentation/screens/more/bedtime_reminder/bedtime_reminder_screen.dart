import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rain_sounds/common/configs/app_cache.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/domain/manager/notification_manager.dart';
import 'package:rain_sounds/presentation/base/base_stateful_widget.dart';
import 'package:rain_sounds/presentation/base/navigation_service.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';
import 'package:rain_sounds/presentation/utils/styles.dart';

class BedTimeReminderScreen extends StatefulWidget {
  const BedTimeReminderScreen({Key? key}) : super(key: key);

  @override
  State<BedTimeReminderScreen> createState() => _BedTimeReminderScreenState();
}

class _BedTimeReminderScreenState extends State<BedTimeReminderScreen> {
  final AppCache appCache = getIt.get();
  final NotificationService notificationService = getIt.get();
  TimeOfDay? timeOfDay;
  DateTime now = DateTime.now();

  final List<ListOfDayModel> listOfDays = [
    ListOfDayModel('S', 'Sun', 7, false),
    ListOfDayModel('M', 'Mon', 1, false),
    ListOfDayModel('T', 'Tues', 2, false),
    ListOfDayModel('W', 'Wed', 3, false),
    ListOfDayModel('T', 'Thus', 4, false),
    ListOfDayModel('F', 'Fri', 5, false),
    ListOfDayModel('SA', 'Sat', 6, false),
  ];

  bool switchValue = false;

  @override
  void initState() {
    super.initState();
    switchValue = appCache.isEnableReminder();
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
      timeOfDay = TimeOfDay(
          hour: int.parse(reminderTime.split(":")[0]),
          minute: int.parse(reminderTime.split(":")[1]));
    } else {
      timeOfDay = const TimeOfDay(hour: 21, minute: 30);
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Container(
      height: h,
      width: w,
      padding: const EdgeInsets.all(16),
      color: k1f172f,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bedtime Reminder',
                  style: TextStyleConstant.titleTextStyle
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
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
                          Transform.scale(
                              scale: 0.9,
                              child: Switch(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                onChanged: (value) {
                                  setState(() {
                                    switchValue = value;
                                  });
                                },
                                value: switchValue,
                                activeColor: k1f79f1,
                                activeTrackColor: k1e346a,
                                inactiveThumbColor: kFirstPrimaryColor,
                                inactiveTrackColor: kGreyColor,
                              )),
                        ],
                      ),
                      Text(
                        'Regular bedtime helps from healthy sleep habits',
                        style: TextStyleConstant.textTextStyle
                            .copyWith(fontSize: 13, color: k8f8b9a),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reminder Time',
                            style: TextStyleConstant.songTitleTextStyle,
                          ),
                          const Icon(
                            Icons.arrow_drop_down_outlined,
                            color: kFirstPrimaryColor,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      InkWell(
                        onTap: () async {
                          timeOfDay = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                now.add(
                                  const Duration(minutes: 1),
                                ),
                              ),
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: ThemeData(
                                    colorScheme: const ColorScheme.light(
                                      primary: Colors.teal,
                                    ),
                                  ),
                                  child: child!,
                                );
                              });
                          setState(() {});
                        },
                        child: Text(
                          timeOfDay != null
                              ? '${timeOfDay?.hour.toString()}:${timeOfDay?.minute.toString()}'
                              : '21:30',
                          style: TextStyleConstant.textTextStyle
                              .copyWith(fontSize: 13, color: k8f8b9a),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
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
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: k1d132b,
                                      gradient: listOfDays[index].onCheck
                                          ? const LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft,
                                              colors: [
                                                k1f7af0,
                                                k505ffa,
                                              ],
                                            )
                                          : null,
                                      shape: listOfDays[index].onCheck
                                          ? BoxShape.circle
                                          : BoxShape.rectangle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        listOfDays[index].shortName,
                                        style: TextStyleConstant
                                            .songTitleTextStyle,
                                      ),
                                    ),
                                  ),
                                )),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Positioned.fill(
              bottom: 40,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: InkWell(
                  onTap: () async {
                    await appCache.setReminder(
                        '${timeOfDay?.hour.toString()}:${timeOfDay?.minute.toString()}');
                    await appCache.enableReminder(switchValue);
                    for (var element in listOfDays) {
                      await appCache.enableReminderFor(
                          element.fullName, element.onCheck);
                    }
                    await setUpReminder();
                    getIt<NavigationService>().pop();
                  },
                  child: SvgPicture.asset(
                    IconPaths.icChecked,
                    height: 80,
                    width: 80,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> setUpReminder() async {
    if (!appCache.isEnableReminder()) {
      await notificationService.cancelScheduledNotifications();
      return;
    }

    final daysChecked = listOfDays.where((element) => element.onCheck);
    await notificationService.cancelScheduledNotifications();
    for (var element in daysChecked) {
      notificationService.createReminderNotification(NotificationWeekAndTime(
          dayOfTheWeek: element.weekDay,
          timeOfDay: timeOfDay ?? const TimeOfDay(hour: 21, minute: 30)));
    }
  }
}

class ListOfDayModel {
  String shortName;
  String fullName;
  int weekDay;
  bool onCheck;

  ListOfDayModel(this.shortName, this.fullName, this.weekDay, this.onCheck);
}
