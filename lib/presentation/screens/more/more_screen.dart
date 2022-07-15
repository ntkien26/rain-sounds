import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:rain_sounds/common/configs/app_cache.dart';
import 'package:rain_sounds/common/injector/network_di.dart';
import 'package:rain_sounds/data/local/model/more.dart';
import 'package:rain_sounds/presentation/base/base_stateful_widget.dart';
import 'package:rain_sounds/presentation/screens/more/bedtime_reminder/bedtime_reminder_screen.dart';
import 'package:rain_sounds/presentation/screens/more/widget/more_item_widget.dart';
import 'package:rain_sounds/presentation/screens/more/widget/premium_item_widget.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/styles.dart';
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
  ];

  final AppCache appCache = getIt.get();

  @override
  void initState() {
    super.initState();
    FlutterInappPurchase.purchaseUpdated.listen(_handlePurchaseUpdate);
  }

  /// Called when new updates arrives at ``purchaseUpdated`` stream
  void _handlePurchaseUpdate(PurchasedItem? productItem) async {
    if (productItem != null) {
      switch (productItem.transactionStateIOS) {
        case TransactionState.deferred:
          break;
        case TransactionState.failed:
          break;
        case TransactionState.purchased:
          setState(() {});
          break;
        case TransactionState.purchasing:
          break;
        case TransactionState.restored:
          break;
        default:
          break;
      }
    }
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
                    Column(
                      children: List.generate(
                        5,
                        (index) => MoreItemWidget(
                          iconSvg: listItem[index].svgIcon ?? '',
                          titleItem: listItem[index].titleItem ?? '',
                          tailingText: listItem[index].tailingText,
                          isLast: listItem[index].isLast,
                          onTap: () async {
                            if (index == 0) {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const BedTimeReminderScreen()))
                                  .then((value) => {setState(() {})});
                            } else if (index == 2) {
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
                                  'subject': 'Feedback to Sound Sleeps',
                                }),
                              );
                              print('Launch url');
                              try {
                                final isLaunched = await launchUrl(emailLaunchUri);
                                print('Launch $isLaunched');
                              } catch (ex) {
                                print('Launch url error: ${ex}');
                              }
                            }
                          },
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

  @override
  bool get wantKeepAlive => true;
}
