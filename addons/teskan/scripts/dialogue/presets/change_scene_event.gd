@tool
extends Control


func _on_SelectScene_pressed():
	$ScenePickerMenu.popup_centered(Vector2(800,800))


func _on_ScenePickerMenu_file_selected(path):
	$'%Scene'.text = path
