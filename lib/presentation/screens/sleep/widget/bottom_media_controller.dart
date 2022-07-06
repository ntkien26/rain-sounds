import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/domain/manager/playback_timer.dart';
import 'package:rain_sounds/presentation/screens/sleep/sleep_bloc.dart';
import 'package:rain_sounds/presentation/screens/sleep/sleep_event.dart';
import 'package:rain_sounds/presentation/screens/sleep/sleep_state.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';
import 'package:rain_sounds/presentation/utils/duration_util.dart';

class BottomMediaController extends StatelessWidget {
  BottomMediaController({
    Key? key,
    required this.bloc, required this.onBottomControllerClicked,
  }) : super(key: key);

  final SleepBloc bloc;
  final PlaybackTimer _playbackTimer = getIt<PlaybackTimer>();
  final VoidCallback onBottomControllerClicked;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SleepBloc, SleepState>(
      bloc: bloc,
      builder: (buildContext, state) {
        return InkWell(
          onTap: () {
            onBottomControllerClicked();
          },
          child: Container(
            color: kBottomBarColor,
            width: double.infinity,
            height: 80,
            child: Row(
              children: [
                Container(
                  width: 80,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                              "${Assets.baseImagesPath}/${state.selectedMix?.cover?.background}.webp"))),
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(state.selectedMix?.name ?? '',
                        style: const TextStyle(color: Colors.white)),
                    const SizedBox(
                      height: 4,
                    ),
                    AnimatedBuilder(
                      animation: _playbackTimer,
                      builder: (context, child) {
                        return Text(
                          formatHHMMSS(_playbackTimer.remainingTime),
                          style: const TextStyle(color: Colors.white),
                        );
                      },
                    )
                  ],
                ),
                const Spacer(),
                bloc.soundService.isPlaying == true
                    ? InkWell(
                    onTap: () {
                      bloc.add(ToggleEvent());
                    },
                    child: SvgPicture.asset(IconPaths.icPause))
                    : InkWell(
                    onTap: () {
                      bloc.add(ToggleEvent());
                    },
                    child: SvgPicture.asset(IconPaths.icPlay)),
                const SizedBox(
                  width: 12,
                ),
                InkWell(
                    onTap: () {
                      bloc.add(StopEvent());
                    },
                    child: SvgPicture.asset(IconPaths.icClose)),
                const SizedBox(
                  width: 12,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
