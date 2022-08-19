tool
extends EditorPlugin


const MainPanel = preload("res://addons/teskan/scenes/main_panel.tscn")

var main_panel_instance


func _enter_tree():
	#add_custom_type("TestSave","Resource",preload("res://addons/teskan/scripts/dialogue/test_save.gd"),preload("res://addons/teskan/sprites/main_menu_icon.png"))
	
	main_panel_instance = MainPanel.instance()
	# Add the main panel to the editor's main viewport.
	get_editor_interface().get_editor_viewport().add_child(main_panel_instance)
	# Hide the main panel. Very much required.
	make_visible(false)



func _exit_tree():
	#remove_custom_type("TestSave")
	
	if main_panel_instance:
		main_panel_instance.queue_free()


func has_main_screen():
	return true


func make_visible(visible):
	if main_panel_instance:
		main_panel_instance.visible = visible


func get_plugin_name():
	return "Teskan"


func get_plugin_icon():
	# Must return some kind of Texture for the icon.
	return preload("res://addons/teskan/sprites/main_menu_icon.png")
	#return get_editor_interface().get_base_control().get_icon("Node", "EditorIcons")
