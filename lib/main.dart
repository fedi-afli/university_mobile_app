import 'package:flutter/material.dart';
import 'package:projet_mobile/models/enseignant.dart';
import 'package:projet_mobile/screens/admin/enseignants_screen.dart';
import 'package:projet_mobile/screens/admin/seances_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/admin/admin_home.dart';
import 'screens/admin/etudiants_screen.dart';
import 'screens/admin/classes_screen.dart';
import 'models/etudiant.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
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
            minimumSize: Size(120, 30),
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
        '/': (context) => const sessionScreen(),
        '/login': (context) => const LoginScreen(),

        '/admin_home': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as int?;
          return AuthGuard(child: AdminHomeScreen(initialIndex: args ?? 0),roleRequired: "admin",) ;
        },
        '/enseignant_home': (context) =>
            const  AuthGuard(child: Scaffold(body: Center(child: Text("Enseignant Home"))),roleRequired: "enseignant",),
        '/etudiant_home': (context) =>
            const Scaffold(body: Center(child: Text("Etudiant Home"))),
        '/admin_home/ajouter_etudiant': (context) =>const AuthGuard(child: AjouterEtudiant(),roleRequired: "admin",)  ,
        '/admin_home/ajouter_enseignant': (context) =>const AuthGuard(child: AjouterEnseignant(),roleRequired: "admin",)  ,
            
        '/admin_home/ajouter_classe': (context) => const AuthGuard(child:  AjouterClass(),roleRequired: "admin",) ,
        '/admin_home/modifier_etudiant': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Etudiant;

          return  AuthGuard(child: ModifierEtudiant(selectionner: args),roleRequired: "admin",)  ;
        },
        '/admin_home/modifier_enseignant': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Enseignant;

          return AuthGuard(child:  ModifierEnseignant(selectionner: args),roleRequired: "admin",)  ;
        },
        "/admin_home/Formulaire_affectation": (context) => AuthGuard(child:  AjouterSeance(),roleRequired: "admin",)
            
      } ,
     /* onGenerateRoute: (settings) {
  return MaterialPageRoute(
    builder: (context) => RouteGuard(settings: settings),
        );
      }, */
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

    // Small delay so the screen doesn't instantly flash
    await Future.delayed(const Duration(milliseconds: 500));

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
    return Scaffold(
      backgroundColor: const Color(0xFF0C9C34), // Green background
      body: Center(
        // A nice white loading spinner
        child: const CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

class AuthGuard extends StatelessWidget {
  final Widget child;
  final String? roleRequired;

  const AuthGuard({
    super.key,
    required this.child,
    this.roleRequired,
  });

  Future<Widget> _checkAccess() async {
    final prefs = await SharedPreferences.getInstance();

    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final role = prefs.getString('userRole');

   
    if (!isLoggedIn) {
      return const LoginScreen();
    }

   
    if (roleRequired != null && role != roleRequired) {
      return const Scaffold(
        body: Center(child: Text("Unauthorized")),
      );
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
            backgroundColor: Color(0xFF0C9C34),
            body: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }
        return snapshot.data!;
      },
    );
  }
}
/* class RouteGuard extends StatelessWidget { 
  final RouteSettings settings;

  const RouteGuard({super.key, required this.settings});

  Future<Widget> _checkAccess() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? role = prefs.getString('userRole');

    String route = settings.name ?? '/';

    
    if (!isLoggedIn && route != '/login') {
      return const LoginScreen();
    }

    if (route.startsWith('/admin') && role != 'admin') {
      return _unauthorized();
    }

    if (route.startsWith('/enseignant') && role != 'enseignant') {
      return _unauthorized();
    }

    if (route.startsWith('/etudiant') && role != 'etudiant') {
      return _unauthorized();
    }

    return _getPage(route);
  }

  Widget _unauthorized() {
    return const Scaffold(
      body: Center(child: Text("Unauthorized Access")),
    );
  }

  Widget _getPage(String route) {
    switch (route) {
      case '/':
        return const sessionScreen();

      case '/login':
        return const LoginScreen();

      case '/admin_home':
        final args = settings.arguments as int?;
        return AdminHomeScreen(initialIndex: args ?? 0);

      case '/enseignant_home':
        return const Scaffold(body: Center(child: Text("Enseignant Home")));

      case '/etudiant_home':
        return const Scaffold(body: Center(child: Text("Etudiant Home")));

      case '/admin_home/ajouter_etudiant':
        return const AjouterEtudiant();

      case '/admin_home/ajouter_enseignant':
        return const AjouterEnseignant();

      case '/admin_home/ajouter_classe':
        return const AjouterClass();

      case '/admin_home/modifier_etudiant':
        final args = settings.arguments as Etudiant;
        return ModifierEtudiant(selectionner: args);

      case '/admin_home/modifier_enseignant':
        final args = settings.arguments as Enseignant;
        return ModifierEnseignant(selectionner: args);

      case "/admin_home/Formulaire_affectation":
        return const AjouterSeance();

      default:
        return const Scaffold(
          body: Center(child: Text("Page not found")),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _checkAccess(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: Color(0xFF0C9C34),
            body: Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        }
        return snapshot.data!;
      },
    );
  }
}
*/