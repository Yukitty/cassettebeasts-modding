extends ContentInfo

const MergeTranslation = preload("merge_translation.gd")

var _merge_translations: Dictionary

func init_content() -> void:
	TranslationServer.add_translation(preload("mod_strings.en.translation"))
	DLC.get_tree().connect("idle_frame", self, "_post_init", [], CONNECT_DEFERRED|CONNECT_ONESHOT)

	var locales: Array = TranslationServer.get_loaded_locales()

	for l in locales:
		var merge_translation: Translation = MergeTranslation.new()
		merge_translation.locale = l
		merge_translation.init_locale()
		TranslationServer.add_translation(merge_translation)
		_merge_translations[l] = merge_translation

func _post_init() -> void:
	for metadata in DLC.mods:
		if metadata.has_method("add_mod_translations"):
			metadata.add_mod_translations(self)

func add_translation(tr: Translation) -> void:
	assert(_merge_translations.has(tr.locale))
	_merge_translations[tr.locale].add_translation(tr)

func add_translation_callback(object: Object, function: String, locale: String = "en") -> void:
	assert(_merge_translations.has(locale))
	_merge_translations[locale].add_translation_callback(object, function)
