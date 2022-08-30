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

#=================================LOADING=================================

func load_timeline():
	var timeline = TDData.get_var("res://teskan_data/dialogue/timelines/"+tree.get_selected().get_metadata(0))
	
	for child in event_list.get_children():
		child.queue_free()
		
	$LoadDelay.start(0.1)
	yield($LoadDelay,"timeout")
	
	load_events_loop(timeline,timeline.events,[])

func load_events_loop(timeline,parent,event_path):
	
	#print("New load loop started! ",parent)
	#LOOP THROUGH ALL THE EVENTS IN THE SELECTED TIMELINE TO LOAD THEM
	#var index = 0
	
	for event in parent:
		#LOAD TEXT EVENTS
		#print("parent ", parent)
		#print("event ",event)
		#text events
		if event.type == "text":
			var new_ui_event = load("res://addons/teskan/scenes/dialogue/presets/events/TextEvent.tscn").instance()
			set_ui_event_id(event,new_ui_event)
			
			#CHECK IF THE EVENT HAS A CHARACTER
			if event.character != 'No Character':
				new_ui_event.get_node("MainBody/HBoxContainer/Character").text = TDData.get_var(event.character).name
				#CHECK IF THE EVENT's CHARACTER HAS A COLOUR
				if TDData.get_var(event.character).colour is Color:
					new_ui_event.get_node("MainBody/HBoxContainer/CharacterColour").color = TDData.get_var(event.character).colour
			
			#print(event_path)
			
			add_ui_event_child(new_ui_event,event_path,event_list,0)
		
		#choice events
		if event.type == "choice":
			var new_ui_event = load("res://addons/teskan/scenes/dialogue/presets/events/ChoiceEvent.tscn").instance()
			set_ui_event_id(event,new_ui_event)
		#	print("delay start")
			#yield($LoadDelay,"timeout")
			#print("delay done")
			#new_choice_event_preset.get_node("EventDivider/Id").text = timeline.events[index].id
			add_ui_event_child(new_ui_event,event_path,event_list,0)
				
			check_for_children_while_loading(timeline,event,event_path)
				
func check_for_children_while_loading(timeline,event,event_path):
	if event.has('children'):
		if event.children != []:
			print(event)
			#ADD THIS EVENT TO THE PATH
			var new_event_path = event_path.duplicate()
			
			new_event_path.append(event.id)
			
			load_events_loop(timeline,event.children,new_event_path)
			
func add_ui_event_child(new_ui_event,event_path,parent,index):
	#print("Parent chillin: ",parent.get_children())
	#print("adding child...")
	if event_path != []:
		#IF WE'RE DONE TRAVERSING THE EVENT PATH
		if index == event_path.size():
			#print("Child added! ",parent)
			parent.add_child(new_ui_event)
		#IF WE NEED TO KEEP TRAVERSING THE EVENT_PATH
		else:
			for ui_event in parent.get_children():
				if get_event_id(ui_event) == event_path[index]:
					index += 1
					add_ui_event_child(new_ui_event,event_path,ui_event.get_node("ChildrenList"),index)
					break
				
	else:
		#print("Child added!")
		parent.add_child(new_ui_event)

func set_ui_event_id(event,ui_event):
	ui_event.get_node("EventDivider/Id").text = event.id
	
#=================================SAVING=================================
		
func save_timeline():
	var timeline = TDData.get_var(last_selected_timeline_path)
	timeline.events.clear()
	
	save_events_loop(timeline,$HSplitContainer/LeftSide/EventList.get_children(),[])
	
	TDData.store_var(last_selected_timeline_path,timeline)
	
	print(TDData.get_var(last_selected_timeline_path))

func save_events_loop(timeline,ui_parent,event_path):
	#print(event_path)
	#var index = 0
	#print("new save loop started...")
	#LOOP THROUGH ALL THE EVENTS IN THE SELECTED TIMELINE TO LOAD THEM
	#print(ui_parent)
	for ui_event in ui_parent:
		#print(ui_parent)
		#LOAD TEXT EVENTS
		#print("=================")
		#print("Path: ",event_path)
		#print("Parent: ",ui_parent)
		#print("Event: ",ui_event)
		#text events
		if ui_event.get_node("Type").text == "Text":
			#if event_path == []:
			#	print("Adding a core child!")
			#print("PATH ",event_path)
			#print("Text")
			#print("event_path ",event_path)
			var new_timeline_events = add_event_child({'type' : 'text', 'character' : 'No Character', 'text' : 'No Text', 'id' : get_event_id(ui_event)},event_path,timeline.events,0)
			#print("new_timeline_events ",new_timeline_events)
			#add_event_child("text",event_path,timeline.events,0,ui_event)
			#print("New event: ",new_event)
		
		#choice events
		if ui_event.get_node("Type").text == "Choice":
			#print("Choice")
			var new_timeline_events = add_event_child({'type' : 'choice', 'desc' : 'No Desc', 'children' : [], 'id' : get_event_id(ui_event)},event_path,timeline.events,0)
			#print("new events! ",new_timeline_events)
			check_for_children_while_saving(timeline,ui_event,event_path)

#CHECK IF AN EVENT HAS CHILDREN AND DO THE SAVE LOOP ON THE EVENT TO SAVE ITS CHILDREN
func check_for_children_while_saving(timeline,event,event_path):
	if event.has_node("ChildrenList") :
		if event.get_node("ChildrenList").get_children():
			#ADD THIS EVENT TO THE PATH
			var new_event_path = event_path.duplicate()
			
			new_event_path.append(get_event_id(event))
			
			save_events_loop(timeline,event.get_node("ChildrenList").get_children(),new_event_path)
	
#ADDS AN EVENT TO THE TIMELINE BY TRAVERSING IT'S PATH
func add_event_child(dict,event_path,parent,index):
	#index is so we can traverse the path
	#CHECK THERE IF THIS IS A SUB EVENT
	if event_path != []:
		#IF WE'RE DONE TRAVERSING THE EVENT PATH
		if index == event_path.size():
			#print("--=========--")
			#print("adding a sub child")
			parent.append(dict)
					
		#IF WE NEED TO KEEP TRAVERSING THE EVENT_PATH
		else:
			for event in parent:
				#print(event_path)
				#print("traversing... ",event)
				if event.id == event_path[index]:
					index += 1
					add_event_child(dict,event_path,event.children,index)
					break
	else:
		#print("--=========--")
		#print("adding a core child")
		parent.append(dict)
	#print("PARENT: ",parent)
	#return parent

func get_event_id(ui_event):
	var id = ui_event.get_node("EventDivider/Id").text
	return id
