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
        $userId = mysqli_real_escape_string($cmx, $_GET['id']); // ID de l'utilisateur

        // Récupérer les infos de l'étudiant via utilisateur_id
        $req = mysqli_query($cmx, "
            SELECT u.nom, u.prenom, u.email, c.id AS classe_id, c.nom AS classe_nom
            FROM etudiants e
            JOIN utilisateurs u ON e.utilisateur_id = u.id
            JOIN classes c ON e.classe_id = c.id
            WHERE u.id = '$userId'
        ");

        if($req && mysqli_num_rows($req) > 0) {
            $row = mysqli_fetch_assoc($req);

            $response["success"] = 1;
            $response["data"] = array(
                "nom" => $row['nom'],
                "prenom" => $row['prenom'],
                "email" => $row['email'],
                "classes" => array(
                    array(
                        "id" => $row['classe_id'],
                        "nom" => $row['classe_nom']
                    )
                )
            );

        } else {
            $response["success"] = 0;
            $response["message"] = "Utilisateur / étudiant non trouvé";
        }

    } else {
        $response["success"] = 0;
        $response["message"] = "ID utilisateur manquant";
    }

} else {
    $response["success"] = 0;
    $response["message"] = "Méthode non autorisée";
}

echo json_encode($response);
?>