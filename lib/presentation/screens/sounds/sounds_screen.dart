import 'package:badges/badges.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                print(
                    'State changed: ${state.status} - ${state.sounds?.length} - ${state.totalSelected}');
                int totalPage = (state.sounds!.length / 9).round();
                if ((state.sounds!.length / 9).round() <
                    state.sounds!.length / 9) {
                  totalPage = (state.sounds!.length / 9).round() + 1;
                }
                final List<List<Sound>> lists = List.empty(growable: true);
                for (int i = 0; i < totalPage; i++) {
                  int startIndex = i * 9;
                  int endIndex = startIndex + 9;
                  if (endIndex < state.sounds!.length) {
                    var page = state.sounds?.sublist(startIndex, endIndex) ??
                        List.empty();
                    lists.add(page);
                  } else {
                    var page = state.sounds
                            ?.sublist(startIndex, state.sounds!.length) ??
                        List.empty();
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
                      height: 16,
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
                            return SoundGroupPage(
                              sounds: lists[index],
                              soundsBloc: _bloc,
                            );
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
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            buildSetTimeButton(),
                            buildPlayButton(state.isPlaying ?? false),
                            buildSelectedButton(state.totalSelected ?? 0)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }

  Container buildPlayButton(bool isPlaying) {
    return Container(
      width: 160,
      height: 36,
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: isPlaying
          ? SvgPicture.asset(IconPaths.ic_pause)
          : SvgPicture.asset(IconPaths.ic_play),
    );
  }

  Widget buildSelectedButton(int totalSelected) {
    return Column(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Badge(
            showBadge: true,
            position: BadgePosition.topEnd(end: -14),
            badgeContent: Text(
              totalSelected.toString(),
              style: TextStyle(color: Colors.white),
            ),
            badgeColor: Colors.blueAccent,
            child: SvgPicture.asset(
              IconPaths.ic_sound,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        const Text(
          'Selected',
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }

  Widget buildSetTimeButton() {
    return Column(
      children: [
        SizedBox(
            height: 24,
            width: 24,
            child: SvgPicture.asset(
              IconPaths.ic_set_time,
              color: Colors.white,
            )),
        const SizedBox(
          height: 4,
        ),
        const Text(
          '30:00',
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }
}
