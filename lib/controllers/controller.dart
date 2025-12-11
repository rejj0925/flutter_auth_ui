import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

final baseUrl = dotenv.env['BASE_URL'] ?? '';

class Controller {
  // Login user
  Future<bool> loginUser(
    TextEditingController usernameController,
    TextEditingController passwordController,
  ) async {
    try {
      var url = Uri.parse("$baseUrl/login_user.php");
      final response = await http
          .post(
            url,
            body: {
              "username": usernameController.text,
              "password": passwordController.text,
            },
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          var currentUser = data['user']['username'];
          log("Login successful: $currentUser");
          return true;
        } else {
          log(data['message']);
          return false;
        }
      } else {
        log("Failed to login: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      log("Error logging in: $e");
      return false;
    }
  }

  // Insert user
  Future<bool> insertUser(
    TextEditingController usernameController,
    TextEditingController passwordController,
  ) async {
    try {
      if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
        log("Username or password is empty");
        return false;
      }

      var url = Uri.parse("$baseUrl/insert_user.php");
      final response = await http
          .post(
            url,
            body: {
              'username': usernameController.text,
              'password': passwordController.text,
            },
          )
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              log('insert_user request timed out');
              throw Exception('Connection timeout');
            },
          );
      final data = json.decode(response.body);
      if (response.statusCode == 200) {
        log(data['message']);
        usernameController.clear();
        passwordController.clear();
        return true;
      } else {
        log('failed to insert user: ${response.statusCode} ${data['message']}');
        return false;
      }
    } catch (e) {
      log('Error inserting user: $e');
      return false;
    }
  }

  Future<List> fetchUsers() async {
    List users = [];
    try {
      var url = Uri.parse("$baseUrl/get_users.php");
      final response = await http
          .get(url)
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              log('get_users request timed out');
              throw Exception('Connection timeout');
            },
          );
      if (response.statusCode == 200) {
        users = json.decode(response.body);
      } else {
        log("failed to load users: ${response.statusCode}");
      }
    } catch (e) {
      log('Error fetching users: $e');
    }
    return users;
  }
}
