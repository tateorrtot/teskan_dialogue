tool
extends Control

onready var tree = self.get_node("../../MainTree")
onready var event_list = $HSplitContainer/LeftSide/EventList

var is_dragging = false
var change_order = false

#ADDING A NEW TEXT EVENT TO THE CURRENT TIMELINE
func _on_AddTextEvent_pressed():
	TDData.new_text_event(event_list,tree)
	
func _on_AddChoiceEvent_pressed():
	TDData.new_choice_event(event_list,tree)

func _on_TimelineScreen_visibility_changed():
	if self.visible == true: #&& file2check.file_exists("res://teskan_data/dialogue/timelines/"+item_selected.get_metadata(0)):
		var timeline_file = TDData.get_var("res://teskan_data/dialogue/timelines/"+tree.get_selected().get_metadata(0))

		for child in event_list.get_children():
			child.queue_free()
		
		#LOADING
		#LOOP THROUGH ALL THE EVENTS IN THE SELECTED TIMELINE TO LOAD THEM
		for event in timeline_file.events:
			#LOAD TEXT EVENTS
			if event.type == "text":
				var new_text_event_preset = load("res://addons/teskan/scenes/dialogue/presets/events/TextEvent.tscn").instance()
				#CHECK IF THE EVENT HAS A CHARACTER
				if event.character != 'No Character':
					new_text_event_preset.get_node("MainBody/HBoxContainer/Character").text = TDData.get_var(event.character).name
					#CHECK IF THE EVENT's CHARACTER HAS A COLOUR
					if TDData.get_var(event.character).colour is Color:
						new_text_event_preset.get_node("MainBody/HBoxContainer/CharacterColour").color = TDData.get_var(event.character).colour
						
				event_list.add_child(new_text_event_preset)
			
			if event.type == "choice":
				var new_choice_event_preset = load("res://addons/teskan/scenes/dialogue/presets/events/TextEvent.tscn").instance()




