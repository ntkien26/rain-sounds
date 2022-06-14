import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/presentation/base/base_stateful_widget.dart';

class AppRoute {
  static Route<dynamic> getRoute(RouteSettings settings) {
    Widget widget;
    try {
      widget = getIt<Widget>(
        instanceName: settings.name,
        param1: settings.arguments,
      );
    } catch (e) {
      widget = Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Không tìm thấy trang'),
        ),
        body: const Center(
          child: Text('Page not found'),
        ),
      );
    }
    return MaterialPageRoute<dynamic>(
      settings: RouteSettings(name: settings.name),
      builder: (BuildContext ctx) => widget,
    );

  }

  Future<Widget> buildPageAsync(Widget widget)  {
    return Future.microtask(() {
      return widget;
    });
  }
}