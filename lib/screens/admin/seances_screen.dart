import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projet_mobile/config/api_config.dart';
import 'package:projet_mobile/models/classe.dart';
import 'package:projet_mobile/models/enseignant.dart';
import 'package:projet_mobile/models/matiere.dart';
import 'package:projet_mobile/models/seance.dart';
import 'package:projet_mobile/screens/admin/classes_screen.dart';
import 'package:projet_mobile/screens/admin/enseignants_screen.dart';

class SeancesScreen extends StatefulWidget {
  const SeancesScreen({Key? key}) : super(key: key);

  @override
  _SeancesScreenState createState() => _SeancesScreenState();
}

class _SeancesScreenState extends State<SeancesScreen> {
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
                  flex: 2,
                  child: Text(
                    "Matiere",
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
                Expanded(
                  flex: 2,
                  child: Text(
                    "date",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "debut",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "fin",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "heure",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: getSeances(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var list = snapshot.data as List<Seance>;
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
                    Seance seance = list[index];
                    DateTime debut = DateTime.parse(
                      "2000-01-01 ${seance.heureDebut}",
                    );
                    DateTime fin = DateTime.parse(
                      "2000-01-01 ${seance.heureFin}",
                    );
                    double difference = fin.difference(debut).inMinutes / 60.0;
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Expanded(flex: 1, child: Text("${seance.id}")),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "${seance.matiere}",
                                style: TextStyle(fontSize: 9),
                              ),
                            ),
                            Expanded(flex: 2, child: Text(seance.classe)),
                            Expanded(
                              flex: 2,
                              child: Text(
                                "${seance.dateSeance}",
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text("${formatTime(seance.heureDebut)}"),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text("${formatTime(seance.heureFin)}"),
                            ),
                            Expanded(flex: 2, child: Text("$difference")),
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
            "/admin_home/Formulaire_affectation",
          );
        },
        tooltip: 'affecter une sceance',
        child: const Icon(Icons.add),
      ),
    );
  }
}

String formatTime(String rawTime) {
  if (rawTime.isEmpty) return "";

  // 1. If there's a date attached (e.g., "2000-01-01 08:00:00.000"), split and take just the time part
  String timePart = rawTime.contains(' ') ? rawTime.split(' ')[1] : rawTime;

  // 2. Take only the first 5 characters (HH:MM) and ignore the seconds/milliseconds
  return timePart.length >= 5 ? timePart.substring(0, 5) : timePart;
}

Future<List<Seance>> getSeances() async {
  final response = await http.get(Uri.parse("$baseUrl/admin/seances.php"));

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    if (data['success'] == 1) {
      // 2. CONVERT THE JSON LIST TO A LIST OF Seance OBJECTS
      List<dynamic> jsonList = data['data'];
      return jsonList.map((json) => Seance.fromJson(json)).toList();
    }
  }
  throw Exception("Impossible de charger les étudiants");
}

Future<List<Matiere>> getmatiere() async {
  final response = await http.get(Uri.parse("$baseUrl/admin/matieres.php"));

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    if (data['success'] == 1) {
      // 2. CONVERT THE JSON LIST TO A LIST OF classe OBJECTS
      List<dynamic> jsonList = data['data'];
      return jsonList.map((json) => Matiere.fromJson(json)).toList();
    }
  }
  throw Exception("Impossible de charger les étudiants");
}

class AjouterSeance extends StatefulWidget {
  const AjouterSeance({Key? key}) : super(key: key);

  @override
  _AjouterSeanceState createState() => _AjouterSeanceState();
}

class _AjouterSeanceState extends State<AjouterSeance> {
  late TextEditingController debutController;
  late TextEditingController finController;
  late TextEditingController dateController;

  late bool hidden;
  late bool hidden2;
  late String? enseignant_selectioner;
  late String? matiere_selectioner;
  late String? classe_selectioner;
  late List<Classe> classesList = [];
  late List<Enseignant> enseignantList = [];
  late List<Matiere> matiereList = [];

