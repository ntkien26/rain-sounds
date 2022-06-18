import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rain_sounds/data/local/model/sound.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_bloc.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_event.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/constants.dart';

class SoundGroupPage extends StatelessWidget {
  const SoundGroupPage(
      {Key? key, required this.sounds, required this.soundsBloc})
      : super(key: key);

  final List<Sound> sounds;
  final SoundsBloc soundsBloc;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        children: sounds
            .map((e) => SoundItem(
                  sound: e,
                  soundsBloc: soundsBloc,
                ))
            .toList());
  }
}

class SoundItem extends StatefulWidget {
  const SoundItem({
    Key? key,
    required this.sound,
    required this.soundsBloc,
  }) : super(key: key);

  final Sound sound;
  final SoundsBloc soundsBloc;

  @override
  State<SoundItem> createState() => _SoundItemState();
}

class _SoundItemState extends State<SoundItem> {
  bool active = false;
  double volume = 1;

  @override
  void initState() {
    super.initState();
    active = widget.sound.active;
    volume = widget.sound.volume.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    _onButtonClick() {
      setState(() {
        active = !active;
      });
      widget.soundsBloc.add(UpdateSound(
          soundId: widget.sound.id, active: active, volume: volume));
    }
    final extension = widget.sound.icon?.split('.').last;
    return InkWell(
      splashColor: Colors.black,
      onTap: _onButtonClick,
      child: Column(
        children: [
          const SizedBox(
            height: 8,
          ),
          Container(
            height: 65,
            width: 65,
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: active ? Colors.blueAccent : Colors.white10,
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: SizedBox(
              child: extension == 'svg'
                  ? SvgPicture.asset(
                      '${Assets.baseIconPath}/${widget.sound.icon}')
                  : Image.asset('${Assets.baseIconPath}/${widget.sound.icon}'),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Expanded(
            child: Text(
              widget.sound.name ?? '',
              textAlign: TextAlign.center,
              maxLines: 1,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          active ? buildVolumeSlider() : const SizedBox()
        ],
      ),
    );
  }

  Widget buildVolumeSlider() {
    _onVolumeChanged(double volume) {
      setState(() {
        this.volume = volume;
      });
      widget.soundsBloc.add(UpdateSound(
          soundId: widget.sound.id, active: active, volume: volume));
    }

    return Expanded(
      child: Slider(
        value: volume,
        min: Constants.minSliderValue,
        max: Constants.maxSliderValue,
        onChanged: active
            ? (double newValue) {
                _onVolumeChanged(newValue.round().toDouble());
              }
            : null,
      ),
    );
  }
}
