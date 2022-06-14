enum SplashStatus { init, initializing, done }

class SplashState {
  const SplashState(
      {this.status = SplashStatus.init,});

  final SplashStatus status;

  SplashState copyWith(
      {SplashStatus? status,}) {
    return SplashState(
        status: status ?? this.status,);
  }

  static const SplashState initState = SplashState();
}
