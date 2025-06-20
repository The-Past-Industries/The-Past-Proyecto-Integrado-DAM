extends Node
class_name EntityPopulator

var generator := EntityGenerator.new()

# RESOURCES

# COMMON ENEMIES

var ANIMATION_HOST_COMMON = preload("res://scenes/characters/enemies/animation_host_common.tscn")

# ASIMOLE
const ASIMOLE_1 = preload("res://scenes/characters/enemies/asimole_1_7/asimole_1.tres")
const ASIMOLE_2 = preload("res://scenes/characters/enemies/asimole_1_7/asimole_2.tres")
const ASIMOLE_3 = preload("res://scenes/characters/enemies/asimole_1_7/asimole_3.tres")
const ASIMOLE_4 = preload("res://scenes/characters/enemies/asimole_1_7/asimole_4.tres")
const ASIMOLE_5 = preload("res://scenes/characters/enemies/asimole_1_7/asimole_5.tres")
const ASIMOLE_6 = preload("res://scenes/characters/enemies/asimole_1_7/asimole_6.tres")
const ASIMOLE_7 = preload("res://scenes/characters/enemies/asimole_1_7/asimole_7.tres")

# BARREL
const BARREL_1 = preload("res://scenes/characters/enemies/barrel_1_4/barrel_1.tres")
const BARREL_2 = preload("res://scenes/characters/enemies/barrel_1_4/barrel_2.tres")
const BARREL_3 = preload("res://scenes/characters/enemies/barrel_1_4/barrel_3.tres")
const BARREL_4 = preload("res://scenes/characters/enemies/barrel_1_4/barrel_4.tres")

# BAT
const BAT_1 = preload("res://scenes/characters/enemies/bat_1_7/bat_1.tres")
const BAT_2 = preload("res://scenes/characters/enemies/bat_1_7/bat_2.tres")
const BAT_3 = preload("res://scenes/characters/enemies/bat_1_7/bat_3.tres")
const BAT_4 = preload("res://scenes/characters/enemies/bat_1_7/bat_4.tres")
const BAT_5 = preload("res://scenes/characters/enemies/bat_1_7/bat_5.tres")
const BAT_6 = preload("res://scenes/characters/enemies/bat_1_7/bat_6.tres")
const BAT_7 = preload("res://scenes/characters/enemies/bat_1_7/bat_7.tres")

# CACTUAR
const CACTUAR_1 = preload("res://scenes/characters/enemies/cactuar_1_4/cactuar_1.tres")
const CACTUAR_2 = preload("res://scenes/characters/enemies/cactuar_1_4/cactuar_2.tres")
const CACTUAR_3 = preload("res://scenes/characters/enemies/cactuar_1_4/cactuar_3.tres")
const CACTUAR_4 = preload("res://scenes/characters/enemies/cactuar_1_4/cactuar_4.tres")

# CREEPS
const CREEPS_1 = preload("res://scenes/characters/enemies/creeps_1_4/creeps_1.tres")
const CREEPS_2 = preload("res://scenes/characters/enemies/creeps_1_4/creeps_2.tres")
const CREEPS_3 = preload("res://scenes/characters/enemies/creeps_1_4/creeps_3.tres")
const CREEPS_4 = preload("res://scenes/characters/enemies/creeps_1_4/creeps_4.tres")

# DEFENCER
const DEFENCER_1 = preload("res://scenes/characters/enemies/defencer_1_7/defencer_1.tres")
const DEFENCER_2 = preload("res://scenes/characters/enemies/defencer_1_7/defencer_2.tres")
const DEFENCER_3 = preload("res://scenes/characters/enemies/defencer_1_7/defencer_3.tres")
const DEFENCER_4 = preload("res://scenes/characters/enemies/defencer_1_7/defencer_4.tres")
const DEFENCER_5 = preload("res://scenes/characters/enemies/defencer_1_7/defencer_5.tres")
const DEFENCER_6 = preload("res://scenes/characters/enemies/defencer_1_7/defencer_6.tres")

