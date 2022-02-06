import 'dart:async';
import 'package:deep_convo/bot.dart';
import 'package:deep_convo/user_preferences.dart';

class AppState {
  bool _ttsEnabled = true;
  Bot _bot = const Bot('','','','',''); // Dummy initializer

  List<Bot> bots = [
    const Bot('Bob', 'en-us-x-iom-local', 'en-US', 'assets/images/usa.png', 'assets/images/face_bob.jpg'),
    const Bot('Emma', 'en-gb-x-gba-network', 'en-GB', 'assets/images/uk.png', 'assets/images/face_emma.jpg'),
    const Bot('Grace', 'en-au-x-aua-network', 'en-AU', 'assets/images/australia.png', 'assets/images/face_grace.jpg'),
    const Bot('Katrina', 'en-IN-language', 'en-IN', 'assets/images/india.png', 'assets/images/face_katrina.jpg'),
    const Bot('Kumar', 'en-in-x-end-local', 'en-IN', 'assets/images/india.png', 'assets/images/face_kumar.jpg'),
    const Bot('Olivia', 'en-us-x-iog-local', 'en-US', 'assets/images/usa.png', 'assets/images/face_olivia.jpg'),
  ];

  AppState() {
    _bot = bots[0]; // Bob
  }

  final StreamController<AppState> _changeController = StreamController<AppState>.broadcast();
  Stream get onChange => _changeController.stream;

  Future<void> initialize() async {
    String botName = await UserPreferences.getBotName();
    _bot = bots.firstWhere((element) => element.username == botName);
    _ttsEnabled = await UserPreferences.isTTSEnabled();
  }

  void _triggerOnChange() {
    _changeController.add(this);
  }

  Bot get bot => _bot;

  String get botName => _bot.username;
  set botName(String botName) {
    _bot = bots.firstWhere((element) => element.username == botName);
    UserPreferences.setBotName(botName);
    _triggerOnChange();
  }

  bool get ttsEnabled => _ttsEnabled;
  set ttsEnabled(bool enabled) {
    _ttsEnabled = enabled;
    UserPreferences.setTTSEnabled(enabled);
    _triggerOnChange();
  }
}