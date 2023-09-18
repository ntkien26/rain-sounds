import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rain_sounds/common/configs/app_cache.dart';
import 'package:rain_sounds/common/injector/network_di.dart';
import 'package:rain_sounds/data/local/model/more.dart';
import 'package:rain_sounds/domain/iap/purchase_service.dart';
import 'package:rain_sounds/presentation/base/base_stateful_widget.dart';
import 'package:rain_sounds/presentation/screens/more/bedtime_reminder/bedtime_reminder_screen.dart';
import 'package:rain_sounds/presentation/screens/more/widget/more_item_widget.dart';
import 'package:rain_sounds/presentation/screens/more/widget/premium_item_widget.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';
import 'package:rain_sounds/presentation/utils/styles.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen>
    with AutomaticKeepAliveClientMixin {
  List<ItemMoreModel> listItem = [
    ItemMoreModel(IconPaths.icBedTimeReminderNew, 'Bedtime Reminder', '', '',
        false, false),
    ItemMoreModel(IconPaths.icStarRate, 'Rate Us 5*', '',
        IconPaths.icRightArrow, true, false),
    ItemMoreModel(IconPaths.icFeedbackNew, 'Feedback', '',
        IconPaths.icRightArrow, true, false),
    ItemMoreModel(IconPaths.icShareNew, 'Share App', '', IconPaths.icRightArrow,
        true, true),
    // ItemMoreModel(IconPaths.icPrivacy, 'Privacy Policy', '',
    //     IconPaths.icRightArrow, true, true),
    // ItemMoreModel(IconPaths.icWarn, 'Term of Service', '', true),
  ];

  final AppCache appCache = getIt.get();
  final PurchaseService purchaseService = getIt.get();
  ValueNotifier<double> starRating = ValueNotifier(3);

  static const _appID = 1631507315;

  @override
  void initState() {
    super.initState();
    purchaseService.purchaseUpdated.listen((updated) {
      if (updated) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final reminderTime = appCache.getReminder();
    if (reminderTime != null) {
      listItem[0].tailingText =
          '${int.parse(reminderTime.split(":")[0])}:${int.parse(reminderTime.split(":")[1])}';
    } else {
      listItem[0].tailingText = '21:30';
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(ImagePaths.bgHome), fit: BoxFit.fill)),
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'App name title',
                    style: TextStyleConstant.titleTextStyle
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  SvgPicture.asset(IconPaths.icCrown)
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // appCache.isPremiumMember()
                      //     ? const SizedBox()
                      //     : const PremiumWidget(),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
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
                          children: List.generate(
                            4,
                            (index) => MoreItemWidget(
                              iconSvg: listItem[index].svgIcon ?? '',
                              titleItem: listItem[index].titleItem ?? '',
                              tailingText: listItem[index].tailingText,
                              isLast: listItem[index].isLast,
                              tailingIcon: listItem[index].tailingIcon,
                              tailingIconSvg: listItem[index].tailingIconSvg,
                              onTap: () async {
                                switch (index) {
                                  case 0:
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const BedTimeReminderScreen()))
                                        .then((value) => {setState(() {})});
                                    break;
                                  case 1:
                                    _launchAppStore();
                                    break;
                                  case 2:
                                    _launchMail();
                                    break;
                                  case 3:
                                    Share.share(
                                        'https://apps.apple.com/vn/app/id$_appID');
                                    break;
                                  // case 4:
                                  //   _launchPrivacy();
                                  //   break;
                                  // case 5:
                                  //   _launchTermOfService();
                                  //   break;
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      FutureBuilder(
                          future: PackageInfo.fromPlatform(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              PackageInfo packageInfo =
                                  snapshot.data as PackageInfo;
                              String version = packageInfo.version;
                              String buildNumber = packageInfo.buildNumber;
                              return SizedBox(
                                width: double.infinity,
                                child: Text(
                                  'Ver $version',
                                  style: TextStyleConstant.songTitleTextStyle
                                      .copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: k8489B0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            } else {
                              return const SizedBox();
                            }
                          }),
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void _launchMail() {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'chillapp.mobile@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Feedback: Chill Rain Sound',
      }),
    );
    try {
      launchUrl(emailLaunchUri);
    } catch (ex) {
      print('Launch url error: $ex');
    }
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

  void _showDialogThankYou() {
    final heightScreen = MediaQuery.of(context).size.height;
    final widthScreen = MediaQuery.of(context).size.width;
    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: heightScreen / 3,
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
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    "Rating Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Text(
                    "We are grateful that you took the time to leave us a review. Your feedback helps us to improve service for everyone",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextButton(
                    onPressed: () {
                      // widget.onSaveCustomClick(sounds);
                      Navigator.of(context).pop();
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 16),
                        child: SizedBox(
                          width: widthScreen - 32,
                          child: Text(
                            'Done',
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
          );
        });
  }

  void _launchAppStore() {
    showDialog(
        context: context,
        builder: (_) {
          final heightScreen = MediaQuery.of(context).size.height;
          final widthScreen = MediaQuery.of(context).size.width;
          return ValueListenableBuilder<double>(
              valueListenable: starRating,
              builder: (context, value, child) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  elevation: 16,
                  child: SingleChildScrollView(
                    child: Container(
                      height: heightScreen / 1.75,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
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
                        children: [
                          const SizedBox(
                            height: 24,
                          ),
                          const Text(
                            "Rate us",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          RatingBar(
                            initialRating: 2,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            ratingWidget: RatingWidget(
                              full: SvgPicture.asset(
                                IconPaths.icStarFilled,
                                color: kDEAA21,
                              ),
                              half: SvgPicture.asset(
                                IconPaths.icStarFilled,
                                color: kDEAA21,
                              ),
                              empty:
                                  SvgPicture.asset(IconPaths.icStarNotFilled),
                            ),
                            onRatingUpdate: (rating) {
                              starRating.value = rating;
                            },
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: TextFormField(
                              textAlign: TextAlign.left,
                              maxLines: 5,
                              style: const TextStyle(
                                color: k8C8C8C,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                alignLabelWithHint: true,
                                fillColor: Colors.black.withOpacity(0.4),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                labelText:
                                    'Please let us know how can we improve\nourselves?',
                                labelStyle: const TextStyle(
                                  color: k8C8C8C,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.all(12).copyWith(bottom: 0),
                            child: TextButton(
                              onPressed: () {
                                // widget.onSaveCustomClick(sounds);
                                if (starRating.value >= 4.5) {
                                  try {
                                    launchUrl(Uri.parse(
                                        'https://apps.apple.com/vn/app/id$_appID'));
                                  } catch (ex) {
                                    print('Launch url error: $ex');
                                  }
                                } else {
                                  //add dialog
                                  Navigator.pop(context);
                                  _showDialogThankYou();
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
                                    width: widthScreen - 32,
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
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.all(12).copyWith(bottom: 0),
                            child: TextButton(
                              onPressed: () {
                                // widget.onSaveCustomClick(sounds);
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                side: const BorderSide(
                                  color: Colors.white,
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
                                    transform: GradientRotation(5.50),
                                    colors: [
                                      k181E4A,
                                      k202968,
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 16),
                                  child: SizedBox(
                                    width: widthScreen - 32,
                                    child: Text(
                                      'Cancel',
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
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
