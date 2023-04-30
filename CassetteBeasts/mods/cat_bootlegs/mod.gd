extends ContentInfo

# Don't try this at home! I'm a professional!
func init_content() -> void:
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

	# Repeat for all modified script files.
	# This one is an Autoload, so it's handled slightly different.
	f.open("res://global/scene_manager/SceneManager.gd", File.READ)
	source_code = f.get_as_text()
	f.close()
	source_code = source_code.replace(
		"\tPlatform.set_achievements_enabled(in_game)\n",
		"")
	var script: GDScript = GDScript.new()
	script.take_over_path("res://global/scene_manager/SceneManager.gd")
	script.source_code = source_code
	script.reload()
	SceneManager.set_script(script)
