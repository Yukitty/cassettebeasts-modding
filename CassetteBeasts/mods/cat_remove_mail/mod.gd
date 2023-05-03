extends ContentInfo

const MOD_TRANSLATION: Translation = preload("mod_strings.en.translation")
const GRAMOPHONE_MAP: PackedScene = preload("res://world/maps/interiors/GramophoneInterior.tscn")
const POST_BOX_PATH: NodePath = @"ExpoConditionalLayer/InterdimensionalPostBox"

func _init() -> void:
	TranslationServer.add_translation(MOD_TRANSLATION)
	edit_scene()

func edit_scene() -> void:
	# Unpack the scene
	var scene: Node = unpack_scene(GRAMOPHONE_MAP)

	# Edit the scene
	if scene.has_node(POST_BOX_PATH):
		scene.get_node(POST_BOX_PATH).free()

	# Repack the scene and free the nodes
	GRAMOPHONE_MAP.pack(scene)
	scene.free()

func unpack_scene(packed_scene: PackedScene) -> Node:
	var scene: Node = packed_scene.instance()
	_instance_child_placeholders(scene)
	return scene

func _instance_child_placeholders(branch: Node) -> void:
	# In order for the scene to repack properly, we must
	# instance all of the placeholders.
	for child in branch.get_children():
		if child is InstancePlaceholder:
			_instance_placeholder(child)
		else:
			_instance_child_placeholders(child)

func _instance_placeholder(placeholder: InstancePlaceholder) -> Node:
	# Both InstancePlaceholder.create_instance and
	# InstancePlaceholder.replace_by_instance
	# refuse to do anything if we're not in the SceneTree.
	#
	# We don't want to be in the SceneTree.
	var instance: Node
	var props: Dictionary

	instance = load(placeholder.get_instance_path()).instance()
	placeholder.replace_by(instance)
	instance.owner = placeholder.owner
	instance.set_scene_instance_load_placeholder(true)
	props = placeholder.get_stored_values(true)
	for k in props[".order"]:
		instance[k] = props[k]
	placeholder.free()
	return instance
