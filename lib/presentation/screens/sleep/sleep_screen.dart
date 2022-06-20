import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/data/local/model/mix.dart';
import 'package:rain_sounds/presentation/screens/sleep/category_mix_page.dart';
import 'package:rain_sounds/presentation/screens/sleep/sleep_bloc.dart';
import 'package:rain_sounds/presentation/screens/sleep/sleep_state.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({Key? key}) : super(key: key);

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  final SleepBloc _bloc = getIt<SleepBloc>();

  final List<Category> categories = [
    Category(id: 0, title: 'All'),
    Category(id: 1, title: 'Custom'),
    Category(id: 2, title: 'Sleep'),
    Category(id: 3, title: 'Rain'),
    Category(id: 4, title: 'Relax'),
    Category(id: 5, title: 'Meditation'),
    Category(id: 6, title: 'Work'),
  ];

  int _selectedIndex = 0;

  final PageController pageController = PageController();
  final ItemScrollController itemScrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(ImagePaths.bgMoreScreen),
                fit: BoxFit.fill)),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Rain Sounds - Sleep Sounds',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500),
                    ),
                  )),
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                height: 28,
                child: ScrollablePositionedList.builder(
                    itemScrollController: itemScrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      return buildTabItem(categories[index], index);
                    }),
              ),
              const SizedBox(
                height: 32,
              ),
              BlocBuilder<SleepBloc, SleepState>(
                bloc: _bloc,
                builder: (BuildContext context, SleepState state) {
                  switch (state.status) {
                    case SleepStatus.empty:
                      break;
                    case SleepStatus.loading:
                      return const CupertinoActivityIndicator();
                    case SleepStatus.success:
                      List<List<Mix>> listMixes = List.empty(growable: true);
                      for (var element in categories) {
                        switch (element.id) {
                          case 0:
                            listMixes.add(state.mixes ?? List.empty());
                            break;
                          case 1:
                            listMixes.add(state.mixes ?? List.empty());
                            break;
                          default:
                            final list = state.mixes
                                ?.where((mix) => mix.category == element.id)
                                .toList();
                            listMixes.add(list ?? List.empty());
                        }
                      }
                      return Expanded(
                        child: PageView.builder(
                            controller: pageController,
                            itemCount: categories.length,
                            onPageChanged: (page) {
                              setState(() {
                                _selectedIndex = page;
                              });
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return CategoryMixPage(
                                mixes: listMixes[index],
                              );
                            }),
                      );
                    case SleepStatus.error:
                      return Container();
                  }
                  return Container();
                },
              )
            ],
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
        itemScrollController.scrollTo(
            index: index, duration: const Duration(microseconds: 300));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            color: _selectedIndex == index ? Colors.blue : Colors.white10,
            borderRadius: const BorderRadius.all(Radius.circular(12))),
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
}

class Category {
  final int id;
  final String title;

  Category({required this.id, required this.title});
}
