import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/presentation/base/base_stateful_widget.dart';
import 'package:rain_sounds/presentation/screens/sounds/sound_group_page.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_bloc.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_state.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';

class SoundsScreen extends StatefulWidget {
  const SoundsScreen({Key? key}) : super(key: key);

  @override
  State<SoundsScreen> createState() => _SoundsScreenState();
}

class _SoundsScreenState extends State<SoundsScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final SoundsBloc _bloc = getIt<SoundsBloc>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(ImagePaths.background_sounds_screen),
                  fit: BoxFit.fill)),
          child: BlocBuilder<SoundsBloc, SoundsState>(
              bloc: _bloc,
              builder: (BuildContext context, SoundsState state) {
                final totalPage = (state.sounds!.length / 9).round();
                print('totalPage: $totalPage');
                var lists = List.generate(
                    totalPage,
                    (i) => state.sounds?.sublist(
                        totalPage * i,
                        (i + 1) * totalPage <= state.sounds!.length
                            ? (i + 1) * totalPage
                            : null));
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 32,
                    ),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'Rain Sounds - Sleep Sounds',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        )),
                    Expanded(
                      child: PageView.builder(
                          itemCount: totalPage,
                          itemBuilder: (BuildContext context, int index) {
                            return SoundGroupPage(sounds: lists[index] ?? List.empty(), soundsBloc: _bloc,);
                          }),
                    ),
                    DotsIndicator(
                      dotsCount: 7,
                      position: _selectedIndex.toDouble(),
                      decorator: const DotsDecorator(
                        color: Colors.white30, // Inactive color
                        activeColor: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Time'),
                            Text('Play'),
                            Text('Edit')
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }
}
