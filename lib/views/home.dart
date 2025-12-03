import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes debug banner
      home: const HomePage(), // Sets HomePage as home
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ModalRoute.of(context)!.settings.arguments as String?;
    
    return Scaffold(
      body: Container(
        color: Colors.green,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: [
              Text(
                "Welcome to the Home Page, ${currentUser ?? 'Guest'}!",
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text("Logout"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
