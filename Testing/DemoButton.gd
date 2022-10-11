extends Button

func _on_Button_pressed():
	#print(TDData.get_var("res://teskan_data/dialogue/timelines/timeline534997616"))
	#var timeline = (TDData.get_var("res://teskan_data/dialogue/timelines/timeline534997616"))
	
	play_timeline("No Name")

func play_timeline(timeline_name):
	
	var dir = Directory.new()
	dir.open("res://teskan_data/dialogue/timelines/")
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir():
			var loaded_timeline = TDData.get_var("res://teskan_data/dialogue/timelines/"+file_name)
			if loaded_timeline.name == timeline_name:
				play_timeline_helper(loaded_timeline.events)
		file_name = dir.get_next()

func play_timeline_helper(events):
	for event in events:
		if event.type == 'text':
			speak(TDData.get_var(event.character_path),event.text)

		if event.has('children'):
			play_timeline_helper(event.children)
			
func speak(character,text):
	get_tree().get_current_scene().get_node("ColorRect").color = Color.greenyellow
	
	var dialogueUI = get_tree().get_current_scene().get_node("DialogueUI")
	var display_text = dialogueUI.get_node("%DisplayText")
	var name_label = dialogueUI.get_node("%NameLabel")
	var portrait_box = dialogueUI.get_node("%PortraitBox")
	var display_value = 0
	

func string_slicer(string : String):
	var in_brackets = false
	var new_string = ""
	for s in string:
		if s == "[" and not in_brackets:
			in_brackets = true
		elif s == "]" and in_brackets:
			in_brackets = false
		elif not in_brackets:
			new_string += s
	return new_string


