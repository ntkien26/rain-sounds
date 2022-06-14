import 'package:flutter/widgets.dart';

class SoundsScreen extends StatefulWidget {
  const SoundsScreen({Key? key}) : super(key: key);

  @override
  State<SoundsScreen> createState() => _SoundsScreenState();
}

class _SoundsScreenState extends State<SoundsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Sounds'));
  }
}
