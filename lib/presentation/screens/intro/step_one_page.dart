import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/color_constant.dart';

class StepOnePage extends StatelessWidget {
  const StepOnePage({Key? key, required this.onNextClicked}) : super(key: key);

  final VoidCallback onNextClicked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage(ImagePaths.bgOnBoarding),
        fit: BoxFit.fill,
      )),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 64,
              ),
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Your sleep is going to be\n so much better!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                      textStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  )),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              const SizedBox(
                width: double.infinity,
                child: Image(
                  image: AssetImage(ImagePaths.imgMoon),
                ),
              ),
              Text(
                'Ready to commit?',
                style: GoogleFonts.nunito(
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(IconPaths.icConfirm),
                  const SizedBox(
                    width: 8,
                  ),
                  Text('Reduce Stress',
                      style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 16))),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(IconPaths.icConfirm),
                  const SizedBox(
                    width: 8,
                  ),
                  Text('Sleep Better',
                      style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 16)))
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(IconPaths.icConfirm),
                  const SizedBox(
                    width: 8,
                  ),
                  Text('Increase Happiness',
                      style: GoogleFonts.nunito(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 16)))
                ],
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  onNextClicked();
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
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Next',
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
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
