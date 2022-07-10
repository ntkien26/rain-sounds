import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/common/utils/ad_helper.dart';
import 'package:rain_sounds/data/remote/model/music_model.dart';
import 'package:rain_sounds/presentation/base/count_down_timer.dart';
import 'package:rain_sounds/presentation/base/navigation_service.dart';
import 'package:rain_sounds/presentation/screens/set_timer/set_timer_screen.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_screen.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import 'now_playing_bloc.dart';
import 'now_playing_event.dart';
import 'now_playing_state.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({Key? key, required this.musicModel})
      : super(key: key);

  final MusicModel musicModel;

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  final NowPlayingBloc _bloc = getIt.get();

  final AdHelper adHelper = getIt.get();

  static const _backgroundColor = Colors.black;

  static const _colors = [
    Color(0xff7ea2d0),
    Color(0xff1e346a),
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
  void dispose() {
    _bloc.add(StopEvent());
    super.dispose();
  }

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
                image: CachedNetworkImageProvider(
                    widget.musicModel.background ?? '')),
          ),
          child: BlocBuilder<NowPlayingBloc, NowPlayingState>(
              bloc: _bloc..add(PlayMusicEvent(widget.musicModel)),
              builder: (BuildContext context, NowPlayingState state) {
                return SafeArea(
                  child: Column(mainAxisSize: MainAxisSize.max, children: [
                    Text(
                      widget.musicModel.group ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 36, color: Colors.white),
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
                              CountDownTimer(fontSize: 54,)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    StreamBuilder(
                      stream: _bloc.onlineMusicPlayer.audioPlayer.isBuffering,
                      builder: (BuildContext context,
                          AsyncSnapshot<bool> asyncSnapshot) {
                        final bool? isBuffering = asyncSnapshot.data;
                        if (isBuffering == true) {
                          return const CircularProgressIndicator.adaptive();
                        } else {
                          return StreamBuilder(
                            stream:
                                _bloc.onlineMusicPlayer.audioPlayer.isPlaying,
                            builder: (BuildContext context,
                                AsyncSnapshot<bool> asyncSnapshot) {
                              final bool? isPlaying = asyncSnapshot.data;
                              return PlayingButton(
                                  isPlaying: isPlaying == true,
                                  onTap: () {
                                    _bloc.add(ToggleEvent());
                                  });
                            },
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 24,),
                    Text(
                      widget.musicModel.title ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ]),
                );
              }),
        ));
  }
}
