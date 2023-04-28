extends ContentInfo

const MergeTranslation = preload("res://mods/cat_translation_patcher/merge_translation.gd")
const ModTranslations = preload("res://mods/cat_translation_patcher/global.gd")

func init_content() -> void:
	print("cat_translation_patcher: Patching TranslationServer!")
	var locales: Array = TranslationServer.get_loaded_locales()

	var node: Node = ModTranslations.new()
	node.name = "ModTranslations"

	for l in locales:
		var merge_translation: Translation = MergeTranslation.new()
		merge_translation.locale = l
		merge_translation.init_locale()
		TranslationServer.add_translation(merge_translation)
		node._merge_translations[l] = merge_translation

	DLC.add_child(node)
