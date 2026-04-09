<?php

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

include("../config/database.php");

$response = array();

if(isset($_POST['email']) && isset($_POST['password']) ){
$email = mysqli_real_escape_string($cmx, trim($_POST['email']));
$password = $_POST['password'];

$req = mysqli_query($cmx,"SELECT * FROM utilisateurs WHERE email='$email'");


if($req){
    $response["data"] = array();
    $res = mysqli_fetch_assoc($req);
    if($res){

    if (password_verify($password, $res['password'])) {
        $user = array();
        $user["id"] = $res["id"];
        $user["nom"] = $res["nom"];
        $user["prenom"] = $res["prenom"];
        $user["email"] = $res["email"];
        $user['password']=$res['password'];
        $user["role"] = $res["role"];
        $user["created_at"] = $res["created_at"];
        array_push($response["data"], $user);

        $response["success"] = 1;
        $response["message"] = "login avec succes ";



    }else{
            $response["success"] = 0;
            $response["message"] = "password incorrect";
        }


    }else{
            $response["success"] = 0;
            $response["message"] = "email incorrect";
        }





}else{

        $response["success"] = 0;
        $response["message"] = "query error";

        
    }
}else{

    $response["success"] = 0;
    $response["message"] = "vide";

    
}
echo json_encode($response);

?>