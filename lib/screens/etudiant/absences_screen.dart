import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/pdf.dart';
import 'dart:convert';
import 'package:projet_mobile/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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

    if (userId == null)
      throw Exception("Session expirée. Veuillez vous reconnecter.");

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
      floatingActionButton: FloatingActionButton(
      onPressed: () async {
        final absences = await absencesFuture;
        await generateAbsencePdf(absences);
      },
      child: Icon(Icons.picture_as_pdf),
    ),
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
                  Text(
                    "Aucune absence enregistrée",
                    style: TextStyle(color: Colors.grey),
                  ),
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
                          Text(
                            "Horaire: ${absence['heure_debut']} - ${absence['heure_fin']}",
                          ),
                        ],
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        // Simple logic to color-code the status
                        color:
                            absence['statut'].toString().toLowerCase() ==
                                'present'
                            ? Colors.green
                            : Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        absence['statut'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
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
Future<void> generateAbsencePdf(List<dynamic> absences) async {
  final pdf = pw.Document();


  final profile = await fetchProfile();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return [
          pw.Text(
            "Rapport d'Absences",
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.SizedBox(height: 10),

          pw.Text("Nom: ${profile['nom']} ${profile['prenom']}"),
          pw.Text("Classe: ${profile['classes'].map((c) => c['nom']).join(", ")}"),
          pw.Text("Email: ${profile['email']}"),

          pw.SizedBox(height: 20),


          pw.Table.fromTextArray(
            headers: ['Matière', 'Date', 'Début', 'Fin', 'Statut'],
            data: absences.map((a) => [
              a['matiere'],
              a['date_seance'],
              a['heure_debut'],
              a['heure_fin'],
              a['statut'],
            ]).toList(),
          ),
        ];
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (format) async => pdf.save(),
    name: "absences_${profile['nom']}.pdf",
  );
}


  Future<Map<String, dynamic>> fetchProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? etudiantIdStr = prefs.getString('userId');

    if (etudiantIdStr == null) throw Exception("ID étudiant manquant");

    int etudiantId = int.parse(etudiantIdStr);

    final url = Uri.parse("$baseUrl/etudiant/profil.php?id=$etudiantId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['success'] == 1) {
        return data['data'];
      } else {
        throw Exception("Impossible de récupérer le profil");
      }
    } else {
      throw Exception("Erreur serveur");
    }
  }