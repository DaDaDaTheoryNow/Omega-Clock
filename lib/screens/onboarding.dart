// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:omega_clock/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) async {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const HomePage()),
    );

    // onBordingPage or HomePage variable set
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("Started", true);
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/images/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle bodyStyle = const TextStyle(fontSize: 19.0);

    PageDecoration pageDecoration = PageDecoration(
      titleTextStyle:
          const TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 16.0),
      pageColor: Theme.of(context).backgroundColor,
      imagePadding: const EdgeInsets.only(top: 100),
      titlePadding: const EdgeInsets.only(top: 65),
      contentMargin: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Theme.of(context).backgroundColor,
      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: () => _onIntroEnd(context),
          child: const Text(
            'Let\'s go right away!',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      pages: [
        PageViewModel(
          title: "Best Free Alarm App",
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Made by ",
                textAlign: TextAlign.center,
                style: bodyStyle,
                textDirection: TextDirection.ltr,
              ),
              GradientText(
                "Smirnov Vladislav ",
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
                colors: const [
                  Colors.blue,
                  Colors.teal,
                  Colors.purple,
                ],
              ),
              Text("7 \"V\" class", style: bodyStyle),
            ],
          ),
          decoration: pageDecoration.copyWith(
            imagePadding: const EdgeInsets.only(top: 5),
            bodyFlex: 2,
            imageFlex: 4,
            bodyAlignment: Alignment.bottomCenter,
            imageAlignment: Alignment.topCenter,
          ),
          image: _buildImage('splash.png'),
          reverse: true,
        ),
        PageViewModel(
          title: "Easy to use",
          body: "Even your grandmother will understand this application!",
          image: _buildImage('splash.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Comfortable size",
          body:
              "The application weighs very little, and will go on many devices",
          image: _buildImage('splash.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Full control of your time",
          body: "24/7 application will help you in time",
          image: _buildImage('splash.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "One click alarm",
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Add your alarm with ",
                textAlign: TextAlign.center,
                style: bodyStyle,
                textDirection: TextDirection.ltr,
              ),
              const Icon(Icons.add_alarm_sharp),
              Text(" button", style: bodyStyle),
            ],
          ),
          image: _buildImage('splash.png'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      next: const Icon(Icons.arrow_forward),
      done: Text('Done',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Theme.of(context).splashColor,
          )),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: ShapeDecoration(
        color: Theme.of(context).backgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
