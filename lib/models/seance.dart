class Seance {
  final int id;
  final String matiere;    // Matches m.nom AS matiere
  final String classe;     // Matches c.nom AS classe
  final String enseignant; // Matches CONCAT(u.nom,' ',u.prenom)
  final String dateSeance;
  final String heureDebut;
  final String heureFin;

  Seance({
    required this.id,
    required this.matiere,
    required this.classe,
    required this.enseignant,
    required this.dateSeance,
    required this.heureDebut,
    required this.heureFin,
  });

  factory Seance.fromJson(Map<String, dynamic> json) {
    return Seance(
      id: int.parse(json['id'].toString()),
      matiere: json['matiere'] ?? "",
      classe: json['classe'] ?? "",
      enseignant: json['enseignant'] ?? "",
      dateSeance: json['date_seance'] ?? "",
      heureDebut: json['heure_debut'] ?? "",
      heureFin: json['heure_fin'] ?? "",
    );
  }
}