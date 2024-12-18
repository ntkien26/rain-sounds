import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/common/configs/app_cache.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/common/utils/ad_helper.dart';
import 'package:rain_sounds/data/remote/model/music_model.dart';
import 'package:rain_sounds/presentation/base/banner_ad.dart';
import 'package:rain_sounds/presentation/base/count_down_timer.dart';
import 'package:rain_sounds/presentation/base/navigation_service.dart';
import 'package:rain_sounds/presentation/screens/set_timer/set_timer_screen.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_screen.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';

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
  final AppCache appCache = getIt.get();

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
                  child: Column(mainAxisSize: MainAxisSize.max, children: [
                    const SizedBox(
                      height: 16,
                    ),
                    InkWell(
                      onTap: () async {
                        await getIt<NavigationService>()
                            .navigateToScreen(screen: SetTimerScreen());
                        setState(() {});
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
                                image: CachedNetworkImageProvider(
                              widget.musicModel.background ?? ''),
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
                                  isPlaying: isPlaying ?? false,
                                  onTap: () {
                                    _bloc.add(ToggleEvent());
                                  });
                            },
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const Spacer(),
                    !appCache.isPremiumMember() ? const AppBannerAd() : const SizedBox()
                  ]),
                );
              }),
        ));
  }
}
