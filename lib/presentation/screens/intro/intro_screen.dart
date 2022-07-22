import 'package:flutter/material.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/presentation/base/navigation_service.dart';
import 'package:rain_sounds/presentation/screens/in_app_purchase/in_app_purchase_screen.dart';
import 'package:rain_sounds/presentation/screens/intro/step_one_page.dart';
import 'package:rain_sounds/presentation/screens/intro/step_three_page.dart';
import 'package:rain_sounds/presentation/screens/intro/step_two_page.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  static const String routePath = 'introScreen';

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(ImagePaths.bgMoreScreen), fit: BoxFit.fill)),
        child: PageView(
          controller: pageController,
          children: [
            StepOnePage(
              onNextClicked: () {
                pageController.animateToPage(1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear);
              },
            ),
            StepTwoPage(
              onNextClicked: () {
                pageController.animateToPage(2,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.linear);
              },
            ),
            StepThreePage(
              onNextClicked: () {
                getIt
                    .get<NavigationService>()
                    .navigateToScreen(screen: const InAppPurchaseScreen());
              },
            )
          ],
        ),
      ),
    );
  }
}
