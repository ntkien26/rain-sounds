import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/presentation/screens/sleep/sleep_bloc.dart';
import 'package:rain_sounds/presentation/screens/sleep/sleep_state.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({Key? key}) : super(key: key);

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {

  final SleepBloc _bloc = getIt<SleepBloc>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(ImagePaths.background_more_screen),
              fit: BoxFit.fill
          )
      ),
      child: BlocBuilder<SleepBloc, SleepState>(
        bloc: _bloc,
        builder: (BuildContext context, SleepState state) {
          switch (state.status) {
            case SleepStatus.empty:
              break;
            case SleepStatus.loading:
              return const CupertinoActivityIndicator();
            case SleepStatus.success:
              return Container();
            case SleepStatus.error:
              return Container();
          }
          return Container();
        },
      ),
    );
  }
}
