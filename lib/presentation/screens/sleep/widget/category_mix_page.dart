import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
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
            mainAxisCellCount: 2.5,
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
          mainAxisCellCount: 0.8,
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
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Go Premium',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Unlock all sound and remove ads',
                    style: TextStyle(color: Colors.white, fontSize: 14),
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
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
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
                return Dialog(
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                    elevation: 16,
                    child: SingleChildScrollView(
                      child: Container(
                        height: size.height/1.35,
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 24,
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
                              padding: const EdgeInsets.all(32),
                              height: size.width * 0.65,
                              width: size.width * 0.65,
                              alignment: Alignment.bottomCenter,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      '${Assets.baseImagesPath}/${widget.mix.cover?.thumbnail}.webp'),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16)),
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            SizedBox(
                              width: size.width * 0.65,
                              child: const Text(
                                'Watch a short video to get this premium mix util close app',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.all(12).copyWith(bottom: 0),
                              child: TextButton(
                                onPressed: () {
                                  unlockMix(adHelper, soundService, context);
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  side: const BorderSide(
                                    color: k7F65F0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                child: Ink(
                                  padding: EdgeInsets.zero,
                                  decoration:  const BoxDecoration(
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
                                      width: size.width - 32,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(IconPaths.icPlay),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          const Text(
                                            'Watch',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
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
                                  getIt<NavigationService>().navigateToScreen(
                                      screen: const InAppPurchaseScreen());
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  side: const BorderSide(
                                    color: kDEAA21,
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
                                        kDEAA21,
                                        kFFE144,
                                      ],
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(100)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 16),
                                    child: SizedBox(
                                      width: size.width - 32,
                                      child: Text(
                                        'Go Premium',
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
                    ));
              });
        } else {
          getIt<NavigationService>()
              .navigateToScreen(screen: NowMixPlayingScreen(mix: widget.mix));
          widget.onItemClicked(widget.mix);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8).copyWith(bottom: 8),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gradient: LinearGradient(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  height: size.height * 0.215,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            '${Assets.baseImagesPath}/${widget.mix.cover?.thumbnail}.webp'),
                        fit: BoxFit.cover),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                ),
                if (widget.mix.premium == true && !appCache.isPremiumMember())
                  SizedBox(
                    height: size.height * 0.215,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(8)),
                        child: SvgPicture.asset(
                          IconPaths.icCrownBanner,
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox()
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              widget.mix.name ?? '',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
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
