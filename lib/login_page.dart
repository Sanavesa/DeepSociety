import 'package:deep_convo/app_state.dart';
import 'package:deep_convo/chat_page.dart';
import 'package:flutter/material.dart';

import 'app_api.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Route _createRoute() {
    final String username = _textController.text;
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ChatPage(username),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.6),
                BlendMode.srcATop),
            image: const AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Deep Society',
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 54,
                  overflow: TextOverflow.visible,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'sans serif'
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _textController,
                    maxLength: null,
                    maxLines: null,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      decorationColor: Colors.white
                    ),
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      hintText: 'Name',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _textController,
                      builder: (context, value, child) {
                        return ElevatedButton(
                          child: const Text('GET STARTED'),
                          onPressed: () {
                            print('Your name is ${_textController.text}');
                            Navigator.of(context).push(_createRoute());
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(60),
                            textStyle: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                  ),
                ],
              ),
              const Text(
                'Spaces to connect\nWays to engage',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