# DEMONPOT
const DEMONPOT_1 = preload("res://scenes/characters/enemies/demonpot_1_5/demonpot_1.tres")
const DEMONPOT_2 = preload("res://scenes/characters/enemies/demonpot_1_5/demonpot_2.tres")
const DEMONPOT_3 = preload("res://scenes/characters/enemies/demonpot_1_5/demonpot_3.tres")
const DEMONPOT_4 = preload("res://scenes/characters/enemies/demonpot_1_5/demonpot_4.tres")
const DEMONPOT_5 = preload("res://scenes/characters/enemies/demonpot_1_5/demonpot_5.tres")

# DRAGONFLY
const DRAGONFLY_1 = preload("res://scenes/characters/enemies/dragonfly_1_7/dragonfly_1.tres")
const DRAGONFLY_2 = preload("res://scenes/characters/enemies/dragonfly_1_7/dragonfly_2.tres")
const DRAGONFLY_3 = preload("res://scenes/characters/enemies/dragonfly_1_7/dragonfly_3.tres")
const DRAGONFLY_4 = preload("res://scenes/characters/enemies/dragonfly_1_7/dragonfly_4.tres")
const DRAGONFLY_5 = preload("res://scenes/characters/enemies/dragonfly_1_7/dragonfly_5.tres")
const DRAGONFLY_6 = preload("res://scenes/characters/enemies/dragonfly_1_7/dragonfly_6.tres")
const DRAGONFLY_7 = preload("res://scenes/characters/enemies/dragonfly_1_7/dragonfly_7.tres")

# DUMMY
const DUMMY_1 = preload("res://scenes/characters/enemies/dummy_1_4/dummy_1.tres")
const DUMMY_2 = preload("res://scenes/characters/enemies/dummy_1_4/dummy_2.tres")
const DUMMY_3 = preload("res://scenes/characters/enemies/dummy_1_4/dummy_3.tres")
const DUMMY_4 = preload("res://scenes/characters/enemies/dummy_1_4/dummy_4.tres")

# ELEMENT
const ELEMENT_1 = preload("res://scenes/characters/enemies/element_1_7/element_1.tres")
const ELEMENT_2 = preload("res://scenes/characters/enemies/element_1_7/element_2.tres")
const ELEMENT_3 = preload("res://scenes/characters/enemies/element_1_7/element_3.tres")
const ELEMENT_4 = preload("res://scenes/characters/enemies/element_1_7/element_4.tres")
const ELEMENT_5 = preload("res://scenes/characters/enemies/element_1_7/element_5.tres")
const ELEMENT_6 = preload("res://scenes/characters/enemies/element_1_7/element_6.tres")
const ELEMENT_7 = preload("res://scenes/characters/enemies/element_1_7/element_7.tres")

# FAIRY
#const FAIRY_1 = preload("res://scenes/characters/enemies/fairy_1_7/fairy_1.tres")
#const FAIRY_2 = preload("res://scenes/characters/enemies/fairy_1_7/fairy_2.tres")
#const FAIRY_3 = preload("res://scenes/characters/enemies/fairy_1_7/fairy_3.tres")
#const FAIRY_4 = preload("res://scenes/characters/enemies/fairy_1_7/fairy_4.tres")
#const FAIRY_5 = preload("res://scenes/characters/enemies/fairy_1_7/fairy_5.tres")
#const FAIRY_6 = preload("res://scenes/characters/enemies/fairy_1_7/fairy_6.tres")
#const FAIRY_7 = preload("res://scenes/characters/enemies/fairy_1_7/fairy_7.tres")

