import 'package:flutter_svg/flutter_svg.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/data/local/model/mix.dart';
import 'package:rain_sounds/presentation/base/base_stateful_widget.dart';
import 'package:rain_sounds/presentation/base/navigation_service.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/now_mix_playing_screen.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';

class CategoryMixPage extends StatelessWidget {
  const CategoryMixPage({Key? key, required this.mixes}) : super(key: key);

  final List<Mix> mixes;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 16,
        childAspectRatio: 0.9,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: mixes
            .map((e) => MixItem(
                  mix: e,
                ))
            .toList());
  }
}

class MixItem extends StatelessWidget {
  const MixItem({Key? key, required this.mix}) : super(key: key);

  final Mix mix;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        if (mix.premium == true) {
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
                          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
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
                                    '${Assets.baseImagesPath}/${mix.cover?.thumbnail}.webp'),
                                fit: BoxFit.cover),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              mix.name ?? '',
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
                        Container(
                          height: size.height * 0.075,
                          decoration: const BoxDecoration(
                            color: Colors.brown,
                            borderRadius: BorderRadius.all(Radius.circular(12)),
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
                            )),
                      ],
                    ),
                  ),
                );
              });
        } else {
          getIt<NavigationService>()
              .navigateToScreen(screen: NowMixPlayingScreen(mix: mix));
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: size.width * 0.5,
                height: size.width * 0.4,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            '${Assets.baseImagesPath}/${mix.cover?.thumbnail}.webp'),
                        fit: BoxFit.cover),
                    borderRadius: const BorderRadius.all(Radius.circular(6))),
              ),
              if (mix.premium == true)
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
            mix.name ?? '',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          )
        ],
      ),
    );
  }
}
