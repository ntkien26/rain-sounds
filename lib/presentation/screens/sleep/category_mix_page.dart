import 'package:flutter_svg/flutter_svg.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/data/local/model/mix.dart';
import 'package:rain_sounds/presentation/base/base_stateful_widget.dart';
import 'package:rain_sounds/presentation/base/navigation_service.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/now_mix_playing_screen.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';

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
        getIt<NavigationService>()
            .navigateToScreen(screen: NowMixPlayingScreen(mix: mix));
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
