import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:rain_sounds/presentation/screens/sounds/sound_group_page.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';

class SoundsScreen extends StatefulWidget {
  const SoundsScreen({Key? key}) : super(key: key);

  @override
  State<SoundsScreen> createState() => _SoundsScreenState();
}

class _SoundsScreenState extends State<SoundsScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: size.height * 0.1,
                  child: const Text('Rain Sounds - Sleep Sounds')),
              SizedBox(
                width: size.width,
                height: size.height * 0.6,
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.55,
                      child: PageView(
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: size.width,
                    height: size.height * 0.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Time'),
                        Text('Play'),
                        Text('Edit')
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
