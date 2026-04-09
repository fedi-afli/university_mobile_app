import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projet_mobile/config/api_config.dart';
import 'package:projet_mobile/models/seance.dart';

class AppelScreen extends StatefulWidget {
  final Seance seance;

  const AppelScreen({Key? key, required this.seance}) : super(key: key);

  @override
  _AppelScreenState createState() => _AppelScreenState();
}

class _AppelScreenState extends State<AppelScreen> {
  List<dynamic> _etudiants = [];
  bool _isLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _fetchEtudiants();
  }

  Future<void> _fetchEtudiants() async {
    final String url = "$baseUrl/enseignant/absences.php?classe_id=${widget.seance.idClasse}";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['success'] == 1) {
          setState(() {
            // On initialise tout le monde à "Présent" (true) par défaut,
            // (Note : tu avais mis false dans ton code précédent, tu peux ajuster selon ton besoin)
            _etudiants = data['data'].map((etudiant) {
              etudiant['isPresent'] = false; 
              return etudiant;
            }).toList();
            _isLoading = false;
          });
        } else {
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      print("Erreur: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _submitAppel() async {
    setState(() => _isSubmitting = true);

    List<Map<String, dynamic>> listePourApi = _etudiants.map((etu) {
      return {
        "etudiant_id": etu['id'], 
        "statut": etu['isPresent'] ? "present" : "absent"
      };
    }).toList();

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/enseignant/absences.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "seance_id": widget.seance.id,
          "etudiants": listePourApi
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['success'] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Appel enregistré avec succès !"), backgroundColor: Colors.green),
          );
          Navigator.pop(context); 
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erreur de connexion"), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Appel : ${widget.seance.matiere}"),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _etudiants.isEmpty
                    ? const Center(child: Text("Aucun étudiant trouvé", style: TextStyle(fontSize: 18, color: Colors.grey)))
                    : ListView.builder(
                        itemCount: _etudiants.length,
                        itemBuilder: (context, index) {
                          var etudiant = _etudiants[index];
                          
                          // Utilisation du CheckboxListTile
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: CheckboxListTile(
                              // Affiche le Prénom et le Nom
                              title: Text(
                                "${etudiant['prenom'] ?? 'N/A'} ${etudiant['nom'] ?? 'N/A'}",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text("ID: ${etudiant['id'] ?? index}"),
                              secondary: const Icon(Icons.person_outline),
                              value: etudiant['isPresent'],
                              activeColor: Colors.green,
                              onChanged: (bool? value) {
                                setState(() {
                                  _etudiants[index]['isPresent'] = value!;
                                });
                              },
                            ),
                          );
                        },
                      ),
          ),
Container(
  padding: const EdgeInsets.all(16.0),
  width: double.infinity,
  child: FilledButton.icon(
    onPressed: (_isLoading || _isSubmitting || _etudiants.isEmpty) 
        ? null 
        : () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                  title: const Text("Confirmation"),
                  content: const Text("Êtes-vous sûr de vouloir valider cet appel ? Vous ne pourrez peut-être plus le modifier plus tard."),
                  actions: [
                    // Bouton Annuler
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Ferme simplement la boîte de dialogue
                      },
                      child: const Text("Annuler"),
                    ),
                    // Bouton Confirmer
                    FilledButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Ferme la boîte de dialogue d'abord
                        _submitAppel(); // Ensuite, lance l'enregistrement !
                      },
                      child: const Text("Confirmer"),
                    ),
                  ],
                ),
              
            );
          },
    icon: _isSubmitting 
        ? const SizedBox(
            width: 20, 
            height: 20, 
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
          )
        : const Icon(Icons.check_circle),
    label: const Text("Valider l'appel", style: TextStyle(fontSize: 16)),
    style: FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 14),
    ),
  ),
),
        ],
      ),
    );
  }
}