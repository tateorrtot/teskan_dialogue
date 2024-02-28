@tool
extends EditorPlugin


const MainPanel = preload("res://addons/teskan/scenes/main_panel.tscn")

var main_panel_instance


func _enter_tree():
	add_custom_type("TimelinePlayer", "Node", load("res://addons/teskan/scripts/dialogue/timeline_player.gd"), load("res://addons/teskan/sprites/timeline.png"))
	#add_custom_type("SceneChanger", "Area2D", load("res://addons/teskan/scripts/dialogue/scene_changer.gd"), load("res://addons/teskan/sprites/door.png"))
	#add_custom_type("TestSave","Resource",preload("res://addons/teskan/scripts/dialogue/test_save.gd"),preload("res://addons/teskan/sprites/main_menu_icon.png"))
	#add_custom_type("Wasp", "CharacterBody2D", load("res://addons/teskan/scripts/enemies/wasp.gd"), load("res://addons/teskan/sprites/door.png"))
	
	main_panel_instance = MainPanel.instantiate()
	# Add the main panel to the editor's main viewport.
	get_editor_interface().get_editor_main_screen().add_child(main_panel_instance)
	# Hide the main panel. Very much required.
	_make_visible(false)
	
	

	if not DirAccess.dir_exists_absolute("res://teskan_data"): # open("res://teskan_data"):
		DirAccess.make_dir_absolute("res://teskan_data")
		DirAccess.make_dir_absolute("res://teskan_data/dialogue")
		DirAccess.make_dir_absolute("res://teskan_data/dialogue/characters")
		DirAccess.make_dir_absolute("res://teskan_data/dialogue/characters")
		DirAccess.make_dir_absolute("res://teskan_data/dialogue/themes")
		DirAccess.make_dir_absolute("res://teskan_data/dialogue/timelines")
		DirAccess.make_dir_absolute("res://teskan_data/dialogue/variables")



func _exit_tree():
	remove_custom_type("TimelinePlayer")
	
	if main_panel_instance:
		main_panel_instance.queue_free()


func _has_main_screen():
	return true


func _make_visible(visible):
	if main_panel_instance:
		main_panel_instance.visible = visible


func _get_plugin_name():
	return "Teskan"


func _get_plugin_icon():
	# Must return some kind of Texture2D for the icon.
	return preload("res://addons/teskan/sprites/main_menu_icon.png")
	#return get_editor_interface().get_base_control().get_icon("Node", "EditorIcons")
