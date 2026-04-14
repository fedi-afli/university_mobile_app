import 'package:flutter/material.dart';
import 'package:projet_mobile/models/enseignant.dart';
import 'package:projet_mobile/screens/admin/enseignants_screen.dart';
import 'package:projet_mobile/screens/admin/seances_screen.dart';
import 'package:projet_mobile/screens/etudiant/etudiant_home.dart';
import 'package:projet_mobile/screens/enseignant/enseignant_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/admin/admin_home.dart';
import 'screens/admin/etudiants_screen.dart';
import 'screens/admin/classes_screen.dart';
import 'models/etudiant.dart';
import 'screens/etudiant/etudiant_home.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder écoute les changements de thème
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ScholarCheck',
          themeMode: currentMode,

          theme: ThemeData(
            useMaterial3: true,
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF059669), // Deep Emerald Green
              onPrimary: Colors.white,
              secondary: Color(0xFF2563EB), // Royal Blue
              onSecondary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF1E293B), 
              // Dark Slate text
            ),
            scaffoldBackgroundColor: const Color(0xFFF8FAFC),

            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF059669),
              foregroundColor: Colors.white,
              centerTitle: true,
              elevation: 0,
              titleTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),

            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                elevation: 2,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                minimumSize: const Size(120, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF059669),
                  width: 2,
                ),
              ),
              hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
            ),

            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Colors.white,
              selectedItemColor: Color(0xFF059669),
              unselectedItemColor: Color(0xFF94A3B8),
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              elevation: 12,
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),

            cardTheme: CardThemeData(
              color: Colors.white,
              elevation: 4,
              shadowColor: const Color(0xFF059669).withOpacity(0.15),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
              clipBehavior: Clip.antiAlias,
            ),

            listTileTheme: const ListTileThemeData(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              iconColor: Color(0xFF059669),
              tileColor: Colors.transparent,
              titleTextStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
              subtitleTextStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF64748B),
                height: 1.4,
              ),
            ),
          ),

          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF059669),      
              onPrimary: Colors.white,
              secondary: Color(0xFF3B82F6),    
              onSecondary: Colors.white,
              surface: Color(0xFF1E293B),      
              onSurface: Colors.white,         
              surfaceContainerHighest: const Color(0xFF0F172A),
            ),
            scaffoldBackgroundColor: const Color(0xFF0F172A), 
            
      
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF059669), 
              foregroundColor: Colors.white,
              centerTitle: true,
              elevation: 0,
              titleTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF059669),
                foregroundColor: Colors.white,
                elevation: 2,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                minimumSize: const Size(120, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFF1E293B), // Champs gris foncé
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF334155)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF334155)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF059669),
                  width: 2,
                ),
              ),
              hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
            ),

            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color(0xFF1E293B),
              selectedItemColor: Color(
                0xFF10B981,
              ), // Émeraude légèrement plus clair
              unselectedItemColor: Color(0xFF64748B),
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              elevation: 12,
              selectedLabelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),

            cardTheme: CardThemeData(
              color: const Color(0xFF1E293B),
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.3),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(
                  color: Color(0xFF334155), // Bordure discrète
                  width: 1,
                ),
              ),
              clipBehavior: Clip.antiAlias,
            ),

            listTileTheme: const ListTileThemeData(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              iconColor: Color(0xFF10B981),
              tileColor: Colors.transparent,
              titleTextStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              subtitleTextStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF94A3B8),
                height: 1.4,
              ),
            ),
          ),

          initialRoute: '/',

          routes: {
            '/': (context) => const sessionScreen(),
            '/login': (context) => const LoginScreen(),

            '/admin_home': (context) {
              final args = ModalRoute.of(context)!.settings.arguments as int?;
              return AuthGuard(
                child: AdminHomeScreen(initialIndex: args ?? 0),
                roleRequired: "admin",
              );
            },
            '/enseignant_home': (context) => const AuthGuard(
              child: EnseignantHomeScreen(),
              roleRequired: "enseignant",
            ),
            '/etudiant_home': (context) => const AuthGuard(
              child: EtudiantHome(),
              roleRequired: "etudiant",
            ),
            '/admin_home/ajouter_etudiant': (context) => const AuthGuard(
              child: AjouterEtudiant(),
              roleRequired: "admin",
            ),
            '/admin_home/ajouter_enseignant': (context) => const AuthGuard(
              child: AjouterEnseignant(),
              roleRequired: "admin",
            ),

            '/admin_home/ajouter_classe': (context) =>
                const AuthGuard(child: AjouterClass(), roleRequired: "admin"),
            '/admin_home/modifier_etudiant': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as Etudiant;
              return AuthGuard(
                child: ModifierEtudiant(selectionner: args),
                roleRequired: "admin",
              );
            },
            '/admin_home/modifier_enseignant': (context) {
              final args =
                  ModalRoute.of(context)!.settings.arguments as Enseignant;
              return AuthGuard(
                child: ModifierEnseignant(selectionner: args),
                roleRequired: "admin",
              );
            },
            "/admin_home/Formulaire_affectation": (context) =>
                const AuthGuard(child: AjouterSeance(), roleRequired: "admin"),
          },
        );
      },
    );
  }
}

class sessionScreen extends StatefulWidget {
  const sessionScreen({super.key});

  @override
  State<sessionScreen> createState() => _sessionScreen();
}

class _sessionScreen extends State<sessionScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    bool isdark = prefs.getBool('getTheme') ?? false;

    await Future.delayed(const Duration(milliseconds: 500));
    if (isdark) {
      themeNotifier.value = ThemeMode.dark;
    } else {
      themeNotifier.value = ThemeMode.light;
    }

    if (isLoggedIn) {
      String? role = prefs.getString('userRole');
      if (role == 'admin') {
        Navigator.pushReplacementNamed(context, '/admin_home', arguments: 0);
      } else if (role == 'enseignant') {
        Navigator.pushReplacementNamed(context, '/enseignant_home');
      } else if (role == 'etudiant') {
        Navigator.pushReplacementNamed(context, '/etudiant_home');
      }
    } else {
      // If NOT logged in, go to Login Screen
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF059669), // Updated to Emerald Green
      body: Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class AuthGuard extends StatelessWidget {
  final Widget child;
  final String? roleRequired;

  const AuthGuard({super.key, required this.child, this.roleRequired});

  Future<Widget> _checkAccess() async {
    final prefs = await SharedPreferences.getInstance();

    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final role = prefs.getString('userRole');

    if (!isLoggedIn) {
      return const LoginScreen();
    }

    if (roleRequired != null && role != roleRequired) {
      return const Scaffold(body: Center(child: Text("Unauthorized")));
    }

    return child;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _checkAccess(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: Color(0xFF059669), // Updated to Emerald Green
            body: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }
        return snapshot.data!;
      },
    );
  }
}
