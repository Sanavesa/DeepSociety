import 'package:avatar_glow/avatar_glow.dart';
import 'package:deep_convo/app_api.dart';
import 'package:deep_convo/settings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'app_state.dart';

class ChatPage extends StatefulWidget {
  final String username;
  const ChatPage(this.username, {Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  final SpeechToText _speech2Text = SpeechToText();
  String _text = '';
  List<String> _chat = [];

  final FlutterTts _text2Speech = FlutterTts();
  late BuildContext _buildContext;

  final ScrollController _scrollController = ScrollController();
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    _initSpeech2Text();
    _initText2Speech();
  }

  Future<void> _loginAPI() async {
    AppState appState = Provider.of(_buildContext, listen: false);
    String reply = await AppApi.login(widget.username, appState.botName);
    setState(() {
      _chat.add(reply);
      _speak(reply);
    });
  }

  Future<void> _sendAPI() async {
    if (_text.isEmpty) {
      return;
    }

    setState(() {
      _chat.add(_text);
    });

    String reply = await AppApi.send(widget.username, _text);
    setState(() {
      _chat.add(reply);
      _speak(reply);
    });
  }

  Future<void> _clearAPI() async {
    await AppApi.clear(widget.username);
    setState(() {});
  }

  void _initSpeech2Text() async {
    print('Initializing Speech2Text...');

    bool isAvailable = await _speech2Text.initialize(
      onStatus: _statusListener,
      onError: _errorListener,
    );

    print('Speech2Text is ${isAvailable? 'available' : 'not available'}');

    if (!isAvailable) {
      Fluttertoast.showToast(
          msg: "Speech2Text is not available",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }

    setState(() {});
  }

  void _initText2Speech() async {
    print('Initializing Text2Speech...');

    await _text2Speech.setLanguage('en-US');
    await _text2Speech.setPitch(1.0);
    await _text2Speech.setSpeechRate(0.0);
    await _text2Speech.setVolume(1.0);

    setState(() {});
  }

  void _statusListener(String status) {
    print('Status: $status');

    setState(() {});
  }

  void _errorListener(SpeechRecognitionError error) {
    print('Error: $error');

    Fluttertoast.showToast(
        msg: "Error: $error",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );

    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _text = result.recognizedWords;
      if (result.finalResult) {
        _sendAPI();
      }
    });
  }

  void _startListening() async {
    if (!_speech2Text.isAvailable || _speech2Text.isListening) {
      return;
    }

    setState(() {
      _text = '';
    });

    await _speech2Text.listen(
      onResult: _onSpeechResult,
      listenMode: ListenMode.dictation,
      cancelOnError: true,
      pauseFor: const Duration(seconds: 5),
    );

    setState(() {});
  }

  void _stopListening() async {
    if (!_speech2Text.isAvailable || !_speech2Text.isListening) {
      return;
    }

    await _speech2Text.stop();

    setState(() {});
  }

  void _cancelListening() async {
    if (!_speech2Text.isAvailable || !_speech2Text.isListening) {
      return;
    }

    await _speech2Text.cancel();

    setState(() {
      _text = '';
    });
  }

  void _endSession() async {
    await _speech2Text.stop();
    await _text2Speech.stop();
    await _clearAPI();
    Navigator.pop(context);
  }

  void _speak(String message) async {
    AppState appState = Provider.of(_buildContext, listen: false);
    if (appState.ttsEnabled) {
      await _text2Speech.setVoice(
          {'name': appState.bot.name, 'locale': appState.bot.locale});
      await _text2Speech.speak(message);
    }
    setState(() {});
  }

  Widget _getFloatingActionButton() {
    if (_speech2Text.isAvailable) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 50, bottom: 30),
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: _endSession,
                  tooltip: 'End Session',
                  backgroundColor: Colors.redAccent,
                  child: const Icon(Icons.call_end),
                  elevation: 2,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AvatarGlow(
                animate: _speech2Text.isListening,
                glowColor: Theme.of(context).primaryColor,
                endRadius: 75.0,
                duration: const Duration(milliseconds: 2000),
                repeatPauseDuration: const Duration(milliseconds: 100),
                repeat: true,
                showTwoGlows: true,
                child: FloatingActionButton.large(
                  heroTag: null,
                  onPressed: _speech2Text.isListening ? _stopListening : _startListening,
                  tooltip: 'Listen',
                  child: Icon(_speech2Text.isListening ? Icons.stop : Icons.mic),
                  elevation: 4,
                ),
              ),
            ),
            Visibility(
              visible: _speech2Text.isListening,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 50, bottom: 30),
                  child: FloatingActionButton(
                    heroTag: null,
                    onPressed: _cancelListening,
                    tooltip: 'Cancel',
                    backgroundColor: Colors.orangeAccent,
                    child: const Icon(Icons.restart_alt),
                    elevation: 2,
                  ),
                ),
              ),
            ),
          ]
        ),
      );
    }
    else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {

    _buildContext = context;
    AppState appState = Provider.of(context);

    if (!_loggedIn) {
      _loggedIn = true;
      _loginAPI();
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(appState.bot.faceFilename),
            ),
            SizedBox(
              width: 8,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appState.botName,
                ),
                const Text(
                  'Online',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => SettingsPage(widget.username),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(0.0, 1.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  }
                ),
              );

              setState(() {
                _text2Speech.setVoice({'name': appState.bot.name, 'locale': appState.bot.locale});
              });
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.1),
                BlendMode.srcATop),
              image: const AssetImage('assets/images/background3.png'),
              fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 140),
            child: SingleChildScrollView(
              reverse: true,
              controller: _scrollController,
              physics: const ScrollPhysics(),
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: _chat.length,
                        itemBuilder: (BuildContext context, int index) {
                          // Bot message
                          if (index % 2 == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20, right: 50),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFFF7),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                child: Text(
                                  _chat[index],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            );
                          }
                          // Human message
                          else {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20, left: 50),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF89CFF0),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                child: Text(
                                  _chat[index],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),

                  (_text.isEmpty || !_speech2Text.isListening) ? Container() :
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, left: 80, right: 28),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        child: Text(
                          _text,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
              ],
            ),
            ),
          ),
          ],
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _getFloatingActionButton(),
    );
  }
}
