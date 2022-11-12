import 'package:flutter/material.dart';
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
import 'package:rain_sounds/presentation/utils/styles.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen>
    with AutomaticKeepAliveClientMixin {
  List<ItemMoreModel> listItem = [
    ItemMoreModel(IconPaths.icBedReminder, 'Bedtime Reminder', '', false),
    ItemMoreModel(IconPaths.icStar, 'Rate Us 5*', '', false),
    ItemMoreModel(IconPaths.icFeedBack, 'Feedback', '', false),
    ItemMoreModel(IconPaths.icShareApp, 'Share App', '', false),
    ItemMoreModel(IconPaths.icWarn, 'Privacy Policy', '', true),
    ItemMoreModel(IconPaths.icWarn, 'Term of Service', '', true),
  ];

  final AppCache appCache = getIt.get();
  final PurchaseService purchaseService = getIt.get();

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
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(ImagePaths.bgMoreScreen), fit: BoxFit.fill)),
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
                    appCache.isPremiumMember()
                        ? const SizedBox()
                        : const PremiumWidget(),
                    const SizedBox(height: 32,),
                    Column(
                      children: List.generate(
                        6,
                        (index) => MoreItemWidget(
                          iconSvg: listItem[index].svgIcon ?? '',
                          titleItem: listItem[index].titleItem ?? '',
                          tailingText: listItem[index].tailingText,
                          isLast: listItem[index].isLast,
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
                                Share.share('https://apps.apple.com/vn/app/id$_appID');
                                break;
                              case 4:
                                _launchPrivacy();
                                break;
                              case 5:
                                _launchTermOfService();
                                break;
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    FutureBuilder(
                        future: PackageInfo.fromPlatform(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            PackageInfo packageInfo =  snapshot.data as PackageInfo;
                            String version = packageInfo.version;
                            String buildNumber = packageInfo.buildNumber;
                            return Text(
                              'Version $version build $buildNumber',
                              style: TextStyleConstant.songTitleTextStyle
                                  .copyWith(fontWeight: FontWeight.w600),
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
      path: 'hopnv.1611@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Feedback to Sound Sleeps IOS',
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

  void _launchAppStore() {
    try {
      launchUrl(Uri.parse(
          'https://apps.apple.com/vn/app/id$_appID'));
    } catch (ex) {
      print('Launch url error: $ex');
    }
  }
}
