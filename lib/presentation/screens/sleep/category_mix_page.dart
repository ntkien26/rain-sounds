import 'package:rain_sounds/data/local/model/mix.dart';
import 'package:rain_sounds/presentation/base/base_stateful_widget.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';

class CategoryMixPage extends StatelessWidget {
  const CategoryMixPage({Key? key, required this.mixes}) : super(key: key);

  final List<Mix> mixes;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 5,
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size.width * 0.4,
          height: size.width * 0.4,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      '${Assets.baseImagesPath}/${mix.cover?.thumbnail}.webp')),
              borderRadius: const BorderRadius.all(Radius.circular(8))),
        ),
        const SizedBox(height: 8,),
        Text(
          mix.name ?? '',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        )
      ],
    );
  }
}
