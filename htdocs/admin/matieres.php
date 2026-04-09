<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
include("../config/database.php");
header('Content-Type: application/json');

$response = array();

$method = $_SERVER['REQUEST_METHOD'];


if($method == 'GET') {
    $req = mysqli_query($cmx, "SELECT id, nom 
                                    FROM   matieres");

    if($req){
        $response["data"] = array();
        while($row = mysqli_fetch_assoc($req)){
            array_push($response["data"], $row);
        }
        $response["success"] = 1;
        
    } else {
        $response["success"] = 0;
        $response["message"] = "Erreur de get serveur";
    }

}

echo json_encode($response);

?>