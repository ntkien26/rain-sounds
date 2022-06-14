import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/presentation/screens/splash/splash_event.dart';
import 'package:rain_sounds/presentation/screens/splash/splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashState.initState) {
    on<SplashInitialDependenciesEvent>(_onInitDependencies);
  }

  static const String tag = 'SplashBloc';

  Future<void> _onInitDependencies(
      SplashInitialDependenciesEvent event,
      Emitter<SplashState> emit,
      ) async {
    emit(state.copyWith(status: SplashStatus.initializing));
    await Future<void>.delayed(const Duration(milliseconds: 3000));
    emit(state.copyWith(status: SplashStatus.done));
  }
}