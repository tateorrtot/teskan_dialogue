extends Node
class_name TimelinePlayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var timeline_to_call_name : String

#func _init(input_name = "No Name"):
	#timeline_to_call_name = input_name

# Called when the node enters the scene tree for the first time.
func play_timeline():
	get_tree().get_current_scene().get_node('DialogueGUI').play_timeline(timeline_to_call_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
