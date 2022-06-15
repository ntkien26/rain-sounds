import 'package:flutter/material.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(ImagePaths.background_more_screen),
              fit: BoxFit.fill)),
    );
  }
}
