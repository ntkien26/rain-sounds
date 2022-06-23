import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rain_sounds/presentation/base/base_stateful_widget.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';
import 'package:rain_sounds/presentation/utils/styles.dart';

class BedTimeReminderScreen extends StatefulWidget {
  const BedTimeReminderScreen({Key? key}) : super(key: key);

  @override
  State<BedTimeReminderScreen> createState() => _BedTimeReminderScreenState();
}

final List<ListOfDayModel> listOfDays = [
  ListOfDayModel('S', false),
  ListOfDayModel('M', false),
  ListOfDayModel('T', false),
  ListOfDayModel('W', false),
  ListOfDayModel('T', false),
  ListOfDayModel('F', false),
  ListOfDayModel('SA', false),
];
bool switchValue = false;

class _BedTimeReminderScreenState extends State<BedTimeReminderScreen> {
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
                                    switchValue = value;                                  });
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
                      Text(
                        '21:30',
                        style: TextStyleConstant.textTextStyle
                            .copyWith(fontSize: 13, color: k8f8b9a),
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
                                        listOfDays[index].days,
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
                child: SvgPicture.asset(
                  IconPaths.icChecked,
                  height: 80,
                  width: 80,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListOfDayModel {
  String days;
  bool onCheck;

  ListOfDayModel(this.days, this.onCheck);
}