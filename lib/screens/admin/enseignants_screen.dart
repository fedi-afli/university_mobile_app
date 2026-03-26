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
    return Column(
      children: [
        // 1. THE HEADER ROW
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 15.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: const Row(
            children: [
              // Using Expanded to force column widths!
              Expanded(flex: 1, child: Text("ID", style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(flex: 4, child: Text("Nom & Prénom", style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(flex: 4, child: Text("Email", style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(flex: 2, child: Text("specialite", style: TextStyle(fontWeight: FontWeight.bold))),
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
            child: Padding(padding: const EdgeInsets.all(10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 Text(
                "Aucune donnée trouvée",
                style: TextStyle(fontSize: 18, color: Colors.grey),
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
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                     Expanded(flex: 1, child: Text("${enseignant.id}")),
                     Expanded(flex: 4, child: Text("${enseignant.nom.toUpperCase()} ${enseignant.prenom}")),
                     Expanded(flex: 4, child: Text(enseignant.email)),
                     Expanded(flex: 2, child: Text("${enseignant.specialite}"))
                         
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


