import 'package:badges/badges.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/data/local/model/sound.dart';
import 'package:rain_sounds/domain/manager/playback_timer.dart';
import 'package:rain_sounds/presentation/base/base_stateful_widget.dart';
import 'package:rain_sounds/presentation/base/navigation_service.dart';
import 'package:rain_sounds/presentation/screens/custom_selected_sound/selected_sounds_screen.dart';
import 'package:rain_sounds/presentation/screens/set_timer/set_timer_screen.dart';
import 'package:rain_sounds/presentation/screens/sounds/sound_group_page.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_bloc.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_event.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_state.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/duration_util.dart';

class SoundsScreen extends StatefulWidget {
  const SoundsScreen({Key? key}) : super(key: key);

  @override
  State<SoundsScreen> createState() => _SoundsScreenState();
}

class _SoundsScreenState extends State<SoundsScreen> {
  int _selectedIndex = 0;
  final SoundsBloc _soundsBloc = getIt<SoundsBloc>();
  final PlaybackTimer _timerController = getIt<PlaybackTimer>();

  @override
  void dispose() {
    print('Sound screen dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(ImagePaths.bgSoundsScreen),
                fit: BoxFit.fill)),
        child: BlocBuilder<SoundsBloc, SoundsState>(
            bloc: _soundsBloc,
            builder: (BuildContext context, SoundsState state) {
              print(
                  'State changed: ${state.status}} - isPlaying ${state.isPlaying}');
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
              return SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 16,
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
                              soundsBloc: _soundsBloc,
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
                      height: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            buildSetTimeButton(),
                            PlayingButton(
                              isPlaying: state.isPlaying ?? false,
                              onTap: () {
                                _soundsBloc.add(ToggleSoundsEvent());
                              },
                            ),
                            buildSelectedButton(state.totalSelected ?? 0)
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }

  void refreshData() {
    _soundsBloc.add(RefreshEvent());
  }

  void onGoBack(dynamic value) {
    refreshData();
  }

  void navigateSelectedSoundsScreen() {
    Route route = MaterialPageRoute(builder: (context) =>  SelectedSoundsScreen(
      soundsBloc: _soundsBloc,
    ));
    Navigator.push(context, route).then(onGoBack);
  }

  Widget buildSelectedButton(int totalSelected) {
    return InkWell(
      onTap: () {
        if (_soundsBloc.soundService.totalActiveSound > 0) {
          navigateSelectedSoundsScreen();
        } else {
          Fluttertoast.showToast(
              msg: "Choose a sound to create a custom",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      },
      child: Column(
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: Badge(
              showBadge: true,
              position: BadgePosition.topEnd(end: -14),
              badgeContent: Text(
                totalSelected.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              badgeColor: Colors.blueAccent,
              child: SvgPicture.asset(
                IconPaths.icSound,
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
      ),
    );
  }

  Widget buildSetTimeButton() {
    return InkWell(
      onTap: () {
        getIt<NavigationService>().navigateToScreen(screen: SetTimerScreen());
      },
      child: AnimatedBuilder(
          animation: _timerController,
          builder: (context, child) {
            return Column(
              children: [
                SizedBox(
                    height: 24,
                    width: 24,
                    child: SvgPicture.asset(
                      IconPaths.icSetTime,
                      color: Colors.white,
                    )),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  formatHHMMSS(_timerController.remainingTime),
                  style: const TextStyle(color: Colors.white),
                )
              ],
            );
          }),
    );
  }
}

class PlayingButton extends StatelessWidget {
  const PlayingButton({
    Key? key,
    required this.isPlaying,
    required this.onTap,
  }) : super(key: key);

  final bool isPlaying;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 180,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.white10,
            border: Border.all(
              color: Colors.white,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: isPlaying
            ? SvgPicture.asset(IconPaths.icPause)
            : SvgPicture.asset(IconPaths.icPlay),
      ),
    );
  }
}
