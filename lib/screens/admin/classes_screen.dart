import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projet_mobile/config/api_config.dart';
import 'package:projet_mobile/models/classe.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({Key? key}) : super(key: key);

  @override
  _classesScreenState createState() => _classesScreenState();
}

class _classesScreenState extends State<ClassesScreen> {
  late List<Classe> allClasses ;
  late List<Classe> filteredClasses ;
  late  TextEditingController searchController;

  @override
  void initState() {
    
    super.initState();
    allClasses = [];
    filteredClasses = [];
    searchController = TextEditingController();
  }


  void _filterClasses(String query) {
    setState(() {
      filteredClasses = allClasses.where((classe) {
        final q = query.toLowerCase();
        return classe.nom.toLowerCase().contains(q);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushReplacementNamed(
          context,
          "/admin_home/ajouter_classe",
          arguments: 2,
        ),
        child: Icon(Icons.add),
        tooltip: 'ajouter classe',
      ),
      body: Column(
        children: [
           Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              onChanged: _filterClasses,
              decoration: InputDecoration(
                hintText: "Rechercher...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 22.0,
              vertical: 15.0,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
                  flex: 3,
                  child: Text(
                    "Nom ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    "Niveau",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getclasses(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if(allClasses.isEmpty){
                  allClasses = snapshot.data as List<Classe>;
                  filteredClasses = allClasses;
                }

                
                if (filteredClasses.length == 0) {
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
                  itemCount: filteredClasses.length,
                  itemBuilder: (context, index) {
                    Classe classe = filteredClasses[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Expanded(child: Text("${classe.id}"), flex: 1),

                            Expanded(
                              child: Text("${classe.nom.toUpperCase()} "),
                              flex: 3,
                            ),
                            Expanded(child: Text("${classe.niveau}"), flex: 3),
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

Future<List<Classe>> getclasses() async {
  final response = await http.get(Uri.parse("$baseUrl/admin/classes.php"));

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    if (data['success'] == 1) {
      // 2. CONVERT THE JSON LIST TO A LIST OF classe OBJECTS
      List<dynamic> jsonList = data['data'];
      return jsonList.map((json) => Classe.fromJson(json)).toList();
    }
  }
  throw Exception("Impossible de charger les étudiants");
}

class AjouterClass extends StatefulWidget {
  const AjouterClass({Key? key}) : super(key: key);
  @override
  _AjouteclassesState createState() => _AjouteclassesState();
}

class _AjouteclassesState extends State<AjouterClass> {
  late TextEditingController nomController;
  late TextEditingController niveauController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nomController = TextEditingController();
    niveauController = TextEditingController();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: const Text("ScholarCheck"),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => Navigator.pushReplacementNamed(
            context,
            "/admin_home",
            arguments: 2,
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
                  "Ajouter un Classe",
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
                      return 'Ce champ est obligatoire';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: "nom"),
                ),
                SizedBox(height: 20),

                TextFormField(
                  controller: niveauController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est obligatoire';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: "niveau"),
                ),

                SizedBox(height: 25),

                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        var url = Uri.parse("$baseUrl/admin/classes.php");

                        try {
                          var response = await http.post(
                            url,
                            body: {
                              "nom": nomController.text,
                              "niveau": niveauController.text,
                            },
                          );

                          var data = json.decode(response.body);

                          if (data['success'] == 1) {
                            Navigator.pushReplacementNamed(
                              context,
                              '/admin_home',
                              arguments: 2,
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
