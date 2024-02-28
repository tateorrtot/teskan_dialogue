@tool
extends Resource
class_name TDResource

@export var id : String
@export var name : String
@export var colour : Color
@export var desc : String
#export var resource : Resource


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _init(input_id = "No ID",input_name = "No Name",input_colour = Color.WHITE,input_desc = "No Description"):
	id = input_id
	name = input_name
	colour = input_colour
	desc = input_desc
