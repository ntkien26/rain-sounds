import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/data/local/model/mix.dart';
import 'package:rain_sounds/data/local/model/sound.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/edit_selected_sound/edit_selected_sound_bloc.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/edit_selected_sound/edit_selected_sound_state.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/edit_selected_sound/sound_group_page.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';
import 'package:rain_sounds/presentation/utils/constants.dart';

import 'edit_selected_sound_event.dart';

class EditSelectedSoundScreen extends StatefulWidget {
  const EditSelectedSoundScreen({
    Key? key,
    required this.mix,
    required this.selection,
    required this.onCancelClick,
  }) : super(key: key);

  final Mix mix;
  final int selection;
  final VoidCallback onCancelClick;

  @override
  State<EditSelectedSoundScreen> createState() =>
      _EditSelectedSoundScreenState();
}

class _EditSelectedSoundScreenState extends State<EditSelectedSoundScreen> {
  final EditSelectedSoundBloc _bloc = getIt.get();
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.selection == 0
          ? (MediaQuery.of(context).size.height/2)
          : (MediaQuery.of(context).size.height* 0.965),
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
                if (widget.selection == 0) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.all(12.0).copyWith(left: 8),
                          child: const Text(
                            'Customize volume',
                            style: TextStyle(
                              color: kFFFFFF,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                          child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: state.selectedSounds?.length ?? 0,
                              itemBuilder: (context, index) {
                                return SelectedSoundItem(
                                    sound: state.selectedSounds![index],
                                    editSelectedSoundBloc: _bloc);
                              }),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.all(8).copyWith(bottom: 0),
                          child: TextButton(
                            onPressed: widget.onCancelClick,
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
                                borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                child: SizedBox(
                                  width:
                                  MediaQuery.of(context).size.width - 32,
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
                          padding:
                          const EdgeInsets.all(8).copyWith(bottom: 0),
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
                                borderRadius:
                                BorderRadius.all(Radius.circular(100)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16, horizontal: 16),
                                child: SizedBox(
                                  width:
                                  MediaQuery.of(context).size.width - 32,
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
                      ],
                    ),
                  );
                }
                else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.all(12.0).copyWith(left: 8),
                        child: const Text(
                          'Customize volume',
                          style: TextStyle(
                            color: kFFFFFF,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Expanded(
                        flex: 1,
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
                      Center(
                        child: DotsIndicator(
                          dotsCount: totalPage,
                          position: _selectedIndex.toDouble(),
                          decorator: const DotsDecorator(
                            color: Colors.white30, // Inactive color
                            activeColor: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.all(8).copyWith(bottom: 0),
                        child: TextButton(
                          onPressed: widget.onCancelClick,
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
                              borderRadius:
                              BorderRadius.all(Radius.circular(100)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 16),
                              child: SizedBox(
                                width:
                                MediaQuery.of(context).size.width - 32,
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
                    ],
                  );
                }
              }
            }),
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
            onTap: () {
              widget.editSelectedSoundBloc.add(UpdateSound(
                  soundId: widget.sound.id, active: false, volume: volume));
            },
            child: SvgPicture.asset(IconPaths.icCancelGray),
          ),
          // const SizedBox(
          //   width: 24,
          // )
        ],
      ),
    );
    // return Column(
    //   children: [
    //     const SizedBox(
    //       height: 8,
    //     ),
    //     Stack(
    //       children: [
    //         Container(
    //           height: 65,
    //           width: 65,
    //           margin: const EdgeInsets.all(4),
    //           decoration: const BoxDecoration(
    //               color: Colors.blueAccent,
    //               borderRadius: BorderRadius.all(Radius.circular(20))),
    //           child: SizedBox(
    //             child: extension == 'svg'
    //                 ? SvgPicture.asset(
    //                     '${Assets.baseIconPath}/${widget.sound.icon}')
    //                 : Image.asset(
    //                     '${Assets.baseIconPath}/${widget.sound.icon}'),
    //           ),
    //         ),
    //         Positioned(
    //           top: 8,
    //           right: 8,
    //           child: InkWell(
    //             onTap: () {
    //               widget.editSelectedSoundBloc.add(UpdateSound(
    //                   soundId: widget.sound.id, active: false, volume: volume));
    //             },
    //             child: SvgPicture.asset(
    //               IconPaths.icClose,
    //               height: 20,
    //               width: 20,
    //             ),
    //           ),
    //         )
    //       ],
    //     ),
    //     const SizedBox(
    //       height: 12,
    //     ),
    //     Text(
    //       widget.sound.name ?? '',
    //       textAlign: TextAlign.center,
    //       maxLines: 1,
    //       style: const TextStyle(color: Colors.white),
    //     ),
    //     buildVolumeSlider()
    //   ],
    // );
  }

  Widget buildVolumeSlider() {
    _onVolumeChanged(double volume) {
      setState(() {
        this.volume = volume;
      });
      widget.editSelectedSoundBloc.add(UpdateSound(
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
