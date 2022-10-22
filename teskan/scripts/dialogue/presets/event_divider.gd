tool
extends ColorRect


onready var timeline_screen = self.get_node("../../../../")
onready var events_list = timeline_screen.get_node("HSplitContainer/LeftSide/EventList")

func move_event(event):
	yield(self,"mouse_entered")
	if timeline_screen.is_dragging == true:
		events_list.move_child(event,self.get_index())
		timeline_screen.is_dragging = false
	else:
		return


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
