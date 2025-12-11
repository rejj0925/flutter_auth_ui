import 'package:flutter/material.dart';
import 'package:flutter_auth_ui/views/signup.dart';
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
      home: const LoginPage(), // Sets LoginPage as home
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final controller = Controller();

  Future<void> _loginUser() async {
    var isSuccess = await controller.loginUser(
      _usernameController,
      _passwordController,
    );
    if (!mounted) return;
    if (isSuccess == true) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.lightGreenAccent],
            begin: AlignmentGeometry.centerRight,
            end: AlignmentGeometry.centerLeft,
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
                  // 👈 Container doesn’t have children, replaced with child
                  children: [
                    Text(
                      'Login',
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
                                controller: _usernameController,

                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(16),
                                  border: OutlineInputBorder(),
                                  labelText: 'Username',
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              TextFormField(
                                controller: _passwordController,
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
                              ),
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                _loginUser();
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
                                'Login',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Don\'t have an account?'),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (context) => const SignupPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Sign up',
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
