import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/common/utils/ad_helper.dart';
import 'package:rain_sounds/data/local/model/mix.dart';
import 'package:rain_sounds/presentation/base/banner_ad.dart';
import 'package:rain_sounds/presentation/base/count_down_timer.dart';
import 'package:rain_sounds/presentation/base/navigation_service.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/edit_selected_sound/edit_selected_sound_screen.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/now_mix_playing_bloc.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/now_mix_playing_event.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/now_mix_playing_state.dart';
import 'package:rain_sounds/presentation/screens/set_timer/set_timer_screen.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_screen.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
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
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3), BlendMode.darken),
                fit: BoxFit.cover,
                image: AssetImage(
                    "${Assets.baseImagesPath}/${widget.mix.cover?.background}.webp")),
          ),
          child: BlocBuilder<NowMixPlayingBloc, NowMixPlayingState>(
              bloc: _bloc
                ..add(
                    PlayMixEvent(mix: widget.mix, autoStart: widget.autoStart)),
              builder: (BuildContext context, NowMixPlayingState state) {
                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        widget.mix.name ?? '',
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(fontSize: 36, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      InkWell(
                        onTap: () {
                          getIt<NavigationService>()
                              .navigateToScreen(screen: SetTimerScreen());
                        },
                        child: SizedBox(
                          width: 250,
                          height: 250,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(150),
                            child: Stack(
                              children: [
                                WaveWidget(
                                  config: CustomConfig(
                                    colors: _colors,
                                    durations: _durations,
                                    heightPercentages: _heightPercentages,
                                  ),
                                  backgroundColor:
                                      _backgroundColor.withOpacity(0.7),
                                  size: const Size(
                                      double.infinity, double.infinity),
                                  waveAmplitude: 0,
                                ),
                                CountDownTimer(
                                  fontSize: 54,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        height: 80,
                        child: InkWell(
                          onTap: () async {
                            await getIt
                                .get<NavigationService>()
                                .navigateToScreen(
                                    screen: EditSelectedSoundScreen(
                                  mix: state.mix!,
                                ));
                            _bloc.add(RefreshEvent(mix: state.mix!));
                          },
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            itemCount: state.mix?.sounds == null
                                ? 1
                                : state.mix!.sounds!.length + 1,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == 0) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      margin: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                          color: Colors.white30,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      child: SizedBox(
                                        child:
                                            SvgPicture.asset(IconPaths.icEdit),
                                      ),
                                    ),
                                    const Text(
                                      'Edit',
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                );
                              }
                              index -= 1;

                              // return row
                              var sound = state.mix?.sounds?[index];
                              final extension = sound?.icon?.split('.').last;
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    margin: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                        color: Colors.white30,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: SizedBox(
                                      child: extension == 'svg'
                                          ? SvgPicture.asset(
                                              '${Assets.baseIconPath}/${sound?.icon}')
                                          : Image.asset(
                                              '${Assets.baseIconPath}/${sound?.icon}'),
                                    ),
                                  ),
                                  Text(
                                    '${sound?.volume.toInt().toString()}%',
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
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
                      const Spacer(),
                      const AppBannerAd()
                    ],
                  ),
                );
              }),
        ));
  }
}
