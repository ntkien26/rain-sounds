import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rain_sounds/data/local/model/sound.dart';
import 'package:rain_sounds/domain/service/sound_service.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';

class StepThreePage extends StatelessWidget {
  const StepThreePage({Key? key, required this.onNextClicked})
      : super(key: key);

  final VoidCallback onNextClicked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(ImagePaths.bgMoreScreen), fit: BoxFit.fill)),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 32,
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  '100+ nature sounds',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                      textStyle: const TextStyle(
                          color: Colors.amberAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              FutureBuilder<String>(
                future: rootBundle.loadString(Assets.soundsJson),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final sounds = soundsFromJson(snapshot.data!);
                    return Expanded(
                      child: GridView.builder(
                          itemCount: sounds.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 15,
                                  crossAxisSpacing: 4,
                                  crossAxisCount: 3),
                          itemBuilder: (context, index) {
                            final Sound sound = sounds[index];
                            final extension = sound.icon?.split('.').last;
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: const BoxDecoration(
                                      color: Colors.white10,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  child: SizedBox(
                                    child: extension == 'svg'
                                        ? SvgPicture.asset(
                                            '${Assets.baseIconPath}/${sound.icon}')
                                        : Image.asset(
                                            '${Assets.baseIconPath}/${sound.icon}'),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  sound.name ?? '',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.nunito(
                                      textStyle: const TextStyle(
                                    color: Colors.white,
                                  )),
                                )
                              ],
                            );
                          }),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                  'Listen to music like meditation at bedtime to boost sleep efficiency',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 16)),
              const SizedBox(
                height: 24,
              ),
              TextButton(
                onPressed: () {
                  onNextClicked();
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          side: const BorderSide(color: kb62f69))),
                  backgroundColor: MaterialStateProperty.all<Color>(kb62f69),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Next',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
