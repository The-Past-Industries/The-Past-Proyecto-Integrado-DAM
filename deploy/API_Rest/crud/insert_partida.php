<?php

//Cabeceras:
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type");

include_once '../database/ThePast.php';
include_once '../tables/Partida.php';

//Variables:
$database = new ThePast();
$connection = $database->getConnection();
$partida = new Partida($connection);

//Decodifica la información del JSON:
$data = json_decode(file_get_contents("php://input"));

if (isset($data->id_jugador) && isset($data->fecha_registro) && isset($data->score) && isset($data->dinero_total) && isset($data->enemigos_matados) && isset($data->dmg_inflingido) && isset($data->dmg_recibido)) {

    $partida->id_jugador = $data->id_jugador;
    $partida->fecha_registro = $data->fecha_registro;
    $partida->score = $data->score;
    $partida->dinero_total = $data->dinero_total;
    $partida->enemigos_matados = $data->enemigos_matados;
    $partida->dmg_inflingido = $data->dmg_inflingido;
    $partida->dmg_recibido = $data->dmg_recibido;

//Realiza el insertado y/o avisa del estado de la operación:
    if ($partida->insert()) {
        http_response_code(201);
        echo json_encode(array("info" => "Registro de partida creado"));
    } else {
        http_response_code(503);
        echo json_encode(array("info"=> "El registro de partida no se pudo crear"));
    }
} else {
    http_response_code(400);
    echo json_encode(array("info"=> "El registro de partida no se pudo crear, faltan datos"));
}
?>