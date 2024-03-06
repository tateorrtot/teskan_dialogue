@tool
extends Control

@onready var tree : Tree = self.get_parent().get_parent().get_node("MainTree")


@onready var name_colour_changer  = $HSplitContainer/ScrollContainer/Pickers/NameColour/NameColourChanger
@onready var name_picker = $HSplitContainer/ScrollContainer/Pickers/NameColour/Name
@onready var faction_picker = $HSplitContainer/ScrollContainer/Pickers/Faction/Faction
@onready var theme_picker = $HSplitContainer/ScrollContainer/Pickers/Theme/Theme
@onready var voice_picker_menu = $VoicePickerMenu
@onready var voice_picker_button = $HSplitContainer/ScrollContainer/Pickers/Voice/Voice
@onready var voice_pitch_min = $HSplitContainer/ScrollContainer/Pickers/VoiceRange/VoicePitchMin
@onready var voice_pitch_max = $HSplitContainer/ScrollContainer/Pickers/VoiceRange/VoicePitchMax
@onready var voice_speed = $HSplitContainer/ScrollContainer/Pickers/VoiceSpeed/VoiceSpeed
@onready var portrait_list = $HSplitContainer/ScrollContainer/Pickers/PortraitList
@onready var portrait_entry = preload("res://addons/teskan/scenes/dialogue/presets/PortraitEntry.tscn")
@onready var portrait_preview = $HSplitContainer/Control/PortraitPreview

var themes = []
var theme_path : String

#LOAD THE CHARACTER
func _on_CharacterScreen_visibility_changed():
	
	if self.visible == true && tree.get_selected():
		var character_file = TDData.get_var("res://teskan_data/dialogue/characters/"+tree.get_selected().get_metadata(0))
		
		name_colour_changer.color = character_file.colour
		name_picker.text = character_file.name
		faction_picker.text = character_file.faction
		if FileAccess.file_exists(character_file.voice):
			voice_picker_button.text = character_file.voice
		else:
			voice_picker_button.text = 'null'
		voice_pitch_min.text = var_to_str(character_file.voice_pitch_min)
		voice_pitch_max.text = var_to_str(character_file.voice_pitch_max)
		voice_speed.text = var_to_str(character_file.voice_speed)
		
		if character_file.theme != 'null':
			theme_picker.text = TDData.get_var(character_file.theme).name
		else:
			theme_picker.text = 'Select File'
		
		#PORTRAITS
		#Clear all children in the portrait list on the UI
		for child in portrait_list.get_children():
			child.queue_free()
		
		#Load all the portraits from the file onto the UI
		var loaded_preview = false
		for portrait in character_file.portraits:
			var new_portrait_entry = portrait_entry.instantiate()
			portrait_list.add_child(new_portrait_entry)
			new_portrait_entry.connect("selected",Callable(self,"_on_PortraitEntry_selected"))
			new_portrait_entry.get_node("PortraitName").text = portrait
			new_portrait_entry.get_node("PortraitPath").text = character_file.portraits[portrait]
			
			if loaded_preview == false:
				loaded_preview = true
				portrait_preview.texture = load(character_file.portraits[portrait])
				
		
		if character_file.portraits.size() == 0:
			portrait_preview.texture = null
		
#CHANGE NAME
func _on_NamePicker_text_entered(new_text):
	var character_file = TDData.get_var("res://teskan_data/dialogue/characters/"+tree.get_selected().get_metadata(0))
	
	tree.get_selected().set_text(0,new_text)
	character_file.name = new_text
	TDData.store_var("res://teskan_data/dialogue/characters/"+tree.get_selected().get_metadata(0),character_file)

#CHANGE COLOUR
func _on_NameColorChanger_color_changed(color):
	var character_file = TDData.get_var("res://teskan_data/dialogue/characters/"+tree.get_selected().get_metadata(0))
	
	tree.get_selected().set_icon_modulate(0,color)
	character_file.colour = color
	TDData.store_var("res://teskan_data/dialogue/characters/"+tree.get_selected().get_metadata(0),character_file)

#CHANGE FACTION
func _on_FactionPicker_text_entered(new_text):
	var character_file = TDData.get_var("res://teskan_data/dialogue/characters/"+tree.get_selected().get_metadata(0))
	
	character_file.faction = new_text
	TDData.store_var("res://teskan_data/dialogue/characters/"+tree.get_selected().get_metadata(0),character_file)
	
