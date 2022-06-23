import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rain_sounds/data/local/model/sound.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/edit_selected_sound/edit_selected_sound_bloc.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';

import 'edit_selected_sound_event.dart';

class SoundGroupPage extends StatelessWidget {
  const SoundGroupPage(
      {Key? key, required this.sounds, required this.editSelectedSoundBloc})
      : super(key: key);

  final List<Sound> sounds;
  final EditSelectedSoundBloc editSelectedSoundBloc;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        children: sounds
            .map((e) => SoundItem(
          sound: e,
          editSelectedSoundBloc: editSelectedSoundBloc,
        ))
            .toList());
  }
}

class SoundItem extends StatefulWidget {
  const SoundItem({
    Key? key,
    required this.sound,
    required this.editSelectedSoundBloc,
  }) : super(key: key);

  final Sound sound;
  final EditSelectedSoundBloc editSelectedSoundBloc;

  @override
  State<SoundItem> createState() => _SoundItemState();
}

class _SoundItemState extends State<SoundItem> {

  @override
  Widget build(BuildContext context) {
    _onButtonClick() {
      widget.editSelectedSoundBloc.add(UpdateSound(
          soundId: widget.sound.id, active: true, volume: 80));
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
            decoration: const BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.all(Radius.circular(20))),
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
        ],
      ),
    );
  }

}
