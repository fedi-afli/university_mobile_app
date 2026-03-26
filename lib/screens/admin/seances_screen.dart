import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:projet_mobile/config/api_config.dart';
import 'package:projet_mobile/models/seance.dart';


class SeancesScreen extends StatefulWidget {
  const SeancesScreen({Key? key}) : super(key: key);

  @override
  _SeancesScreenState createState() => _SeancesScreenState();
}

class _SeancesScreenState extends State<SeancesScreen> {


  @override
  Widget build(BuildContext context) {
    return  Column(
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
              Expanded(flex: 3, child: Text("Matiere", style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(flex: 2, child: Text("Classe", style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(flex: 2, child: Text("date", style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(flex: 2, child: Text("heure", style: TextStyle(fontWeight: FontWeight.bold))),
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
          Seance seance = list[index];
          DateTime debut = DateTime.parse("2000-01-01 ${seance.heureDebut}");
          DateTime fin = DateTime.parse("2000-01-01 ${seance.heureFin}");
          double difference = fin.difference(debut).inMinutes / 60.0;
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                     Expanded(flex: 1, child: Text("${seance.id}")),
                     Expanded(flex: 3, child: Text("${seance.matiere}")),
                     Expanded(flex: 2, child: Text(seance.classe)),
                     Expanded(flex: 2, child: Text("${seance.dateSeance}")),
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
  );
}
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


