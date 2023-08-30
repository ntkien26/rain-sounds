import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/data/local/model/mix.dart';
import 'package:rain_sounds/presentation/base/count_down_timer.dart';
import 'package:rain_sounds/presentation/base/navigation_service.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/now_mix_playing_screen.dart';
import 'package:rain_sounds/presentation/screens/sleep/sleep_bloc.dart';
import 'package:rain_sounds/presentation/screens/sleep/sleep_event.dart';
import 'package:rain_sounds/presentation/screens/sleep/sleep_state.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';

class BottomMediaController extends StatefulWidget {
  const BottomMediaController({
    Key? key,
    required this.bloc,
    required this.mix,
  }) : super(key: key);

  final SleepBloc bloc;
  final Mix mix;

  @override
  State<BottomMediaController> createState() => _BottomMediaControllerState();
}

class _BottomMediaControllerState extends State<BottomMediaController> {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SleepBloc, SleepState>(
      bloc: widget.bloc,
      builder: (buildContext, state) {
        return InkWell(
          onTap: () {
            getIt<NavigationService>().navigateToScreen(
                screen: NowMixPlayingScreen(
              mix: widget.mix,
              autoStart: false,
            ));
          },
          child: Container(
            color: kBottomBarColor.withOpacity(0.9),
            width: double.infinity,
            height: 68,
            child: Row(
              children: [
                Container(
                  width: 68,
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
                    Text(widget.mix.name ?? '',
                        style: const TextStyle(color: Colors.white)),
                    const SizedBox(
                      height: 4,
                    ),
                    CountDownTimer(
                      isNowPlayScreen: false,
                    )
                  ],
                ),
                const Spacer(),
                StreamBuilder(
                    stream: widget.bloc.soundService.isPlaying,
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      if (snapshot.hasData && snapshot.data == true) {
                        return InkWell(
                            onTap: () {
                              widget.bloc.add(ToggleEvent());
                              setState(() {});
                            },
                            child: SvgPicture.asset(IconPaths.icPause));
                      } else {
                        return InkWell(
                            onTap: () {
                              widget.bloc.add(ToggleEvent());
                              setState(() {});
                            },
                            child: SvgPicture.asset(IconPaths.icPlay));
                      }
                    }),
                const SizedBox(
                  width: 24,
                ),
                InkWell(
                    onTap: () {
                      widget.bloc.add(StopEvent());
                    },
                    child: SvgPicture.asset(IconPaths.icClose)),
                const SizedBox(
                  width: 24,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
