<?php

//Cabeceras:
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

//Se importan los objetos necesarios:
include_once '../database/ThePast.php';
include_once '../tables/Partida.php';

//Variables:
$database = new ThePast();
$connection = $database->getConnection();
$partida = new Partida($connection);


$result = $partida->read();


// Gestión de resultados:
if ($result->num_rows > 0) {
    $partidaList = array();
    while ($partida = $result->fetch_assoc()) {
        extract($partida);
        $extractedData = array(
            "id_jugador" => $id_jugador,
            "fecha_registro" => $fecha_registro,
            "score" => $score,
            "dinero_total" => $dinero_total,
            "enemigos_matados" => $enemigos_matados,
            "dmg_inflingido" => $dmg_inflingido,
            "dmg_recibido" => $dmg_recibido,
        );
        array_push($partidaList, $extractedData);
    }

    http_response_code(200);

    echo json_encode($partidaList);

} else {
    http_response_code(404);
    echo json_encode(array("info"=> "Data not found"));
}
