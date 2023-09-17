import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rain_sounds/common/configs/app_cache.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/common/utils/ad_helper.dart';
import 'package:rain_sounds/data/local/model/mix.dart';
import 'package:rain_sounds/presentation/base/count_down_timer.dart';
import 'package:rain_sounds/presentation/base/navigation_service.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/edit_selected_sound/edit_selected_sound_screen.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/now_mix_playing_bloc.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/now_mix_playing_event.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/now_mix_playing_state.dart';
import 'package:rain_sounds/presentation/screens/set_timer/set_timer_screen.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_screen.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';
import 'package:badges/badges.dart' as badges;
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class NowMixPlayingScreen extends StatefulWidget {
  const NowMixPlayingScreen(
      {Key? key, required this.mix, this.autoStart = true})
      : super(key: key);

  final Mix mix;
  final bool autoStart;

  @override
  State<NowMixPlayingScreen> createState() => _NowMixPlayingScreenState();
}

class _NowMixPlayingScreenState extends State<NowMixPlayingScreen> {
  final NowMixPlayingBloc _bloc = getIt.get();
  final AdHelper adHelper = getIt.get();
  final AppCache appCache = getIt.get();

  static const _backgroundColor = Colors.black;

  static const _colors = [
    Color(0xff69a4f1),
    Color(0xff4c5cb0),
  ];

  static const _durations = [
    5000,
    4000,
  ];

  static const _heightPercentages = [
    0.65,
    0.66,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            widget.mix.name ?? '',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              tileMode: TileMode.decal,
              colors: [
                k010621,
                k1D1A55,
              ],
            ),
          ),
          child: BlocBuilder<NowMixPlayingBloc, NowMixPlayingState>(
              bloc: _bloc
                ..add(
                    PlayMixEvent(mix: widget.mix, autoStart: widget.autoStart)),
              builder: (BuildContext context, NowMixPlayingState state) {
                return SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        InkWell(
                          onTap: () {
                            getIt<NavigationService>()
                                .navigateToScreen(screen: SetTimerScreen());
                          },
                          child: Column(
                            children: [
                              Container(
                                // padding: const EdgeInsets.all(20),
                                margin: const EdgeInsets.all(16),
                                height: MediaQuery.of(context).size.width - 32,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        '${Assets.baseImagesPath}/${widget.mix.cover?.background}.webp'),
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                ),
                              ),
                              const SizedBox(
                                height: 64,
                              ),
                              CountDownTimer(
                                isNowPlayScreen: true,
                              )
                            ],
                          ),
                          // child: SizedBox(
                          //   width: 250,
                          //   height: 250,
                          //   child: ClipRRect(
                          //     borderRadius: BorderRadius.circular(150),
                          //     child: Stack(
                          //       children: [
                          //         WaveWidget(
                          //           config: CustomConfig(
                          //             colors: _colors,
                          //             durations: _durations,
                          //             heightPercentages: _heightPercentages,
                          //           ),
                          //           backgroundColor:
                          //               _backgroundColor.withOpacity(0.7),
                          //           size: const Size(
                          //               double.infinity, double.infinity),
                          //           waveAmplitude: 0,
                          //         ),
                          //         CountDownTimer(
                          //           fontSize: 54,
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                showModalBottomSheet<int>(
                                  isDismissible: false,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) {
                                    return EditSelectedSoundScreen(
                                      mix: state.mix!,
                                      selection: 1,
                                      onCancelClick: () {
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                );
                                _bloc.add(RefreshEvent(mix: state.mix!));
                              },
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: SvgPicture.asset(
                                      IconPaths.icAmbience,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  const Text(
                                    'Edit',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                            StreamBuilder(
                              stream: _bloc.soundService.isPlaying,
                              builder: (BuildContext context,
                                  AsyncSnapshot<bool> asyncSnapshot) {
                                final bool? isPlaying = asyncSnapshot.data;
                                return PlayingButton(
                                    isPlaying: isPlaying == true,
                                    onTap: () {
                                      _bloc.add(ToggleMixEvent());
                                    });
                              },
                            ),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet<int>(
                                  isDismissible: false,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) {
                                    return EditSelectedSoundScreen(
                                      mix: state.mix!,
                                      selection: 0,
                                      onCancelClick: () {
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                );
                                _bloc.add(RefreshEvent(mix: state.mix!));
                              },
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: badges.Badge(
                                      showBadge: true,
                                      position: BadgePosition.topEnd(end: -14),
                                      badgeContent: const Text(
                                        '3',
                                        style: TextStyle(color: Colors.white),
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
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ));
  }
}
