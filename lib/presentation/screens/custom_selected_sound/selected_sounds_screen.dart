import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/data/local/model/sound.dart';
import 'package:rain_sounds/presentation/base/navigation_service.dart';
import 'package:rain_sounds/presentation/screens/custom_selected_sound/save_custom_screen.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_bloc.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_event.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/constants.dart';

class SelectedSoundsScreen extends StatefulWidget {
  const SelectedSoundsScreen({Key? key, required this.soundsBloc})
      : super(key: key);

  final SoundsBloc soundsBloc;

  @override
  State<SelectedSoundsScreen> createState() => _SelectedSoundsScreenState();
}

class _SelectedSoundsScreenState extends State<SelectedSoundsScreen> {
  List<Sound> sounds = List.empty();

  @override
  void initState() {
    loadSelectedSounds();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF201936),
            child: SafeArea(
                child: Column(
              children: [
                sounds.isNotEmpty
                    ? SizedBox(
                      child: ListView.builder(
                          itemCount: sounds.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return SoundItem(
                              sound: sounds[index],
                              soundsBloc: widget.soundsBloc,
                              onRemoveClicked: () {
                                widget.soundsBloc.add(UpdateSound(
                                    soundId: sounds[index].id,
                                    active: false,
                                    volume: sounds[index].volume));
                                sounds.removeAt(index);
                                setState(() {});
                              },
                            );
                          }),
                    )
                    : Container(),
                const Spacer(),
                SaveCustomButton(
                  text: 'Save Custom',
                  onTap: () {
                    getIt
                        .get<NavigationService>()
                        .navigateToScreen(screen: SaveCustomScreen(
                      sounds: sounds,
                    ));
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: SizedBox(
                    width: 40,
                    height: 50,
                    child: Column(
                      children: [
                        SvgPicture.asset(IconPaths.icCloseArrow),
                        const Text(
                          'Close',
                          style: TextStyle(color: Colors.white70),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ))));
  }

  Future<void> loadSelectedSounds() async {
    sounds = await widget.soundsBloc.soundService.getSelectedSounds();
    setState(() {});
  }
}

class SoundItem extends StatefulWidget {
  const SoundItem(
      {Key? key,
      required this.sound,
      required this.soundsBloc,
      required this.onRemoveClicked})
      : super(key: key);

  final Sound sound;
  final SoundsBloc soundsBloc;
  final VoidCallback onRemoveClicked;

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
    final extension = widget.sound.icon?.split('.').last;
    return Container(
      margin: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(
            width: 8,
          ),
          SizedBox(
            width: 75,
            child: Column(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  margin: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: SizedBox(
                    child: extension == 'svg'
                        ? SvgPicture.asset(
                            '${Assets.baseIconPath}/${widget.sound.icon}')
                        : Image.asset(
                            '${Assets.baseIconPath}/${widget.sound.icon}'),
                  ),
                ),
                Text(
                  widget.sound.name ?? '',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          buildVolumeSlider(),
          InkWell(
            child: SvgPicture.asset(IconPaths.icClose),
            onTap: widget.onRemoveClicked,
          ),
          const SizedBox(
            width: 24,
          )
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

class SaveCustomButton extends StatelessWidget {
  const SaveCustomButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: size.width * 0.9,
        height: 40,
        decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
