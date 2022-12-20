import 'package:omega_clock/modules/set_timer_finish.dart';

class SelectSound {
  void getSound(String selectedItemSound) {
    switch (selectedItemSound) {
      case "Default":
        sound_timer = "assets/sounds/sound_default.mp3";
        break;
      case "Iphone":
        sound_timer = "assets/sounds/sound_iphone.mp3";
        break;
      case "Tick Tock":
        sound_timer = "assets/sounds/sound_tick.mp3";
        break;
      case "Long Tick":
        sound_timer = "assets/sounds/sound_tick_long.mp3";
        break;
      case "Nirvana":
        sound_timer = "assets/sounds/sound_nirvana.mp3";
        break;
    }
  }
}
