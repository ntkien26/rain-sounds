import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/data/local/hive_model/custom_mix_model.dart';
import 'package:rain_sounds/data/local/hive_model/sound_model.dart';
import 'package:rain_sounds/data/local/model/sound.dart';
import 'package:rain_sounds/presentation/base/base_stateful_widget.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';
import 'package:rain_sounds/presentation/utils/constants.dart';

class SaveCustomScreen extends StatefulWidget {
  const SaveCustomScreen({Key? key, required this.sounds}) : super(key: key);

  final List<Sound> sounds;

  @override
  State<SaveCustomScreen> createState() => _SaveCustomScreenState();
}

int indexSelected = 0;

class _SaveCustomScreenState extends State<SaveCustomScreen> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Container(
        color: k1d132b,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: h / 5),
            child: Container(
              padding: const EdgeInsets.only(top: 12, left: 12),
              decoration: BoxDecoration(
                color: kFirstPrimaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: SvgPicture.asset(
                              IconPaths.icClose,
                              color: Colors.black26,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Name',
                              style: TextStyle(fontSize: 12),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 52),
                              child: TextField(
                                  controller: textEditingController,
                                  textAlign: TextAlign.center,
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black12),
                                    ),
                                  )),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'Cover',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: h / 6,
                          child: ListView.builder(
                            itemBuilder: (_, index) {
                              return Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        indexSelected = index;
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(2)
                                          .copyWith(top: 20),
                                      width: w / 3.5,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                '${Assets.baseImagesPath}/${Constants.listBgCover[index]}.webp'),
                                          ),
                                          color: Colors.black12),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 4, bottom: 4),
                                          child: indexSelected == index
                                              ? SvgPicture.asset(
                                                  IconPaths.icSelectBlue,
                                                  height: 20,
                                                  width: 20,
                                                )
                                              : const SizedBox(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  )
                                ],
                              );
                            },
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: 8,
                          )),
                    ],
                  ),
                  Positioned.fill(
                    bottom: 32,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: InkWell(
                          onTap: () async {
                            final Box<CustomMixModel> box = getIt.get();
                            final sounds = widget.sounds
                                .map((e) => SoundModel(
                                    id: e.id,
                                    name: e.name,
                                    fileName: e.fileName,
                                    icon: e.icon,
                                    volume: e.volume,
                                    premium: e.premium))
                                .toList();
                            await box.add(
                              CustomMixModel(
                                  name: textEditingController.text,
                                  thumbnail: Constants.listBgCover[indexSelected],
                                  sounds: sounds),
                            );
                            Fluttertoast.showToast(msg: 'Save custom success');
                            Navigator.pop(context);
                          },
                          child: SvgPicture.asset(
                            IconPaths.icChecked,
                            height: 60,
                            width: 60,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
