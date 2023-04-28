extends ContentInfo


const overrides: Dictionary = {
	"res://world/objects/static_physics/tree_1/Tree1.tscn":
		preload("res://mods/cat_tree_mesh/objects/tree_1/tree1.tscn"),
	"res://world/objects/static_physics/tree_1/Tree2.tscn":
		preload("res://mods/cat_tree_mesh/objects/tree_1/tree2.tscn"),
	"res://world/objects/static_physics/tree_1/AutumnTree1.tscn":
		preload("res://mods/cat_tree_mesh/objects/tree_1/autumn_tree1.tscn"),
	"res://world/objects/static_physics/tree_1/AutumnTree2.tscn":
		preload("res://mods/cat_tree_mesh/objects/tree_1/autumn_tree2.tscn"),
	"res://world/objects/static_physics/tree_1/SnowTree1.tscn":
		preload("res://mods/cat_tree_mesh/objects/tree_1/snow_tree1.tscn"),
	"res://world/objects/static_physics/tree_1/SnowTree2.tscn":
		preload("res://mods/cat_tree_mesh/objects/tree_1/snow_tree2.tscn"),
}


func init_content() -> void:
	var res: Resource
	for k in overrides:
		res = overrides[k]
		res.take_over_path(k)
