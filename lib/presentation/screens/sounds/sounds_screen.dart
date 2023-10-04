import 'dart:ui';

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
import 'package:rain_sounds/presentation/base/count_down_timer.dart';
import 'package:rain_sounds/presentation/base/navigation_service.dart';
import 'package:rain_sounds/presentation/screens/custom_selected_sound/save_custom_screen.dart';
import 'package:rain_sounds/presentation/screens/custom_selected_sound/selected_sounds_screen.dart';
import 'package:rain_sounds/presentation/screens/sounds/sound_group_page.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_bloc.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_event.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_state.dart';
import 'package:rain_sounds/presentation/screens/sounds/widget/custom_timer_ambience.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';
import 'package:badges/badges.dart' as badges;
import 'package:rain_sounds/presentation/utils/styles.dart';

class SoundsScreen extends StatefulWidget {
  const SoundsScreen({Key? key}) : super(key: key);

  @override
  State<SoundsScreen> createState() => _SoundsScreenState();
}

class _SoundsScreenState extends State<SoundsScreen> {
  int _selectedIndex = 0;
  final SoundsBloc _soundsBloc = getIt<SoundsBloc>();
  final PlaybackTimer _playbackTimer = getIt<PlaybackTimer>();
  ValueNotifier<bool> isOpenModalBottomSheet = ValueNotifier(false);

  @override
  void dispose() {
    print('Sound screen dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: ValueListenableBuilder<bool>(
          valueListenable: isOpenModalBottomSheet,
          builder: (_, value, widget) {
            return ImageFiltered(
              enabled: isOpenModalBottomSheet.value,
              imageFilter: ImageFilter.blur(
                  sigmaX: 2, sigmaY: 2, tileMode: TileMode.decal),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(ImagePaths.bgHome),
                        fit: BoxFit.fill)),
                child: BlocBuilder<SoundsBloc, SoundsState>(
                    bloc: _soundsBloc,
                    builder: (BuildContext context, SoundsState state) {
                      if (state.status == SoundsStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      print(
                          'State changed: ${state.status}} - isPlaying ${state.isPlaying}');
                      int totalPage = (state.sounds!.length / 9).round();
                      if ((state.sounds!.length / 9).round() <
                          state.sounds!.length / 9) {
                        totalPage = (state.sounds!.length / 9).round() + 1;
                      }
                      final List<List<Sound>> lists =
                          List.empty(growable: true);
                      for (int i = 0; i < totalPage; i++) {
                        int startIndex = i * 9;
                        int endIndex = startIndex + 9;
                        if (endIndex < state.sounds!.length) {
                          var page =
                              state.sounds?.sublist(startIndex, endIndex) ??
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
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Chill Sound',
                                    style: TextStyleConstant.titleTextStyle
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  SvgPicture.asset(IconPaths.icCrown)
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              SizedBox(
                                height: 460,
                                child: PageView.builder(
                                    itemCount: totalPage,
                                    onPageChanged: (page) {
                                      setState(() {
                                        _selectedIndex = page;
                                      });
                                    },
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return SoundGroupPage(
                                        sounds: lists[index],
                                        soundsBloc: _soundsBloc,
                                      );
                                    }),
                              ),
                              const Spacer(),
                              DotsIndicator(
                                dotsCount: totalPage,
                                position: _selectedIndex.toDouble(),
                                decorator: const DotsDecorator(
                                  color: Colors.white30, // Inactive color
                                  activeColor: Colors.white,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 32,
                                  ),
                                  buildSetTimeButton(),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  const Spacer(),
                                  PlayingButton(
                                    isPlaying: state.isPlaying ?? false,
                                    onTap: () {
                                      _soundsBloc.add(ToggleSoundsEvent());
                                    },
                                  ),
                                  const Spacer(),
                                  buildSelectedButton(state.totalSelected ?? 0),
                                  const SizedBox(
                                    width: 24,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 24,
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            );
          }),
    );
  }

  void refreshData() {
    _soundsBloc.add(RefreshEvent());
  }

  void onGoBack(dynamic value) {
    refreshData();
  }

  void navigateSelectedSoundsScreen() {
    Route route = MaterialPageRoute(
        builder: (context) => SelectedSoundsScreen(
              soundsBloc: _soundsBloc,
              onCancelClick: () {}, onSaveCustomClick: (sounds) {  },
            ),
        settings: const RouteSettings(name: SelectedSoundsScreen.routeName));
    Navigator.push(context, route).then(onGoBack);
  }

  Widget buildSelectedButton(int totalSelected) {
    return InkWell(
      onTap: () {
        if (_soundsBloc.soundService.totalActiveSound > 0) {
          // navigateSelectedSoundsScreen();
          isOpenModalBottomSheet.value = true;
          showModalBottomSheet<int>(
            isDismissible: false,
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
              return SelectedSoundsScreen(
                soundsBloc: _soundsBloc,
                onCancelClick: () {
                  Navigator.pop(context);
                  isOpenModalBottomSheet.value = false;
                },
                onSaveCustomClick: (sounds) {
                  isOpenModalBottomSheet.value = false;
                  getIt.get<NavigationService>().navigateToScreen(
                          screen: SaveCustomScreen(
                        sounds: sounds,
                      ));
                },
              );
            },
          );
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
            child: badges.Badge(
              showBadge: true,
              position: BadgePosition.topEnd(end: -14),
              badgeContent: Text(
                totalSelected.toString(),
                style: const TextStyle(color: Colors.white),
              ),
              badgeColor: Colors.blueAccent,
              child: SvgPicture.asset(
                IconPaths.icSelected,
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
          isOpenModalBottomSheet.value = true;
          // await getIt<NavigationService>().navigateToScreen(screen: SetTimerScreen());
          // setState(() {});
          showModalBottomSheet<int>(
            isDismissible: false,
            backgroundColor: Colors.transparent,
            context: context,
            builder: (context) {
              return Container(
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      transform: GradientRotation(5.50),
                      colors: [
                        k202968,
                        k181E4A,
                      ],
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SetCustomAmbience(
                      onConfirmClick: () {
                        Navigator.pop(context);
                        isOpenModalBottomSheet.value = false;
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Column(
          children: [
            SizedBox(
                height: 24,
                width: 24,
                child: SvgPicture.asset(
                  IconPaths.icTimer,
                  color: Colors.white,
                )),
            const SizedBox(
              height: 4,
            ),
            CountDownTimer(
              isNowPlayScreen: false,
            )
          ],
        ));
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
        width: 120,
        height: 60,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              transform: GradientRotation(5.50),
              colors: [
                k5C40DF,
                k7F65F0,
              ],
            ),
            borderRadius: BorderRadius.all(Radius.circular(100))),
        child: isPlaying
            ? SvgPicture.asset(
                IconPaths.icPause,
                height: 30,
              )
            : SvgPicture.asset(
                IconPaths.icPlay,
                height: 30,
              ),
      ),
    );
  }
}
