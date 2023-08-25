import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rain_sounds/common/configs/app_config.dart';
import 'package:rain_sounds/common/configs/app_route.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/presentation/app/app_bloc.dart';
import 'package:rain_sounds/presentation/base/navigation_service.dart';
import 'package:rain_sounds/presentation/screens/splash/splash_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig().configApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (BuildContext context) => getIt<AppBloc>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: getIt<NavigationService>().navigatorKey,
        onGenerateRoute: AppRoute.getRoute,
        theme: ThemeData(textTheme: GoogleFonts.robotoTextTheme()),
        initialRoute: SplashScreen.routePath,
        builder: EasyLoading.init(),
      ),
    );
  }

}
