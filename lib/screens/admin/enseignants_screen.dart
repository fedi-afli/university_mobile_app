import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projet_mobile/config/api_config.dart';
import 'package:projet_mobile/models/enseignant.dart';

class EnseignantsScreen extends StatefulWidget {
  const EnseignantsScreen({Key? key}) : super(key: key);

  @override
  _EnseignantsScreenState createState() => _EnseignantsScreenState();
}

class _EnseignantsScreenState extends State<EnseignantsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushReplacementNamed(
          context,
          '/admin_home/ajouter_enseignant',
        ),
        tooltip: 'ajouter etudiant',
        child: const Icon(Icons.add),
      ),
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
                    "specialite",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getdata(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var list = snapshot.data as List<Enseignant>;
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
                    Enseignant enseignant = list[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Expanded(flex: 1, child: Text("${enseignant.id}")),
                            Expanded(
                              flex: 4,
                              child: Text(
                                "${enseignant.nom.toUpperCase()} ${enseignant.prenom}",
                              ),
                            ),
                            Expanded(flex: 4, child: Text(enseignant.email)),
                            Expanded(
                              flex: 2,
                              child: Text("${enseignant.specialite}"),
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
    );
  }
}

Future<List<Enseignant>> getdata() async {
  final response = await http.get(Uri.parse("$baseUrl/admin/enseignants.php"));

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    if (data['success'] == 1) {
      // 2. CONVERT THE JSON LIST TO A LIST OF enseignant OBJECTS
      List<dynamic> jsonList = data['data'];
      return jsonList.map((json) => Enseignant.fromJson(json)).toList();
    }
  }
  throw Exception("Impossible de charger les étudiants");
}

class AjouterEnseignant extends StatefulWidget {
  const AjouterEnseignant({Key? key}) : super(key: key);

  @override
  State<AjouterEnseignant> createState() => _AjouterEnseignantState();
}

class _AjouterEnseignantState extends State<AjouterEnseignant> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController nomController;
  late TextEditingController prenomController;
  late TextEditingController classeController;
  late TextEditingController checkpasswordController;
  late TextEditingController specialiter;
  late bool hidden;
  late bool hidden2;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nomController = TextEditingController();
    prenomController = TextEditingController();
    classeController = TextEditingController();
    checkpasswordController = TextEditingController();
    specialiter = TextEditingController();
    hidden = true;
    hidden2 = true;
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: const Text("ScholarCheck"),
        automaticallyImplyLeading: false,
        leading: 
          
          IconButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, "/admin_home", arguments: 1,),
            icon: const Icon(Icons.arrow_back),
          ),
        
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Ajouter un Enseignant",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                SizedBox(height: 50),
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
                SizedBox(height: 20),

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
                SizedBox(height: 20),

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
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        obscureText: hidden,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ce champ est obligatoire'; // The error message shown to the user
                          }
                          if (value.length < 6) {
                            return 'password doit contenir au moins 6 caractères';
                          }
                          return null; // Returning null means "No errors, it's valid!"
                        },
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: "password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              hidden ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                hidden = !hidden;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(flex: 2, child: SizedBox(width: 50)),

                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        obscureText: hidden2,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ce champ est obligatoire'; // The error message shown to the user
                          } else if (value != passwordController.text) {
                            return 'pas le meme password';
                          }
                          return null; // Returning null means "No errors, it's valid!"
                        },
                        controller: checkpasswordController,
                        decoration: InputDecoration(
                          labelText: "verifier password",
                          suffixIcon: IconButton(
                            icon: Icon(
                              hidden2 ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                hidden2 = !hidden2;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                TextFormField(
                  controller: specialiter,
                  decoration: const InputDecoration(labelText: "specialiter"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est obligatoire'; // The error message shown to the user
                    }
                    return null; // Returning null means "No errors, it's valid!"
                  },
                ),

                SizedBox(height: 25),

                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        var url = Uri.parse("$baseUrl/admin/enseignants.php");

                        try {
                          var response = await http.post(
                            url,
                            body: {
                              "nom": nomController.text,
                              "prenom": prenomController.text,
                              "email": emailController.text.trim(),
                              "password": passwordController.text,
                              "role": "enseignant",
                              "specialite": specialiter.text,
                            },
                          );

                          var data = json.decode(response.body);

                          if (data['success'] == 1) {
                          Navigator.pushReplacementNamed(
                              context,
                              '/admin_home',
                              arguments: 1, // 1 = Enseignants tab
                            ); 
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(data['message'])),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "erreur: cannot connect to server ",
                              ),
                            ),
                          );
                        }
                      } else {
                        print("Erreur : Le champ est vide.");
                      }
                    },
                    child: const Text("Ajouter enseignant"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
