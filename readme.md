# 👑 The Past: A Procedural Dungeon Adventure

**The Past** es un videojuego de exploración y combate donde cada partida ofrece una experiencia única gracias a su sistema de **generación de mundo**. El juego utiliza una estética **HD-2D**, combinando sprites en pixel art con entornos 3D e **iluminación volumétrica tridimensional aplicada a elementos 2D**.

---

## 🎮 Características principales

- 🧩 **Generación aleatoria** de niveles: cada piso se genera en una cuadrícula conectada por pasillos con reglas específicas.
- 🗺️ **Minimapa interactivo**: muestra salas reveladas, pasillos, y marcadores de tipo (tienda, jefe, tesoro, etc.).
- ⚔️ **Sistema de combate visual**: efectos animados y sincronizados con lógica de juego.
- 📦 **Celdas con conexión lógica**: los pasillos y salas se interconectan con restricciones y condiciones.
- 🧙‍♂️ **Eventos aleatorios**: probabilidades controladas de ocurrencia de efectos o sucesos en salas específicas.
- 🌟 **Efectos visuales dinámicos**: partículas, resplandores y animaciones que simulan magia, ataques, habilidades o elementos del ambiente.
- 💡 **Iluminación 3D en elementos 2D**: sprites y efectos reciben luz, sombra y ambiente del entorno 3D.
- 🖼️ **Estilo HD-2D**: combina pixel art 2D con profundidad visual 3D.

---

## 🧱 Arquitectura del juego

- `WorldGenerator`: lógica de creación procedural basada en grafos
- `MapVisualizer`: visualización del minimapa desde una perspectiva top-down
- `RoomData`: define tipo, conexiones, visibilidad y eventos de cada sala
- `CombatManager` y `VFXPlayer`: manejan combate, animaciones y transiciones
- `EntityManagerGlobal`: acceso global a entidades del jugador y enemigos

---

## 🧪 Mecánicas implementadas

- 🧭 Exploración sala a sala con condiciones de visibilidad
- 🎯 Teletransporte y aparición de enemigos
- 🔁 Animaciones condicionales y secuencias temporizadas
- 💥 Efectos que viajan entre posiciones del escenario
- 🗡️ Sistema de combate por turnos e interacción de estadísticas
---

## 🛠️ Tecnologías utilizadas

- [Godot Engine 4.4](https://godotengine.org/)
- GDScript (con estructuras y tipado fuerte)
- Estructura lógica de clases y objetos a medida
- Diseño modular con nodos como `Node3D`, `Panel`, `TextureRect`, `ColorRect`, ...
- Iluminación global y luces dinámicas (`OmniLight3D`, materiales emissive)
- Estructuras de datos en `Dictionary`, `Vector2i`, `Array`, `enum` personalizados

---

## 🤝 Contribuir

Buscamos aportes para:

- Nuevos tipos de salas o patrones de generación
- Efectos visuales adicionales (magia, trampas, eventos ambientales)
- Mejoras en la lógica de combate y balance de enemigos
- UI y accesibilidad del minimapa

---

## 📋 Próximas metas

- 🧠 IA básica para enemigos
- ⛓️ Niveles encadenados con progresión
- 💬 Localización e interfaz multilingüe
- 🎮 Soporte para mando y HUD dinámico

---

## 🏛️ Licencia

Proyecto creado por The Past Industries. Licencia en revisión.