# FROG
#const FROG_1 = preload("res://scenes/characters/enemies/frog_1_14/frog_1.tres")
#const FROG_2 = preload("res://scenes/characters/enemies/frog_1_14/frog_2.tres")
#const FROG_3 = preload("res://scenes/characters/enemies/frog_1_14/frog_3.tres")
#const FROG_4 = preload("res://scenes/characters/enemies/frog_1_14/frog_4.tres")
#const FROG_5 = preload("res://scenes/characters/enemies/frog_1_14/frog_5.tres")
#const FROG_6 = preload("res://scenes/characters/enemies/frog_1_14/frog_6.tres")
#const FROG_7 = preload("res://scenes/characters/enemies/frog_1_14/frog_7.tres")
#const FROG_8 = preload("res://scenes/characters/enemies/frog_1_14/frog_8.tres")
#const FROG_9 = preload("res://scenes/characters/enemies/frog_1_14/frog_9.tres")
#const FROG_10 = preload("res://scenes/characters/enemies/frog_1_14/frog_10.tres")
#const FROG_11 = preload("res://scenes/characters/enemies/frog_1_14/frog_11.tres")
#const FROG_12 = preload("res://scenes/characters/enemies/frog_1_14/frog_12.tres")
#const FROG_13 = preload("res://scenes/characters/enemies/frog_1_14/frog_13.tres")
#const FROG_14 = preload("res://scenes/characters/enemies/frog_1_14/frog_14.tres")

# GENIE
const GENIE_1 = preload("res://scenes/characters/enemies/genie_1_7/genie_1.tres")
const GENIE_2 = preload("res://scenes/characters/enemies/genie_1_7/genie_2.tres")
const GENIE_3 = preload("res://scenes/characters/enemies/genie_1_7/genie_3.tres")
const GENIE_4 = preload("res://scenes/characters/enemies/genie_1_7/genie_4.tres")
const GENIE_5 = preload("res://scenes/characters/enemies/genie_1_7/genie_5.tres")
const GENIE_6 = preload("res://scenes/characters/enemies/genie_1_7/genie_6.tres")
const GENIE_7 = preload("res://scenes/characters/enemies/genie_1_7/genie_7.tres")

# HOBGOB
const HOBGOB_1 = preload("res://scenes/characters/enemies/hobgob_1_6/hobgob_1.tres")
const HOBGOB_2 = preload("res://scenes/characters/enemies/hobgob_1_6/hobgob_2.tres")
const HOBGOB_3 = preload("res://scenes/characters/enemies/hobgob_1_6/hobgob_3.tres")
const HOBGOB_4 = preload("res://scenes/characters/enemies/hobgob_1_6/hobgob_4.tres")
const HOBGOB_5 = preload("res://scenes/characters/enemies/hobgob_1_6/hobgob_5.tres")
const HOBGOB_6 = preload("res://scenes/characters/enemies/hobgob_1_6/hobgob_6.tres")

# JACKOLANTERN
const JACKOLANTERN_1 = preload("res://scenes/characters/enemies/jackolantern_1_5/jackolantern_1.tres")
const JACKOLANTERN_2 = preload("res://scenes/characters/enemies/jackolantern_1_5/jackolantern_2.tres")
const JACKOLANTERN_3 = preload("res://scenes/characters/enemies/jackolantern_1_5/jackolantern_3.tres")
const JACKOLANTERN_4 = preload("res://scenes/characters/enemies/jackolantern_1_5/jackolantern_4.tres")
const JACKOLANTERN_5 = preload("res://scenes/characters/enemies/jackolantern_1_5/jackolantern_5.tres")

# LANTERN
const LANTERN_1 = preload("res://scenes/characters/enemies/lantern_1_7/lantern_1.tres")
const LANTERN_2 = preload("res://scenes/characters/enemies/lantern_1_7/lantern_2.tres")
const LANTERN_3 = preload("res://scenes/characters/enemies/lantern_1_7/lantern_3.tres")
const LANTERN_4 = preload("res://scenes/characters/enemies/lantern_1_7/lantern_4.tres")
const LANTERN_5 = preload("res://scenes/characters/enemies/lantern_1_7/lantern_5.tres")
const LANTERN_6 = preload("res://scenes/characters/enemies/lantern_1_7/lantern_6.tres")
const LANTERN_7 = preload("res://scenes/characters/enemies/lantern_1_7/lantern_7.tres")

