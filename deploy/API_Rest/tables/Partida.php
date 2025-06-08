<?php
class Partida {

    
    private $tabla = "partida";
    private $connection;
    public $id_jugador;
    public $fecha_registro;
    public $score;
    public $dinero_total;
    public $enemigos_matados;
    public $dmg_inflingido;
    public $dmg_recibido;

    public function __construct($db) {
        $this->connection = $db;
    }

    
    function read() {
        $stmt = $this->connection->prepare("SELECT * FROM " . $this->tabla . " ORDER BY score DESC");
        $stmt->execute();
        $result = $stmt->get_result();
        return $result;
    }

    function insert() {
    $stmt = $this->connection->prepare("INSERT INTO " . $this->tabla . " 
        (id_jugador, fecha_registro, score, dinero_total, enemigos_matados, dmg_inflingido, dmg_recibido) 
        VALUES (?, ?, ?, ?, ?, ?, ?)");

    $this->id_jugador = strip_tags($this->id_jugador);
    $this->fecha_registro = strip_tags($this->fecha_registro);
    $this->score = strip_tags($this->score);
    $this->dinero_total = strip_tags($this->dinero_total);
    $this->enemigos_matados = strip_tags($this->enemigos_matados);
    $this->dmg_inflingido = strip_tags($this->dmg_inflingido);
    $this->dmg_recibido = strip_tags($this->dmg_recibido);

    $stmt->bind_param(
        "isiiiii",
        $this->id_jugador,
        $this->fecha_registro,
        $this->score,
        $this->dinero_total,
        $this->enemigos_matados,
        $this->dmg_inflingido,
        $this->dmg_recibido
    );

    return $stmt->execute();
    }

}
?>