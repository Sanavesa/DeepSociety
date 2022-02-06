import 'package:deep_convo/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'change_bot_name.dart';

class SettingsPage extends StatefulWidget {

  final String username;

  const SettingsPage(this.username, {Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {

    AppState appState = Provider.of(context);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Settings'),
        ),
        body: Column(
          children: <Widget>[
            Card(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: ListTile(
                title: const Text(
                  'Personal Assistant',
                ),
                subtitle: Text(
                  appState.botName,
                ),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangeBotNamePage(widget.username)),
                  );
                  setState(() {});
                },
              ),
            ),
            Card(
              margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Text To Speech (TTS)'),
                    Switch(
                      value: appState.ttsEnabled,
                      onChanged: (value) {
                        setState(() {
                          appState.ttsEnabled = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}