# MECHASPHERE
const MECHASPHERE_1 = preload("res://scenes/characters/enemies/mechasphere_1_4/mechasphere_1.tres")
const MECHASPHERE_2 = preload("res://scenes/characters/enemies/mechasphere_1_4/mechasphere_2.tres")
const MECHASPHERE_3 = preload("res://scenes/characters/enemies/mechasphere_1_4/mechasphere_3.tres")
const MECHASPHERE_4 = preload("res://scenes/characters/enemies/mechasphere_1_4/mechasphere_4.tres")

# SLIME
const SLIME_1 = preload("res://scenes/characters/enemies/slime_1_8/slime_1.tres")
const SLIME_2 = preload("res://scenes/characters/enemies/slime_1_8/slime_2.tres")
const SLIME_3 = preload("res://scenes/characters/enemies/slime_1_8/slime_3.tres")
const SLIME_4 = preload("res://scenes/characters/enemies/slime_1_8/slime_4.tres")
const SLIME_5 = preload("res://scenes/characters/enemies/slime_1_8/slime_5.tres")
const SLIME_6 = preload("res://scenes/characters/enemies/slime_1_8/slime_6.tres")
const SLIME_7 = preload("res://scenes/characters/enemies/slime_1_8/slime_7.tres")
const SLIME_8 = preload("res://scenes/characters/enemies/slime_1_8/slime_8.tres")

# SPORE
const SPORE_1 = preload("res://scenes/characters/enemies/spore_1_7/spore_1.tres")
const SPORE_2 = preload("res://scenes/characters/enemies/spore_1_7/spore_2.tres")
const SPORE_3 = preload("res://scenes/characters/enemies/spore_1_7/spore_3.tres")
const SPORE_4 = preload("res://scenes/characters/enemies/spore_1_7/spore_4.tres")
const SPORE_5 = preload("res://scenes/characters/enemies/spore_1_7/spore_5.tres")
const SPORE_6 = preload("res://scenes/characters/enemies/spore_1_7/spore_6.tres")
const SPORE_7 = preload("res://scenes/characters/enemies/spore_1_7/spore_7.tres")

# TREANT
const TREANT_1 = preload("res://scenes/characters/enemies/treant_1_7/treant_1.tres")
const TREANT_2 = preload("res://scenes/characters/enemies/treant_1_7/treant_2.tres")
const TREANT_3 = preload("res://scenes/characters/enemies/treant_1_7/treant_3.tres")
const TREANT_4 = preload("res://scenes/characters/enemies/treant_1_7/treant_4.tres")
const TREANT_5 = preload("res://scenes/characters/enemies/treant_1_7/treant_5.tres")
const TREANT_6 = preload("res://scenes/characters/enemies/treant_1_7/treant_6.tres")
const TREANT_7 = preload("res://scenes/characters/enemies/treant_1_7/treant_7.tres")

# TWOFACED
const TWOFACED_1 = preload("res://scenes/characters/enemies/twofaced_1_7/twofaced_1.tres")
const TWOFACED_2 = preload("res://scenes/characters/enemies/twofaced_1_7/twofaced_2.tres")
const TWOFACED_3 = preload("res://scenes/characters/enemies/twofaced_1_7/twofaced_3.tres")
const TWOFACED_4 = preload("res://scenes/characters/enemies/twofaced_1_7/twofaced_4.tres")
const TWOFACED_5 = preload("res://scenes/characters/enemies/twofaced_1_7/twofaced_5.tres")
const TWOFACED_6 = preload("res://scenes/characters/enemies/twofaced_1_7/twofaced_6.tres")
const TWOFACED_7 = preload("res://scenes/characters/enemies/twofaced_1_7/twofaced_7.tres")

