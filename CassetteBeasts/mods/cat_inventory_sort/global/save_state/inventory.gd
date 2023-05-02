extends "res://global/save_state/Inventory.gd"

func _cmp_item_node(a: Node, b: Node) -> bool:
	# Use fixed sort order for consumables and such
	if a.item.sort_order < b.item.sort_order:
		return true
	if a.item.sort_order > b.item.sort_order:
		return false

	# Special sorting for stickers.
	if a.item is StickerItem and a.item.battle_move is BattleMove and b.item is StickerItem and b.item.battle_move is BattleMove:
		var a_battle_move: BattleMove = a.item.battle_move
		var b_battle_move: BattleMove = b.item.battle_move
		var a_element: ElementalType
		var b_element: ElementalType

		# Fetch fixed type if possible
		if a_battle_move.elemental_types.size() > 0:
			a_element = a_battle_move.elemental_types[0]
		if b_battle_move.elemental_types.size() > 0:
			b_element = b_battle_move.elemental_types[0]

		# Sort "typeless" stickers to the top
		if a_element == null and b_element != null:
			return true
		if a_element != null and b_element == null:
			return false

		# If both have a different element, sort by element
		if a_element != b_element:
			# Use the element's sort order first
			if a_element.sort_order < b_element.sort_order:
				return true
			if a_element.sort_order > b_element.sort_order:
				return false

			# Then use the element's name to sort
			var a_name: String = Strings.strip_bbcode(tr(a_element.name))
			var b_name: String = Strings.strip_bbcode(tr(b_element.name))
			var name_cmp: int = a_name.naturalnocasecmp_to(b_name)
			if name_cmp < 0:
				return true
			if name_cmp > 0:
				return false

	# If all else fails, sort by item name
	var a_name: String = Strings.strip_bbcode(tr(a.get_sortable_name()))
	var b_name: String = Strings.strip_bbcode(tr(b.get_sortable_name()))
	var name_cmp: int = a_name.naturalnocasecmp_to(b_name)
	if name_cmp < 0:
		return true
	if name_cmp > 0:
		return false

	# Sort copies of the same item by rarity
	if a.item.get_rarity() > b.item.get_rarity():
		return true
	if a.item.get_rarity() < b.item.get_rarity():
		return false

	return false
