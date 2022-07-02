import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rain_sounds/common/utils/in_app_purchase_helper.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/presentation/base/base_stateful_widget.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';
import 'package:rain_sounds/presentation/utils/styles.dart';

class InAppPurchaseScreen extends StatefulWidget {
  const InAppPurchaseScreen({Key? key}) : super(key: key);

  @override
  State<InAppPurchaseScreen> createState() => _InAppPurchaseScreenState();
}

class _InAppPurchaseScreenState extends State<InAppPurchaseScreen> {
  final IAPHelper iapHelper = getIt.get();

  List<PurchaseModel> listOfPurchase = [
    PurchaseModel(
      title: 'Monthly',
      text: '3 days trial free',
      price: '91.000 ₫',
      isIcon: false,
      color1: k5f5490,
      color2: k4b3fad,
    ),
    PurchaseModel(
      title: 'Yearly',
      text: 'Best seller',
      price: '295.000 ₫',
      isIcon: true,
      color1: k7d7b88,
      color2: k893c82,
    ),
    PurchaseModel(
      title: 'Lifetime',
      text: 'Sale off 20%',
      price: '567.000 ₫',
      isIcon: false,
      color1: k795ec8,
      color2: k299ac6,
    ),
  ];
  int indexChecked = 1;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(ImagePaths.bgPremium), fit: BoxFit.fill)),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      IconPaths.icClose,
                      height: 30,
                      width: 30,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _checkedTitle('Unlock all sounds'),
                      const SizedBox(
                        height: 16,
                      ),
                      _checkedTitle('Remove ads'),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _checkedTitle('Unlock all music'),
                      const SizedBox(
                        height: 16,
                      ),
                      _checkedTitle('Constantly update'),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 32,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(3, (index) {
                  final indexPurchase = listOfPurchase[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        indexChecked = index;
                        if (!indexPurchase.isIcon) {
                          indexPurchase.isIcon = true;
                          for (final purchase in listOfPurchase) {
                            if (purchase != indexPurchase) {
                              purchase.isIcon = false;
                            }
                          }
                        }
                      });
                    },
                    child: _priceContainer(
                      index: index,
                      height: h,
                      width: w,
                      title: indexPurchase.title,
                      text: indexPurchase.text,
                      price: indexPurchase.price,
                      isIcon: indexPurchase.isIcon,
                      color1: indexPurchase.color1,
                      color2: indexPurchase.color2,
                    ),
                  );
                }),
              ),
              const SizedBox(
                height: 32,
              ),
              Text(
                feeText(indexChecked),
                style: TextStyleConstant.normalTextStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              SizedBox(
                width: w,
                child: TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: const BorderSide(color: kb62f69))),
                    backgroundColor: MaterialStateProperty.all<Color>(kb62f69),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: InkWell(
                      onTap: () {
                        switch (indexChecked) {
                          case 0:
                            iapHelper.buy(monthly);
                            break;
                          case 1:
                            iapHelper.buy(yearly);
                            break;
                          case 2:
                            iapHelper.buy(lifetime);
                            break;
                        }
                      },
                      child: Text(
                        btText(indexChecked),
                        style: TextStyleConstant.normalTextStyle,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                feeTextSub(indexChecked),
                style: TextStyleConstant.smallTextStyle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _checkedTitle(String title) {
    return Row(
      children: [
        SvgPicture.asset(IconPaths.icCheckedGreen),
        const SizedBox(
          width: 5,
        ),
        Text(
          title,
          style: TextStyleConstant.mediumTextStyle,
        ),
      ],
    );
  }

  Widget _priceContainer(
      {required double height,
        required double width,
        required String title,
        required String text,
        required String price,
        required bool isIcon,
        required Color color1,
        required Color color2,
        required int index}) {
    return Stack(
      children: [
        Container(
          height: isIcon ? height / 3.9 : height / 4.4,
          width: isIcon ? width / 3.6 : width / 3.5,
          margin: index == 1
              ? const EdgeInsets.symmetric(horizontal: 8).copyWith(top: 12)
              : const EdgeInsets.only(top: 12),
          decoration: BoxDecoration(
              border: Border.all(color: kFirstPrimaryColor),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  color1,
                  color2,
                ],
              )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 24,
              ),
              Text(
                text,
                style: const TextStyle(
                    color: kf9d136,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 32,
              ),
              Text(
                price,
                style: const TextStyle(
                    color: k78f721, fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 28,
              ),
              isIcon
                  ? SvgPicture.asset(IconPaths.icSelectBlue)
                  : const SizedBox(),
            ],
          ),
        ),
        Positioned.fill(
          right: 0,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 22,
              width: 70,
              decoration: const BoxDecoration(
                color: kFirstPrimaryColor,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

String feeText(index) {
  const String constString = 'Try 3 days free and then ';
  if (index == 1) {
    return constString + '295.000 ₫/year';
  } else if (index == 0) {
    return constString + '91.000 ₫/month';
  } else {
    return 'Enjoy a Lifetime Subscription at 567.000 ₫';
  }
}

String btText(index) {
  const String constString = 'Subscribe for ';
  if (index == 1) {
    return constString + '295.000 ₫/year';
  } else if (index == 0) {
    return constString + '91.000 ₫/month';
  } else {
    return 'Buy now';
  }
}

String feeTextSub(index) {
  if (index == 1) {
    return 'Subscription automatically renews after the end of the current period. You will be charged 295.000 ₫. Cancel anytime. You can manage and cancel subscriptions in Setting of Sleep Sounds app or in Google Play.';
  } else if (index == 0) {
    return 'Subscription automatically renews after the end of the current period. You will be charged 91.000 ₫. Cancel anytime. You can manage and cancel subscriptions in Setting of Sleep Sounds app or in Google Play.';
  } else {
    return '';
  }
}

class PurchaseModel {
  String title;
  String text;
  String price;

  Color color1;
  Color color2;
  bool isIcon;

  PurchaseModel(
      {required this.title,
      required this.text,
      required this.price,
      required this.color1,
      required this.color2,
      required this.isIcon});
}
