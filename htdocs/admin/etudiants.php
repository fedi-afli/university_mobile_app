<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
include("../config/database.php");
header('Content-Type: application/json');

$response = array();

$method = $_SERVER['REQUEST_METHOD'];


if($method == 'GET') {
    $req = mysqli_query($cmx, "SELECT e.id, u.nom, u.prenom, u.password, u.email ,c.nom AS classe , c.id AS idc
                                    FROM etudiants e
                                    JOIN utilisateurs u ON e.utilisateur_id = u.id
                                    JOIN classes c ON e.classe_id = c.id;");

    if($req){
        $response["data"] = array();
        while($row = mysqli_fetch_assoc($req)){
            array_push($response["data"], $row);
        }
        $response["success"] = 1;
        
    } else {
        $response["success"] = 0;
        $response["message"] = "Erreur";
    }

}

// POST: add new student
else if($method == 'POST') {

        $nom = $_POST['nom'];
        $prenom = $_POST['prenom'];
        $email = $_POST['email']; 
        $password = password_hash($_POST['password'], PASSWORD_DEFAULT);
        $classe_id =$_POST['classe_id'];
        mysqli_begin_transaction($cmx);
        $sql1 = "INSERT INTO utilisateurs (nom, prenom, email, password, role)
                VALUES ('$nom', '$prenom', '$email', '$password', 'etudiant')";
        $req1 = mysqli_query($cmx, $sql1);

        if ($req1) {
            
            $user_id = mysqli_insert_id($cmx);

           
            $sql2 = "INSERT INTO etudiants (utilisateur_id, classe_id)
                    VALUES ('$user_id', '$classe_id')";
            $req2 = mysqli_query($cmx, $sql2);

            if ($req2) {
                mysqli_commit($cmx);
                $response["success"] = 1;
            } else {
                mysqli_rollback($cmx);
                $response["success"] = 0;
                $response["message"] = "Erreur insertion etudiant";
            }
        } else {
            mysqli_rollback($cmx);
            $response["success"] = 0;
            $response["message"] = "Erreur insertion utilisateur";
        }
}


else if($method == 'PUT') {

    parse_str(file_get_contents("php://input"), $put_vars);

    $etudiant_id = $put_vars['id']; 
    $nom = $put_vars['nom'];
    $prenom = $put_vars['prenom'];
    $email = $put_vars['email'];
    $classe_id = $put_vars['classe_id'];
    $password = password_hash($put_vars['password'], PASSWORD_DEFAULT);

   
    $getUser = mysqli_query($cmx, "SELECT utilisateur_id FROM etudiants WHERE id='$etudiant_id'");
    $row = mysqli_fetch_assoc($getUser);

    if (!$row) {
        $response["success"] = 0;
        $response["message"] = "Étudiant introuvable";
        echo json_encode($response);
        exit;
    }

    $user_id = $row['utilisateur_id'];

    mysqli_begin_transaction($cmx);


    $sql1 = "UPDATE utilisateurs SET
             nom='$nom',
             prenom='$prenom',
             email='$email',
             password='$password'
             WHERE id='$user_id' AND role='etudiant'";

    $req1 = mysqli_query($cmx, $sql1);

    $sql2 = "UPDATE etudiants SET
             classe_id='$classe_id'
             WHERE id='$etudiant_id'";

    $req2 = mysqli_query($cmx, $sql2);

    if ($req1 && $req2) {
        mysqli_commit($cmx);

        $response["success"] = 1;
        $response["message"] = "Étudiant mis à jour avec succès";
    } else {
        mysqli_rollback($cmx);

        $response["success"] = 0;
        $response["message"] = "Erreur";
    }
}
else if($method == 'DELETE') {
    parse_str(file_get_contents("php://input"), $delete_vars);
    $id = $delete_vars['id']; 

    $row = mysqli_fetch_assoc(mysqli_query($cmx, "SELECT utilisateur_id FROM etudiants  WHERE id='$id'"));
    $utilisateur_id = $row['utilisateur_id'];

    mysqli_begin_transaction($cmx);

    
    $req1 = mysqli_query($cmx, "DELETE FROM etudiants  WHERE id='$id'");

    
    $req2 = mysqli_query($cmx, "DELETE FROM utilisateurs WHERE id='$utilisateur_id'");

    if ($req1 && $req2) {
        mysqli_commit($cmx);
        $response["success"] = 1;
    } else {
        mysqli_rollback($cmx);
        $response["success"] = 0;
        $response["message"] = "Erreur lors de la suppression ";
    }
}

else {
    $response["success"] = 0;
    $response["message"] = "Méthode non autorisée";
}

echo json_encode($response);
?>