var resource_list: Array = [
	# ASIMOLE
	ASIMOLE_1, ASIMOLE_2, ASIMOLE_3, ASIMOLE_4, ASIMOLE_5, ASIMOLE_6, ASIMOLE_7,

	# BARREL
	BARREL_1, BARREL_2, BARREL_3, BARREL_4,

	# BAT
	BAT_1, BAT_2, BAT_3, BAT_4, BAT_5, BAT_6, BAT_7,

	# CACTUAR
	CACTUAR_1, CACTUAR_2, CACTUAR_3, CACTUAR_4,

	# CREEPS
	CREEPS_1, CREEPS_2, CREEPS_3, CREEPS_4,

	# DEFENCER
	DEFENCER_1, DEFENCER_2, DEFENCER_3, DEFENCER_4, DEFENCER_5, DEFENCER_6,

	# DEMONPOT
	DEMONPOT_1, DEMONPOT_2, DEMONPOT_3, DEMONPOT_4, DEMONPOT_5,

	# DRAGONFLY
	DRAGONFLY_1, DRAGONFLY_2, DRAGONFLY_3, DRAGONFLY_4, DRAGONFLY_5, DRAGONFLY_6, DRAGONFLY_7,

	# DUMMY
	DUMMY_1, DUMMY_2, DUMMY_3, DUMMY_4,

	# ELEMENT
	ELEMENT_1, ELEMENT_2, ELEMENT_3, ELEMENT_4, ELEMENT_5, ELEMENT_6, ELEMENT_7,

	# GENIE
	GENIE_1, GENIE_2, GENIE_3, GENIE_4, GENIE_5, GENIE_6, GENIE_7,

	# HOBGOB
	HOBGOB_1, HOBGOB_2, HOBGOB_3, HOBGOB_4, HOBGOB_5, HOBGOB_6,

	# JACKOLANTERN
	JACKOLANTERN_1, JACKOLANTERN_2, JACKOLANTERN_3, JACKOLANTERN_4, JACKOLANTERN_5,

	# LANTERN
	LANTERN_1, LANTERN_2, LANTERN_3, LANTERN_4, LANTERN_5, LANTERN_6, LANTERN_7,

	# MECHASPHERE
	MECHASPHERE_1, MECHASPHERE_2, MECHASPHERE_3, MECHASPHERE_4,

	# SLIME
	SLIME_1, SLIME_2, SLIME_3, SLIME_4, SLIME_5, SLIME_6, SLIME_7, SLIME_8,

	# SPORE
	SPORE_1, SPORE_2, SPORE_3, SPORE_4, SPORE_5, SPORE_6, SPORE_7,

	# TREANT
	TREANT_1, TREANT_2, TREANT_3, TREANT_4, TREANT_5, TREANT_6, TREANT_7,

	# TWOFACED
	TWOFACED_1, TWOFACED_2, TWOFACED_3, TWOFACED_4, TWOFACED_5, TWOFACED_6, TWOFACED_7,
]

