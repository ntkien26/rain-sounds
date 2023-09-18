import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:rain_sounds/common/configs/app_cache.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/data/local/model/mix.dart';
import 'package:rain_sounds/presentation/base/navigation_service.dart';
import 'package:rain_sounds/presentation/screens/in_app_purchase/in_app_purchase_screen.dart';
import 'package:rain_sounds/presentation/screens/sleep/sleep_bloc.dart';
import 'package:rain_sounds/presentation/screens/sleep/sleep_event.dart';
import 'package:rain_sounds/presentation/screens/sleep/sleep_state.dart';
import 'package:rain_sounds/presentation/screens/sleep/widget/category_mix_page.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';
import 'package:rain_sounds/presentation/utils/styles.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'widget/bottom_media_controller.dart';

class RelaxScreen extends StatefulWidget {
  const RelaxScreen({Key? key}) : super(key: key);

  @override
  State<RelaxScreen> createState() => _RelaxScreenState();
}

class _RelaxScreenState extends State<RelaxScreen>
    with AutomaticKeepAliveClientMixin {
  final SleepBloc _bloc = getIt<SleepBloc>();

  int _selectedIndex = 0;

  final PageController pageController = PageController();
  final ItemScrollController itemScrollController = ItemScrollController();
  final AppCache appCache = getIt.get();

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        _bloc.add(RefreshEvent());
      },
      child: Scaffold(
        backgroundColor: bgColor,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(ImagePaths.bgHome), fit: BoxFit.fill)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'App name title',
                        style: TextStyleConstant.titleTextStyle
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                          onTap: () {
                            getIt<NavigationService>()
                                .navigateToScreen(screen: const InAppPurchaseScreen());
                          },
                          child: SvgPicture.asset(IconPaths.icCrown)
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  BlocBuilder<SleepBloc, SleepState>(
                    bloc: _bloc,
                    builder: (BuildContext context, SleepState state) {
                      switch (state.status) {
                        case SleepStatus.empty:
                          return const Center(
                              child: CircularProgressIndicator());
                        case SleepStatus.loading:
                          return const CupertinoActivityIndicator();
                        case SleepStatus.success:
                          List<List<Mix>> listMixes =
                              List.empty(growable: true);
                          List<Mix> customMixes = state.mixes
                                  ?.where((element) => element.category == 1)
                                  .toList() ??
                              List.empty();

                          for (var element in state.categories ?? []) {
                            switch (element.id) {
                              case 0:
                                listMixes.add(state.mixes ?? List.empty());
                                break;
                              case 1:
                                listMixes.add(customMixes);
                                break;
                              default:
                                final list = state.mixes
                                    ?.where((mix) => mix.category == element.id)
                                    .toList();
                                listMixes.add(list ?? List.empty());
                            }
                          }
                          return Expanded(
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 28,
                                      child: ScrollablePositionedList.builder(
                                          itemScrollController:
                                              itemScrollController,
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              state.categories?.length ?? 0,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return buildTabItem(
                                                state.categories![index],
                                                index);
                                          }),
                                    ),
                                    const SizedBox(
                                      height: 24,
                                    ),
                                    Expanded(
                                      child: PageView.builder(
                                          controller: pageController,
                                          itemCount: state.categories?.length,
                                          onPageChanged: (page) {
                                            setState(() {
                                              _selectedIndex = page;
                                            });
                                          },
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return CategoryMixPage(
                                              mixes: listMixes[index],
                                              showPremiumBanner: false,
                                              // showPremiumBanner: index == 0 &&
                                              //     !appCache.isPremiumMember(),
                                              sleepBloc: _bloc,
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                                StreamBuilder(
                                    stream: _bloc.soundService.playingMix,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        print(
                                            'Show bottom: ${(snapshot.data as Mix).name}');
                                        return Align(
                                          alignment: Alignment.bottomCenter,
                                          child: BottomMediaController(
                                            bloc: _bloc,
                                            mix: snapshot.data as Mix,
                                          ),
                                        );
                                      } else {
                                        print('Show bottom: empty');
                                        return const SizedBox();
                                      }
                                    })
                              ],
                            ),
                          );
                        case SleepStatus.error:
                          return Container();
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTabItem(Category category, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        pageController.animateToPage(_selectedIndex,
            duration: const Duration(microseconds: 300),
            curve: Curves.bounceIn);
        itemScrollController.jumpTo(index: index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        margin: index == 0
            ? const EdgeInsets.symmetric(horizontal: 8).copyWith(left: 0)
            : const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            transform: const GradientRotation(5.50),
            colors: _selectedIndex == index
                ? [
                    k5C40DF,
                    k7F65F0,
                  ]
                : [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.3),
                  ],
          ),
        ),
        child: Center(
          child: Text(
            category.title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
