import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projet_mobile/config/api_config.dart';
import 'package:projet_mobile/models/etudiant.dart';

class EtudiantsScreen extends StatefulWidget {
  const EtudiantsScreen({Key? key}) : super(key: key);

  @override
  _EtudiantsScreenState createState() => _EtudiantsScreenState();
}

class _EtudiantsScreenState extends State<EtudiantsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 1. THE HEADER ROW
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 22.0,
              vertical: 15.0,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: const Row(
              children: [
                // Using Expanded to force column widths!
                Expanded(
                  flex: 1,
                  child: Text(
                    "ID",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    "Nom & Prénom",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    "Email",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Classe",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getEtudiants(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var list = snapshot.data as List<Etudiant>;
                if (list.length == 0) {
                  return Scaffold(
                    body: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Aucune donnée trouvée",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    Etudiant etudiant = list[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            // These must match the flex values in the header perfectly!
                            Expanded(flex: 1, child: Text("${etudiant.id}")),
                            Expanded(
                              flex: 4,
                              child: Text(
                                "${etudiant.nom.toUpperCase()} ${etudiant.prenom}",
                              ),
                            ),
                            Expanded(flex: 4, child: Text(etudiant.email)),
                            Expanded(
                              flex: 2,
                              child: Text(etudiant.classe ?? 'N/A'),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(
            context,
            "/admin_home/ajouter_etudiant",
          );
        },
        tooltip: 'ajouter etudiant',
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<List<Etudiant>> getEtudiants() async {
  final response = await http.get(Uri.parse("$baseUrl/admin/etudiants.php"));

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    if (data['success'] == 1) {
      // 2. CONVERT THE JSON LIST TO A LIST OF ETUDIANT OBJECTS
      List<dynamic> jsonList = data['data'];
      return jsonList.map((json) => Etudiant.fromJson(json)).toList();
    }
  }
  throw Exception("Impossible de charger les étudiants");
}

class AjouterEtudiant extends StatefulWidget {
  const AjouterEtudiant({Key? key}) : super(key: key);

  @override
  _AjouterEtudiantState createState() => _AjouterEtudiantState();
}

class _AjouterEtudiantState extends State<AjouterEtudiant> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController nomController;
  late TextEditingController prenomController;
  late TextEditingController classeController;
  

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nomController = TextEditingController();
    prenomController = TextEditingController();
    classeController = TextEditingController();
    
    
  }
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    
    // TODO: implement build


    return Scaffold(
      appBar: AppBar(title: const Text("ScholarCheck")),
      body:
       Center(
        child: Padding(padding: const EdgeInsets.all(10),
       child: Form(
          key: _formKey,
          child: Column(
            
            crossAxisAlignment: CrossAxisAlignment.center,
           children: [
            SizedBox(height: 50,),
    TextFormField(
      controller: nomController,
      validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ce champ est obligatoire'; // The error message shown to the user
          }
          return null; // Returning null means "No errors, it's valid!"
        },
      decoration: const InputDecoration(labelText: "nom"),
    ),

    TextFormField(
      controller: prenomController,
      validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ce champ est obligatoire'; // The error message shown to the user
          }
          return null; // Returning null means "No errors, it's valid!"
        },
      decoration: const InputDecoration(labelText: "prenom"),
    ),

    TextFormField(
    validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ce champ est obligatoire'; // The error message shown to the user
          }
          return null; // Returning null means "No errors, it's valid!"
        },
      controller: emailController,
      decoration: const InputDecoration(labelText: "email"),
    ),

    TextFormField(
      validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ce champ est obligatoire'; // The error message shown to the user
          }
          return null; // Returning null means "No errors, it's valid!"
        },
      controller: passwordController,
      decoration: const InputDecoration(labelText: "password"),
    ),
    TextFormField(
      validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Ce champ est obligatoire'; // The error message shown to the user
          }
          return null; // Returning null means "No errors, it's valid!"
        },
      controller: classeController,
      decoration: const InputDecoration(labelText: "password"),
    ),

    

    Center(
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            var url = Uri.parse("$baseUrl/admin/etudiants.php");

            try {
              var response = await http.post(
                url,
                body: {
                  "nom": nomController.text,
                  "prenom": prenomController.text,
                  "email": emailController.text.trim(),
                  "password": passwordController.text,
                  "role": "etudiant",
                  "classe_id":classeController.text,
                },
              );

              var data = json.decode(response.body);

              if (data['success'] == 1) {
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(data['message'])),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("erreur: cannot connect to server "),
                ),
              );
            }
          } else {
            print("Erreur : Le champ est vide.");
          }
        },
        child: const Text("Ajouter étudiant"),
      ),
    ),
  ],
           

          ),
           
        ),
      ),
       )
    );
  }
}
