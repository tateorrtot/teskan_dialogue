@tool
extends TDEResource
class_name TDEText

#type and character are from what it inherits, TDEResource
var character : String
var text : String

func _init(input_type = "text",input_character = "No name",input_text = "No text"):
	type = input_type
	character = input_character
	text = input_text

#Function that's called to "build" the sub-resource. Creating a coresponding UI element then putting the new sub-resource at the end
#of the array of it's parent resource
func build(tree,tdetext,event_list):
	var text_event_preset = load("res://addons/teskan/scenes/dialogue/presets/TextEvent.tscn")
	var new_text_event_preset = text_event_preset.instantiate()
	event_list.add_child(new_text_event_preset)
	
	var timeline_resource = load("user://addons/teskan/data/dialogue/timelines/"+tree.get_selected().get_metadata(0))
	
	timeline_resource.events.append(tdetext)
	#Just noticed this, for some reason I'm saving this without flags and I'm also not loading the timeline_resource with the
	#Ignore-Cache flag on. Not sure if this effects anything as this "build" function is only called when the sub-resource is made
	#for the first time.
	ResourceSaver.save(timeline_resource.get_path(),timeline_resource)
