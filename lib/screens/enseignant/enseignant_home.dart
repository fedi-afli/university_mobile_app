import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projet_mobile/config/api_config.dart';

import 'mes_seances_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnseignantHomeScreen extends StatefulWidget {
  const EnseignantHomeScreen({super.key});

  @override
  State<EnseignantHomeScreen> createState() => _EnseignantHomeScreen();
}

class _EnseignantHomeScreen extends State<EnseignantHomeScreen> {
  late SeancesScreen seances;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    seances =SeancesScreen();
  
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          prefs.clear();

                          Navigator.pushReplacementNamed(context, "/");
                        },
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
        body:seances,
      );
  }

  
    @override
    void dispose() {
      super.dispose();
    }
  }

