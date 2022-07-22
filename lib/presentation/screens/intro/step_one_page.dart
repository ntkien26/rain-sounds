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
              image: AssetImage(ImagePaths.bgMoreScreen), fit: BoxFit.fill)),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 64,
              ),
              SizedBox(height: 100, child: Image.asset(ImagePaths.icSleeping)),
              const SizedBox(
                height: 24,
              ),
              Text(
                'Your sleep is going to be so much better!',
                style: GoogleFonts.nunito(
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24)),
              ),
              const SizedBox(
                height: 48,
              ),
              Text(
                'Ready to commit?',
                style: GoogleFonts.nunito(
                    textStyle: const TextStyle(
                        color: Colors.amberAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(IconPaths.icCheckedGreen),
                  const SizedBox(width: 8,),
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
                  SvgPicture.asset(IconPaths.icCheckedGreen),
                  const SizedBox(width: 8,),
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
                  SvgPicture.asset(IconPaths.icCheckedGreen),
                  const SizedBox(width: 8,),
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