#CHANGE VOICE
func _on_VoicePicker_pressed():
	voice_picker_menu.popup_centered(Vector2(800,800))
func _on_VoicePickerMenu_file_selected(path):
	var character_file = TDData.get_var("res://teskan_data/dialogue/characters/"+tree.get_selected().get_metadata(0))
	var audio_stream_player = $AudioStreamPlayer

	voice_picker_button.text = voice_picker_menu.current_path
	character_file.voice = voice_picker_menu.current_path
	
	TDData.store_var("res://teskan_data/dialogue/characters/"+tree.get_selected().get_metadata(0),character_file)
	audio_stream_player.stream = load(voice_picker_menu.current_path)
	audio_stream_player.play()

#CHANGE VOICE PITCH RANGE
func _on_VoicePitchMin_text_entered(new_text):
	var character_file = TDData.get_var("res://teskan_data/dialogue/characters/"+tree.get_selected().get_metadata(0))
	
	character_file.voice_pitch_min = float(new_text)
	TDData.store_var("res://teskan_data/dialogue/characters/"+tree.get_selected().get_metadata(0),character_file)
func _on_VoicePitchMax_text_entered(new_text):
	var character_file = TDData.get_var("res://teskan_data/dialogue/characters/"+tree.get_selected().get_metadata(0))
	
	character_file.voice_pitch_max = float(new_text)
	TDData.store_var("res://teskan_data/dialogue/characters/"+tree.get_selected().get_metadata(0),character_file)

#VOICE SPEED
func _on_VoiceSpeed_text_changed(new_text):
	var character_file = TDData.get_var("res://teskan_data/dialogue/characters/"+tree.get_selected().get_metadata(0))
	
	character_file.voice_speed = float(new_text)
	TDData.store_var("res://teskan_data/dialogue/characters/"+tree.get_selected().get_metadata(0),character_file)

#PORTRAIT STUFF
#When a portrait is clicked preview it
func _on_PortraitEntry_selected(portrait_path):
	portrait_preview.texture = load(portrait_path)
#Make a new portrait entry
func _on_NewPortraitEntry_pressed():
	var new_portrait_entry = portrait_entry.instantiate()
	portrait_list.add_child(new_portrait_entry)
	
	new_portrait_entry.connect("selected",Callable(self,"_on_PortraitEntry_selected"))

#THEME
func _on_ThemeMenu_index_pressed(index):
	var themes_in_tree = tree.get_root().get_child(1)
	var current_tree_item_theme = themes_in_tree.get_child(0)
	var item_selected = tree.get_selected()
	
	#LOOP THROUGH ALL THE CHARACTERS IN THE TREE UNTIL I FIND THE ONE THAT WAS SELECTED IN THE POPUP MENU
	while true:
		##print(current_tree_item_theme)
		#If the current character being iterated over is what we picked, save it
		if current_tree_item_theme.get_text(0) == themes[index].name:
			#Save the character that was selected into the text event, which is in the timeline's file
			var theme_file = TDData.get_var("res://teskan_data/dialogue/themes/"+current_tree_item_theme.get_metadata(0))
			theme_path = "res://teskan_data/dialogue/themes/"+current_tree_item_theme.get_metadata(0)
			var character_file = TDData.get_var("res://teskan_data/dialogue/characters/"+tree.get_selected().get_metadata(0))
			
			theme_picker.text = TDData.get_var(theme_path).name
			character_file.theme = theme_path
			
			TDData.store_var("res://teskan_data/dialogue/characters/"+tree.get_selected().get_metadata(0),character_file)
			break
		else: 
			current_tree_item_theme = current_tree_item_theme.get_next()

func _on_Theme_pressed():
	themes = get_themes()
	$ThemeMenu.clear()
	for i in themes:
		$ThemeMenu.add_item(i.name)
	
	$ThemeMenu.popup_centered(Vector2(800,800))

#GET ALL THE CHARACTERS THAT CAN BE PICKED
func get_themes():
	var themes = []
	var dir = DirAccess.open("res://teskan_data/dialogue/themes")
	dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			var theme = TDData.get_var("res://teskan_data/dialogue/themes/"+file)
			themes.append({'name' : theme.name, 'path' : "res://teskan_data/dialogue/themes/"+file})
			
	dir.list_dir_end()
	return themes
