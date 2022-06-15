import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/presentation/screens/music/music_bloc.dart';
import 'package:rain_sounds/presentation/screens/music/music_state.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({Key? key}) : super(key: key);

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {

  final MusicBloc _bloc = getIt<MusicBloc>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(ImagePaths.background_music_screen),
              fit: BoxFit.fill)
      ),
      child: BlocBuilder<MusicBloc, MusicState>(
        bloc: _bloc,
        builder: (BuildContext context, MusicState state) {
          switch (state.status) {
            case MusicStatus.empty:
              break;
            case MusicStatus.loading:
              return const CupertinoActivityIndicator();
            case MusicStatus.success:
              return Container();
            case MusicStatus.error:
              return Container();
          }
          return Container();
        },
      ),
    );
  }
}
