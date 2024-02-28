extends Node2D

@export var gui : DialogueGUI

func _ready():
	gui.play_timeline("test")
