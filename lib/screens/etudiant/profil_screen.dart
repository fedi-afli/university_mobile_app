import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projet_mobile/config/api_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>> profileFuture;

  @override
  void initState() {
    super.initState();
    profileFuture = fetchProfile();
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<Map<String, dynamic>>(
      future: profileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Erreur : ${snapshot.error}"));
        }

        var profile = snapshot.data!;
        var classes = profile['classes'] as List<dynamic>;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: theme.cardColor,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: theme.colorScheme.primary,
                      child: Text(
                        profile['nom'][0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 40,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      leading: Icon(Icons.person, color: theme.colorScheme.primary),
                      title: const Text("Nom"),
                      subtitle: Text(profile['nom']),
                    ),
                    ListTile(
                      leading: Icon(Icons.person_outline, color: theme.colorScheme.primary),
                      title: const Text("Prénom"),
                      subtitle: Text(profile['prenom']),
                    ),
                    ListTile(
                      leading: Icon(Icons.email, color: theme.colorScheme.primary),
                      title: const Text("Email"),
                      subtitle: Text(profile['email']),
                    ),
                    ListTile(
                      leading: Icon(Icons.school, color: theme.colorScheme.primary),
                      title: const Text("Classe(s)"),
                      subtitle: Text(classes.map((c) => c['nom']).join(", ")),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}