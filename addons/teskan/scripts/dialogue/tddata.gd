tool
extends Object
class_name TDData

###--------------COMPONENTS--------------###

static func new_character(tree):
	var characters_holder = tree.get_root().get_children()
	var timestamp = OS.get_ticks_usec()
	var character_dict = {'id' : null, 'name' : 'No Name', 'colour' : Color.white, 'desc' : 'No Desc', 'faction' : 'No Faction', 'voice' : 'No Voice', 'voice_pitch_min' : 0.7, 'voice_pitch_max' : 1.3, 'portraits' : {}}
	
	character_dict.id = timestamp
	store_var("res://teskan_data/dialogue/characters/character"+var2str(timestamp),character_dict )

	var new_tree_child = tree.create_item(characters_holder)
	new_tree_child.set_text(0, "No Name")
	new_tree_child.set_icon(0,load("res://addons/teskan/sprites/character.png"))
	new_tree_child.set_metadata(0,'character'+var2str(timestamp))
	

static func new_timeline(tree):
	var timelines_holder = tree.get_root().get_children().get_next().get_next()
	var timestamp = OS.get_ticks_usec()
	var timeline_dict = {'id' : null, 'name' : 'No Name', 'colour' : Color.white, 'desc' : 'No Desc', 'events' : []}
	
	timeline_dict.id = timestamp
	store_var("res://teskan_data/dialogue/timelines/timeline"+var2str(timestamp),timeline_dict )

	var new_tree_child = tree.create_item(timelines_holder)
	new_tree_child.set_text(0, "No Name")
	new_tree_child.set_icon(0,load("res://addons/teskan/sprites/timeline.png"))
	new_tree_child.set_metadata(0,'timeline'+var2str(timestamp))
	
	
	
###--------------EVENTS--------------###
	
static func new_text_event(event_list,tree):
	var text_event_dict = {'type' : 'text', 'character' : 'No Character', 'text' : 'No Text', 'id' : var2str(OS.get_ticks_usec())}
	var timeline_path = "res://teskan_data/dialogue/timelines/"+tree.get_selected().get_metadata(0)
	
	var timeline_file = get_var(timeline_path)
	timeline_file.events.append(text_event_dict)
	store_var(timeline_path,timeline_file)

	var new_text_event_preset = ResourceLoader.load("res://addons/teskan/scenes/dialogue/presets/events/TextEvent.tscn","", true).instance()
	new_text_event_preset.get_node("EventDivider/Id").text = text_event_dict.id
	event_list.add_child(new_text_event_preset)
	
static func new_choice_event(event_list,tree):	
	var choice_event_dict = {'type' : 'choice', 'desc' : 'No Desc', 'children' : [], 'id' : var2str(OS.get_ticks_usec())}
	var timeline_path = "res://teskan_data/dialogue/timelines/"+tree.get_selected().get_metadata(0)
	
	var timeline_file = get_var(timeline_path)
	timeline_file.events.append(choice_event_dict)
	store_var(timeline_path,timeline_file)

	var new_choice_event_preset = ResourceLoader.load("res://addons/teskan/scenes/dialogue/presets/events/ChoiceEvent.tscn","", true).instance()
	new_choice_event_preset.get_node("EventDivider/Id").text = choice_event_dict.id
	event_list.add_child(new_choice_event_preset)

###--------------STORE AND SAVE DATA--------------###

static func store_var(path,variable):
	var file = File.new()
	#variable.id = timestamp
	
	file.open(path,File.WRITE)
	file.store_var(variable,true)
	file.close()
	

	
static func get_var(path):
	var file = File.new()
	
	file.open(path, File.READ)
	var loaded_variable = file.get_var(true)
	file.close()
	
	return loaded_variable
