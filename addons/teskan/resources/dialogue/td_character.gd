@tool
extends TDResource
class_name TDCharacter

@export var faction : String
@export var voice : AudioStream
@export var voice_pitch_min : float
@export var voice_pitch_max : float
@export var portraits : Dictionary
#export var resource : Resource


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _init(input_id = "No ID",input_name = "No Name",input_colour = Color.WHITE,input_desc = "No Desc",input_faction = "Factionless",input_voice = load("res://fritz.wav"),input_voice_pitch_min = 0.8,input_voice_pitch_max = 1.2,input_portraits = {"Default":load("res://icon.png")}):
	id = input_id
	name = input_name
	colour = input_colour
	desc = input_desc
	
	faction = input_faction
	voice = input_voice
	voice_pitch_min = input_voice_pitch_min
	voice_pitch_max = input_voice_pitch_max
	portraits = input_portraits


func build(tree,tdcharacter):
	var tree_holder = tree.get_root().get_children()
	var timestamp = Time.get_ticks_usec()
	
	var new_tree_child = tree.create_item(tree_holder)
	new_tree_child.set_text(0, "New Character")
	new_tree_child.set_icon(0,load("res://addons/teskan/sprites/character.png"))
	new_tree_child.set_metadata(0,"character"+var_to_str(timestamp)+".tres")
	
	#var new_test_save = 
	tdcharacter.id = var_to_str(timestamp)
	ResourceSaver.save("res://addons/teskan/data/dialogue/characters/character"+var_to_str(timestamp)+".tres", tdcharacter)

