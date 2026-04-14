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
import 'package:projet_mobile/screens/enseignant/appel_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
                  Expanded(
                  flex: 2,
                  child: Text(
                    ""
                    
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
                            Expanded(flex: 2,child: seance.appel == true? const SizedBox.shrink() : FilledButton(onPressed: (){
                              Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                     
                                      builder: (context) => AppelScreen(seance: seance),
                                    ),
                                  );
                            }, child: Icon(Icons.how_to_reg)),)

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

String formatTime(String rawTime) {
  if (rawTime.isEmpty) return "";

 
  String timePart = rawTime.contains(' ') ? rawTime.split(' ')[1] : rawTime;

  
  return timePart.length >= 5 ? timePart.substring(0, 5) : timePart;
}

Future<List<Seance>> getSeances() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? myId = prefs.getString('userId'); 


  

  final response = await http.get(Uri.parse("$baseUrl/enseignant/seances.php?user_id=$myId"));

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    if (data['success'] == 1) {

      List<dynamic> jsonList = data['data'];
      return jsonList.map((json) => Seance.fromJson(json)).toList();
    }
  }
  throw Exception("Impossible de charger les étudiants");
}
