import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rain_sounds/common/configs/app_cache.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/common/utils/ad_helper.dart';
import 'package:rain_sounds/data/remote/model/music_model.dart';
import 'package:rain_sounds/presentation/base/navigation_service.dart';
import 'package:rain_sounds/presentation/screens/in_app_purchase/in_app_purchase_screen.dart';
import 'package:rain_sounds/presentation/screens/playing/music/now_playing_screen.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';
import 'package:rain_sounds/presentation/utils/styles.dart';

class GridMusicWidget extends StatelessWidget {
  GridMusicWidget({
    Key? key,
    this.listMusic,
  }) : super(key: key);
  final List<MusicModel>? listMusic;
  final AdHelper adHelper = getIt.get();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final AppCache appCache = getIt.get();
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 8,
      crossAxisSpacing: 16,
      childAspectRatio: 0.9,
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: List.generate(
        listMusic?.length ?? 1,
        (index) {
          final musicItem = listMusic?[index];
          return Container(
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
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    if (musicItem?.premium == true && !appCache.isPremiumMember()) {
                      getIt<NavigationService>()
                          .navigateToScreen(screen: const InAppPurchaseScreen());
                    } else {
                      getIt<NavigationService>().navigateToScreen(
                          screen: NowPlayingScreen(
                              musicModel: musicItem ?? MusicModel()));
                      // adHelper.showInterstitialAd(onAdDismissedFullScreenContent: () {
                      //   getIt<NavigationService>().navigateToScreen(
                      //       screen: NowPlayingScreen(
                      //           musicModel: musicItem ?? MusicModel()));
                      // }, onAdFailedToLoad: () {
                      //   getIt<NavigationService>().navigateToScreen(
                      //       screen: NowPlayingScreen(
                      //           musicModel: musicItem ?? MusicModel()));
                      // });
                    }
                  },
                  child: Container(
                    height: size.height * 0.165,
                    // width: size.width * 0.5,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                musicItem?.background ?? ''),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        musicItem?.badge != ""
                            ? Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        kGradientPurpleColor,
                                        kGradientOrangeColor,
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(6)),
                                child: Text(
                                  '${musicItem?.badge}',
                                  style: TextStyleConstant.iconTextStyle,
                                ),
                              )
                            : const SizedBox(),
                        musicItem?.premium == true && !appCache.isPremiumMember()
                            ? SvgPicture.asset(
                                IconPaths.icPremium,
                                height: 24,
                                width: 24,
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '${musicItem?.title}',
                    style: TextStyleConstant.songTitleTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
