import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rain_sounds/domain/service/sound_service.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';

class StepTwoPage extends StatelessWidget {
  const StepTwoPage({Key? key, required this.onNextClicked}) : super(key: key);

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
                  '50+ mix sounds - music collection',
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
                future: rootBundle.loadString(Assets.mixesJson),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final mixes = mixesFromJson(snapshot.data!);
                    return Expanded(
                      child: GridView.builder(
                          itemCount: mixes.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  crossAxisCount: 3),
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset(
                                  '${Assets.baseImagesPath}/${mixes[index].cover?.thumbnail}.webp'),
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
                  'Relax and fall asleep faster with relaxing content selected just for you',
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
