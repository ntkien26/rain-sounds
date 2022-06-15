import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/presentation/screens/sounds/sound_group_page.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_bloc.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_state.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';

class SoundsScreen extends StatefulWidget {
  const SoundsScreen({Key? key}) : super(key: key);

  @override
  State<SoundsScreen> createState() => _SoundsScreenState();
}

class _SoundsScreenState extends State<SoundsScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final SoundsBloc _bloc = getIt<SoundsBloc>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(ImagePaths.background_sounds_screen),
                  fit: BoxFit.fill)),
          child: BlocBuilder<SoundsBloc, SoundsState>(
            bloc: _bloc,
            builder: (BuildContext context, SoundsState state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 2,
                      child: Text('Rain Sounds - Sleep Sounds')),
                  Expanded(
                    flex: 6,
                    child: Column(
                      children: [
                        PageView(
                          controller: _pageController,
                          onPageChanged: (page) {
                            setState(() {
                              _selectedIndex = page;
                            });
                          },
                          children: const [
                            SoundGroupPage(),
                            SoundGroupPage(),
                            SoundGroupPage(),
                            SoundGroupPage(),
                            SoundGroupPage(),
                            SoundGroupPage(),
                          ],
                        ),
                        DotsIndicator(
                          dotsCount: 7,
                          position: _selectedIndex.toDouble(),
                          decorator: const DotsDecorator(
                            color: Colors.white30, // Inactive color
                            activeColor: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('Time'),
                          Text('Play'),
                          Text('Edit')
                        ],
                      ),
                    ),
                  )
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
