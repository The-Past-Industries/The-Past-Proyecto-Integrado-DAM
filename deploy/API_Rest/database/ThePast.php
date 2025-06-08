<?php
class ThePast {

    //Datos para la conexión a la base de datos:
    private $host = "localhost";
    private $user = "****";
    private $password = "***";
    private $database = "thepast";

    //Establecer la conexión:
    public function getConnection() {
        $connection = new mysqli($this->host, $this->user, $this->password, $this->database);
        $connection->set_charset("utf8");
        if($connection->connect_error) {
            die("Error al conectar con MySQL".$connection->connect_error);
        } else {
            return $connection;
        }
    }
}
?>