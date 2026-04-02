import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projet_mobile/config/api_config.dart';
import 'package:projet_mobile/screens/admin/classes_screen.dart';
import 'package:projet_mobile/screens/admin/enseignants_screen.dart';
import 'package:projet_mobile/screens/admin/etudiants_screen.dart';
import 'package:projet_mobile/screens/admin/seances_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHomeScreen extends StatefulWidget {
  final int initialIndex;
  const AdminHomeScreen({super.key, this.initialIndex = 0});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreen();
}

class _AdminHomeScreen extends State<AdminHomeScreen> {
  late int selectedIndex;
  late EtudiantsScreen etudiantsScreen;
  late EnseignantsScreen enseignantsScreen;
  late ClassesScreen classesScreen;
  late SeancesScreen seancesScreen;
  late List<Widget> screen;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedIndex = widget.initialIndex;
    etudiantsScreen = EtudiantsScreen();
    enseignantsScreen = EnseignantsScreen();
    classesScreen = ClassesScreen();
    seancesScreen = SeancesScreen();
    screen = [etudiantsScreen, enseignantsScreen, classesScreen, seancesScreen];
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
                    title: Text('Deconnixion'),
                    content: Text(
                      "Êtes-vous sûr de vouloir vous déconnecter ?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("annuler"),
                      ),

                      FilledButton(
                        onPressed: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();

                            prefs.clear();

                            Navigator.pushReplacementNamed(context, "/");},
                        child: Text('deconnecter'),
                      ),
                    ],
                  ),
                );



              
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: screen[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() => selectedIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Étudiants'),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'enseignants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.meeting_room),
            label: 'Classes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Séances',
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
