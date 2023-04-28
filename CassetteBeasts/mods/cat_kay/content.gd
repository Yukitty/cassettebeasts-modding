extends ContentInfo

var csv: File
var live_translation: Translation

func init_content() -> void:
	var res: Resource = preload("res://mods/cat_kay/kay_introduction.wav")
	res.take_over_path("res://sfx/voices/kayleigh/kayleigh_introduction.wav")

	live_translation = Translation.new()

	if OS.has_feature("editor"):
		print("cat_kay: Opened translation table for appending.")
		csv = File.new()
		csv.open("user://kay.csv", File.READ_WRITE)
		csv.seek_end()


func add_mod_translations(mod_translations) -> void:
	mod_translations.add_translation(preload("res://mods/cat_kay/kay.en.translation"))
	mod_translations.add_translation(live_translation)
	mod_translations.add_translation_callback(self, "_modify_message")


func _modify_message(src_message: String, message: String) -> String:
	if message.match("*Kayleigh*"):
		message = message.replace("Kayleigh", "Kay")
		live_translation.add_message(src_message, message)

		if OS.has_feature("editor"):
			print("cat_kay: Added " + src_message + " to translation table.")
			csv.store_csv_line(PoolStringArray([src_message, message]))
			csv.flush()

		return message
	return ""
