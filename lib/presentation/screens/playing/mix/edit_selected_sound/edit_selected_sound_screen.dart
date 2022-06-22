import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/data/local/model/sound.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/edit_selected_sound/edit_selected_sound_bloc.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/edit_selected_sound/edit_selected_sound_state.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/constants.dart';

import 'edit_selected_sound_event.dart';

class EditSelectedSoundScreen extends StatelessWidget {
  EditSelectedSoundScreen({Key? key}) : super(key: key);

  final EditSelectedSoundBloc _bloc = getIt.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(ImagePaths.bgMoreScreen), fit: BoxFit.fill)),
        child: SafeArea(
          child: BlocBuilder<EditSelectedSoundBloc, EditSelectedSoundState>(
              bloc: _bloc,
              builder: (context, state) {
                print('EditSelectedSoundBloc sound: ${state.selectedSounds?.length}');
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12,),
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Current Selection',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    const SizedBox(height: 12,),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: state.selectedSounds?.length ?? 0,
                          itemBuilder: (context, index) {
                            return SelectedSoundItem(
                                sound: state.selectedSounds![index],
                                editSelectedSoundBloc: _bloc);
                          }
                      ),
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }
}

class SelectedSoundItem extends StatefulWidget {
  const SelectedSoundItem({
    Key? key,
    required this.sound,
    required this.editSelectedSoundBloc,
  }) : super(key: key);

  final Sound sound;
  final EditSelectedSoundBloc editSelectedSoundBloc;

  @override
  State<SelectedSoundItem> createState() => _SelectedSoundItemState();
}

class _SelectedSoundItemState extends State<SelectedSoundItem> {
  bool active = false;
  double volume = 1;

  @override
  Widget build(BuildContext context) {
    active = widget.sound.active;
    volume = widget.sound.volume.toDouble();
    final extension = widget.sound.icon?.split('.').last;
    return Column(
      children: [
        const SizedBox(
          height: 8,
        ),
        Container(
          height: 70,
          width: 70,
          margin: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
              color: Colors.blueAccent,
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
        Text(
          widget.sound.name ?? '',
          textAlign: TextAlign.center,
          maxLines: 1,
          style: const TextStyle(color: Colors.white),
        ),
        buildVolumeSlider()
      ],
    );
  }

  Widget buildVolumeSlider() {
    _onVolumeChanged(double volume) {
      setState(() {
        this.volume = volume;
      });
      widget.editSelectedSoundBloc.add(UpdateSound(
          soundId: widget.sound.id, active: active, volume: volume));
    }

    return SizedBox(
      width: 140,
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
