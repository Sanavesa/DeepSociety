import 'package:deep_convo/app_api.dart';
import 'package:deep_convo/bot.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';

class ChangeBotNamePage extends StatefulWidget {

  final String username;

  const ChangeBotNamePage(this.username, {Key? key}) : super(key: key);

  @override
  _ChangeBotNamePageState createState() => _ChangeBotNamePageState();
}

class _ChangeBotNamePageState extends State<ChangeBotNamePage> {

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
        title: const Text('Personal Assistant'),
      ),
      body: Scrollbar(
        child: ListView.separated(
          itemCount: appState.bots.length,
          separatorBuilder: (BuildContext context, int index) {
            return Container(
              margin: const EdgeInsets.only(left: 70, right: 10),
              height: 1,
              child: const Divider(
                color: Colors.black26,
              ),
            );
          },
          itemBuilder: (BuildContext context, int index) {
            final Bot bot = appState.bots[index];

            return RadioListTile<Bot>(
              onChanged: (selection) {
                setState(() {
                  appState.botName = selection!.username;
                  AppApi.changeBotName(widget.username, appState.botName);
                });
              },
              groupValue: appState.bot,
              value: appState.bots[index],
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(bot.username),
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: AssetImage(bot.flagFilename),
                  ),
                ],
              )
            );
          },
        ),
      ),
    );
  }
}