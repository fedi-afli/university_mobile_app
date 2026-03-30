class Matiere {
  final int id;
  final String nom;


  Matiere({required this.id, required this.nom});
  

  factory Matiere.fromJson(Map<String, dynamic> json) {
    return Matiere(
      id: int.parse(json['id'].toString()),
      nom: json['nom'],
     
    );
  }
}
