-- Definición de Datos
-- Entidad: JUGADOR 
CREATE TABLE IF NOT EXISTS jugador (
    id_jugador INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    alias VARCHAR(100),
    fecha_union DATE NOT NULL,
    victorias_totales BIGINT DEFAULT 0,
    logros LONGTEXT,
    personaje_pref INT
);

-- Entidad: PARTIDA 
CREATE TABLE IF NOT EXISTS partida (
    id_jugador INT NOT NULL,
    fecha_registro DATETIME NOT NULL,
    duracion BIGINT  NOT NULL,
    dinero_total INT  NOT NULL,
    llaves_total INT  NOT NULL,
    personaje INT  NOT NULL,
    enemigos_matados LONGTEXT  NOT NULL,
    daño_magico_inflingido DECIMAL(15,3)  NOT NULL,
    daño_fisico_inflingido DECIMAL(15,3)  NOT NULL,
    daño_verdadero_inflingido DECIMAL(15,3)  NOT NULL,
    daño_total_inflingido DECIMAL(15,3)  NOT NULL,
    daño_recibido DECIMAL(15,3)  NOT NULL,
    curacion_recibida DECIMAL(15,3) NOT NULL,
    final_realizado INT NOT NULL,
    PRIMARY KEY (id_jugador, fecha_registro),
    FOREIGN KEY (id_jugador) REFERENCES jugador(id_jugador)
);

-- Entitidad: ESTAMPA
CREATE TABLE IF NOT EXISTS estampa (
    id_jugador INT NOT NULL,
    fecha_registro DATETIME NOT NULL,
    tipo_habitacion INT,
    nivel VARCHAR(100),
    accion VARCHAR(50),
    id_elemento INT,
    PRIMARY KEY (id_jugador, fecha_registro),
    FOREIGN KEY (id_jugador) REFERENCES jugador(id_jugador)
);

-- Inserciones:
INSERT INTO jugador (nombre, alias, fecha_union, victorias_totales, logros, personaje_pref)
VALUES 
('LucianoAlfa', 'ElDuro', CURDATE(), 0, NULL, 1),
('MaraStrike', 'Silencio Mortal', CURDATE(), 0, '{"logro_1": true, "logro_3": false}', 2),
('KrovanX', 'El Rápido', CURDATE(), 0, NULL, 1),
('YurikaM', 'Fénix Azul', CURDATE(), 0, '{"logro_2": true}', 2),
('HexTech', 'El Cazador', CURDATE(), 0, NULL, 1);
