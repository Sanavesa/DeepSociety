import 'package:deep_convo/app_state.dart';
import 'package:deep_convo/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppState appState = AppState();
  await appState.initialize();

  runApp(MyApp(appState));
}

class MyApp extends StatelessWidget {

  final AppState appState;

  const MyApp(this.appState, {Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider<AppState>.value(
      value: appState,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Deep Society',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const LoginPage(),
      ),
    );
  }
}