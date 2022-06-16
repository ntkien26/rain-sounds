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
        mainAxisSpacing: 15,
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
          SizedBox(
            height: 50,
            width: 50,
            child: extension == 'svg'
                ? SvgPicture.asset(
                    '${Assets.baseIconPath}/${widget.sound.icon}.svg')
                : Image.asset(
                    '${Assets.baseIconPath}/${widget.sound.icon}.png'),
          ),
          const SizedBox(height: 12,),
          Text(
            widget.sound.name ?? '',
            style: const TextStyle(color: Colors.white),
          ),
          buildVolumeSlider()
        ],
      ),
    );
  }

  Slider buildVolumeSlider() {
    _onVolumeChanged(double volume) {
      setState(() {
        this.volume = volume;
      });
      widget.soundsBloc.add(UpdateSound(
          soundId: widget.sound.id, active: active, volume: volume));
    }

    return Slider(
      value: volume,
      min: Constants.minSliderValue,
      max: Constants.maxSliderValue,
      onChanged: active
          ? (double newValue) {
              _onVolumeChanged(newValue.round().toDouble());
            }
          : null,
    );
  }
}
