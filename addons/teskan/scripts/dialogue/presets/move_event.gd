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
	wait_after_drag.start(0.0001)
	yield(wait_after_drag,"timeout")
	
	var timeline_file = TDData.get_var("res://addons/teskan/data/dialogue/timelines/"+tree.get_selected().get_metadata(0))
	var original_pos = event.get_index()
	var target_pos = self.get_parent().get_index()
	#print("change order ",timeline_screen.change_order)
	if timeline_screen.is_dragging == true and change_order == true:
		print("target ",target_pos)
		#MOVE THE EVENT IN THE FILES
		if self.get_parent().get_parent() != event.get_parent():
			print("DIFFERENT")
		
		if target_pos < original_pos:
			timeline_file.events.insert(target_pos,timeline_file.events[original_pos])
			timeline_file.events.remove(original_pos + 1)
		else:
			timeline_file.events.insert(target_pos + 1,timeline_file.events[original_pos])
			for event in timeline_file.events:
				print(TDData.get_var(event.character).name)
			timeline_file.events.remove(original_pos)
			
		for event in timeline_file.events:
			pass#print(TDData.get_var(event.character).name)
		
		TDData.store_var("res://addons/teskan/data/dialogue/timelines/"+tree.get_selected().get_metadata(0),timeline_file)
		
		
		events_list.move_child(event,target_pos)
		timeline_screen.is_dragging = false
	elif timeline_screen.is_dragging == true and force_change_event_parent == true:
		print("Add child")

func change_parent(event):
	pass
