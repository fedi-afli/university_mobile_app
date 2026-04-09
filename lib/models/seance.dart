class Seance {
  final int id;
  final String matiere; 
  final String classe;
  final String idClasse; 
  final String enseignant; 
  final String dateSeance;
  final String heureDebut;
  final String heureFin;
  final bool appel;

  Seance({
    required this.id,
    required this.matiere,
    required this.classe,
    required this.idClasse,
    required this.enseignant,
    required this.dateSeance,
    required this.heureDebut,
    required this.heureFin,
    required this.appel,
  });

  factory Seance.fromJson(Map<String, dynamic> json) {
    return Seance(
      id: int.parse(json['id'].toString()),
      matiere: json['matiere'] ?? "",
      classe: json['classe'] ?? "",
      idClasse: json['classe_id'] ?? "",
      enseignant: json['enseignant'] ?? "",
      dateSeance: json['date_seance'] ?? "",
      heureDebut: json['heure_debut'] ?? "",
      heureFin: json['heure_fin'] ?? "",
      appel: json['appel'] ?? false,
    );
  }
}
