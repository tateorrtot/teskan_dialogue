tool
extends TDComponent
class_name Timeline


# Declare member variables here.
var events = []

func _init(tree):
	var timestamp = OS.get_ticks_usec()
	id = timestamp
	
	TDData.store_var("res://teskan_data/dialogue/timelines/timeline"+var2str(timestamp),self )

	load_to_ui(tree,timestamp)

func load_to_ui(tree,timestamp):
	var timelines_holder = tree.get_root().get_children().get_next().get_next()
	var new_tree_child = tree.create_item(timelines_holder)
	
	new_tree_child.set_text(0, "No Name")
	new_tree_child.set_icon(0,load("res://addons/teskan/sprites/timeline.png"))
	new_tree_child.set_metadata(0,'timeline'+var2str(timestamp))
	#new_tree_child.set_metadata(0,'timeline'+var2str(timestamp))
