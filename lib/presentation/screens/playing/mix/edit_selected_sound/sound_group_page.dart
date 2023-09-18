import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rain_sounds/common/configs/app_cache.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/data/local/model/sound.dart';
import 'package:rain_sounds/presentation/base/navigation_service.dart';
import 'package:rain_sounds/presentation/screens/in_app_purchase/in_app_purchase_screen.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/edit_selected_sound/edit_selected_sound_bloc.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';

import 'edit_selected_sound_event.dart';

class SoundGroupPage extends StatelessWidget {
  const SoundGroupPage(
      {Key? key, required this.sounds, required this.editSelectedSoundBloc})
      : super(key: key);

  final List<Sound> sounds;
  final EditSelectedSoundBloc editSelectedSoundBloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 4,
          childAspectRatio: 0.75,
          children: sounds
              .map((e) => SoundItem(
                    sound: e,
                    editSelectedSoundBloc: editSelectedSoundBloc,
                  ))
              .toList()),
    );
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
  final ValueNotifier<bool> active = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final AppCache appCache = getIt.get();
    _onButtonClick() {
      if (widget.sound.premium && !appCache.isPremiumMember()) {
        getIt<NavigationService>()
            .navigateToScreen(screen: const InAppPurchaseScreen());
      } else {
        widget.editSelectedSoundBloc.add(UpdateSound(
            soundId: widget.sound.id, active: active.value, volume: 80));
      }
    }

    final extension = widget.sound.icon?.split('.').last;
    return ValueListenableBuilder<bool>(
        valueListenable: active,
        builder: (context, value, child) {
          return InkWell(
            splashColor: Colors.black,
            onTap: () {
              active.value = !active.value;
              _onButtonClick;
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8, bottom: 4),
              decoration: BoxDecoration(
                // color: active ? Colors.blueAccent : Colors.white10,
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                // border: Border.all(color: active ? k7F65F0 : Colors.transparent),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  transform: GradientRotation(5.50),
                  colors: [
                    k181E4A,
                    k202968,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 8,
                    offset: const Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width / 4,
                        width: MediaQuery.of(context).size.width / 4,
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          gradient: active.value
                              ? const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  transform: GradientRotation(5.50),
                                  colors: [
                                    k7F65F0,
                                    k5C40DF,
                                  ],
                                )
                              : const LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  transform: GradientRotation(5.50),
                                  colors: [
                                    k2F366D,
                                    k404B99,
                                  ],
                                ),
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                        ),
                        child: SizedBox(
                          child: extension == 'svg'
                              ? SvgPicture.asset(
                                  '${Assets.baseIconPath}/${widget.sound.icon}')
                              : Image.asset(
                                  '${Assets.baseIconPath}/${widget.sound.icon}'),
                        ),
                      ),
                      if (widget.sound.premium == true &&
                          !appCache.isPremiumMember())
                        Positioned(
                          top: 0,
                          right: 0,
                          child: SvgPicture.asset(
                            IconPaths.icCrown,
                            height: 20,
                            width: 20,
                          ),
                        )
                      else
                        const SizedBox()
                    ],
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
            ),
          );
        });
  }
}
