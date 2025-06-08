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
    id_usuario INT NOT NULL,
    fecha_registro DATETIME NOT NULL,
    dinero_total INT  NOT NULL,
    enemigos_matados LONGTEXT  NOT NULL,
    daño_total_inflingido DECIMAL(15,3)  NOT NULL,
    daño_recibido DECIMAL(15,3)  NOT NULL,
    curacion_recibida DECIMAL(15,3) NOT NULL,
    final_realizado INT NOT NULL,
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

INSERT INTO partida 
VALUES
(1, CURDATE(), 1200, 350, 3, 1, 'esqueleto:5,zombie:3,bruja:1', 1234.567, 2345.678, 150.123, 3730.368, 890.234, 456.789, 3),
(1, CURDATE(), 1225, 410, 5, 2, 'goblin:10,lobo:2', 800.000, 3100.500, 200.000, 4100.500, 760.000, 500.250, 6),
(2, CURDATE(), 1180, 290, 1, 1, 'vampiro:1,esqueleto:3', 1600.000, 1900.000, 300.000, 3800.000, 1200.500, 400.000, 2),
(3, CURDATE(), 1210, 500, 4, 2, 'zombie:4,lobo:6,bruja:2', 1450.350, 2250.250, 175.175, 3875.775, 910.890, 600.600, 7),
(1, CURDATE(), 1195, 370, 2, 1, 'golem:1,bruja:1', 900.900, 2700.000, 100.000, 3700.900, 800.800, 350.350, 4),
(3, CURDATE(), 1230, 420, 3, 2, 'goblin:5,esqueleto:5', 1300.500, 2400.600, 225.225, 3926.325, 980.120, 490.490, 8),
(3, CURDATE(), 1170, 310, 2, 1, 'bruja:3,zombie:2', 1100.000, 2100.100, 180.000, 3380.100, 870.870, 370.370, 9),
(2, CURDATE(), 1205, 460, 6, 2, 'vampiro:2,lobo:4', 1700.250, 2800.750, 250.250, 4751.250, 1050.100, 610.610, 1),
(1, CURDATE(), 1188, 395, 2, 1, 'esqueleto:6,golem:1', 1400.400, 2000.000, 220.000, 3620.400, 960.960, 480.480, 5),
(4, CURDATE(), 1222, 380, 4, 2, 'goblin:8,bruja:1', 1250.000, 2350.000, 190.000, 3790.000, 920.920, 530.530, 10);
