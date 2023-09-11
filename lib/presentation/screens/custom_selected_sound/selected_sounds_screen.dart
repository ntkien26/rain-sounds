import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/data/local/model/sound.dart';
import 'package:rain_sounds/presentation/base/navigation_service.dart';
import 'package:rain_sounds/presentation/screens/custom_selected_sound/save_custom_screen.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_bloc.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_event.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';
import 'package:rain_sounds/presentation/utils/constants.dart';
import 'package:rain_sounds/presentation/utils/styles.dart';

class SelectedSoundsScreen extends StatefulWidget {
  const SelectedSoundsScreen(
      {Key? key,
      required this.soundsBloc,
      required this.onCancelClick,
      required this.onSaveCustomClick})
      : super(key: key);

  static const routeName = "selected-sounds";

  final SoundsBloc soundsBloc;
  final VoidCallback onCancelClick;
  final Function(List<Sound>) onSaveCustomClick;

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
    return Container(
        height: MediaQuery.of(context).size.height / 2,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              transform: GradientRotation(5.50),
              colors: [
                k202968,
                k181E4A,
              ],
            )),
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Customize volume",
                style: TextStyleConstant.mediumTextStyle
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              sounds.isNotEmpty
                  ? SizedBox(
                      child: ListView.builder(
                          itemCount: sounds.length,
                          physics: const NeverScrollableScrollPhysics(),
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
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(8).copyWith(bottom: 0),
                child: TextButton(
                  onPressed: () {
                    widget.onSaveCustomClick(sounds);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: const BorderSide(
                      color: k7F65F0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Ink(
                    padding: EdgeInsets.zero,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: <Color>[
                          k5C40DF,
                          k7F65F0,
                        ],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 32,
                        child: Text(
                          'Save Custom',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(8).copyWith(bottom: 0),
                child: TextButton(
                  onPressed: widget.onCancelClick,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    side: const BorderSide(
                      color: Colors.white,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  child: Ink(
                    padding: EdgeInsets.zero,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 32,
                        child: Text(
                          'Cancel',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // SaveCustomButton(
              //   text: 'Save Custom',
              //   onTap: () {
              //     getIt
              //         .get<NavigationService>()
              //         .navigateToScreen(screen: SaveCustomScreen(
              //       sounds: sounds,
              //     ));
              //   },
              // ),
              // const SizedBox(
              //   height: 16,
              // ),
              // InkWell(
              //   onTap: () {
              //     Navigator.of(context).pop();
              //   },
              //   child: SizedBox(
              //     width: 40,
              //     height: 50,
              //     child: Column(
              //       children: [
              //         SvgPicture.asset(IconPaths.icCloseArrow),
              //         const Text(
              //           'Close',
              //           style: TextStyle(color: Colors.white70),
              //         )
              //       ],
              //     ),
              //   ),
              // )
            ],
          ),
        ));
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
          // const SizedBox(
          //   width: 8,
          // ),
          SizedBox(
            child: Container(
              height: 75,
              width: 75,
              // margin: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                transform: GradientRotation(5.50),
                colors: [
                  k7F65F0,
                  k5C40DF,
                ],
              )),
              child: SizedBox(
                child: extension == 'svg'
                    ? SvgPicture.asset(
                        '${Assets.baseIconPath}/${widget.sound.icon}')
                    : Image.asset(
                        '${Assets.baseIconPath}/${widget.sound.icon}'),
              ),
            ),
          ),
          buildVolumeSlider(),
          InkWell(
            onTap: widget.onRemoveClicked,
            child: SvgPicture.asset(IconPaths.icCancelGray),
          ),
          // const SizedBox(
          //   width: 24,
          // )
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(
                width: 24,
              ),
              Text(
                widget.sound.name ?? '',
                textAlign: TextAlign.center,
                maxLines: 1,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          Slider(
            value: volume,
            min: Constants.minSliderValue,
            max: Constants.maxSliderValue,
            activeColor: Colors.white,
            onChanged: active
                ? (double newValue) {
                    _onVolumeChanged(newValue.round().toDouble());
                  }
                : null,
          ),
        ],
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
