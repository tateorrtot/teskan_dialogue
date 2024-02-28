@tool
extends HBoxContainer

#onready var dict = self.get_parent().get("tree_dict")

@onready var tree : Tree = self.get_parent().get_child(0)
@onready var root : TreeItem = tree.get_root()
	
@onready var characters_holder = root.get_child(0)
@onready var themes_holder = root.get_child(1)
@onready var timelines_holder = root.get_child(2)
@onready var variables_holder = root.get_child(3)

#func _input(event):
#	print(root.get_children())
	



#onready var timestamp = Time.get_ticks_usec()

#onready var test_save = load("res://addons/teskan/scripts/dialogue/test_save.gd")




	#await get_tree().create_timer(0.001).timeout
	##var dict = self.get_parent().get_tree_dict()
func _on_NewCharacter_pressed():
	#var new_character = TDCharacter.new()
	#new_character.build(tree,new_character)
	TDData.new_character(tree)
	
func _on_NewTheme_pressed():
	TDData.new_theme(tree)
	
	
func _on_NewTimeline_pressed():
	#tddata.new_timeline(tree)
	TDData.new_timeline(tree)

func _on_NewVariable_pressed():
	var new_tree_child = tree.create_item(variables_holder)
	new_tree_child.set_text(0, "New Variable")
	new_tree_child.set_icon(0,load("res://addons/teskan/sprites/variable.png"))

func _on_delete_selected_pressed():
	var tree_item_selected = tree.get_selected()
	if tree_item_selected == null:
		return
	
	var tree_item_parent = tree.get_selected().get_parent()

	match tree_item_parent:
		characters_holder:
			DirAccess.remove_absolute("res://teskan_data/dialogue/characters/"+tree_item_selected.get_metadata(0))
			tree_item_selected.free()
		themes_holder:
			DirAccess.remove_absolute("res://teskan_data/dialogue/themes/"+tree_item_selected.get_metadata(0))
			tree_item_selected.free()
		timelines_holder:
			DirAccess.remove_absolute("res://teskan_data/dialogue/timelines/"+tree_item_selected.get_metadata(0))
			tree_item_selected.free()
		variables_holder:
			DirAccess.remove_absolute("res://teskan_data/dialogue/variables/"+tree_item_selected.get_metadata(0))
			tree_item_selected.free()


"""func store_var(path,variable):
	var file = File.new()
	#variable.id = timestamp
	
	file.open(path,File.WRITE)
	file.store_var(variable,true)
	file.close()
	
func get_var(path):
	var file = File.new()
	
	file.open(path, File.READ)
	var loaded_variable = file.get_var(true)
	file.close()
	
	return loaded_variable
"""



