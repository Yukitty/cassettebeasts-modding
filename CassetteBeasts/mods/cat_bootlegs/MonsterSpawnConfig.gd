# Use file path instead of class_name
extends "res://data/spawn_config_scripts/MonsterSpawnConfig.gd"

func _configure_world_mon(node: Node) -> Node:
	var mod: ContentInfo = DLC.mods_by_id["cat_bootlegs"]

	# Call parent func
	node = ._configure_world_mon(node)

	# We only care about normal overworld monster encounters
	if not node.has_node("MonsterPalette"):
		return node

	# Get the representative monster tape and character
	var palette: MonsterPalette = node.get_node("MonsterPalette")
	var tape: TapeConfig = palette.get_node(palette.tape_path)
	var c: CharacterConfig = tape.get_parent()

	# Make the representative monster shiny or not using mod odds, instead of const odds.
	if c.character_kind == Character.CharacterKind.MONSTER and randf() < mod.setting_bootleg_chance / 100.0:
		tape.type_override = [_random_type()]
	else:
		tape.type_override.clear()

	# Does not mess with any other bootleg odds
	return node
