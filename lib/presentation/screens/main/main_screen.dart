import 'package:flutter_svg/flutter_svg.dart';
import 'package:rain_sounds/presentation/base/base_stateful_widget.dart';
import 'package:rain_sounds/presentation/screens/more/more_screen.dart';
import 'package:rain_sounds/presentation/screens/music/music_screen.dart';
import 'package:rain_sounds/presentation/screens/sleep/relax_screen.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_screen.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const String routePath = 'mainScreen';

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  late AppLifecycleState previousState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    previousState = AppLifecycleState.resumed;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        previousState = AppLifecycleState.resumed;
        break;
      case AppLifecycleState.inactive:
        previousState = AppLifecycleState.inactive;
        break;
      case AppLifecycleState.paused:
        previousState = AppLifecycleState.paused;
        break;
      case AppLifecycleState.detached:
        previousState = AppLifecycleState.detached;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: k181f4c,
        items: bottomBarItems,
        onTap: _onTappedBar,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white38,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const <Widget>[
          RelaxScreen(),
          SoundsScreen(),
          MusicScreen(),
          MoreScreen()
        ],
      ),
    );
  }

  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
    });
    _pageController.animateToPage(value,
        curve: Curves.linear, duration: const Duration(milliseconds: 200));
  }

  final List<BottomNavigationBarItem> bottomBarItems =
  <BottomNavigationBarItem>[
    BottomNavigationBarItem(
      label: "Relax Sound",
      icon: Container(
          margin: const EdgeInsets.all(6),
          height: 20,
          width: 20,
          child: SvgPicture.asset(IconPaths.icMoonSound)),
    ),
    BottomNavigationBarItem(
      label: "Ambience",
      icon: Container(
          margin: const EdgeInsets.all(6),
          height: 20,
          width: 20,
          child: SvgPicture.asset(IconPaths.icAmbience)),
    ),
    BottomNavigationBarItem(
      label: "Music",
      icon: Container(
          margin: const EdgeInsets.all(6),
          height: 20,
          width: 20,
          child: SvgPicture.asset(IconPaths.icMusicTab)),
    ),
    BottomNavigationBarItem(
      label: "Setting",
      icon: Container(
          margin: const EdgeInsets.all(6),
          height: 20,
          width: 20,
          child: SvgPicture.asset(IconPaths.icSetup)),
    ),
  ];

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
