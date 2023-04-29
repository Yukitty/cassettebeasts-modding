extends ContentInfo

const OUTPUT_FILE = "user://mod_output/cat_kay/mod_strings.csv"

var csv := File.new()
var live_translation := Translation.new()

func init_content() -> void:
	# Replace voice line from mod directory
	var res: Resource = preload("kay_introduction.wav")
	res.take_over_path("res://sfx/voices/kayleigh/kayleigh_introduction.wav")

	# If we're in the Editor and the output file exists,
	# open it up and prepare to write to it.
	# This is how the translation strings were exported -- by occurring in-game.
	if OS.has_feature("editor") and csv.file_exists(OUTPUT_FILE):
		print("cat_kay: Opened translation table for appending.")
		csv.open(OUTPUT_FILE, File.READ_WRITE)
		csv.seek_end()

func add_mod_translations(mod_translations) -> void:
	mod_translations.add_translation(preload("mod_strings.en.translation"))
	mod_translations.add_translation(live_translation)
	mod_translations.add_translation_callback(self, "_on_translation")

func _on_translation(src_message: String, message: String) -> String:
	if message == "":
		# If there's no actual translation result,
		# modify the untranslated string.
		# This might happen when other mods add more dialog
		# without using the TranslationServer.
		if "Kayleigh" in src_message and not ("_" in src_message):
			message = src_message.replace("Kayleigh", "Kay")
			live_translation.add_message(src_message, message)
			return message

	elif "Kayleigh" in message:
		message = message.replace("Kayleigh", "Kay")
		live_translation.add_message(src_message, message)
		if OS.has_feature("editor") and csv.is_open():
			print("cat_kay: cached " + src_message)
			csv.store_csv_line(PoolStringArray([src_message, message]))
			csv.flush()
		return message

	return ""
