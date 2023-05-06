extends ContentInfo

# Constants
const TRANSLATIONS: Array = [
	preload("mod_strings.en.translation"),
]

const RESOURCES: Dictionary = {
	"res://data/spawn_config_scripts/MonsterSpawnProfile.gd":
		preload("MonsterSpawnProfile.gd"),
	"res://data/spawn_config_scripts/MonsterSpawnConfig.gd":
		preload("MonsterSpawnConfig.gd"),
}

# Settings
var setting_bootleg_chance: float = 0.1

# Mod interoperability
const modutils_settings = [
	{
		"property": "setting_bootleg_chance",
		"type": "slider",
		"label": "Overworld Bootleg Chance",
		"min_value": 0.1,
		"max_value": 10.0,
		"step": 0.1,
		"format": "{value}%",
	}
]

func _init() -> void:
	for translation in TRANSLATIONS:
		TranslationServer.add_translation(translation)
	for k in RESOURCES:
		RESOURCES[k].take_over_path(k)
