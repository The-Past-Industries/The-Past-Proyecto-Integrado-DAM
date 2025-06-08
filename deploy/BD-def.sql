-- Creación de BD
CREATE DATABASE IF NOT EXISTS thepast;
USE thepast;

-- Definición de Datos
-- Entidad: JUGADOR 
CREATE TABLE IF NOT EXISTS jugador (
    id_jugador INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    fecha_union DATE NOT NULL
);

-- Entidad: PARTIDA 
CREATE TABLE IF NOT EXISTS partida (
    id_jugador INT NOT NULL,
    fecha_registro DATETIME NOT NULL,
    score BIGINT NOT NULL,
    dinero_total INT  NOT NULL,
    enemigos_matados INT  NOT NULL,
    dmg_inflingido BIGINT  NOT NULL,
    dmg_recibido BIGINT  NOT NULL,
    PRIMARY KEY (id_jugador, fecha_registro),
    FOREIGN KEY (id_jugador) REFERENCES jugador(id_jugador)
);