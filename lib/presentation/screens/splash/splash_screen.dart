import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rain_sounds/common/configs/app_cache.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/common/utils/ad_helper.dart';
import 'package:rain_sounds/presentation/base/base_stateful_widget.dart';
import 'package:rain_sounds/presentation/base/navigation_service.dart';
import 'package:rain_sounds/presentation/screens/intro/intro_screen.dart';
import 'package:rain_sounds/presentation/screens/main/main_screen.dart';
import 'package:rain_sounds/presentation/screens/splash/splash_bloc.dart';
import 'package:rain_sounds/presentation/screens/splash/splash_event.dart';
import 'package:rain_sounds/presentation/screens/splash/splash_state.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String routePath = 'splashScreen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  double _height = 0.0;
  double _width = 0.0;

  late AnimationController _controller;
  late Animation<double> _animation;

  final AdHelper adHelper = getIt.get();
  final AppCache appCache = getIt.get();

  @override
  void initState() {
    super.initState();
    adHelper.preloadInterstitialAd();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
  }

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
            setState(() {
              _height = 180;
              _width = 180;
            });
            _controller.forward();
            break;
          case SplashStatus.done:
            if (appCache.isFirstLaunch()) {
              getIt<NavigationService>().navigateToAndRemoveUntil(
                IntroScreen.routePath,
                (Route<void> route) => false,
              );
            } else {
              if (adHelper.isInterstitialAdsReady()) {
                adHelper.showInterstitialAd(
                  onAdDismissedFullScreenContent: () {
                    navigateToMainScreen();
                  },
                  onAdFailedToLoad: () {
                    navigateToMainScreen();
                  },
                );
              } else {
                navigateToMainScreen();
              }
              break;
            }
        }
      },
      child: Scaffold(
        backgroundColor: bgColor,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(ImagePaths.bgHome),
                  fit: BoxFit.fill)),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(
                  height: 32,
                ),
                SizedBox(
                  height: 180,
                  child: AnimatedContainer(
                      height: _height,
                      width: _width,
                      duration: const Duration(milliseconds: 700),
                      child: Image.asset(ImagePaths.icMoon)),
                ),
                const Spacer(),
                Column(
                  children: [
                    SizeTransition(
                      sizeFactor: _animation,
                      child: Center(
                        child: Text(
                          'Rain Sounds for Sleep',
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 20,
                                  color: Colors.white)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: 200,
                      height: 2,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    SizeTransition(
                      sizeFactor: _animation,
                      child: Center(
                        child: Text(
                          'Help you sleep better',
                          style: GoogleFonts.roboto(
                              textStyle: const TextStyle(
                                  fontSize: 16, color: Colors.white)),
                        ),
                      ),
                    )
                  ],
                ),
                const Spacer(
                  flex: 2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void navigateToMainScreen() {
    getIt<NavigationService>().navigateToAndRemoveUntil(
      MainScreen.routePath,
      (Route<void> route) => false,
    );
  }
}
