import 'package:flutter/material.dart';
import 'package:projet_mobile/screens/admin/enseignants_screen.dart';
import 'screens/login_screen.dart';
import 'screens/admin/admin_home.dart';
import 'screens/admin/etudiants_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final int initialIndex =0;
  const MyApp({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ScholarCheck',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0C9C34), // nice green
        ),
        scaffoldBackgroundColor: Colors.white,

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0C9C34),
          foregroundColor: Colors.white, // text/icons white
          centerTitle: true,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0C9C34),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF0C9C34),
          selectedItemColor: Color.fromARGB(255, 0, 136, 38),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
      ),

      initialRoute: '/',

      routes: {
        '/': (context) => const LoginScreen(),
        '/admin_home': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as int?;
          return AdminHomeScreen(initialIndex: args ?? 0);
        },
        '/enseignant_home': (context) =>
            const Scaffold(body: Center(child: Text("Enseignant Home"))),
        '/etudiant_home': (context) =>
            const Scaffold(body: Center(child: Text("Etudiant Home"))),
        '/admin_home/ajouter_etudiant': (context) => const AjouterEtudiant(),
        '/admin_home/ajouter_enseignant': (context) =>
            const AjouterEnseignant(),
      },
    );
  }
}
