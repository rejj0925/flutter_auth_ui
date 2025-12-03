import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes debug banner
      home: const SignupPage(), // Sets SignupPage as home
    );
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _obscurePassword = true;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  List users = [];
  final String baseUrl = 'http://localhost/bb88_api';
  Future<void> _fetchUsers() async {
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
      if (!mounted) return;
      if (response.statusCode == 200) {
        setState(() {
          users = json.decode(response.body);
        });
      } else {
        log("failed to load users: ${response.statusCode}");
      }
    } catch (e) {
      log('Error fetching users: $e');
    }
  }

  Future<void> _insertUser() async {
    try {
      if (_usernameController.text.isEmpty ||
          _passwordController.text.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username and password are required')),
        );
        return;
      }

      var url = Uri.parse("$baseUrl/insert_user.php");
      final response = await http
          .post(
            url,
            body: {
              'username': _usernameController.text,
              'password': _passwordController.text,
            },
          )
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              log('insert_user request timed out');
              throw Exception('Connection timeout');
            },
          );

      if (!mounted) return;
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'User registered')),
        );
        _usernameController.clear();
        _passwordController.clear();
      } else {
        log('failed to insert user: ${response.statusCode} ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to register user: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      log('Error inserting user: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.lightGreenAccent],
            begin: AlignmentGeometry.centerLeft,
            end: AlignmentGeometry.centerRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment
                .center, // fixed .center to MainAxisAlignment.center
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 204, 204, 204).withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),

                child: Column(
                  //Container doesn’t have children, replaced with child
                  children: [
                    Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        spacing: 16,
                        children: [
                          Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(16),
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: 'Username',
                                ),
                                controller: _usernameController,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              TextFormField(
                                obscureText: _obscurePassword,

                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(16),
                                  border: OutlineInputBorder(),
                                  labelText: 'Password',
                                  filled: true,
                                  fillColor: Colors.white,
                                  suffixIcon: IconButton(
                                    icon: _obscurePassword
                                        ? const Icon(Icons.visibility_off)
                                        : const Icon(Icons.visibility),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                ),
                                controller: _passwordController,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 200,
                            child: ElevatedButton(
                              onPressed: () {
                                _insertUser();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellowAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: Text(
                                'Sign Up',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Already have an account?'),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
