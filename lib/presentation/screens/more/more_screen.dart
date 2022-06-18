import 'package:flutter/material.dart';
import 'package:rain_sounds/data/local/model/more.dart';
import 'package:rain_sounds/presentation/base/base_stateful_widget.dart';
import 'package:rain_sounds/presentation/screens/more/widget/more_item_widget.dart';
import 'package:rain_sounds/presentation/screens/more/widget/premium_item_widget.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/styles.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  List<ItemMoreModel> listItem = [
    ItemMoreModel(IconPaths.icBedReminder, 'Bedtime Reminder', true, false),
    ItemMoreModel(IconPaths.icStar, 'Rate Us 5*', false, false),
    ItemMoreModel(IconPaths.icFeedBack, 'Feedback', false, false),
    ItemMoreModel(IconPaths.icShareApp, 'Share App', false, false),
    ItemMoreModel(IconPaths.icWarn, 'Privacy Policy', false, true),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(ImagePaths.background_more_screen),
              fit: BoxFit.fill)),
      child: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Settings',
              style: TextStyleConstant.titleTextStyle
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 32,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const PremiumWidget(),
                    Column(
                      children: List.generate(
                        5,
                        (index) => MoreItemWidget(
                          iconSvg: listItem[index].svgIcon ?? '',
                          titleItem: listItem[index].titleItem ?? '',
                          isTime: listItem[index].isTime,
                          isLast: listItem[index].isLast,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Version 2.3.2',
                      style: TextStyleConstant.songTitleTextStyle
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
