import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/presentation/screens/music/music_bloc.dart';
import 'package:rain_sounds/presentation/screens/music/music_state.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({Key? key}) : super(key: key);

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MusicBloc, MusicState>(
      bloc: getIt.get(),
      builder: (BuildContext context, MusicState state) {
        return const Center(child: Text('Music'));
      });
  }
}
