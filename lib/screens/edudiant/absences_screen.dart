import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projet_mobile/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AbsenceScreen extends StatefulWidget {
  const AbsenceScreen({super.key});

  @override
  State<AbsenceScreen> createState() => _AbsenceScreenState();
}

class _AbsenceScreenState extends State<AbsenceScreen> {
  late Future<List<dynamic>> absencesFuture;

  @override
  void initState() {
    super.initState();
    absencesFuture = fetchAbsences();
  }

  Future<List<dynamic>> fetchAbsences() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null) throw Exception("Session expirée. Veuillez vous reconnecter.");

    // The PHP now expects the user ID to match u.id in the database
    final url = Uri.parse("$baseUrl/etudiant/absences.php?id=$userId");
    
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == 1) {
        return data['data']; 
      } else {
        // Return empty list if success is 0 (likely no absences found)
        return [];
      }
    } else {
      throw Exception("Erreur serveur (${response.statusCode})");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: absencesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Erreur : ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final absences = snapshot.data ?? [];

          if (absences.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_available, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("Aucune absence enregistrée", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                absencesFuture = fetchAbsences();
              });
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: absences.length,
              itemBuilder: (context, index) {
                final absence = absences[index];

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.red.withOpacity(0.1),
                      child: const Icon(Icons.event_busy, color: Colors.red),
                    ),
                    title: Text(
                      absence['matiere'], // From SQL alias: m.nom AS matiere
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Date: ${absence['date_seance']}"),
                          Text("Horaire: ${absence['heure_debut']} - ${absence['heure_fin']}"),
                        ],
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        // Simple logic to color-code the status
                        color: absence['statut'].toString().toLowerCase() == 'justifiée' 
                            ? Colors.green 
                            : Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        absence['statut'],
                        style: const TextStyle(color: Colors.white, fontSize: 11),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}