  @override
  void initState() {
    super.initState();

    debutController = TextEditingController();
    finController = TextEditingController();
    dateController = TextEditingController();

    hidden = true;
    hidden2 = true;
    enseignant_selectioner = null;
    matiere_selectioner = null;

    classe_selectioner = null;
    classes();
    enseignants();
    matieres();
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

  Future<void> enseignants() async {
    try {
      List<Enseignant> ens = await getdata();
      setState(() {
        enseignantList = ens;
        // Turn off the loading spinner
      });
    } catch (e) {
      print("Error loading classes");
    }
  }

  Future<void> matieres() async {
    try {
      List<Matiere> mat = await getmatiere();
      setState(() {
        matiereList = mat;
        // Turn off the loading spinner
      });
    } catch (e) {
      print("Error loading classes");
    }
  }

  final _formKey = GlobalKey<FormState>();

  Future<void> _selectTime(
    BuildContext context,
    TextEditingController controller,
  ) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        // Formats time as HH:MM:00 for your database
        controller.text =
            "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}:00";
      });
    }
  }

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
            arguments: 3,
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
                  "Ajouter un seance",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontStyle: FontStyle.italic,
                  ),
                ),

                SizedBox(height: 30),

                DropdownButtonFormField<String>(
                  value: enseignant_selectioner, // Initially null
                  decoration: const InputDecoration(labelText: "enseignant"),
                  validator: (value) {
                    if (value == null) return "Veuillez choisir une classe";
                    return null;
                  },
                  items: enseignantList.map<DropdownMenuItem<String>>((c) {
                    return DropdownMenuItem<String>(
                      value: c.id.toString(),
                      child: Text(c.nom),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      enseignant_selectioner = value;
                    });
                  },
                ),
                SizedBox(height: 30),

                DropdownButtonFormField<String>(
                  value: matiere_selectioner, // Initially null
                  decoration: const InputDecoration(labelText: "matiere"),
                  validator: (value) {
                    if (value == null) return "Veuillez choisir une matiere";
                    return null;
                  },
                  items: matiereList.map<DropdownMenuItem<String>>((c) {
                    return DropdownMenuItem<String>(
                      value: c.id.toString(),
                      child: Text(c.nom),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      matiere_selectioner = value;
                    });
                  },
                ),
                SizedBox(height: 30),

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

                // ------------------ DATE DE SEANCE ------------------
                TextFormField(
                  controller: dateController,
                  readOnly: true, // Prevents keyboard from opening
                  decoration: const InputDecoration(
                    labelText: "Date de la séance",
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000), // How far back they can go
                      lastDate: DateTime(2101), // How far forward they can go
                    );
                    if (pickedDate != null) {
                      setState(() {
                        // Formats date as YYYY-MM-DD for your database
                        dateController.text =
                            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Veuillez choisir une date";
                    return null;
                  },
                ),

                // ------------------ HEURE DE DEBUT ------------------
                SizedBox(height: 30),
                TextFormField(
                  controller: debutController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Heure de début",
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  onTap: () => _selectTime(context, debutController),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Veuillez choisir l'heure de début";

                    if (finController.text.isNotEmpty) {
                      DateTime debut = DateTime.parse(
                        "2000-01-01 $value",
                      );
                      DateTime fin = DateTime.parse("2000-01-01 ${finController.text}");
                      if (debut.isAfter(fin)) {
                        return "temp erroner";
                      }
                    }

                    return null;
                  },
                ),

                // ------------------ HEURE DE FIN ------------------
                SizedBox(height: 30),
                TextFormField(
                  controller: finController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Heure de fin",
                    suffixIcon: Icon(Icons.access_time),
                  ),
                  onTap: () => _selectTime(context, finController),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Veuillez choisir l'heure de fin";

                    if (finController.text.isNotEmpty) {
                      DateTime fin = DateTime.parse(
                        "2000-01-01 $value",
                      );
                      DateTime debut = DateTime.parse("${debutController.text}");
                      if (debut.isAfter(fin)) {
                        return "temp erroner";
                      }
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),

                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        var url = Uri.parse("$baseUrl/admin/seances.php");

                        try {
                          var response = await http.post(
                            url,
                            body: {
                              "enseignant_id": enseignant_selectioner,
                              "matiere_id": matiere_selectioner,
                              "date_seance": dateController.text,
                              "heure_debut": debutController.text,
                              "heure_fin": finController.text,
                              "classe_id": classe_selectioner,
                            },
                          );

                          var data = json.decode(response.body);

                          if (data['success'] == 1) {
                            Navigator.pushReplacementNamed(
                              context,
                              '/admin_home',
                              arguments: 3,
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
