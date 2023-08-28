import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rain_sounds/presentation/utils/styles.dart';

class MoreItemWidget extends StatelessWidget {
  const MoreItemWidget({
    Key? key,
    required this.iconSvg,
    required this.titleItem,
    this.tailingText,
    this.isLast, this.onTap, this.tailingIcon, this.tailingIconSvg,
  }) : super(key: key);
  final String iconSvg;
  final String titleItem;
  final String? tailingText;
  final bool? tailingIcon;
  final String? tailingIconSvg;
  final bool? isLast;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
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
              (tailingText != null && tailingIcon == false)
                ? Text(
                  tailingText ?? '',
                  style: TextStyleConstant.songTitleTextStyle,
                ) : SvgPicture.asset(tailingIconSvg??''),
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
            height: 20,
          ),
        ],
      ),
    );
  }
}
