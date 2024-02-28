extends Node
class_name TimelinePlayer


@export var timeline_to_call_name : String
@onready var dialogue_gui = get_tree().get_current_scene().get_node('DialogueGUI')


func play_timeline():
	if dialogue_gui.visible == false:
		dialogue_gui.play_timeline(timeline_to_call_name)
