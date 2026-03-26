class Enseignant {
  final int id;         // This is the ID from the 'enseignants' table
  final String nom;
  final String prenom;
  final String email;
  final String specialite;

  Enseignant({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.specialite,
  });

  factory Enseignant.fromJson(Map<String, dynamic> json) {
    return Enseignant(
      // Parsing as String first handles various MySQL/JSON return types safely
      id: int.parse(json['id'].toString()), 
      nom: json['nom'] ?? "",
      prenom: json['prenom'] ?? "",
      email: json['email'] ?? "",
      specialite: json['specialite'] ?? "",
    );
  }

  // Helpful for the PUT/UPDATE method in Flutter
  Map<String, String> toMap() {
    return {
      'id': id.toString(),
      'nom': nom,
      'prenom': prenom,
      'specialite': specialite,
    };
  }
}