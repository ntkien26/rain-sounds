import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/data/remote/model/music_model.dart';
import 'package:rain_sounds/domain/manager/timer_controller.dart';
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
  final TimerController _timerController = getIt<TimerController>();

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
                  height: 12,
                ),
              ]),
            );
          }),
    ));
  }

  Widget buildTimer() {
    return AnimatedBuilder(
        animation: _timerController,
        builder: (context, child) {
          return Center(
            child: Text(
              formatHHMMSS(_timerController.remainingTime),
              style: const TextStyle(fontSize: 54, color: Colors.white),
            ),
          );
        });
  }
}
