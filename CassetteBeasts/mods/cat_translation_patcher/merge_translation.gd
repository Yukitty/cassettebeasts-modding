extends Translation

const default_translation_paths = [
	"res://translation/1.1_demo.",
	"res://translation/strings_demo.",
	"res://translation/strings_release.",
	"res://translation/dialogue_demo.",
	"res://translation/dialogue_release.",
]

var translations: Array
var callbacks: Array

func init_locale() -> void:
	var tr: Translation
	for path in default_translation_paths:
		tr = load(path + locale + ".translation")
		translations.push_back(tr)
		TranslationServer.remove_translation(tr)

func add_translation(tr: Translation) -> void:
	assert(tr != null)
	translations.push_front(tr)

func add_translation_callback(object: Object, function: String) -> void:
	assert(object != null and function != null)
	assert(object.has_method(function))
	callbacks.push_front([object, function])

func _get_message(src_message: String) -> String:
	var message: String = ""
	for tr in translations:
		message = tr.get_message(src_message)
		if message != "":
			break

	var modified: String = ""
	for cb in callbacks:
		modified = cb[0].call(cb[1], src_message, message)
		assert(modified is String)
		if modified != "":
			message = modified

	return message
