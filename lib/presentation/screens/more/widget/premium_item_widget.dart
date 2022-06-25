import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/presentation/base/navigation_service.dart';
import 'package:rain_sounds/presentation/screens/in_app_purchase/in_app_purchase_screen.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';
import 'package:rain_sounds/presentation/utils/styles.dart';

class PremiumWidget extends StatelessWidget {
  const PremiumWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        getIt<NavigationService>()
            .navigateToScreen(screen: const InAppPurchaseScreen());
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    IconPaths.icPremiumNoColor,
                    height: 24,
                    width: 24,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upgrade Premium',
                        style: TextStyleConstant.songTitleTextStyle,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Unlock all sounds and remove ads',
                        style: TextStyleConstant.textTextStyle
                            .copyWith(fontSize: 13),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 32,
                        width: 148,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                kGradientOrangeBtColor,
                                kGradientPurpleBtColor,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(36)),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              shadowColor: Colors.transparent),
                          child: Text(
                            'Go Premium',
                            style: TextStyleConstant.textTextStyle.copyWith(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          const Divider(
            color: kDividerColor,
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
