tool
extends Control

onready var tree = self.get_node("../../MainTree")
onready var event_list = $HSplitContainer/LeftSide/EventList

var is_dragging = false
var change_order = false

var last_selected_timeline_path

#ADDING A NEW TEXT EVENT TO THE CURRENT TIMELINE
func _on_AddTextEvent_pressed():
	TDData.new_text_event(event_list,tree)
	
func _on_AddChoiceEvent_pressed():
	TDData.new_choice_event(event_list,tree)

func _on_TimelineScreen_visibility_changed():
	#print(TDData.get_var("res://teskan_data/dialogue/timelines/"+tree.get_selected().get_metadata(0)))
	if self.visible == true:
		#print(TDData.get_var("res://teskan_data/dialogue/timelines/"+tree.get_selected().get_metadata(0)))
		last_selected_timeline_path = "res://teskan_data/dialogue/timelines/"+tree.get_selected().get_metadata(0)
		load_timeline()
	elif self.visible == false:
		save_timeline()

func load_timeline():
	var timeline = TDData.get_var("res://teskan_data/dialogue/timelines/"+tree.get_selected().get_metadata(0))
	
	for child in event_list.get_children():
		child.queue_free()
		
	load_events_loop(timeline,timeline.events)

func load_events_loop(timeline,parent):
	#print(parent)
	#LOOP THROUGH ALL THE EVENTS IN THE SELECTED TIMELINE TO LOAD THEM
	var index = 0
	
	for event in parent:
		#LOAD TEXT EVENTS
		#print("parent ", parent)
		#print("event ",event)
		#text events
		if event.type == "text":
			var new_text_event_preset = load("res://addons/teskan/scenes/dialogue/presets/events/TextEvent.tscn").instance()
			new_text_event_preset.get_node("EventDivider/Id").text = event.id
			
			#CHECK IF THE EVENT HAS A CHARACTER
			if event.character != 'No Character':
				new_text_event_preset.get_node("MainBody/HBoxContainer/Character").text = TDData.get_var(event.character).name
				#CHECK IF THE EVENT's CHARACTER HAS A COLOUR
				if TDData.get_var(event.character).colour is Color:
					new_text_event_preset.get_node("MainBody/HBoxContainer/CharacterColour").color = TDData.get_var(event.character).colour
					
			event_list.add_child(new_text_event_preset)
		
		#choice events
		if event.type == "choice":
			var new_choice_event_preset = load("res://addons/teskan/scenes/dialogue/presets/events/ChoiceEvent.tscn").instance()
			new_choice_event_preset.get_node("EventDivider/Id").text = timeline.events[index].id
			event_list.add_child(new_choice_event_preset)
			
			if event.children != []:
				
				load_events_loop(timeline,event.children)
				
	index +=1
		
func save_timeline():
	var timeline = TDData.get_var(last_selected_timeline_path)
	timeline.events.clear()
	
	save_events_loop(timeline,$HSplitContainer/LeftSide/EventList.get_children(),[])
	
	TDData.store_var(last_selected_timeline_path,timeline)
	
	print(TDData.get_var(last_selected_timeline_path))

func save_events_loop(timeline,ui_parent,event_path):
	#print(event_path)
	var index = 0
	#print("new save loop started...")
	#LOOP THROUGH ALL THE EVENTS IN THE SELECTED TIMELINE TO LOAD THEM
	#print(ui_parent)
	for ui_event in ui_parent:
		#LOAD TEXT EVENTS
		
		#text events
		if ui_event.get_node("Type").text == "Text":
			#print("PATH ",event_path)
			#print("Text")
			#print("event_path ",event_path)
			var new_timeline_events = add_event_child({'type' : 'text', 'character' : 'No Character', 'text' : 'No Text', 'id' : get_event_id(ui_event)},event_path,timeline.events,0,ui_event)
			#print("new_timeline_events ",new_timeline_events)
			#add_event_child("text",event_path,timeline.events,0,ui_event)
			#print("New event: ",new_event)
		
		#choice events
		if ui_event.get_node("Type").text == "Choice":
			#print("Choice")
			var new_timeline_events = add_event_child({'type' : 'choice', 'desc' : 'No Desc', 'children' : [], 'id' : get_event_id(ui_event)},event_path,timeline.events,0,ui_event)
			#print("new events! ",new_timeline_events)
			
			check_for_children_while_saving(timeline,ui_event,event_path)
			
			
			
		index += 1
		
#FINDS WHAT THE PARENT OF AN EVENT SHOULD BE WHEN SAVING IT 
func add_event_child(dict,event_path,parent,index,event):
	#CHECK THERE IF THIS IS A SUB EVENT
	if event_path != []:
		#print("index ",index)
		#IF WE'RE DONE TRAVERSING THE EVENT PATH
		if index == event_path.size():
			parent.append(dict)
					
		#IF WE NEED TO KEEP TRAVERSING THE EVENT_PATH
		else:
			for event in parent:
				#print(event_path)
				#print("traversing... ",event)
				if event.id == event_path[index]:
					index += 1
					add_event_child(dict,event_path,event.children,index,event)
					break
	else:
		parent.append(dict)

	return parent


func check_for_children_while_saving(timeline,event,event_path):
	if event.has_node("ChildrenList") :
		if event.get_node("ChildrenList").get_children():
			#ADD THIS EVENT TO THE PATH
			event_path.append(get_event_id(event))
			
			save_events_loop(timeline,event.get_node("ChildrenList").get_children(),event_path)
			
func get_event_id(event):
	var id = event.get_node("EventDivider/Id").text
	return id
