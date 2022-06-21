import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rain_sounds/common/configs/app_cache.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/domain/manager/timer_controller.dart';
import 'package:rain_sounds/presentation/base/navigation_service.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';

class SetTimerScreen extends StatelessWidget {
  SetTimerScreen({Key? key}) : super(key: key);
  final AppCache appCache = getIt.get();
  final TimerController timerController = getIt.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFF201936),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(
                height: 24,
              ),
              const Text(
                'Set Timer',
                style: TextStyle(color: Colors.white70),
              ),
              TimeButton(
                text: '15 mín',
                onTap: () {
                  appCache.setTimer(const Duration(minutes: 15).toString());
                  timerController.reset();
                  getIt<NavigationService>().pop();
                },
              ),
              TimeButton(
                text: '30 mín',
                onTap: () {
                  appCache.setTimer(const Duration(minutes: 30).toString());
                  timerController.reset();
                  getIt<NavigationService>().pop();
                },
              ),
              TimeButton(
                text: '1 hour',
                onTap: () {
                  appCache.setTimer(const Duration(hours: 1).toString());
                  timerController.reset();
                  getIt<NavigationService>().pop();
                },
              ),
              TimeButton(
                text: '2 hour',
                onTap: () {
                  appCache.setTimer(const Duration(hours: 2).toString());
                  timerController.reset();
                  getIt<NavigationService>().pop();
                },
              ),
              TimeButton(
                text: 'Custom',
                onTap: () {},
              ),
              TimeButton(
                text: 'Off',
                onTap: () {
                  appCache.setTimer('off');
                  timerController.off();
                  getIt<NavigationService>().pop();
                },
              ),
              const SizedBox(
                height: 40,
              ),
              buildCancelButton(),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCancelButton() {
    return InkWell(
      onTap: () {
        getIt<NavigationService>().pop();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.white70,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: SvgPicture.asset(IconPaths.icClose),
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            'Cancel',
            style: TextStyle(color: Colors.white70),
          )
        ],
      ),
    );
  }
}

class TimeButton extends StatelessWidget {
  const TimeButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 250,
        height: 40,
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Colors.white70,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