var resource_name_map: Dictionary = {
	ASIMOLE_1: "asimole_1",
	ASIMOLE_2: "asimole_2",
	ASIMOLE_3: "asimole_3",
	ASIMOLE_4: "asimole_4",
	ASIMOLE_5: "asimole_5",
	ASIMOLE_6: "asimole_6",
	ASIMOLE_7: "asimole_7",

	BARREL_1: "barrel_1",
	BARREL_2: "barrel_2",
	BARREL_3: "barrel_3",
	BARREL_4: "barrel_4",

	BAT_1: "bat_1",
	BAT_2: "bat_2",
	BAT_3: "bat_3",
	BAT_4: "bat_4",
	BAT_5: "bat_5",
	BAT_6: "bat_6",
	BAT_7: "bat_7",

	CACTUAR_1: "cactuar_1",
	CACTUAR_2: "cactuar_2",
	CACTUAR_3: "cactuar_3",
	CACTUAR_4: "cactuar_4",

	CREEPS_1: "creeps_1",
	CREEPS_2: "creeps_2",
	CREEPS_3: "creeps_3",
	CREEPS_4: "creeps_4",

	DEFENCER_1: "defencer_1",
	DEFENCER_2: "defencer_2",
	DEFENCER_3: "defencer_3",
	DEFENCER_4: "defencer_4",
	DEFENCER_5: "defencer_5",
	DEFENCER_6: "defencer_6",

	DEMONPOT_1: "demonpot_1",
	DEMONPOT_2: "demonpot_2",
	DEMONPOT_3: "demonpot_3",
	DEMONPOT_4: "demonpot_4",
	DEMONPOT_5: "demonpot_5",

	DRAGONFLY_1: "dragonfly_1",
	DRAGONFLY_2: "dragonfly_2",
	DRAGONFLY_3: "dragonfly_3",
	DRAGONFLY_4: "dragonfly_4",
	DRAGONFLY_5: "dragonfly_5",
	DRAGONFLY_6: "dragonfly_6",
	DRAGONFLY_7: "dragonfly_7",

	DUMMY_1: "dummy_1",
	DUMMY_2: "dummy_2",
	DUMMY_3: "dummy_3",
	DUMMY_4: "dummy_4",

	ELEMENT_1: "element_1",
	ELEMENT_2: "element_2",
	ELEMENT_3: "element_3",
	ELEMENT_4: "element_4",
	ELEMENT_5: "element_5",
	ELEMENT_6: "element_6",
	ELEMENT_7: "element_7",

	GENIE_1: "genie_1",
	GENIE_2: "genie_2",
	GENIE_3: "genie_3",
	GENIE_4: "genie_4",
	GENIE_5: "genie_5",
	GENIE_6: "genie_6",
	GENIE_7: "genie_7",

	HOBGOB_1: "hobgob_1",
	HOBGOB_2: "hobgob_2",
	HOBGOB_3: "hobgob_3",
	HOBGOB_4: "hobgob_4",
	HOBGOB_5: "hobgob_5",
	HOBGOB_6: "hobgob_6",

	JACKOLANTERN_1: "jackolantern_1",
	JACKOLANTERN_2: "jackolantern_2",
	JACKOLANTERN_3: "jackolantern_3",
	JACKOLANTERN_4: "jackolantern_4",
	JACKOLANTERN_5: "jackolantern_5",

	LANTERN_1: "lantern_1",
	LANTERN_2: "lantern_2",
	LANTERN_3: "lantern_3",
	LANTERN_4: "lantern_4",
	LANTERN_5: "lantern_5",
	LANTERN_6: "lantern_6",
	LANTERN_7: "lantern_7",

	MECHASPHERE_1: "mechasphere_1",
	MECHASPHERE_2: "mechasphere_2",
	MECHASPHERE_3: "mechasphere_3",
	MECHASPHERE_4: "mechasphere_4",

	SLIME_1: "slime_1",
	SLIME_2: "slime_2",
	SLIME_3: "slime_3",
	SLIME_4: "slime_4",
	SLIME_5: "slime_5",
	SLIME_6: "slime_6",
	SLIME_7: "slime_7",
	SLIME_8: "slime_8",

	SPORE_1: "spore_1",
	SPORE_2: "spore_2",
	SPORE_3: "spore_3",
	SPORE_4: "spore_4",
	SPORE_5: "spore_5",
	SPORE_6: "spore_6",
	SPORE_7: "spore_7",

	TREANT_1: "treant_1",
	TREANT_2: "treant_2",
	TREANT_3: "treant_3",
	TREANT_4: "treant_4",
	TREANT_5: "treant_5",
	TREANT_6: "treant_6",
	TREANT_7: "treant_7",

	TWOFACED_1: "twofaced_1",
	TWOFACED_2: "twofaced_2",
	TWOFACED_3: "twofaced_3",
	TWOFACED_4: "twofaced_4",
	TWOFACED_5: "twofaced_5",
	TWOFACED_6: "twofaced_6",
	TWOFACED_7: "twofaced_7"
}

