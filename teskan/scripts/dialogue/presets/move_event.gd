tool
extends Button

onready var timeline_screen = find_parent("TimelineScreen")#self.get_node("../../../../../")
onready var tree = self.find_parent("Dialogue").get_node("MainTree")
onready var events_list = timeline_screen.get_node("HSplitContainer/LeftSide/EventList")
onready var wait_after_drag = timeline_screen.get_node("WaitAfterDrag")
onready var event_divider = self.get_node("../EventDivider")
onready var main_body = self.get_node("../MainBody")

var is_dragging = false
var change_order = false
var force_change_event_parent = false

#===========================DRAGGING AND DROPPING===========================#
#CONNECT SIGNALS
func _ready():
	event_divider.connect("mouse_entered",self,"_on_EventDivider_mouse_entered")
	event_divider.connect("mouse_exited",self,"_on_EventDivider_mouse_exited")

	main_body.connect("mouse_entered",self,"_on_MainBody_mouse_entered")
	main_body.connect("mouse_exited",self,"_on_MainBody_mouse_exited")
		
#START DRAGGING
func _on_MoveEvent_button_down():
	timeline_screen.is_dragging = true
#DROP THE EVENT
func _on_MoveEvent_button_up():
	for event in events_list.get_children():
		event.get_node("MoveEvent").move_event(self.get_parent())
		#CHECK FOR SUB EVENTS
		if event.has_node("ChildrenList"):
			if event.get_node("ChildrenList").get_child_count() > 0:
				move_sub_events(event)

func move_sub_events(event):
	for sub_event in event.get_node("ChildrenList").get_children():
		sub_event.get_node("MoveEvent").move_event(self.get_parent())
		if sub_event.has_node("ChildrenList"):
			if sub_event.get_node("ChildrenList").get_child_count() > 0:
				move_sub_events(sub_event)

#CHANGE THE ORDER, DONT ADD THE EVENT AS A CHILD
func _on_EventDivider_mouse_entered():
	change_order = true
func _on_EventDivider_mouse_exited():
	change_order = false

#ADD THE EVENT AS A CHILD TO ANOTHER EVENT
func _on_MainBody_mouse_entered():
	force_change_event_parent = true
func _on_MainBody_mouse_exited():
	force_change_event_parent = false
		
#MOVE THE EVENT
func move_event(event):
	#event is the event we're trying to move
	#self is the target of where we're moving the event 
	wait_after_drag.start(0.0001)
	yield(wait_after_drag,"timeout")
	
	#var timeline_path = "res://teskan_data/dialogue/timelines/"+tree.get_selected().get_metadata(0)
	#var timeline_file = TDData.get_var("res://teskan_data/dialogue/timelines/"+tree.get_selected().get_metadata(0))
	var original_index = event.get_index()
	var target_index = self.get_parent().get_index()
	#CHANGE ORDER NOT PARENT
	if timeline_screen.is_dragging == true and change_order == true and self.get_parent().get_parent() == event.get_parent():
		print("CHANGE ORDER")
		event.get_parent().move_child(event,target_index)
		timeline_screen.is_dragging = false
		#if target_index < original_index:
			#timeline_file.events.insert(target_index,timeline_file.events[original_index])
			#timeline_file.events.remove(original_index + 1)
		#else:
			#timeline_file.events.insert(target_index + 1,timeline_file.events[original_index])
			#timeline_file.events.remove(original_index)
			
		#TDData.store_var("res://teskan_data/dialogue/timelines/"+tree.get_selected().get_metadata(0),timeline_file)
		
	#FORCE CHANGE PARENT 
	if timeline_screen.is_dragging == true and force_change_event_parent == true and self.get_parent().has_node("ChildrenList"): #and self.get_parent().get_parent() == event.get_parent():
		print("Change Parent")
		#for parent in self.get_parent():
		#TDData.get_event_parents(event)
		#var current_event_path = TDData.get_event_path(event)
		var new_parent_child_list = self.get_parent().get_node("ChildrenList")
		event.get_parent().remove_child(event)
		new_parent_child_list.add_child(event)
		
		#var desired_index = event.get_index()
		#var target_event_path = TDData.get_event_path(event)
		
		#TDData.set_event_path(timeline_path,current_event_path,target_event_path,desired_index)

	#CHANGE PARENT AND ORDER
	elif timeline_screen.is_dragging == true and change_order == true and self.get_parent().get_parent() != event.get_parent():
		print("Change parent AND order")
		var new_parent_child_list
		
		if self.get_parent().get_parent().get_parent().has_node("ChildrenList"):
			new_parent_child_list = self.get_parent().get_parent().get_parent().get_node("ChildrenList")
		else:
			new_parent_child_list = events_list
			
		event.get_parent().remove_child(event)
		new_parent_child_list.add_child(event)
		
		event.get_parent().move_child(event,target_index)
		
		timeline_screen.is_dragging = false
		#print(self.get_parent().get_node("EventDivider/Id").text)	"""

func change_parent(event):
	pass

