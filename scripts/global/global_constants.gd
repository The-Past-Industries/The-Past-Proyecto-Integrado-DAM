class_name GlobalConstants

# Data paths
const ITEMS_LIST_JSON_PATH: String = "res://raw_data/item_list.json"
const LOG_FILE_DEBUG: String = "user://log.txt"

# === WORLD GENERATION PROPERTIES ===

# Base length of the main path from initial room
const WORLDGEN_MAX_LENGTH_FROM_INIT: int = 50

# Additional length per level
const WORLDGEN_MAX_LENGTH_LEVEL_MULTLIPIER: int = 100


const WORLDGEN_MAX_INSTANCES_PER_POPULATION: int = 3
const WORLDGEN_MAX_TARGET_SECUNDARY_BRANCH: int = 3

# -- Main path verticality --
const WORLDGEN_MAX_VERTICAL_CORRIDORS: int = 4
const WORLDGEN_VERTICAL_CORRIDOR_TURN_CHANCE: float = 0.4

# -- Branches --
const WORLDGEN_BRANCHING_ROOM_CHANCE: float = 0.4
const WORLDGEN_BRANCH_LENGTH_MIN: int = 2
const WORLDGEN_BRANCH_LENGTH_MAX: int = 5
const WORLDGEN_MAX_BACKTRACK_ATTEMPTS: int = 4

# -- Rooms --
const WORLDGEN_MIN_COMMON_ROOMS_PER_LEVEL: int = 25


# -- Special rooms --
const WORLDGEN_MAX_TREASURE_ROOMS_PER_LEVEL: int = 6
const WORLDGEN_MAX_SHOP_ROOMS_PER_LEVEL: int = 2
const WORLDGEN_CAMPUS_ROOM_CHANCE: float = 1
const WORLDGEN_MAX_BOSS_ATTEMPTS = 15


# -- Debug --
const WORLDGEN_DEBUG_DEFAULT_SEED: int = 72139486
