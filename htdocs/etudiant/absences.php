<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

include("../config/database.php");
header('Content-Type: application/json');

$response = array();
$method = $_SERVER['REQUEST_METHOD'];

if($method == 'GET') {

    if(isset($_GET['id'])) {
        $id = mysqli_real_escape_string($cmx, $_GET['id']);

    $req = mysqli_query($cmx, "
        SELECT 
            a.id,
            a.statut,
            s.date_seance,
            s.heure_debut,
            s.heure_fin,
            m.nom AS matiere
        FROM absences a
        JOIN seances s ON a.seance_id = s.id
        JOIN matieres m ON s.matiere_id = m.id
        JOIN etudiants e ON a.etudiant_id = e.id
        JOIN utilisateurs u ON u.id = e.utilisateur_id
        WHERE u.id = '$id'
        ORDER BY s.date_seance DESC
    ");

        if($req) {
            $response["data"] = array();

            while($row = mysqli_fetch_assoc($req)) {
                $response["data"][] = $row;
            }

            $response["success"] = 1;

        } else {
            $response["success"] = 0;
            $response["message"] = "Erreur récupération absences";
        }

    } else {
        $response["success"] = 0;
        $response["message"] = "ID manquant";
    }

} else {
    $response["success"] = 0;
    $response["message"] = "Méthode non autorisée";
}

echo json_encode($response);
?>