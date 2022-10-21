extends VBoxContainer

signal option_button_pressed
var selected_id

func on_option_button_pressed(id):
	selected_id =id
	emit_signal("option_button_pressed")
