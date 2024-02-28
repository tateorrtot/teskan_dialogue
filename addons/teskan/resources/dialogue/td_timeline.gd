@tool
extends TDResource
class_name TDTimeline

@export var events : Array
#export var resource : Resource


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _init(input_id = "No ID",input_name = "No Name",input_colour = Color.WHITE,input_desc = "No Desc",input_events = []):
	id = input_id
	name = input_name
	colour = input_colour
	desc = input_desc
	
	events = input_events

func build(tree,tdtimeline):
	var tree_holder = tree.get_root().get_children().get_next().get_next()
	var timestamp = Time.get_ticks_usec()
	
	var new_tree_child = tree.create_item(tree_holder)
	new_tree_child.set_text(0, "New Timeline")
	new_tree_child.set_icon(0,load("res://addons/teskan/sprites/timeline.png"))
	new_tree_child.set_metadata(0,"timeline"+var_to_str(timestamp)+".tres")
	
	#var new_test_save = 
	tdtimeline.id = var_to_str(timestamp)
	ResourceSaver.save(tdtimeline,"user://addons/teskan/data/dialogue/timelines/timeline"+var_to_str(timestamp)+".tres")