const ANIMATION_HOST_GORGON = preload("res://scenes/characters/enemies/special/gorgon_1_3/animation_host_gorgon.tscn")
const GORGON_1 = preload("res://scenes/characters/enemies/special/gorgon_1_3/gorgon_1.tres")
const GORGON_2 = preload("res://scenes/characters/enemies/special/gorgon_1_3/gorgon_2.tres")
const GORGON_3 = preload("res://scenes/characters/enemies/special/gorgon_1_3/gorgon_3.tres")

const ANIMATION_HOST_MINOTAUR = preload("res://scenes/characters/enemies/special/minotaur_1_3/animation_host_minotaur.tscn")
const MINOTAUR_1 = preload("res://scenes/characters/enemies/special/minotaur_1_3/minotaur_1.tres")
const MINOTAUR_2 = preload("res://scenes/characters/enemies/special/minotaur_1_3/minotaur_2.tres")
const MINOTAUR_3 = preload("res://scenes/characters/enemies/special/minotaur_1_3/minotaur_3.tres")

const ANIMATION_HOST_VAMPIRE = preload("res://scenes/characters/enemies/special/vampire_1_3/animation_host_vampire.tscn")
const VAMPIRE_1 = preload("res://scenes/characters/enemies/special/vampire_1_3/vampire_1.tres")
const VAMPIRE_2 = preload("res://scenes/characters/enemies/special/vampire_1_3/vampire_2.tres")
const VAMPIRE_3 = preload("res://scenes/characters/enemies/special/vampire_1_3/vampire_3.tres")

const ANIMATION_HOST_WEREWOLF = preload("res://scenes/characters/enemies/special/werewolf_1_3/animation_host_werewolf.tscn")
const WEREWOLF_1 = preload("res://scenes/characters/enemies/special/werewolf_1_3/werewolf_1.tres")
const WEREWOLF_2 = preload("res://scenes/characters/enemies/special/werewolf_1_3/werewolf_2.tres")
const WEREWOLF_3 = preload("res://scenes/characters/enemies/special/werewolf_1_3/werewolf_3.tres")

const ANIMATION_HOST_WIZARD_1 = preload("res://scenes/characters/enemies/special/wizard/animation_host_wizard_1.tscn")

const ANIMATION_HOST_WIZARD_2 = preload("res://scenes/characters/enemies/special/wizard/animation_host_wizard_2.tscn")

const ANIMATION_HOST_WIZARD_3 = preload("res://scenes/characters/enemies/special/wizard/animation_host_wizard_3.tscn")

const ANIMATION_HOST_YOKAI_1_2 = preload("res://scenes/characters/enemies/special/yokai/animation_host_yokai_1_2.tscn")
const YOKAI_1 = preload("res://scenes/characters/enemies/special/yokai/yokai_1.tres")
const YOKAI_2 = preload("res://scenes/characters/enemies/special/yokai/yokai_2.tres")

const ANIMATION_HOST_YOKAI_3 = preload("res://scenes/characters/enemies/special/yokai/animation_host_yokai_3.tscn")


func load_common_enemies() -> Array[EntityEnemy]:
	var list: Array[EntityEnemy] = []
	for resource in resource_list:
		var enemy: EntityEnemy = generator.generate_entity(EntityType.ENEMY) as EntityEnemy
		enemy.body_instance = ANIMATION_HOST_COMMON.instantiate()
		enemy.body_instance.call_deferred("set_sprite_frames", resource)
		enemy.stats_manager.randomizeStats()
		
		if resource_name_map.has(resource):
			enemy.sprite_name = resource_name_map[resource]
		else:
			enemy.sprite_name = "unknown"
		list.append(enemy)
	return list

func load_bosses() -> Array:
	var list: Array[EntityBoss] = []
	_load_gorgons(list)
	_load_minotaurs(list)
	_load_vampires(list)
	_load_werewolves(list)
	_load_wizard_1(list)
	_load_wizard_2(list)
	_load_wizard_3(list)
	_load_yokais_1_2(list)
	_load_yokai_3(list)
	return list

