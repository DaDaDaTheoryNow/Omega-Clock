// ignore_for_file: deprecated_member_use

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:omega_clock/generated/codegen_loader.g.dart';
import 'package:omega_clock/home.dart';
import 'package:omega_clock/modules/notifications.dart';
import 'package:omega_clock/modules/set_sound_timer.dart';
import 'package:omega_clock/screens/onboarding.dart';
import 'package:omega_clock/widgets/settings/settings_main.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:omega_clock/modules/simple_gradient_text.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    print("Task executing: " + taskName);
    switch (taskName) {
      case "missAlarm":
        Noti.showBigTextNotification(
            title: "Go back (click)",
            body: "Your alarm clocks miss you ;(",
            fln: flutterLocalNotificationsPlugin);
        break;
      case "controlAlarm":
        Noti.showBigTextNotification(
            title: "Omega Clock",
            body: "Control your time with Omega Clock",
            fln: flutterLocalNotificationsPlugin);
        break;
      default:
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Workmanager().initialize(callbackDispatcher);

  // get isStarted info
  final prefs = await SharedPreferences.getInstance();
  final isStarted = prefs.getBool("Started") ?? false;
  debugPrint("get isStarted '$isStarted'");

  // get selectSound for timer
  final selectedItemSound = prefs.getString("SelectSound") ?? "Default";
  SelectSound().getSound(selectedItemSound);
  debugPrint("get TimerSound '$selectedItemSound'");

  // get selectTheme
  selectedItemTheme = prefs.getString("SelectTheme") ?? "Dark";
  debugPrint("get Theme '$selectedItemTheme'");

  // get backgroundNotifications
  isNotifications = prefs.getBool("Notifications") ?? true;
  debugPrint("get Notifications '$isNotifications'");
  if (isNotifications) {
    Workmanager().cancelByUniqueName("missAlarm");
    Workmanager().cancelByUniqueName("controlAlarm");
    // start again
    Workmanager().registerPeriodicTask("missAlarm", "missAlarm",
        initialDelay: Duration(hours: 54), frequency: Duration(hours: 54));
    Workmanager().registerPeriodicTask("controlAlarm", "controlAlarm",
        initialDelay: Duration(hours: 24), frequency: Duration(hours: 24));

    debugPrint("Notifications on");
  } else {
    Workmanager().cancelByUniqueName("missAlarm");
    Workmanager().cancelByUniqueName("controlAlarm");

    debugPrint("Notifications off");
  }

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ru')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      assetLoader: CodegenLoader(),
      child: OmegaClockApp(isStarted: isStarted),
    ),
  );
}

class SplashScreen extends StatefulWidget {
  final bool isStarted;
  const SplashScreen({Key? key, required this.isStarted}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: Theme.of(context).backgroundColor,
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: SizedBox(
              height: 95,
              width: 95,
              child: Image(
                image: AssetImage("assets/images/splash.png"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: GradientText(
              'Omega Clock',
              style: const TextStyle(
                fontSize: 42.5,
              ),
              colors: const [
                Colors.blue,
                Colors.red,
                Colors.teal,
                Colors.purple,
              ],
            ),
          ),
          GradientText(
            'by Vladislav Smirnov',
            style: const TextStyle(
              fontSize: 12.5,
            ),
            colors: const [
              Colors.blue,
              Colors.red,
              Colors.teal,
              Colors.purple,
            ],
          ),
        ],
      ),
      nextScreen: widget.isStarted ? const HomePage() : const OnboardingPage(),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
      animationDuration: const Duration(milliseconds: 435),
      duration: 435,
    );
  }
}

class OmegaClockApp extends StatelessWidget {
  final bool isStarted;
  const OmegaClockApp({Key? key, required this.isStarted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: AdaptiveTheme(
        // lightData
        light: ThemeData(
          brightness: Brightness.light,
          // splashColor theme || use all black colors widget in light theme
          splashColor: Colors.black,
          // background theme || use white widgets and background
          backgroundColor: Colors.white,
          // bottomAppBarColor theme || use scaffold backgroundColor
          bottomAppBarColor: Colors.lightBlue,
          // elevated button theme
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue),
          ),
          // hintColor theme use || disabled BottomBar icons
          hintColor: Colors.grey,
          // focusColor theme || use focus BottomBar icons
          focusColor: Colors.lightBlue,
          // accentColor theme || use in nothingWarningText
          accentColor: Colors.white,
          // errorColor theme || use bottom and up apps widgets
          errorColor: Colors.white,
          // appBar theme
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
          // DialogBackGround theme || week text color
          dialogBackgroundColor: Colors.black,
          // cardColor theme || use in card widget
          cardColor: const Color.fromARGB(255, 213, 206, 206),
          // canvasColor || use in widgetSpan alarm
          canvasColor: Colors.white,
          // icon theme
          iconTheme: IconThemeData(
            color: Colors.white,
            size: 35,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // darkData
        dark: ThemeData(
          brightness: Brightness.dark,
          // splashColor theme || use all black colors widget in light theme
          splashColor: const Color.fromARGB(
              195, 59, 182, 63), // use all green colors widget
          // background theme || use white widgets and background
          backgroundColor: Colors.black,
          // bottomAppBarColor theme || use scaffold backgroundColor
          bottomAppBarColor: Colors.black,
          // elevated button theme
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(201, 8, 233, 15)),
          ),
          // hintColor theme || disabled BottomBar icons
          hintColor: Colors.white,
          // focusColor theme || use focus BottomBar icons
          focusColor: const Color.fromARGB(195, 59, 182, 63),
          // accentColor theme || use in nothingWarningText
          accentColor: Colors.white,
          // errorColor theme || use bottom and up apps widgets
          errorColor: Colors.grey[900],
          // appBar theme
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(195, 59, 182, 63),
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
          // DialogBackGround theme || week text color
          dialogBackgroundColor: Colors.white,
          // cardColor theme || use in card widget
          cardColor: Colors.white,
          // canvasColor || use in widgetSpan alarm
          canvasColor: const Color.fromARGB(195, 59, 182, 63),
          // icon theme
          iconTheme: IconThemeData(
            color: Colors.white,
            size: 35,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initial: AdaptiveThemeMode.dark,
        builder: (theme, darkTheme) => MaterialApp(
          theme: theme,
          darkTheme: darkTheme,
          initialRoute: "/",
          routes: {
            "/": (ctx) => SplashScreen(isStarted: isStarted),
            "/home": (ctx) => HomePage(),
          },
        ),
      ),
    );
  }
}
