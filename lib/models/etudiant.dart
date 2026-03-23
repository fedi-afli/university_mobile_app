class Etudiant {
  final int id;
  final String nom;
  final String prenom;
  final String classe; 

  Etudiant({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.classe,
  });

  factory Etudiant.fromJson(Map<String, dynamic> json) {
    return Etudiant(
      id: int.parse(json['id'].toString()), 
      nom: json['nom'] ?? "",
      prenom: json['prenom'] ?? "",
      classe: json['classe'] ?? "",
    );
  }
}