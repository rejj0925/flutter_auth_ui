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

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ModalRoute.of(context)!.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
        ),
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
        title: Text('Welcome, ${currentUser ?? 'Guest'}!'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(1),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (Route<dynamic> route) => false,
                );
              },
              icon: const Icon(Icons.logout_rounded),
              style: IconButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color.fromARGB(255, 47, 111, 49),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      body: users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Container(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadiusGeometry.vertical(top: Radius.circular(12), bottom: Radius.circular(12)),
                              child: DataTable(
                                headingRowColor: WidgetStateProperty.all(
                                  Colors.lightGreen.shade100,
                                ),
                                columns: const [
                                  DataColumn(label: Text("ID", style: TextStyle(fontWeight: FontWeight.bold),)),
                                  DataColumn(label: Text("Username", style: TextStyle(fontWeight: FontWeight.bold),)),
                                ],
                                rows: users.map((user) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(user['id'].toString())),
                                      DataCell(Text(user['username'] ?? '')),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
