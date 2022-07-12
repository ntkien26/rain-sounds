import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/data/local/model/mix.dart';
import 'package:rain_sounds/data/local/model/sound.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/edit_selected_sound/edit_selected_sound_bloc.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/edit_selected_sound/edit_selected_sound_state.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/edit_selected_sound/sound_group_page.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/constants.dart';

import 'edit_selected_sound_event.dart';

class EditSelectedSoundScreen extends StatefulWidget {
  const EditSelectedSoundScreen({Key? key, required this.mix})
      : super(key: key);

  final Mix mix;

  @override
  State<EditSelectedSoundScreen> createState() =>
      _EditSelectedSoundScreenState();
}

class _EditSelectedSoundScreenState extends State<EditSelectedSoundScreen> {
  final EditSelectedSoundBloc _bloc = getIt.get();
  int _selectedIndex = 0;

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
                print('State changed: ${state.status}');
                if (state.status == EditSelectedSoundStatus.empty) {
                  return Container();
                } else {
                  int totalPage = (state.sounds!.length / 9).round();
                  if ((state.sounds!.length / 9).round() <
                      state.sounds!.length / 9) {
                    totalPage = (state.sounds!.length / 9).round() + 1;
                  }
                  final List<List<Sound>> lists = List.empty(growable: true);
                  for (int i = 0; i < totalPage; i++) {
                    int startIndex = i * 9;
                    int endIndex = startIndex + 9;
                    if (endIndex < state.sounds!.length) {
                      var page = state.sounds?.sublist(startIndex, endIndex) ??
                          List.empty();
                      lists.add(page);
                    } else {
                      var page = state.sounds
                              ?.sublist(startIndex, state.sounds!.length) ??
                          List.empty();
                      lists.add(page);
                    }
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'Current Selection',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 170,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.selectedSounds?.length ?? 0,
                            itemBuilder: (context, index) {
                              return SelectedSoundItem(
                                  sound: state.selectedSounds![index],
                                  editSelectedSoundBloc: _bloc);
                            }),
                      ),
                      Flexible(
                        flex: 5,
                        child: PageView.builder(
                            itemCount: totalPage,
                            onPageChanged: (page) {
                              setState(() {
                                _selectedIndex = page;
                              });
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return SoundGroupPage(
                                sounds: lists[index],
                                editSelectedSoundBloc: _bloc,
                              );
                            }),
                      ),
                      Flexible(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    IconPaths.icClose,
                                    width: 20,
                                    height: 20,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  const Text(
                                    'Cancel',
                                    style: TextStyle(color: Colors.white38),
                                  )
                                ],
                              ),
                              DotsIndicator(
                                dotsCount: totalPage,
                                position: _selectedIndex.toDouble(),
                                decorator: const DotsDecorator(
                                  color: Colors.white30, // Inactive color
                                  activeColor: Colors.white,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _bloc.add(ResetEvent(mix: widget.mix));
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      IconPaths.icReset,
                                      width: 20,
                                      height: 20,
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    const Text(
                                      'Reset',
                                      style: TextStyle(color: Colors.white38),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
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
        Stack(
          children: [
            Container(
              height: 65,
              width: 65,
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
            Positioned(
              top: 8,
              right: 8,
              child: InkWell(
                onTap: () {
                  widget.editSelectedSoundBloc.add(UpdateSound(
                      soundId: widget.sound.id, active: false, volume: volume));
                },
                child: SvgPicture.asset(
                  IconPaths.icClose,
                  height: 20,
                  width: 20,
                ),
              ),
            )
          ],
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
      width: 130,
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
