import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rain_sounds/common/configs/app_cache.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/common/utils/ad_helper.dart';
import 'package:rain_sounds/data/local/model/mix.dart';
import 'package:rain_sounds/domain/service/sound_service.dart';
import 'package:rain_sounds/presentation/base/base_stateful_widget.dart';
import 'package:rain_sounds/presentation/base/navigation_service.dart';
import 'package:rain_sounds/presentation/screens/in_app_purchase/in_app_purchase_screen.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/now_mix_playing_screen.dart';
import 'package:rain_sounds/presentation/screens/sleep/sleep_bloc.dart';
import 'package:rain_sounds/presentation/screens/sleep/sleep_event.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';

class CategoryMixPage extends StatelessWidget {
  const CategoryMixPage(
      {Key? key,
      required this.mixes,
      required this.showPremiumBanner,
      required this.sleepBloc})
      : super(key: key);

  final List<Mix> mixes;
  final bool showPremiumBanner;
  final SleepBloc sleepBloc;

  @override
  Widget build(BuildContext context) {
    final listGridTile = mixes
        .map(
          (mix) => StaggeredGridTile.count(
            crossAxisCellCount: 2,
            mainAxisCellCount: 2,
            child: MixItem(
              mix: mix,
              onItemClicked: (mix) {
                sleepBloc.add(SelectMixEvent(mix: mix));
              },
            ),
          ),
        )
        .toList();
    print('listGridTile: ${listGridTile.length}');
    if (showPremiumBanner) {
      listGridTile.insert(
        2,
        StaggeredGridTile.count(
          crossAxisCellCount: 4,
          mainAxisCellCount: 0.9,
          child: InkWell(
            onTap: () {
              getIt<NavigationService>()
                  .navigateToScreen(screen: const InAppPurchaseScreen());
            },
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      kGradientOrangeBtColor,
                      kGradientPurpleBtColor,
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Go Premium',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 20),
                  ),
                  SizedBox(height: 4,),
                  Text(
                    'Unlock all sound and remove ads',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 100),
      child: StaggeredGrid.count(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 28,
        axisDirection: AxisDirection.down,
        children: listGridTile,
      ),
    );
  }
}

class MixItem extends StatefulWidget {
  const MixItem({Key? key, required this.mix, required this.onItemClicked})
      : super(key: key);

  final Mix mix;
  final Function(Mix) onItemClicked;

  @override
  State<MixItem> createState() => _MixItemState();
}

class _MixItemState extends State<MixItem> {
  final AdHelper adHelper = getIt.get();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final AppCache appCache = getIt.get();
    return InkWell(
      onTap: () {
        if (widget.mix.premium == true && !appCache.isPremiumMember()) {
          AdHelper adHelper = getIt.get();
          SoundService soundService = getIt.get();
          showDialog(
              context: context,
              builder: (context) {
                final Size size = MediaQuery.of(context).size;
                return AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  backgroundColor: bgColor,
                  content: SizedBox(
                    width: size.width * 0.9,
                    height: size.height * 0.6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Align(
                              alignment: Alignment.topRight,
                              child: SvgPicture.asset(IconPaths.icClose)),
                        ),
                        const Text(
                          'Unlock for free',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Container(
                          height: size.height * 0.2,
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    '${Assets.baseImagesPath}/${widget.mix.cover?.thumbnail}.webp'),
                                fit: BoxFit.cover),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              widget.mix.name ?? '',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        const Text(
                          'Watch a short video to get this premium mix util close app',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        InkWell(
                          onTap: () {
                            unlockMix(adHelper, soundService, context);
                          },
                          child: Container(
                            height: size.height * 0.075,
                            decoration: const BoxDecoration(
                              color: Colors.brown,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(IconPaths.icPlay),
                                const SizedBox(
                                  width: 12,
                                ),
                                const Text(
                                  'WATCH',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Container(
                            height: size.height * 0.075,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                colors: [
                                  kGradientOrangeBtColor,
                                  kGradientPurpleBtColor,
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            child: InkWell(
                              onTap: () {
                                getIt<NavigationService>().navigateToScreen(
                                    screen: const InAppPurchaseScreen());
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    child: SvgPicture.asset(
                                        IconPaths.icPremiumNoColor),
                                    height: 32,
                                    width: 32,
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  const Text(
                                    'GO PREMIUM',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                );
              });
        } else {
          adHelper.showInterstitialAd(onAdDismissedFullScreenContent: () {
            getIt<NavigationService>()
                .navigateToScreen(screen: NowMixPlayingScreen(mix: widget.mix));
            widget.onItemClicked(widget.mix);
          });
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                height: size.height * 0.185,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            '${Assets.baseImagesPath}/${widget.mix.cover?.thumbnail}.webp'),
                        fit: BoxFit.cover),
                    borderRadius: const BorderRadius.all(Radius.circular(6))),
              ),
              if (widget.mix.premium == true && !appCache.isPremiumMember())
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      IconPaths.icPremium,
                      height: 24,
                      width: 24,
                    ),
                  ),
                )
              else
                const SizedBox()
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            widget.mix.name ?? '',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Future<void> unlockMix(AdHelper adHelper, SoundService soundService,
      BuildContext context) async {
    adHelper.showRewardedAd(onUserRewarded: () async {
      setState(() {
        widget.mix.premium = false;
      });
      await soundService.updateMix(widget.mix.mixSoundId, false);
      Navigator.pop(context);
      getIt<NavigationService>()
          .navigateToScreen(screen: NowMixPlayingScreen(mix: widget.mix));
      widget.onItemClicked(widget.mix);
    }, isLoadingAd: (loading) {
      if (loading) {
        EasyLoading.show(status: 'Loading ads...');
      } else {
        EasyLoading.dismiss();
      }
    });
  }
}
