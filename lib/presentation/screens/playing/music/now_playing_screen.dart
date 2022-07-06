import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/common/utils/ad_helper.dart';
import 'package:rain_sounds/data/remote/model/music_model.dart';
import 'package:rain_sounds/domain/manager/playback_timer.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_screen.dart';
import 'package:rain_sounds/presentation/utils/duration_util.dart';

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
  final PlaybackTimer _playbackTimer = getIt<PlaybackTimer>();

  final AdHelper adHelper = getIt.get();

  @override
  void dispose() {
    _bloc.add(StopEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover,
            image:
                CachedNetworkImageProvider(widget.musicModel.background ?? '')),
      ),
      child: BlocBuilder<NowPlayingBloc, NowPlayingState>(
          bloc: _bloc..add(PlayMusicEvent(widget.musicModel)),
          builder: (BuildContext context, NowPlayingState state) {
            return SafeArea(
              child: Column(mainAxisSize: MainAxisSize.max, children: [
                const SizedBox(
                  height: 24,
                ),
                Text(
                  widget.musicModel.title ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 36, color: Colors.white),
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      shape: BoxShape.circle),
                  child: buildTimer(),
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
                        stream: _bloc.onlineMusicPlayer.audioPlayer.isPlaying,
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
                )
              ]),
            );
          }),
    ));
  }

  Widget buildTimer() {
    return AnimatedBuilder(
        animation: _playbackTimer,
        builder: (context, child) {
          return Center(
            child: Text(
              formatHHMMSS(_playbackTimer.remainingTime),
              style: const TextStyle(fontSize: 54, color: Colors.white),
            ),
          );
        });
  }
}
