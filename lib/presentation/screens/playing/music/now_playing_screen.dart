import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/domain/iap/PremiumManager.dart';
import 'package:rain_sounds/presentation/base/banner_ad.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';
import 'package:rain_sounds/presentation/utils/duration_util.dart';
import 'package:rain_sounds/data/remote/model/music_model.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_screen.dart';

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
  final PremiumManager premiumManager = getIt.get();

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
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.musicModel.group ?? '',
          textAlign: TextAlign.center,
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
        child: BlocBuilder<NowPlayingBloc, NowPlayingState>(
          bloc: _bloc..add(PlayMusicEvent(widget.musicModel)),
          builder: (BuildContext context, NowPlayingState state) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(height: 16),
                  // Album Art
                  Container(
                    margin: const EdgeInsets.all(16),
                    height: MediaQuery.of(context).size.width - 32,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                            widget.musicModel.background ?? ''),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Track Info
                  Text(
                    widget.musicModel.title ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.musicModel.group ?? '',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  // Progress Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: StreamBuilder<Duration>(
                      stream: _bloc.onlineMusicPlayer.audioPlayer.currentPosition,
                      builder: (context, snapshot) {
                        final position = snapshot.data ?? Duration.zero;
                        return StreamBuilder<Playing?>(
                          stream: _bloc.onlineMusicPlayer.audioPlayer.current,
                          builder: (context, snapshot) {
                            final playing = snapshot.data;
                            final duration = playing?.audio.duration ?? Duration.zero;
                            return ProgressBar(
                              progress: position,
                              total: duration,
                              baseBarColor: Colors.white.withOpacity(0.24),
                              bufferedBarColor: Colors.white.withOpacity(0.24),
                              thumbColor: Colors.white,
                              barHeight: 4.0,
                              progressBarColor: Colors.white,
                              thumbRadius: 8.0,
                              timeLabelTextStyle: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                              onSeek: (duration) {
                                _bloc.onlineMusicPlayer.audioPlayer.seek(duration);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Controls Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Loop Toggle
                      IconButton(
                        icon: Icon(
                          state.isLooping ? Icons.repeat_one : Icons.repeat,
                          color: state.isLooping ? k7F65F0 : Colors.white,
                          size: 28,
                        ),
                        onPressed: () => _bloc.add(ToggleLoopEvent()),
                      ),
                      // Play/Pause
                      StreamBuilder<bool>(
                        stream: _bloc.onlineMusicPlayer.audioPlayer.isBuffering,
                        builder: (context, snapshot) {
                          if (snapshot.data == true) {
                            return const CircularProgressIndicator.adaptive();
                          }
                          return PlayingButton(
                            isPlaying: state.isPlaying ?? false,
                            onTap: () => _bloc.add(ToggleEvent()),
                          );
                        },
                      ),
                      // Sleep Timer
                      IconButton(
                        icon: Icon(
                          Icons.timer,
                          color: state.sleepTimerRemaining != null
                              ? k7F65F0
                              : Colors.white,
                          size: 28,
                        ),
                        onPressed: () => _showSleepTimerBottomSheet(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Sleep Timer Display
                  if (state.sleepTimerRemaining != null)
                    Text(
                      'Sleep timer: ${formatHHMMSS(state.sleepTimerRemaining!.inSeconds)}',
                      style: const TextStyle(color: k7F65F0, fontSize: 14),
                    ),
                  const Spacer(),
                  if (!premiumManager.isPremium()) const AppBannerAd(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showSleepTimerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: k1D1A55,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Sleep Timer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildTimerOption('Off', null),
            _buildTimerOption('15 minutes', const Duration(minutes: 15)),
            _buildTimerOption('30 minutes', const Duration(minutes: 30)),
            _buildTimerOption('1 hour', const Duration(hours: 1)),
            _buildTimerOption('2 hours', const Duration(hours: 2)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerOption(String label, Duration? duration) {
    return ListTile(
      title: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
      onTap: () {
        _bloc.add(SetSleepTimerEvent(duration));
        Navigator.pop(context);
      },
    );
  }
}
