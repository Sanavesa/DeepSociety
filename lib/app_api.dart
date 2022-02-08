import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';

import 'constants.dart';

class AppApi {

  static final Dio _dio = Dio(_options);
  static final BaseOptions _options = BaseOptions(
      baseUrl: Constants.baseUrl,
      responseType: ResponseType.json,
      headers: {HttpHeaders.contentTypeHeader: "application/json"},
  );

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

  static Future<bool> login(String username, String botName) async {
    final payload = {
      'username': username,
      'botname': botName,
    };

    print('called login with');
    print(payload);

    try {
      await _dio.post('/login', data: payload);
      return true;
    }
    on DioError catch(e) {
      _showError(e.response?.data['error']);
      return false;
    }
  }

  static Future<bool> logout(String username) async {
    final payload = {
      'username': username
    };

    print('called logout with');
    print(payload);

    try {
      await _dio.post('/logout', data: payload);
      return true;
    }
    on DioError catch(e) {
      _showError(e.response?.data['error']);
      return false;
    }
  }

  static Future<String?> send(String username, String message) async {
    final payload = {
      'username': username,
      'message': message,
    };

    print('called send with');
    print(payload);

    try {
      final response = await _dio.post('/send', data: payload);
      final reply = response.data['data'] as String;
      return reply;
    }
    on DioError catch(e) {
      _showError(e.response?.data['error']);
      return null;
    }
  }

  static Future<bool> changeBotName(String username, String botName) async {
    final payload = {
      'username': username,
      'botname': botName
    };

    print('called change_botname with');
    print(payload);

    try {
      await _dio.post('/change_botname', data: payload);
      return true;
    }
    on DioError catch(e) {
      _showError(e.response?.data['error']);
      return false;
    }
  }

  static Future<bool> changeUsername(String username, String newUsername) async {
    final payload = {
      'username': username,
      'new_username': newUsername
    };

    print('called change_username with');
    print(payload);

    try {
      await _dio.post('/change_username', data: payload);
      return true;
    }
    on DioError catch(e) {
      _showError(e.response?.data['error']);
      return false;
    }
  }
}