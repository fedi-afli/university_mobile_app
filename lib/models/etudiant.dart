class Etudiant {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String classe;
  final String password;
  final String idc;

  Etudiant({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.classe,
    required this.password,
    required this.idc
  });

  factory Etudiant.fromJson(Map<String, dynamic> json) {
    return Etudiant(
      id: int.parse(json['id'].toString()),
      nom: json['nom'] ?? "",
      prenom: json['prenom'] ?? "",
      email: json['email'] ?? "",
      classe: json['classe'] ?? "",
      password: json['password']?? "",
      idc:  json['idc']?? "",
    );
  }
}
