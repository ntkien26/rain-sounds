import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rain_sounds/presentation/utils/styles.dart';

class MoreItemWidget extends StatelessWidget {
  const MoreItemWidget({
    Key? key,
    required this.iconSvg,
    required this.titleItem,
    this.isTime,
    this.isLast,
  }) : super(key: key);
  final String iconSvg;
  final String titleItem;
  final bool? isTime;
  final bool? isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  iconSvg,
                  height: 24,
                  width: 24,
                ),
                const SizedBox(
                  width: 16,
                ),
                Text(
                  titleItem,
                  style: TextStyleConstant.songTitleTextStyle,
                )
              ],
            ),
            isTime == true
                ? Text(
                    '21:30',
                    style: TextStyleConstant.songTitleTextStyle,
                  )
                : const SizedBox(),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        isLast == false
            ? const Divider(
                color: Color(0xff512944),
              )
            : const SizedBox(),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}