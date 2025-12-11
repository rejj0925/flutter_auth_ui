import 'package:flutter/material.dart';
import 'views/signup.dart';
import 'views/home.dart';
import 'views/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> main() async{
  await dotenv.load(fileName: ".env");
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
