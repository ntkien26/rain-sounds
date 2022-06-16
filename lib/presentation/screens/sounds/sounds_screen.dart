import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/data/local/model/sound.dart';
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
                print('length: ${state.sounds!.length} totalPage: $totalPage');
                final List<List<Sound>> lists = List.empty(growable: true);
                for (int i = 0; i < totalPage; i++) {
                  int startIndex = i * 9 ;
                  int endIndex = startIndex + 9;
                  if (endIndex < state.sounds!.length) {
                    var page = state.sounds?.sublist(startIndex, endIndex) ?? List.empty();
                    lists.add(page);
                  } else {
                    var page = state.sounds?.sublist(startIndex, state.sounds!.length) ?? List.empty();
                    lists.add(page);
                  }
                }
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
                    const SizedBox(
                      height: 36,
                    ),
                    Expanded(
                      child: PageView.builder(
                          itemCount: totalPage,
                          onPageChanged: (page) {
                            setState(() {
                              _selectedIndex = page;
                            });
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return SoundGroupPage(sounds: lists[index], soundsBloc: _bloc,);
                          }),
                    ),
                    DotsIndicator(
                      dotsCount: totalPage,
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
