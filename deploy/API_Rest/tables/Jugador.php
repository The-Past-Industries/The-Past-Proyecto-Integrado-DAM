<?php
class Jugador {

    private $tabla = "jugador";
    private $connection;
    public $id_jugador;
    public $nombre;
    public $fecha_union;

    public function __construct($db) {
        $this->connection = $db;
    }


	function read()
	{
		if ($this->id_jugador >= 0) {
			$stmt = $this->conn->prepare("
			SELECT * FROM " . $this->tabla . " WHERE id = ?");
			$stmt->bind_param("i", $this->id);
		} else {
			$stmt = $this->conn->prepare("SELECT * FROM " . $this->tabla);
		}
		$stmt->execute();
		$result = $stmt->get_result();
		return $result;

    }
    

    function insert() {
        $stmt = $this->connection->prepare("INSERT INTO " . $this->tabla . " (nombre, fecha_union) VALUES (?, ?)");

        $this->nombre = strip_tags($this->nombre);
        $this->fecha_union = strip_tags($this->fecha_union);

        $stmt->bind_param("ss", $this->nombre, $this->fecha_union);
        return $stmt->execute();
    }
}
?>