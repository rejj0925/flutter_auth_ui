import 'package:flutter/material.dart';
import 'package:flutter_auth_ui/views/home.dart';
import 'package:flutter_auth_ui/views/signup.dart';
import 'views/login.dart';


void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/signup': (context) => SignupPage(),
        '/login': (context) => LoginPage(),        
        '/home': (context) => HomePage(), 
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth UI',
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
