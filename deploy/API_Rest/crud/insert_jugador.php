<?php

//Cabeceras:
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type");

include_once '../database/ThePast.php';
include_once '../tables/Jugador.php';

//Variables:
$database = new ThePast();
$connection = $database->getConnection();
$player = new Jugador($connection);

//Decodifica la información del JSON:
$data = json_decode(file_get_contents("php://input"));

if (isset($data->nombre) && isset($data->fecha_union)) {
    
    $player->id_jugador = $data->id_jugador;
    $player->nombre = $data->nombre;
    $player->fecha_union = $data->fecha_union;

//Realiza el insertado y/o avisa del estado de la operación:
    if ($player->insert()) {
        http_response_code(201);
        echo json_encode(array("info" => "Jugador creado"));
    } else {
        http_response_code(503);
        echo json_encode(array("info"=> "El jugador no se pudo crear"));
    }
} else {
    http_response_code(400);
    echo json_encode(array("info"=> "El jugador no se puede crear, faltan datos"));
}
?>