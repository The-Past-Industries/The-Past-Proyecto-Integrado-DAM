<?php

//Cabeceras:
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

//Se importan los objetos necesarios:
include_once '../database/ThePast.php';
include_once '../tables/Jugador.php';

//Variables:
$database = new ThePast();
$connection = $database->getConnection();
$player = new Jugador($connection);


if (isset($_GET['id_jugador'])) {
    $player->id_jugador = $_GET['id_jugadot'];
} else {

    $player->id_jugador = -1;
}

$result = $player->read();



// Gestión de resultados:
if ($result->num_rows > 0) {
    $playerList = array();
    while ($player = $result->fetch_assoc()) {
        extract($player);
        $extractedData = array(
            "id_jugador" => $id_jugador,
            "nombre" => $nombre,
            "fecha_union" => $fecha_union,
        );
        array_push($playerList, $extractedData);
    }

    http_response_code(200);

    echo json_encode($playerList);

} else {
    http_response_code(404);
    echo json_encode(array("info"=> "Data not found"));
}
