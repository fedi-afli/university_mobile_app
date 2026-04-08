<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

include("../config/database.php");
header('Content-Type: application/json');

$response = array();
$method = $_SERVER['REQUEST_METHOD'];


if($method == 'GET') {
    $req = mysqli_query($cmx, "SELECT s.id, m.nom AS matiere, c.nom AS classe, 
                                      CONCAT(u.nom,' ',u.prenom) AS enseignant,
                                      s.date_seance, s.heure_debut, s.heure_fin
                               FROM seances s
                               JOIN enseignants e ON s.enseignant_id = e.id
                               JOIN utilisateurs u ON e.utilisateur_id = u.id
                               JOIN classes c ON s.classe_id = c.id
                               JOIN matieres m ON s.matiere_id = m.id
                               ORDER BY s.date_seance, s.heure_debut");

    if($req){
        $response["data"] = array();
        while($row = mysqli_fetch_assoc($req)){
            array_push($response["data"], $row);
        }
        $response["success"] = 1;
    } else {
        $response["success"] = 0;
        $response["message"] = "Erreur: ".mysqli_error($cmx);
    }
}


else if($method == 'POST') {
    $enseignant_id = $_POST['enseignant_id'];
    $classe_id = $_POST['classe_id'];
    $matiere_id = $_POST['matiere_id'];
    $date_seance = $_POST['date_seance'];
    $heure_debut = $_POST['heure_debut'];
    $heure_fin = $_POST['heure_fin'];

    $sql = "INSERT INTO seances (enseignant_id, classe_id, matiere_id, date_seance, heure_debut, heure_fin)
            VALUES ('$enseignant_id', '$classe_id', '$matiere_id', '$date_seance', '$heure_debut', '$heure_fin')";
    $req = mysqli_query($cmx, $sql);

    if($req){
        $response["success"] = 1;
        $response["message"] = "Séance ajoutée avec succès";
    } else {
        $response["success"] = 0;
        $response["message"] = "Erreur: ".mysqli_error($cmx);
    }
}




echo json_encode($response);
?>