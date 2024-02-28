@tool
extends Object
class_name TDData


###--------------CREATE COMPONENTS--------------###

static func new_character(tree : Tree):
	var characters_holder = tree.get_root().get_child(0)
	var timestamp = Time.get_ticks_usec()
	var character_dict = {'id' : 'null', 'name' : 'null', 'colour' : Color.WHITE, 'desc' : 'null', 'faction' : 'null', 'theme' : 'null', 'voice' : 'null', 'voice_pitch_min' : 0.7, 'voice_pitch_max' : 1.3, 'portraits' : {}, 'voice_speed' : 1.0}
	
	character_dict.id = timestamp
	store_var("res://teskan_data/dialogue/characters/character"+var_to_str(timestamp),character_dict )

	var new_tree_child = tree.create_item(characters_holder)
	new_tree_child.set_text(0, "No Name")
	new_tree_child.set_icon(0,load("res://addons/teskan/sprites/character.png"))
	new_tree_child.set_metadata(0,'character'+var_to_str(timestamp))
	
static func new_theme(tree : Tree):
	var themes_holder = tree.get_root().get_child(1)
	var timestamp = Time.get_ticks_usec()
	var theme_dict = {'id' : 'null', 'name' : 'null', 'colour' : Color.WHITE, 'desc' : 'null', 'font' : 'null', 'small_font' : 12, 'medium_font' : 20, 'large_font' : 28, 'font_outline_size' : 1, 'kground' : 'null', 'name_background_colour' : Color.BLACK, 'text_accent_colour' : Color.BLACK,'font_outline_colour' : Color.BLACK}
	
	theme_dict.id = timestamp
	###print(1)
	store_var("res://teskan_data/dialogue/themes/theme"+var_to_str(timestamp),theme_dict )
	###print(2)
	
	var new_tree_child = tree.create_item(themes_holder)
	
	new_tree_child.set_text(0, "No Name")
	new_tree_child.set_icon(0,load("res://addons/teskan/sprites/theme.png"))
	new_tree_child.set_metadata(0,'theme'+var_to_str(timestamp))
	

static func new_timeline(tree : Tree):
	var timelines_holder = tree.get_root().get_child(2)
	var timestamp = Time.get_ticks_usec()
	var timeline_dict = {'id' : null, 'name' : 'No Name', 'colour' : Color.WHITE, 'desc' : 'No Desc', 'events' : []}
	
	timeline_dict.id = timestamp
	store_var("res://teskan_data/dialogue/timelines/timeline"+var_to_str(timestamp),timeline_dict )
	
	
	var new_tree_child = tree.create_item(timelines_holder)
	new_tree_child.set_text(0, "No Name")
	new_tree_child.set_icon(0,load("res://addons/teskan/sprites/timeline.png"))
	new_tree_child.set_metadata(0,'timeline'+var_to_str(timestamp))


###--------------TIMELINE STUFF--------------###

static func play_timeline(timeline):
	##print('timeline playing.')
	##print('=======')
	##print('TIMELINE: ',timeline)
	"""if timeline.events != null:
		for event in timeline.events:
			##print(event.type)
			#if event.type == 'text':
			#	##print(event.text)
			if event.has('children'):
				play_timeline(event.children)	"""
	

###--------------STORE AND SAVE DATA--------------###

static func store_var(path,variable):
	#var file = FileAccess.new()
	#variable.id = timestamp
	###print(path)
	var file = FileAccess.open(path,FileAccess.WRITE)
	###print(file.get_path())
	file.store_var(variable,true)
	file.close()
	

	
static func get_var(path):
	#var file = FileAccess.new()
	if path == "null":
		printerr("Tried to load file: '",path,"' but is null.")
		return null
	
	var file = FileAccess.open(path, FileAccess.READ)
	#print("File loaded! ",file)
	var loaded_variable = file.get_var(true)
	#print("Loaded variable: ",loaded_variable)
	file.close()
	
	return loaded_variable
