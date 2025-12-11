import 'package:flutter/material.dart';
import 'package:flutter_auth_ui/controllers/controller.dart';


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
  final controller = Controller();


  Future<void> _insertUser() async {
      var isSuccess = await controller.insertUser(
        _usernameController,
        _passwordController,
      );
      if (!mounted) return;
      if (isSuccess == true) {
        Navigator.pushReplacementNamed(context, '/login');
      }
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
                  color: const Color.fromARGB(
                    255,
                    204,
                    204,
                    204,
                  ).withValues(alpha: 0.5),
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
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                _insertUser();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellowAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                shadowColor: Colors.black,
                                elevation: 10
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
