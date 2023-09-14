import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rain_sounds/common/configs/app_cache.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/common/utils/ad_helper.dart';
import 'package:rain_sounds/presentation/base/base_stateful_widget.dart';
import 'package:rain_sounds/presentation/base/navigation_service.dart';
import 'package:rain_sounds/presentation/screens/more/bedtime_reminder/bedtime_reminder_screen.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';
import 'package:rain_sounds/presentation/utils/styles.dart';
import 'package:url_launcher/url_launcher.dart';

class InAppPurchaseScreen extends StatefulWidget {
  const InAppPurchaseScreen({Key? key}) : super(key: key);

  @override
  State<InAppPurchaseScreen> createState() => _InAppPurchaseScreenState();
}

class _InAppPurchaseScreenState extends State<InAppPurchaseScreen> {
  // final PurchaseService purchaseService = getIt.get();
  final AppCache appCache = getIt.get();
  final AdHelper adHelper = getIt.get();

  List<PurchaseModel> listOfPurchase = [
    PurchaseModel(
      title: 'Monthly',
      text: '3 days trial free',
      price: '',
      isIcon: false,
      color1: k1B8961,
      color2: k40DBC8,
    ),
    PurchaseModel(
      title: 'Yearly',
      text: 'Best seller',
      price: '',
      isIcon: true,
      color1: k891B71,
      color2: kDB40AF,
    ),
    PurchaseModel(
      title: 'Lifetime',
      text: 'Sale off 20%',
      price: '',
      isIcon: false,
      color1: k1B4E89,
      color2: k40ACDB,
    ),
  ];
  int indexChecked = 1;

  @override
  void initState() {
    super.initState();
    // purchaseService.products.listen((iapItems) => {
    //       iapItems.forEach((element) {
    //         print('iapItems: $element');
    //         switch (element.identifier) {
    //           case 'monthly':
    //             listOfPurchase[0].price = element.priceString;
    //             break;
    //           case 'yearly':
    //             listOfPurchase[1].price = element.priceString;
    //             break;
    //           case 'lifetime':
    //             listOfPurchase[2].price = element.priceString;
    //         }
    //       }),
    //       setState(() {})
    //     }
    //     );
  }

  void _handlePurchaseSuccessfully() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
              backgroundColor: k1f172f,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Congratulation! Purchased successfully. Now you can open all sounds and music without advertisements',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  InkWell(
                    onTap: () {
                      if (appCache.isFirstLaunch()) {
                        getIt<NavigationService>().navigateToScreen(
                            screen: const BedTimeReminderScreen());
                      } else {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      }
                    },
                    child: Container(
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
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                            primary: Colors.transparent,
                            shadowColor: Colors.transparent),
                        child: Text(
                          'OK',
                          style: TextStyleConstant.textTextStyle.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  )
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(ImagePaths.bgOnBoarding), fit: BoxFit.fill)),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    if (appCache.isFirstLaunch()) {
                      if (adHelper.isInterstitialAdsReady()) {
                        adHelper.showInterstitialAd(
                            onAdDismissedFullScreenContent: () {
                              getIt<NavigationService>().navigateToScreen(
                                  screen: const BedTimeReminderScreen());
                            }, onAdFailedToLoad: () {
                          getIt<NavigationService>().navigateToScreen(
                              screen: const BedTimeReminderScreen());
                        });
                      } else {
                        getIt<NavigationService>().navigateToScreen(
                            screen: const BedTimeReminderScreen());
                      }
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: SvgPicture.asset(
                    IconPaths.icLeftArrow,
                  ),
                )
              ],
            ),
            Column(
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
            const Spacer(),
            SizedBox(
              width: w,
              child: Padding(
                padding: const EdgeInsets.all(12).copyWith(bottom: 0),
                child: TextButton(
                  onPressed: () async {
                    EasyLoading.show(status: 'Processing purchase');
                    switch (indexChecked) {
                      case 0:
                        // if (await purchaseService.buy('monthly')) {
                        //   _handlePurchaseSuccessfully();
                        // }
                        EasyLoading.dismiss();
                        break;
                      case 1:
                        // if (await purchaseService.buy('yearly')) {
                        //   _handlePurchaseSuccessfully();
                        // }
                        EasyLoading.dismiss();
                        break;
                      case 2:
                        // if (await purchaseService.buy('lifetime')) {
                        //   _handlePurchaseSuccessfully();
                        // }
                        EasyLoading.dismiss();
                        break;
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
                      borderRadius:
                          BorderRadius.all(Radius.circular(100)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 32,
                        child: Text(
                          btText(indexChecked),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Subscription automatically renews after the end of the current period. You will be charged 100,000d. Cancel anytime. You can manage and cancel subscriptions in Setting of Sleep Sounds app or in Google Play',
                style: TextStyleConstant.smallTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            // const Spacer(),
            // Row(
            //   children: [
            //     const Spacer(),
            //     InkWell(
            //       child: const Text(
            //         'Term of Service',
            //         style: TextStyle(color: Colors.white),
            //       ),
            //       onTap: () {
            //         _launchTermOfService();
            //       },
            //     ),
            //     const Text(
            //       ' and ',
            //       style: TextStyle(color: Colors.white54),
            //     ),
            //     InkWell(
            //       child: const Text(
            //         'Privacy Policy',
            //         style: TextStyle(color: Colors.white),
            //       ),
            //       onTap: () {
            //         _launchPrivacy();
            //       },
            //     ),
            //     const Spacer(),
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  void _launchPrivacy() {
    try {
      launchUrl(Uri.parse(
          'https://smarttouch2017.wordpress.com/2022/07/21/rain-sounds-for-sleep/'));
    } catch (ex) {
      print('Launch url error: $ex');
    }
  }

  void _launchTermOfService() {
    try {
      launchUrl(Uri.parse(
          'https://smarttouch2017.wordpress.com/2022/11/11/term-of-service-for-sleep-sounds/'));
    } catch (ex) {
      print('Launch url error: $ex');
    }
  }

  Widget _checkedTitle(String title) {
    return Row(
      children: [
        Text(
          '●',
          style: TextStyleConstant.mediumTextStyle.copyWith(fontSize: 8),
        ),
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
          // padding: EdgeInsets.all(value),
          height: height / 7,
          width: width,
          margin: const EdgeInsets.only(top: 28),
          decoration: BoxDecoration(
            border: Border.all(color: kFFFFFF.withOpacity(0.2)),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            gradient: const LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: <Color>[
                k181E4A,
                k202968,
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(
                width: 16,
              ),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '3 days free trial',
                    style: TextStyle(
                        color: kFFFFFF,
                        fontSize: 13,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    '100,000 vnd',
                    style: TextStyle(
                        color: kFFFFFF,
                        fontSize: 24,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const Spacer(),
              isIcon
                  ? SvgPicture.asset(IconPaths.icCheckedFilled)
                  : SvgPicture.asset(IconPaths.icCheckedEmpty),
              const SizedBox(
                width: 16,
              ),
            ],
          ),
        ),
        Positioned.fill(
          right: 0,
          left: 16,
          top: 8,
          child: Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: 30,
              width: 90,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    color2,
                    color1,
                  ],
                ),
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: kFFFFFF),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String btText(index) {
    const String constString = 'Subscribe for 100,000';
    if (index == 1) {
      return '$constString${listOfPurchase[1].price} ₫/year';
    } else if (index == 0) {
      return '$constString${listOfPurchase[0].price} ₫/month';
    } else {
      return '$constString${listOfPurchase[0].price} ₫/month';
    }
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
