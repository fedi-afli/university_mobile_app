<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
include("../config/database.php");
header('Content-Type: application/json');

$response = array();

$method = $_SERVER['REQUEST_METHOD'];


if($method == 'GET') {
    $req = mysqli_query($cmx, "SELECT id, nom , niveau 
                                    FROM   classes");

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
        $niveau = $_POST['niveau'];
        
        
        $sql1 = "INSERT INTO  classes (nom, niveau)
                VALUES ('$nom', '$niveau')";
        $req1 = mysqli_query($cmx, $sql1);

        if ($req1) {
            

            
                $response["success"] = 1;
             
        } else {
            $response["success"] = 0;
            $response["message"] = "Erreur insertion classe";
        }
}

// PUT: update existing student
else if($method == 'PUT') {

    parse_str(file_get_contents("php://input"), $put_vars);

    $id = $put_vars['id'];
    $nom = $put_vars['nom'];
    $niveau= $put_vars['niveau'];


  

    $sql1 = "UPDATE classes SET
             nom='$nom',
             niveau='$niveau'
             WHERE id='$id'";

    $req1 = mysqli_query($cmx, $sql1);

   
 

    
    if ($req1) {
    

        $response["success"] = 1;
        $response["message"] = "classe mis à jour avec succès";
    } else {
        mysqli_rollback($cmx);

        $response["success"] = 0;
        $response["message"] = "Erreur" ;
    }
}

else {
    $response["success"] = 0;
    $response["message"] = "Méthode non autorisée";
}

echo json_encode($response);
?>