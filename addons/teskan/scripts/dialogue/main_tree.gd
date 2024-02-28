@tool
extends Tree

var tree = self
var root = tree.create_item()

var characters_tree_holder = tree.create_item(root)
var themes_tree_holder = tree.create_item(root)
var timelines_tree_holder = tree.create_item(root)
var variables_tree_holder = tree.create_item(root)

@onready var popup_menu : PopupMenu = self.get_parent().get_node("PopupMenu")

var files = {
	"characters":[],
	"themes":[],
	"timelines":[],
	"variables":[]	
}

var dirs = {
	'characters' : "res://teskan_data/dialogue/characters/",
	'themes' : "res://teskan_data/dialogue/themes/",
	'timelines' : "res://teskan_data/dialogue/timelines/",
	'variables' : "res://teskan_data/dialogue/variables/"
}

#LOADING AND PREPARING THE DIFFERENT RESOURCES
func _ready():
	tree.set_hide_root(true)
	
	characters_tree_holder.set_text(0, "Characters")
	themes_tree_holder.set_text(0, "Themes")
	timelines_tree_holder.set_text(0, "Timelines")
	variables_tree_holder.set_text(0, "Variables")
	
	#characters.open("res://teskan_data/dialogue/characters/")
	#themes.open("res://teskan_data/dialogue/themes/")
	#timelines.open("res://teskan_data/dialogue/timelines/")
	#variables.open("res://teskan_data/dialogue/variables/")
	files['characters'] = DirAccess.get_files_at(dirs['characters'])
	files['themes'] = DirAccess.get_files_at(dirs['themes'])
	files['timelines'] = DirAccess.get_files_at(dirs['timelines'])
	#DirAccess.get_files_at(dirs['variables'])
	
	#var file = File.new()
	
	###print(load("res://teskan_data/dialogue/characters/"+files['characters'][0]).name)
	
	#LOAD ALL THE CHARACTERS IN THE DATA FILES
	var current_loop = 0
	while true:
		#print("Loading chars! ",files)
		if current_loop >= files['characters'].size():
			break
		elif files['characters'].size() > 0:
			###print(files['characters'].size())
			add_tree_item(characters_tree_holder,files['characters'][current_loop],"characters")
			current_loop += 1
	
	#LOAD ALL THE TIMELINES IN THE DATA FILES
	current_loop = 0
	while true:
		if current_loop >= files['timelines'].size():
			break
		elif files['timelines'].size() > 0:
			###print(files['characters'].size())
			add_tree_item(timelines_tree_holder,files['timelines'][current_loop],"timelines")
			current_loop += 1
			
	#LOAD ALL THE THEMES IN THE DATA FILES
	current_loop = 0
	while true:
		if current_loop >= files['themes'].size():
			break
		elif files['themes'].size() > 0:
			###print(files['characters'].size())
			add_tree_item(themes_tree_holder,files['themes'][current_loop],"themes")
			current_loop += 1

#ADD A NEW TREE ITEM	
func add_tree_item(tree_holder,metadata,type : String):
	print("Adding tree item!")
	
	var loaded_file = TDData.get_var("res://teskan_data/dialogue/"+type+"/"+metadata)
	###print(load(loaded_file))
	
	var new_tree_child = tree.create_item(tree_holder)
	new_tree_child.set_icon_modulate(0,loaded_file.colour)
	new_tree_child.set_text(0,loaded_file.name)
	type.trim_suffix(type.chr(type.length()-1))
	
	new_tree_child.set_icon(0,load("res://addons/teskan/sprites/"+type.trim_suffix("s") +".png"))
	new_tree_child.set_metadata(0,metadata)

#GET ALL THE RESOURCES (character.tscn etc) IN A FILE
#func get_files(dir : DirAccess,string,files : Array):
#	dir.open("res://teskan_data/dialogue/"+string)
	###print(string)
	#dir.list_dir_begin()
#	dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
	
#	while true:
#		var file = dir.get_next()
#		if file == "":
#			break
#		elif not file.begins_with("."):
#			files[string].append(file)
#			
	###print(files)
#	dir.list_dir_end()

#OPEN THE POPUP MENU ON RMB
"""func _input(event):
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) or tree.get_selected() == null:
		return
	
	var item_selected_text = tree.get_selected().get_text(0) 
	## ADD
	if item_selected_text == 'Characters' || item_selected_text == 'Themes' || item_selected_text == 'Timelines' || item_selected_text == 'Variables':
		item_selected_text = item_selected_text.erase(item_selected_text.length() - 1,1)
		
		#RESET THE MENU
		popup_menu.clear()
		popup_menu.size.x = 1
		popup_menu.size.y = 1
		
		#ADD THE OPTIONS AND POP UP
		popup_menu.add_item("Add "+item_selected_text,0)
		popup_menu.popup(Rect2(get_global_mouse_position().x,get_global_mouse_position().y,popup_menu.size.x,popup_menu.size.y))
	## REMOVE
	else:
		var item_selected_parent_text = tree.get_selected().get_parent().get_text(0)
		item_selected_parent_text = item_selected_parent_text.erase(item_selected_parent_text.length() - 1,1)
		
		#RESET THE MENU
		popup_menu.clear()
		popup_menu.size.x = 1
		popup_menu.size.y = 1
		
		#ADD THE OPTIONS AND POP UP
		popup_menu.add_item("Delete "+item_selected_parent_text,0)
		popup_menu.position.x = (get_global_mouse_position().x)
		popup_menu.position.y = (get_global_mouse_position().y)
		popup_menu.popup()
		#popup_menu.popup(Rect2(get_global_mouse_position().x,get_global_mouse_position().y,popup_menu.size.x,popup_menu.size.y))
"""

"""#DO STUFF WHEN SOMETHING ON THE RMB POPUP IS SELECTED
func _on_PopupMenu_index_pressed(index):
	var popup_selected = popup_menu.get_item_text(index)
	var tree_item_selected = tree.get_selected()
	var dir : DirAccess

	#DELETE A RESOURCE
	if popup_selected == "Delete Character":
		DirAccess.remove_absolute("res://teskan_data/dialogue/characters/"+tree_item_selected.get_metadata(0))
		tree_item_selected.free()
	elif popup_selected == "Delete Timeline":
		DirAccess.remove_absolute("res://teskan_data/dialogue/timelines/"+tree_item_selected.get_metadata(0))
		tree_item_selected.free()
	elif popup_selected == "Delete Theme":
		DirAccess.remove_absolute("res://teskan_data/dialogue/themes/"+tree_item_selected.get_metadata(0))
		tree_item_selected.free()
	elif popup_selected == "Delete Variable":
		DirAccess.remove_absolute("res://teskan_data/dialogue/variables/"+tree_item_selected.get_metadata(0))
		tree_item_selected.free()
	
	#ADD A RESOURCE
	if popup_selected == "Add Character":
		TDData.new_character(tree)
	elif popup_selected == "Add Timeline":
		TDData.new_timeline(tree)
	elif popup_selected == "Add Theme":
		TDData.new_theme(tree)
	elif popup_selected == "Add Variable":
		pass
"""
