<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
include("../config/database.php");
header('Content-Type: application/json');

$response = array();

$method = $_SERVER['REQUEST_METHOD'];


if($method == 'GET') {
    $req = mysqli_query($cmx, "SELECT e.id, u.nom, u.prenom,u.email, e.specialite 
                                    FROM  enseignants e
                                    JOIN utilisateurs u ON e.utilisateur_id = u.id
                                    ");

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
        $specialite =$_POST['specialite'];
        $sql1 = "INSERT INTO utilisateurs (nom, prenom, email, password, role)
                VALUES ('$nom', '$prenom', '$email', '$password', 'enseignant')";
        $req1 = mysqli_query($cmx, $sql1);

        if ($req1) {
            
            $user_id = mysqli_insert_id($cmx);

           
            $sql2 = "INSERT INTO enseignants (utilisateur_id, specialite)
                    VALUES ('$user_id', '$specialite')";
            $req2 = mysqli_query($cmx, $sql2);

            if ($req2) {
                $response["success"] = 1;
            } else {
                $response["success"] = 0;
                $response["message"] = "Erreur insertion enseignant";
            }
        } else {
            $response["success"] = 0;
            $response["message"] = "Erreur insertion utilisateur";
        }
}

// PUT: update existing student
else if($method == 'PUT') {

    parse_str(file_get_contents("php://input"), $put_vars);

    $id = $put_vars['id'];
    $nom = $put_vars['nom'];
    $prenom = $put_vars['prenom'];
    $email = $put_vars['email'];
    $specialite = $put_vars['specialite'];
    $password = password_hash($put_vars['password'], PASSWORD_DEFAULT);

    $getUser = mysqli_query($cmx, "SELECT utilisateur_id FROM enseignants WHERE id='$id'");
    $row = mysqli_fetch_assoc($getUser);

    if (!$row) {
        $response["success"] = 0;
        $response["message"] = "Étudiant introuvable";
        echo json_encode($response);
        exit;
    }
    $utilisateur_id=$row['utilisateur_id'];

   
    mysqli_begin_transaction($cmx);

    $sql1 = "UPDATE utilisateurs SET
             nom='$nom',
             prenom='$prenom',
             email='$email',
             password='$password'
             WHERE id='$utilisateur_id'";

    $req1 = mysqli_query($cmx, $sql1);

   
    $sql2 = "UPDATE enseignants SET
            specialite ='$specialite'
            WHERE id='$id'";

    $req2 = mysqli_query($cmx, $sql2);

    
    if ($req1 && $req2) {
        mysqli_commit($cmx); 

        $response["success"] = 1;
        $response["message"] = "Étudiant mis à jour avec succès";
    } else {
        mysqli_rollback($cmx);

        $response["success"] = 0;
        $response["message"] = "Erreur" ;
    }
}





else if($method == 'DELETE') {
    parse_str(file_get_contents("php://input"), $delete_vars);
    $id = $delete_vars['id']; 

    $row = mysqli_fetch_assoc(mysqli_query($cmx, "SELECT utilisateur_id FROM enseignants WHERE id='$id'"));
    $utilisateur_id = $row['utilisateur_id'];

    mysqli_begin_transaction($cmx);

    
    $req1 = mysqli_query($cmx, "DELETE FROM enseignants WHERE id='$id'");

    
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