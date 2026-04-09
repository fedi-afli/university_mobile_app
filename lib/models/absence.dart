class Absence {
  final int? id;
  final int? seanceId;
  final int? etudiantId;
  final String? statut;

  Absence({
    this.id,
    this.seanceId,
    this.etudiantId,
    this.statut,
  });

  // Conversion du JSON (venant de l'API PHP) vers l'objet Flutter
  factory Absence.fromJson(Map<String, dynamic> json) {
    return Absence(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      seanceId: json['seance_id'] != null ? int.tryParse(json['seance_id'].toString()) : null,
      etudiantId: json['etudiant_id'] != null ? int.tryParse(json['etudiant_id'].toString()) : null,
      statut: json['statut']?.toString(),
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (seanceId != null) 'seance_id': seanceId,
      if (etudiantId != null) 'etudiant_id': etudiantId,
      if (statut != null) 'statut': statut,
    };
  }
}