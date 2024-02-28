@tool
extends Control

@onready var tree = self.get_parent().get_node("MainTree")
@onready var root = tree.get_root()

@onready var tree_characters_holder = root.get_child(0)
@onready var tree_themes_holder = root.get_child(1)
@onready var tree_timelines_holder = root.get_child(2)

func _on_MainTree_cell_selected():
	var tree_item_parent = tree.get_selected().get_parent()

	match tree_item_parent:
		tree_characters_holder:
			set_current_tab(0)
		tree_themes_holder:
			set_current_tab(1)
		tree_timelines_holder:
			set_current_tab(2)
		
		_:
			set_current_tab(-1)

func set_current_tab(tab_index):
	var tabs = self.get_parent().get_node("Screens")
	for i in tabs.get_children():
		i.visible = false
	if tab_index > -1:
		tabs.get_child(tab_index).visible = true
