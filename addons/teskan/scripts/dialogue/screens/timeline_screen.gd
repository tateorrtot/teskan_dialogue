tool
extends Control

onready var tree = self.get_node("../../MainTree")
onready var event_list = $HSplitContainer/LeftSide/EventList

var is_dragging = false
var change_order = false

var last_selected_timeline_path

###--------------CREATE EVENTS--------------###
func _on_AddTextEvent_pressed():
	var new_text_event_preset = ResourceLoader.load("res://addons/teskan/scenes/dialogue/presets/events/TextEvent.tscn","", true).instance()
	new_text_event_preset.get_node("EventDivider/Id").text = var2str(OS.get_ticks_usec())
	event_list.add_child(new_text_event_preset)
	save_timeline()
	
func _on_AddChoiceEvent_pressed():
	var new_choice_event_preset = ResourceLoader.load("res://addons/teskan/scenes/dialogue/presets/events/ChoiceEvent.tscn","", true).instance()
	new_choice_event_preset.get_node("EventDivider/Id").text = var2str(OS.get_ticks_usec())
	event_list.add_child(new_choice_event_preset)
	save_timeline()
	
func _on_AddIfEvent_pressed():
	var new_if_event_preset = ResourceLoader.load("res://addons/teskan/scenes/dialogue/presets/events/IfEvent.tscn","", true).instance()
	new_if_event_preset.get_node("EventDivider/Id").text = var2str(OS.get_ticks_usec())
	event_list.add_child(new_if_event_preset)
	save_timeline()
	
func _on_AddOptionEvent_pressed():
	var new_option_event_preset = ResourceLoader.load("res://addons/teskan/scenes/dialogue/presets/events/OptionEvent.tscn","", true).instance()
	new_option_event_preset.get_node("EventDivider/Id").text = var2str(OS.get_ticks_usec())
	event_list.add_child(new_option_event_preset)
	save_timeline()
	
func _on_AddExitEvent_pressed():
	var new_option_event_preset = ResourceLoader.load("res://addons/teskan/scenes/dialogue/presets/events/ExitEvent.tscn","", true).instance()
	new_option_event_preset.get_node("EventDivider/Id").text = var2str(OS.get_ticks_usec())
	event_list.add_child(new_option_event_preset)
	save_timeline()
	
func _on_AddScriptEvent_pressed():
	var new_script_event_preset = ResourceLoader.load("res://addons/teskan/scenes/dialogue/presets/events/ScriptEvent.tscn","", true).instance()
	new_script_event_preset.get_node("EventDivider/Id").text = var2str(OS.get_ticks_usec())
	event_list.add_child(new_script_event_preset)
	save_timeline()

	
func _on_TimelineScreen_visibility_changed():
	#print(TDData.get_var("res://teskan_data/dialogue/timelines/"+tree.get_selected().get_metadata(0)))
	if self.visible == true:
		#print(TDData.get_var("res://teskan_data/dialogue/timelines/"+tree.get_selected().get_metadata(0)))
		last_selected_timeline_path = "res://teskan_data/dialogue/timelines/"+tree.get_selected().get_metadata(0)
		load_timeline()
	elif self.visible == false:
		save_timeline()
		


#=================================LOADING=================================

func _on_SaveButton_pressed():
	save_timeline()

func load_timeline():
	var timeline = TDData.get_var("res://teskan_data/dialogue/timelines/"+tree.get_selected().get_metadata(0))
	
	$'%Name'.text = timeline.name
	$'%NameColourChanger'.color = timeline.colour
	
	for child in event_list.get_children():
		child.queue_free()
		
	$LoadDelay.start(0.001)
	yield($LoadDelay,"timeout")
	
	#TDData.play_timeline(timeline)
	
	load_events_loop(timeline,timeline.events,[])

func load_events_loop(timeline,parent,event_path):
	#LOOP THROUGH ALL THE EVENTS IN THE SELECTED TIMELINE TO LOAD THEM
	
	for event in parent:
		#LOAD TEXT EVENTS
		#text events
		if event.type == "text":
			var new_ui_event = load("res://addons/teskan/scenes/dialogue/presets/events/TextEvent.tscn").instance()
			set_ui_event_id(event,new_ui_event)
			#CHECK IF THE EVENT HAS A CHARACTER
			if event.character_path != 'null':
				if File.new().file_exists(event.character_path):
					new_ui_event.get_node('%CharacterName').text = TDData.get_var(event.character_path).name
					
					#CHECK IF THE EVENT's CHARACTER HAS A COLOUR
					if TDData.get_var(event.character_path).colour is Color:
						new_ui_event.get_node('%CharacterColour').color = TDData.get_var(event.character_path).colour
					new_ui_event.character_path = event.character_path
					
					if event.portrait != '':
						new_ui_event.get_node('%PortraitName').text = event.portrait
						#').text#TDData.get_var(event.character_path)
					
			if event.text != 'null':
				new_ui_event.get_node('%Text').text = event.text
			add_ui_event_child(new_ui_event,event_path,event_list,0)
		
		#choice events
		if event.type == "choice":
			var new_ui_event = load("res://addons/teskan/scenes/dialogue/presets/events/ChoiceEvent.tscn").instance()
			set_ui_event_id(event,new_ui_event)
			add_ui_event_child(new_ui_event,event_path,event_list,0)
			if event.desc != null:
				#print('event.desc: ',event.desc)
				new_ui_event.get_node('%Description').text = event.desc
			check_for_children_while_loading(timeline,event,event_path)
			
		#options events
		if event.type == "option":
			var new_ui_event = load("res://addons/teskan/scenes/dialogue/presets/events/OptionEvent.tscn").instance()
			set_ui_event_id(event,new_ui_event)
			add_ui_event_child(new_ui_event,event_path,event_list,0)
			new_ui_event.get_node('%Prompt').text = event.prompt
			
			check_for_children_while_loading(timeline,event,event_path)
		
		if event.type == "if":
			var new_ui_event = load("res://addons/teskan/scenes/dialogue/presets/events/IfEvent.tscn").instance()
			set_ui_event_id(event,new_ui_event)
			add_ui_event_child(new_ui_event,event_path,event_list,0)
			
			new_ui_event.get_node('%Parameter1').text = event.parameter_1
			new_ui_event.get_node('%Operator').text = event.operator
			new_ui_event.get_node('%Parameter2').text = event.parameter_2
						#choice events
		if event.type == "exit":
			var new_ui_event = load("res://addons/teskan/scenes/dialogue/presets/events/ExitEvent.tscn").instance()
			set_ui_event_id(event,new_ui_event)
			add_ui_event_child(new_ui_event,event_path,event_list,0)

		if event.type == "script":
			var new_ui_event = load("res://addons/teskan/scenes/dialogue/presets/events/ScriptEvent.tscn").instance()
			set_ui_event_id(event,new_ui_event)
			add_ui_event_child(new_ui_event,event_path,event_list,0)
			
			new_ui_event.get_node('%FilePath').text = event.file_path
			#new_ui_event.get_node('%Prompt').text = event.prompt
			
			#check_for_children_while_loading(timeline,event,event_path)
			
			
