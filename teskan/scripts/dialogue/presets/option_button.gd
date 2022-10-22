extends Button
signal pressed_with_id

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	
	self.connect('pressed',self,'on_self_pushed')
	self.connect("pressed_with_id",self.get_parent(),"on_option_button_pressed")



func on_self_pushed():
	emit_signal("pressed_with_id",self.get_meta('id'))
