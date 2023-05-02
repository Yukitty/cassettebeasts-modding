extends ContentInfo

func _init() -> void:
	TranslationServer.add_translation(preload("mod_strings.en.translation"))
	var res: Resource = preload("global/save_state/inventory.gd")
	res.take_over_path("res://global/save_state/Inventory.gd")
