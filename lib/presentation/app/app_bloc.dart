import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/presentation/app/app_event.dart';
import 'package:rain_sounds/presentation/app/app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial());
}