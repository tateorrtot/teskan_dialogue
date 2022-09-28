tool
extends HBoxContainer

#onready var dict = self.get_parent().get("tree_dict")

onready var tree = self.get_parent().get_child(0)
onready var root = tree.get_root()
	
onready var characters_holder = root.get_children()
onready var themes_holder = root.get_children().get_next()
onready var timelines_holder = root.get_children().get_next().get_next()
onready var variables_holder = root.get_children().get_next().get_next().get_next()

var tddata = TDData.new()

#onready var timestamp = OS.get_ticks_usec()

#onready var test_save = load("res://addons/teskan/scripts/dialogue/test_save.gd")



#func _ready():
	#yield(get_tree().create_timer(0.001),"timeout")
	##var dict = self.get_parent().get_tree_dict()
func _on_NewCharacter_pressed():
	#var new_character = TDCharacter.new()
	#new_character.build(tree,new_character)
	tddata.new_character(tree)
	
func _on_NewTheme_pressed():
	var new_tree_child = tree.create_item(themes_holder)
	new_tree_child.set_text(0, "New Theme")
	new_tree_child.set_icon(0,load("res://addons/teskan/sprites/theme.png"))
	
	
func _on_NewTimeline_pressed():
	#tddata.new_timeline(tree)
	var new_timeline = Timeline.new(tree)
	print(new_timeline.id)

func _on_NewVariable_pressed():
	var new_tree_child = tree.create_item(variables_holder)
	new_tree_child.set_text(0, "New Variable")
	new_tree_child.set_icon(0,load("res://addons/teskan/sprites/variable.png"))



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
