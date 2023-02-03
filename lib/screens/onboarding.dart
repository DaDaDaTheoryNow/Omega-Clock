// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:omega_clock/generated/locale_keys.g.dart';
import 'package:omega_clock/home.dart';
import 'package:omega_clock/widgets/settings/settings_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:omega_clock/modules/simple_gradient_text.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
              clipBehavior: Clip.hardEdge,
              content: Padding(
                padding: const EdgeInsets.only(left: 3, right: 3),
                child: SizedBox(
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 45),
                        child: Text(
                          LocaleKeys.onboarding_Initial_settings.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                          ),
                        ),
                      ),

                      // language changer
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: 65,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).splashColor,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LocaleKeys.settings_main_Change_language.tr(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                  color: Colors.black,
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        switch (LocaleKeys
                                            .settings_main_language
                                            .tr()) {
                                          case "English":
                                            setState(() {
                                              context.setLocale(Locale("ru"));
                                            });
                                            break;
                                          case "Русский":
                                            setState(() {
                                              context.setLocale(Locale("en"));
                                            });
                                            break;
                                          default:
                                        }
                                      },
                                      child: Text(LocaleKeys
                                          .settings_main_language
                                          .tr()))),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
              actions: [
                Center(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("OK")),
                  ),
                ))
              ],
            );
          });
    });
  }

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
    TextStyle bodyStyle = const TextStyle(fontSize: 17.0);

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
          child: Text(
            LocaleKeys.onboarding_Lets_go_right_away.tr(),
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      pages: [
        PageViewModel(
          title: LocaleKeys.onboarding_Best_app.tr(),
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                LocaleKeys.onboarding_Made_by.tr(),
                textAlign: TextAlign.center,
                style: bodyStyle,
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
              Text(LocaleKeys.onboarding_class.tr(), style: bodyStyle),
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
          title: LocaleKeys.onboarding_Easy_to_use.tr(),
          body: LocaleKeys.onboarding_The_app_is_easy_to_use.tr(),
          image: _buildImage('splash.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: LocaleKeys.onboarding_Comfortable_size.tr(),
          body: LocaleKeys.onboarding_The_application_weighs_very_little.tr(),
          image: _buildImage('splash.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: LocaleKeys.onboarding_Full_control_of_your_time.tr(),
          body: LocaleKeys.onboarding_24_application_will_help.tr(),
          image: _buildImage('splash.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: LocaleKeys.onboarding_One_click_alarm.tr(),
          bodyWidget: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                LocaleKeys.onboarding_Add_your_alarm_with.tr(),
                textAlign: TextAlign.center,
                style: bodyStyle,
                //textDirection: TextDirection.ltr,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_alarm_sharp,
                      color: Color.fromARGB(201, 8, 233, 15),
                    ),
                    Text(LocaleKeys.onboarding_button.tr(), style: bodyStyle),
                  ],
                ),
              )
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
      done: Text(LocaleKeys.onboarding_Done.tr(),
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
