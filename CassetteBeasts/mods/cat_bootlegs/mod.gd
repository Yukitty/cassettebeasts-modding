extends ContentInfo

# Don't try this at home! I'm a professional!
func _init() -> void:
	TranslationServer.add_translation(preload("mod_strings.en.translation"))
	_init_cheat_mod()
	_update_monster_spawn_config()

func _init_cheat_mod() -> void:
	var script: GDScript = preload("file_button.gd")
	script.take_over_path("res://menus/title/FileButton.gd")
	SaveSystem.connect("file_loaded", self, "_mark_cheated")
	_disable_achievements()

func _mark_cheated() -> void:
	SaveState.has_cheated = true

func _disable_achievements() -> void:
	var script: GDScript = preload("platform.gd")
	script.take_over_path("res://addons/platform/Platform.gd")
	Platform.set_script(script)
	Platform.notification(Node.NOTIFICATION_READY)

func _update_monster_spawn_config() -> void:
	# Updating class_name scripts is hard!

	# First we load the original source code into a giant string.
	# Our metadata.tres marked this file as modified so it would be exported,
	# otherwise it would only be compiled bytecode we can't easily edit.
	var source_code: String
	var f := File.new()
	f.open("res://data/spawn_config_scripts/MonsterSpawnConfig.gd", File.READ)
	source_code = f.get_as_text()
	f.close()

	# Now we modify the source code with string functions!
	# First we MUST remove class_name, to avoid parsing errors.
	# Then we can change what we really want.
	# We can use String.replace here because both lines
	# we want to change are unique in the file and only occur once.
	source_code = source_code.replace(
		"class_name MonsterSpawnConfig\n", ""
	).replace(
		"const BOOTLEG_CHANCE = 0.001\n",
		"const BOOTLEG_CHANCE = 0.98\n")

	# Then we load that string into the global class_name const
	MonsterSpawnConfig.source_code = source_code
	MonsterSpawnConfig.reload()
