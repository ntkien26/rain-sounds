import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/data/local/model/mix.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/now_mix_playing_bloc.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/now_mix_playing_event.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/now_mix_playing_state.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_screen.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';

class NowMixPlayingScreen extends StatefulWidget {
  const NowMixPlayingScreen({Key? key, required this.mix}) : super(key: key);

  final Mix mix;

  @override
  State<NowMixPlayingScreen> createState() => _NowMixPlayingScreenState();
}

class _NowMixPlayingScreenState extends State<NowMixPlayingScreen> {
  final NowMixPlayingBloc _bloc = getIt.get();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              print('NowMixPlayingState: ${state.isPlaying}');
              return Column(
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
                    child: const Center(
                      child: Text(
                        '30:00',
                        style: TextStyle(fontSize: 60, color: Colors.white),
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
              );
            }),
      )),
    );
  }
}
