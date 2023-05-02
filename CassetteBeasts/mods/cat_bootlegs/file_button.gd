extends "res://menus/title/FileButton.gd"

var has_cheated: bool

func set_state(state: int, data) -> void:
	# Call parent function first
	.set_state(state, data)

	# Update old save files and fetch cheat state
	if state == State.LOADED and data:
		if version_dlc.has("cat_bootlegs"):
			_update_save_file(data)

		has_cheated = data.get("has_cheated", false) == true

func load_file() -> void:
	# Display "cheats enabled" warning if this save file was clean
	if not has_cheated:
		release_focus()
		GlobalMessageDialog.clear_state()
		yield (GlobalMessageDialog.show_message("CONFIRM_LOAD_SAVE_WITH_CHEAT_MODS1", false), "completed")
		if not yield (MenuHelper.confirm("CONFIRM_LOAD_SAVE_WITH_NEW_MODS2", 1, 1), "completed"):
			grab_focus()
			return

	# Continue as normal
	.load_file()

# Fix save files tagged by old versions (Sorry!)
func _update_save_file(snapshot: Dictionary) -> void:
	snapshot.has_cheated = true
	snapshot.version_dlc.erase("cat_bootlegs")

	while SaveSystem.busy:
		yield(get_tree(), "idle_frame")
	SaveSystem.busy = true
	SaveSystem.save_icon_animator.play("saving")
	yield(SaveSystem.storage.store_async(file_path, snapshot, PoolByteArray()).join(), "completed")
	SaveSystem.save_icon_animator.play("fade_out", 0.25)
	SaveSystem.busy = false
