@tool
extends Control


func _on_SelectSound_pressed():
	$SoundPickerMenu.popup_centered(Vector2(800,800))


func _on_SoundPickerMenu_file_selected(path):
	$'%FilePath'.text = path
