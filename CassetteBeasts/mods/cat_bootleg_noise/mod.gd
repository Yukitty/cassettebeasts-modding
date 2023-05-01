extends ContentInfo

const BootlegNoise: PackedScene = preload("res://mods/cat_bootleg_noise/nodes/bootleg_noise.tscn")

func init_content() -> void:
	TranslationServer.add_translation(preload("mod_strings.en.translation"))
	DLC.get_tree().connect("node_added", self, "_on_node_added")

func _on_node_added(node: Node) -> void:
	if node.get_script() != EncounterConfig:
		return

	if not node.is_connected("ready", self, "_on_EncounterConfig_ready"):
		node.connect("ready", self, "_on_EncounterConfig_ready", [node], CONNECT_DEFERRED)

func _on_EncounterConfig_ready(encounter: EncounterConfig) -> void:
	var npc: Node = encounter.get_parent()

	# We only care about Overworld NPCs.
	if npc.get_script() != NPC:
		return

	# We only care about the displayed sprite.
	if not npc.has_node("MonsterPalette"):
		return

	# Use the MonsterPalette to get the correct TapeConfig,
	# because the encounter monsters are shuffled.
	var palette: MonsterPalette = npc.get_node("MonsterPalette")

	if palette.tape_path.is_empty() or not palette.has_node(palette.tape_path):
		# Get bootlegs from encounter
		var bootleg: bool = false
		if encounter.seed_value != 0 or encounter.unique_id != "":
			for tape in encounter.get_bootlegs():
				if tape.form == palette.species:
					bootleg = true
					break
		if not bootleg:
			return
	else:
		# Get bootleg from NPC tape
		var tape: TapeConfig = palette.get_node(palette.tape_path)
		if not tape or tape.type_override.size() == 0:
			return

	var noise: Node = BootlegNoise.instance()
	npc.add_child(noise)