func check_for_children_while_loading(timeline,event,event_path):
	if event.has('children'):
		if event.children != []:
			#print(event)
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
	
	print("Saving timeline")

func save_events_loop(timeline,ui_parent,event_path):
	#LOOP THROUGH ALL THE EVENTS IN THE SELECTED TIMELINE TO LOAD THEM
	for ui_event in ui_parent:
		#TEXT
		if ui_event.get_node("Type").text == "Text":
			var new_event = {'type' : 'text', 'character_path' : 'null', 'portrait' : 'null', 'text' : 'null', 'id' : get_event_id(ui_event)}
			if ui_event.get_node('%CharacterName').text != '':
				new_event.character_path = ui_event.character_path
			if ui_event.get_node('%Text').text != '':
				new_event.text = ui_event.get_node('%Text').text
			
			new_event.portrait = ui_event.get_node('%PortraitName').text
			
			add_event_child(new_event,event_path,timeline.events,0)
		#CHOICE
		if ui_event.get_node("Type").text == "Choice":
			#print("Choice found!")
			var new_event = {'type' : 'choice', 'desc' : 'null', 'children' : [], 'id' : get_event_id(ui_event)}
			new_event.desc = ui_event.get_node("%Description").text
			
			#print(new_event.desc)
			add_event_child(new_event,event_path,timeline.events,0)
				
			
			check_for_children_while_saving(timeline,ui_event,event_path)
		#OPTION
		if ui_event.get_node("Type").text == "Option":
			var new_event = {'type' : 'option', 'prompt' : 'null', 'children' : [], 'id' : get_event_id(ui_event)}
			new_event.prompt = ui_event.get_node('%Prompt').text
			
			add_event_child(new_event,event_path,timeline.events,0)
			
			check_for_children_while_saving(timeline,ui_event,event_path)
		#IF EVENT
		if ui_event.get_node("Type").text == "IfEvent":
			var new_event = {'type' : 'if', 'parameter_1' : 'null', 'operator' : 'null', 'parameter_2' : 'null', 'children' : [], 'id' : get_event_id(ui_event)}
			new_event.parameter_1 = ui_event.get_node('%Parameter1').text
			new_event.operator = ui_event.get_node('%Operator').text
			new_event.parameter_2 = ui_event.get_node('%Parameter2').text
			add_event_child(new_event,event_path,timeline.events,0)
			
			check_for_children_while_saving(timeline,ui_event,event_path)

		#EXIT
		if ui_event.get_node("Type").text == "Exit":
			var new_event = {'type' : 'exit', 'id' : get_event_id(ui_event)}
			
			add_event_child(new_event,event_path,timeline.events,0)
			
			check_for_children_while_saving(timeline,ui_event,event_path)
			
		#SCRIPT
		if ui_event.get_node("Type").text == "Script":
			var new_event = {'type' : 'script', 'id' : get_event_id(ui_event), 'file_path' : 'null'}
			
			new_event.file_path = ui_event.get_node('%FilePath').text
			add_event_child(new_event,event_path,timeline.events,0)
			
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

func get_event_id(ui_event):
	var id = ui_event.get_node("EventDivider/Id").text
	return id






#=================================NAME/COLOUR=================================

func get_file():
	return TDData.get_var("res://teskan_data/dialogue/timelines/"+tree.get_selected().get_metadata(0))

func get_store_file(property,value):
	var theme_file = TDData.get_var("res://teskan_data/dialogue/timelines/"+tree.get_selected().get_metadata(0))
	theme_file[property] = value
	TDData.store_var("res://teskan_data/dialogue/timelines/"+tree.get_selected().get_metadata(0),theme_file)
	 

func _on_NameColourChanger_color_changed(color):
	get_store_file('colour',color)
	tree.get_selected().set_icon_modulate(0,color)

func _on_Name_text_changed(new_text):
	get_store_file('name',new_text)
	tree.get_selected().set_text(0,new_text)


