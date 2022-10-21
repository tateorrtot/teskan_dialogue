tool
extends Object
class_name TDData

###--------------CREATE COMPONENTS--------------###

static func new_character(tree):
	var characters_holder = tree.get_root().get_children()
	var timestamp = OS.get_ticks_usec()
	var character_dict = {'id' : 'null', 'name' : 'null', 'colour' : Color.white, 'desc' : 'null', 'faction' : 'null', 'theme' : 'null', 'voice' : 'null', 'voice_pitch_min' : 0.7, 'voice_pitch_max' : 1.3, 'portraits' : {}, 'voice_speed' : 1.0}
	
	character_dict.id = timestamp
	store_var("res://teskan_data/dialogue/characters/character"+var2str(timestamp),character_dict )

	var new_tree_child = tree.create_item(characters_holder)
	new_tree_child.set_text(0, "No Name")
	new_tree_child.set_icon(0,load("res://addons/teskan/sprites/character.png"))
	new_tree_child.set_metadata(0,'character'+var2str(timestamp))
	
static func new_theme(tree):
	var themes_holder = tree.get_root().get_children().get_next()
	var timestamp = OS.get_ticks_usec()
	var theme_dict = {'id' : 'null', 'name' : 'null', 'colour' : Color.white, 'desc' : 'null', 'font' : 'null', 'small_font' : 12, 'medium_font' : 20, 'large_font' : 28, 'font_outline_size' : 1, 'background' : 'null', 'name_background_colour' : Color.black, 'text_accent_colour' : Color.black,'font_outline_colour' : Color.black}
	
	theme_dict.id = timestamp
	#print(1)
	store_var("res://teskan_data/dialogue/themes/theme"+var2str(timestamp),theme_dict )
	#print(2)
	
	var new_tree_child = tree.create_item(themes_holder)
	
	new_tree_child.set_text(0, "No Name")
	new_tree_child.set_icon(0,load("res://addons/teskan/sprites/theme.png"))
	new_tree_child.set_metadata(0,'theme'+var2str(timestamp))
	

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


###--------------TIMELINE STUFF--------------###

static func play_timeline(timeline):
	print('timeline playing.')
	print('=======')
	print('TIMELINE: ',timeline)
	"""if timeline.events != null:
		for event in timeline.events:
			print(event.type)
			#if event.type == 'text':
			#	print(event.text)
			if event.has('children'):
				play_timeline(event.children)	"""
	

###--------------STORE AND SAVE DATA--------------###

static func store_var(path,variable):
	var file = File.new()
	#variable.id = timestamp
	#print(path)
	file.open(path,File.WRITE)
	#print(file.get_path())
	file.store_var(variable,true)
	file.close()
	

	
static func get_var(path):
	var file = File.new()

	file.open(path, File.READ)
	var loaded_variable = file.get_var(true)
	file.close()
	
	return loaded_variable
