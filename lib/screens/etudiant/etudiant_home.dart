import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'absences_screen.dart';
import 'profil_screen.dart';
import 'package:projet_mobile/main.dart';

class EtudiantHome extends StatefulWidget {
  final int initialIndex;
  const EtudiantHome({super.key, this.initialIndex = 0});

  @override
  State<EtudiantHome> createState() => _EtudiantHomeState();
}

class _EtudiantHomeState extends State<EtudiantHome> {
  late int selectedIndex;
  late List<Widget> screens;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    screens = [const ProfileScreen(), const AbsenceScreen()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ScholarCheck"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Déconnexion'),
                  content: const Text(
                    "Êtes-vous sûr de vouloir vous déconnecter ?",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Annuler"),
                    ),
                    FilledButton(
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.clear();
                        Navigator.pushReplacementNamed(context, "/");
                      },
                      child: const Text('Déconnecter'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
           IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Changer de thème',
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();

                        
              if (themeNotifier.value == ThemeMode.light) {
                themeNotifier.value = ThemeMode.dark;
                await prefs.setBool('getTheme', true);
              }
              else{
                themeNotifier.value = ThemeMode.light;
                await prefs.setBool('getTheme', false);
              }
              
            },
          ),
        ],
      ),
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, 
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
        
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person), 
            label: 'Profile'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_busy),
            label: 'Absences',
          ),
        ],
      ),
    );
  }
}