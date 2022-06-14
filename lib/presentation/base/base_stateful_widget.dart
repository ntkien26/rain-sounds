import 'package:flutter/material.dart';

export 'package:flutter/material.dart';

abstract class BaseStatefulWidget extends StatefulWidget {
  const BaseStatefulWidget({Key? key}) : super(key: key);

  Widget build(BuildContext context);

  void init(_BaseStatefulState state){}
  void dispose(){}

  @override
  _BaseStatefulState<BaseStatefulWidget> createState() =>
      _BaseStatefulState<BaseStatefulWidget>();
}

class _BaseStatefulState<T extends StatefulWidget> extends State<T>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  void initState() {
    (widget as BaseStatefulWidget).init(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return (widget as BaseStatefulWidget).build(context);
  }

  @override
  void dispose() {
    (widget as BaseStatefulWidget).dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}