import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projet_mobile/config/api_config.dart';
import 'package:projet_mobile/models/etudiant.dart';
import 'package:projet_mobile/models/classe.dart';
import 'package:projet_mobile/screens/admin/classes_screen.dart';

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
                      child: InkWell(
                        onTap: () {
                          // TODO: Add your click action here!
                          // Example: Navigate to a details screen
                          Navigator.pushReplacementNamed(
                            context,
                            '/admin_home/modifier_etudiant',
                            arguments: etudiant,
                          );
                        },

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
  late TextEditingController checkpasswordController;
  late bool hidden;
  late bool hidden2;
  late String? classe_selectioner;
  late List<Classe> classesList = [];

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nomController = TextEditingController();
    prenomController = TextEditingController();
    classeController = TextEditingController();
    checkpasswordController = TextEditingController();
    hidden = true;
    hidden2 = true;

    classe_selectioner = null;
    classes();
  }

  Future<void> classes() async {
    try {
      List<Classe> data = await getclasses();
      setState(() {
        classesList = data;
        // Turn off the loading spinner
      });
    } catch (e) {
      print("Error loading classes");
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: const Text("ScholarCheck"),
        leading: IconButton(
          onPressed: () => Navigator.pushReplacementNamed(
            context,
            "/admin_home",
            arguments: 0,
          ),
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
                  "Ajouter un etudiant",
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

                 DropdownButtonFormField<String>(
                    value: classe_selectioner, // Initially null
                    decoration: const InputDecoration(labelText: "Classe"),
                    validator: (value) {
                      if (value == null) return "Veuillez choisir une classe";
                      return null;
                    },
                    items: classesList.map<DropdownMenuItem<String>>((c) {
                      return DropdownMenuItem<String>(
                        value: c.id.toString(),
                        child: Text(c.nom),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        classe_selectioner = value;
                      });
                    },
                  
                ),

                SizedBox(height: 30),

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
                              "classe_id": classe_selectioner,
                            },
                          );

                          var data = json.decode(response.body);

                          if (data['success'] == 1) {
                            Navigator.pushReplacementNamed(
                              context,
                              '/admin_home',
                              arguments: 0, // 1 = Enseignants tab
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
                    child: const Text("Ajouter"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

class ModifierEtudiant extends StatefulWidget {
  final Etudiant selectionner;

  const ModifierEtudiant({super.key, required this.selectionner});

  @override
  _ModifierEtudiantState createState() => _ModifierEtudiantState();
}

class _ModifierEtudiantState extends State<ModifierEtudiant> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController nomController;
  late TextEditingController prenomController;
  late TextEditingController classeController;
  late TextEditingController checkpasswordController;
  late bool hidden;
  late bool hidden2;
  late String? classe_selectioner;
  late List<Classe> classesList = [];
  late Etudiant selectedEtudient;

  @override
  void initState() {
    super.initState();
    selectedEtudient = widget.selectionner;
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nomController = TextEditingController();
    prenomController = TextEditingController();
    classeController = TextEditingController();
    checkpasswordController = TextEditingController();
    hidden = true;
    hidden2 = true;

    emailController.text = selectedEtudient.email;
    passwordController = TextEditingController();
    nomController.text = selectedEtudient.nom;
    prenomController.text = selectedEtudient.prenom;
    checkpasswordController = TextEditingController();

    classe_selectioner = selectedEtudient.idc.toString();
    classes();
  }

  Future<void> classes() async {
    try {
      List<Classe> data = await getclasses();
      setState(() {
        classesList = data;
        // Turn off the loading spinner
      });
    } catch (e) {
      print("Error loading classes");
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: const Text("ScholarCheck"),
        leading: IconButton(
          onPressed: () => Navigator.pushReplacementNamed(
            context,
            "/admin_home",
            arguments: 0,
          ),
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
                  "Modifier un etudiant",
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

                
                  
                   DropdownButtonFormField<String>(
                    value: classe_selectioner,
                    decoration: const InputDecoration(labelText: "Classe"),
                    validator: (value) {
                      if (value == null) return "Veuillez choisir une classe";
                      return null;
                    },
                    items: classesList.map<DropdownMenuItem<String>>((c) {
                      return DropdownMenuItem<String>(
                        value: c.id.toString(),
                        child: Text(c.nom),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        classe_selectioner = value;
                      });
                    },
                  ),
                

                SizedBox(height: 30),

                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        var url = Uri.parse("$baseUrl/admin/etudiants.php");

                        try {
                          var response = await http.put(
                            url,
                            body: {
                              "id": selectedEtudient.id.toString(),
                              "nom": nomController.text,
                              "prenom": prenomController.text,
                              "email": emailController.text.trim(),
                              "password": passwordController.text,
                              "classe_id": classe_selectioner,
                            },
                          );

                          var data = json.decode(response.body);

                          if (data['success'] == 1) {
                            Navigator.pushReplacementNamed(
                              context,
                              '/admin_home',
                              arguments: 0, // 1 = Enseignants tab
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
                    child: const Text("Modifier"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
