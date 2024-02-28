extends Node

signal interact_button_pressed

@export var interact_cooldown : Timer

func _input(event):
	if Input.is_action_just_pressed("dialogue_input"):
		interact_button_pressed.emit()
