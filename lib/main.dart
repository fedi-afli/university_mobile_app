import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GestAbsence',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      
      initialRoute: '/',
     
      routes: {
        '/': (context) => const LoginScreen(),
        '/admin_home': (context) => const Scaffold(body: Center(child: Text("Admin Home"))),
        '/enseignant_home': (context) => const Scaffold(body: Center(child: Text("Enseignant Home"))),
        '/etudiant_home': (context) => const Scaffold(body: Center(child: Text("Etudiant Home"))),
      },
    );
  }
}