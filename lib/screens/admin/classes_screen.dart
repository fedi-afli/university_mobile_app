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

              var list = snapshot.data as List<Classe>;
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
                  Classe classe = list[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Expanded(child: Text("${classe.id}"), flex: 1,),
                          
                          Expanded(child: Text("${classe.nom.toUpperCase()} "),flex: 3,),
                          Expanded(child: Text("${classe.niveau}"),flex: 3,),
                          
                          
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
