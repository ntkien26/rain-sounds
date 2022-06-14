import 'package:flutter/material.dart';

class SoundGroupPage extends StatelessWidget {
  const SoundGroupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      // Generate 100 widgets that display their index in the List.
      children: List.generate(9, (index) {
        return const SoundItem();
      }),
    );
  }
}

class SoundItem extends StatefulWidget {
  const SoundItem({
    Key? key,
  }) : super(key: key);

  @override
  State<SoundItem> createState() => _SoundItemState();
}

class _SoundItemState extends State<SoundItem> {

  double _volume = 100;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Column(
        children: [
          const SizedBox(
            height: 50,
            width: 50,
          ),
          Text(
            'Item',
            style: Theme.of(context).textTheme.headline5,
          ),
          Slider(
            min: 0.0,
            max: 100.0,
            value: _volume,
            onChanged: (value) {
              setState(() {
                _volume = value;
              });
            },
          )
        ],
      ),
    );
  }
}
