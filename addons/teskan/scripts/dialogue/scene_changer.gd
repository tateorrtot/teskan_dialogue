extends StaticBody2D
class_name SceneChanger

@onready var main_gui = get_tree().current_scene.get_node("MainGUI") 
@export var scene_to_change_to_path : String
@export var is_active := true

@export var is_end_screen := false

func change_scene_to_file():
	if is_active:
		if is_end_screen:
			main_gui.end_level()
			
			await main_gui.next_level_pressed
			
			get_tree().change_scene_to_file(scene_to_change_to_path)
			get_tree().paused = false
		else:
			SaveGame.save_game()
			get_tree().change_scene_to_file(scene_to_change_to_path)


