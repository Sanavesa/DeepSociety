import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'constants.dart';

class AppApi {

  static void _showError(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0
    );
  }

  static Future<String> login(String username, String botName) async {
    final params = {
      'username': username,
      'botName': botName,
    };
    var uri = Uri.http(Constants.baseUrl, '/login', params);

    print(uri);

    final response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });

    if (response.statusCode != 200) {
      _showError('ERROR ${response.statusCode} - Failed to login!');
      return 'ERROR';
    }

    print(response.statusCode);
    print(response.body);

    final data = jsonDecode(response.body);
    final text = data['text'] as String;
    return text;
  }

  static Future<String> send(String username, String message) async {
    final params = {
      'username': username,
      'text': message,
    };
    var uri = Uri.http(Constants.baseUrl, '/send', params);

    print(uri);

    final response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });

    if (response.statusCode != 200) {
      _showError('ERROR ${response.statusCode} - Failed to send text!');
      return 'ERROR';
    }

    print(response.statusCode);
    print(response.body);

    final data = jsonDecode(response.body);
    final text = data['text'] as String;
    return text;
  }

  static Future<void> clear(String username) async {
    final params = {
      'username': username
    };
    var uri = Uri.http(Constants.baseUrl, '/clear', params);

    print(uri);

    final response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });

    if (response.statusCode != 200) {
      _showError('ERROR ${response.statusCode} - Failed to send text!');
      return;
    }

    print(response.statusCode);
    print(response.body);

    return;
  }

  static Future<void> changeBot(String username, String botName) async {
    final params = {
      'username': username,
      'botName': botName
    };
    var uri = Uri.http(Constants.baseUrl, '/changeBot', params);

    print(uri);

    final response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });

    if (response.statusCode != 200) {
      _showError('ERROR ${response.statusCode} - Failed to update bot!');
      return;
    }

    print(response.statusCode);
    print(response.body);

    return;
  }
}