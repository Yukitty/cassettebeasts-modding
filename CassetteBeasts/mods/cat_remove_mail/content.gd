extends ContentInfo

func init_content() -> void:
	TranslationServer.add_translation(preload("mod_strings.en.translation"))
	DLC.get_tree().connect("node_added", self, "_on_node_added", [], CONNECT_DEFERRED)

func _on_node_added(node: Node) -> void:
	if node.filename == "res://world/maps/interiors/GramophoneInterior.tscn":
		var post_box: Node
		post_box = node.get_node("ExpoConditionalLayer/InterdimensionalPostBox")
		if post_box:
			post_box.queue_free()
