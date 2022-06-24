import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/common/utils/ad_helper.dart';
import 'package:rain_sounds/data/local/model/mix.dart';
import 'package:rain_sounds/domain/manager/timer_controller.dart';
import 'package:rain_sounds/presentation/base/navigation_service.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/edit_selected_sound/edit_selected_sound_screen.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/now_mix_playing_bloc.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/now_mix_playing_event.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/now_mix_playing_state.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_screen.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/duration_util.dart';

class NowMixPlayingScreen extends StatefulWidget {
  const NowMixPlayingScreen({Key? key, required this.mix}) : super(key: key);

  final Mix mix;

  @override
  State<NowMixPlayingScreen> createState() => _NowMixPlayingScreenState();
}

class _NowMixPlayingScreenState extends State<NowMixPlayingScreen> {
  final NowMixPlayingBloc _bloc = getIt.get();
  final TimerController _timerController = getIt<TimerController>();

  final AdHelper adHelper = getIt.get();

  @override
  void initState() {
    super.initState();
    adHelper.showInterstitialAd(onAdShowedFullScreenContent: () {}, onAdDismissedFullScreenContent: () {});
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
            image: AssetImage(
                "${Assets.baseImagesPath}/${widget.mix.cover?.background}.webp")),
      ),
      child: BlocBuilder<NowMixPlayingBloc, NowMixPlayingState>(
          bloc: _bloc..add(PlayMixEvent(widget.mix)),
          builder: (BuildContext context, NowMixPlayingState state) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    widget.mix.name ?? '',
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
                  SizedBox(
                    height: 80,
                    child: InkWell(
                      onTap: () {
                        getIt
                            .get<NavigationService>()
                            .navigateToScreen(screen: EditSelectedSoundScreen());
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: SizedBox(
                                    child: SvgPicture.asset(IconPaths.icEdit),
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
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
                                style: const TextStyle(color: Colors.white70),
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
                  PlayingButton(
                    isPlaying: state.isPlaying ?? false,
                    onTap: () {
                      _bloc.add(ToggleMixEvent());
                    },
                  )
                ],
              ),
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