func _load_gorgons(list: Array[EntityBoss]):
	var const_list = [GORGON_1, GORGON_2, GORGON_3]
	for resource in const_list:
		var boss: EntityBoss = generator.generate_entity(EntityType.BOSS)
		boss.body_instance = ANIMATION_HOST_GORGON.instantiate()
		boss.body_instance.call_deferred("set_sprite_frames", resource)
		boss.stats_manager.randomize_boss_stats()
		boss.boss_type = BossType.GORGON
		list.append(boss)
	
func _load_minotaurs(list: Array[EntityBoss]):
	var const_list = [MINOTAUR_1, MINOTAUR_2, MINOTAUR_3]
	for resource in const_list:
		var boss: EntityBoss = generator.generate_entity(EntityType.BOSS)
		boss.body_instance = ANIMATION_HOST_MINOTAUR.instantiate()
		boss.body_instance.call_deferred("set_sprite_frames", resource)
		boss.stats_manager.randomize_boss_stats()
		boss.boss_type = BossType.MINOTAUR
		list.append(boss)
	
func _load_vampires(list: Array[EntityBoss]):
	var const_list = [VAMPIRE_1, VAMPIRE_2, VAMPIRE_3]
	for resource in const_list:
		var boss: EntityBoss = generator.generate_entity(EntityType.BOSS)
		boss.body_instance = ANIMATION_HOST_VAMPIRE.instantiate()
		boss.body_instance.call_deferred("set_sprite_frames", resource)
		boss.stats_manager.randomize_boss_stats()
		boss.boss_type = BossType.VAMPIRE
		list.append(boss)
	
func _load_werewolves(list: Array[EntityBoss]):
	var const_list = [WEREWOLF_1, WEREWOLF_2, WEREWOLF_3]
	for resource in const_list:
		var boss: EntityBoss = generator.generate_entity(EntityType.BOSS)
		boss.body_instance = ANIMATION_HOST_WEREWOLF.instantiate()
		boss.body_instance.call_deferred("set_sprite_frames", resource)
		boss.stats_manager.randomize_boss_stats()
		boss.boss_type = BossType.WEREWOLF
		list.append(boss)
	
func _load_wizard_1(list: Array[EntityBoss]):
	var boss: EntityBoss = generator.generate_entity(EntityType.BOSS)
	boss.body_instance = ANIMATION_HOST_WIZARD_1.instantiate()
	boss.stats_manager.randomize_boss_stats()
	boss.boss_type = BossType.WIZARD_1
	list.append(boss)
	
func _load_wizard_2(list: Array[EntityBoss]):
	var boss: EntityBoss = generator.generate_entity(EntityType.BOSS)
	boss.body_instance = ANIMATION_HOST_WIZARD_2.instantiate()
	boss.stats_manager.randomize_boss_stats()
	boss.boss_type = BossType.WIZARD_2
	list.append(boss)
	
func _load_wizard_3(list: Array[EntityBoss]):
	var boss: EntityBoss = generator.generate_entity(EntityType.BOSS)
	boss.body_instance = ANIMATION_HOST_WIZARD_3.instantiate()
	boss.stats_manager.randomize_boss_stats()
	boss.boss_type = BossType.WIZARD_3
	list.append(boss)
	
func _load_yokais_1_2(list: Array[EntityBoss]):
	var const_list = [YOKAI_1, YOKAI_2]
	for resource in const_list:
		var boss: EntityBoss = generator.generate_entity(EntityType.BOSS)
		boss.body_instance = ANIMATION_HOST_YOKAI_1_2.instantiate()
		boss.body_instance.call_deferred("set_sprite_frames", resource)
		boss.stats_manager.randomize_boss_stats()
		boss.boss_type = BossType.YOKAI
		list.append(boss)
	
func _load_yokai_3(list: Array[EntityBoss]):
	var boss: EntityBoss = generator.generate_entity(EntityType.BOSS)
	boss.body_instance = ANIMATION_HOST_YOKAI_3.instantiate()
	boss.stats_manager.randomize_boss_stats()
	boss.boss_type = BossType.YOKAI_3
	list.append(boss)
