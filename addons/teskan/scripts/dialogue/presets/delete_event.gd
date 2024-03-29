@tool
extends Button

func _on_DeleteEvent_pressed():
	self.get_node("../../").queue_free()
