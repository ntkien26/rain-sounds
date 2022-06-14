import 'package:rain_sounds/presentation/base/base_stateful_widget.dart';
import 'package:rain_sounds/presentation/screens/more/more_screen.dart';
import 'package:rain_sounds/presentation/screens/music/music_screen.dart';
import 'package:rain_sounds/presentation/screens/sleep/sleep_screen.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_screen.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const String routePath = 'mainScreen';

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen>
    with WidgetsBindingObserver {

  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  late AppLifecycleState previousState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
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
        items: bottomBarItems,
        onTap: _onTappedBar,
        selectedItemColor: kFirstPrimaryColor,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const <Widget>[
            SleepScreen(),
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
    _pageController.jumpToPage(value);
  }

  final List<BottomNavigationBarItem> bottomBarItems =
  <BottomNavigationBarItem>[
    const BottomNavigationBarItem(
      label: "Sleep",
      icon: Icon(Icons.music_note),
    ),
    const BottomNavigationBarItem(
      label: "Sounds",
      icon: Icon(Icons.music_note),
    ),
    const BottomNavigationBarItem(
      label: "Music",
      icon: Icon(Icons.music_note),
    ),
    const BottomNavigationBarItem(
      label: "More",
      icon: Icon(Icons.music_note),
    ),
  ];

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }
}