import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/presentation/base/navigation_service.dart';
import 'package:rain_sounds/presentation/base/base_stateful_widget.dart';
import 'package:rain_sounds/presentation/screens/main/main_screen.dart';
import 'package:rain_sounds/presentation/screens/splash/splash_bloc.dart';
import 'package:rain_sounds/presentation/screens/splash/splash_event.dart';
import 'package:rain_sounds/presentation/screens/splash/splash_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String routePath = 'splashScreen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SplashBloc>(
        create: (BuildContext context) => getIt<SplashBloc>()
          ..add(
            SplashInitialDependenciesEvent(),
          ),
        child: _buildSplashChild(context));
  }

  Widget _buildSplashChild(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (BuildContext context, SplashState state) async {
        switch (state.status) {
          case SplashStatus.init:
            break;
          case SplashStatus.initializing:
            break;
          case SplashStatus.done:
            getIt<NavigationService>().navigateToAndRemoveUntil(
              MainScreen.routePath,
                  (Route<void> route) => false,
            );
            break;
        }
      },
      child: Scaffold(
        body: Container(
          color: const Color(0xFFECF4FB),
          child: const Center(
            child: Text('Splash screen....'),
          ),
        ),
      ),
    );
  }

}