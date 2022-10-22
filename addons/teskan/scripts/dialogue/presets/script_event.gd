tool
extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_SelectScript_pressed():
	$ScriptPickerMenu.popup_centered(Vector2(800,800))


func _on_ScriptPickerMenu_file_selected(path):
	$'%FilePath'.text = path
