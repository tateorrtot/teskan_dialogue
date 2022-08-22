tool
extends TDEvent

onready var tree : Tree = self.get_node("../../MainTree")


onready var name_colour_changer  = $HSplitContainer/ScrollContainer/Pickers/NameColour/NameColourChanger
onready var name_picker = $HSplitContainer/ScrollContainer/Pickers/NameColour/NamePicker
onready var faction_picker = $HSplitContainer/ScrollContainer/Pickers/Faction/FactionPicker
onready var voice_picker_menu = $VoicePickerMenu
onready var voice_picker_button = $HSplitContainer/ScrollContainer/Pickers/Voice/VoicePicker
onready var voice_pitch_min = $HSplitContainer/ScrollContainer/Pickers/VoiceRange/VoicePitchMin
onready var voice_pitch_max = $HSplitContainer/ScrollContainer/Pickers/VoiceRange/VoicePitchMax
onready var portrait_list = $HSplitContainer/ScrollContainer/Pickers/PortraitList
onready var portrait_entry = preload("res://addons/teskan/scenes/dialogue/presets/PortraitEntry.tscn")
onready var portrait_preview = $HSplitContainer/Control/PortraitPreview


#LOAD THE CHARACTER
func _on_CharacterScreen_visibility_changed():
	
	if self.visible == true && tree.get_selected():
		var character_file = TDData.get_var("res://teskan_data/dialogue/characters/"+tree.get_selected().get_metadata(0))
		
		name_colour_changer.color = character_file.colour
		name_picker.text = character_file.name
		faction_picker.text = character_file.faction
		voice_picker_button.text = character_file.voice
		voice_pitch_min.text = var2str(character_file.voice_pitch_min)
		voice_pitch_max.text = var2str(character_file.voice_pitch_max)
		
		#PORTRAITS
		#Clear all children in the portrait list on the UI
		for child in portrait_list.get_children():
			child.queue_free()
		
		#Load all the portraits from the file onto the UI
		var loaded_preview = false
		for portrait in character_file.portraits:
			var new_portrait_entry = portrait_entry.instance()
			portrait_list.add_child(new_portrait_entry)
			new_portrait_entry.connect("selected", self, "_on_PortraitEntry_selected")
			new_portrait_entry.get_node("PortraitName").text = portrait
			new_portrait_entry.get_node("PortraitPath").text = character_file.portraits[portrait]
			
			if loaded_preview == false:
				loaded_preview = true
				portrait_preview.texture = load(character_file.portraits[portrait])
		
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
	voice_picker_menu.popup(Rect2(Vector2(500,500),Vector2(1000,1000)))
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

#PORTRAIT STUFF
#When a portrait is clicked preview it
func _on_PortraitEntry_selected(portrait_path):
	portrait_preview.texture = load(portrait_path)
#Make a new portrait entry
func _on_NewPortraitEntry_pressed():
	var new_portrait_entry = portrait_entry.instance()
	portrait_list.add_child(new_portrait_entry)
	new_portrait_entry.connect("selected", self, "_on_PortraitEntry_selected")
