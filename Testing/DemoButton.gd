extends Button
#signal event_finished()

func _on_Button_pressed():
	#print(TDData.get_var("res://teskan_data/dialogue/timelines/timeline534997616"))
	#var timeline = (TDData.get_var("res://teskan_data/dialogue/timelines/timeline534997616"))
	
	get_tree().get_current_scene().get_node("DialogueUI").play_timeline("No Name")
