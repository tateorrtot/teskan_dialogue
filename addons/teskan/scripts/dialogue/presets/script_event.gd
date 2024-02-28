@tool
extends Control

func _on_SelectScript_pressed():
	$ScriptPickerMenu.popup_centered(Vector2(800,800))


func _on_ScriptPickerMenu_file_selected(path):
	$'%FilePath'.text = path
