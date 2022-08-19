tool
extends HBoxContainer

onready var portrait_list = self.get_parent()
onready var tree : Tree = self.get_node("../../../../../../../MainTree")
signal selected(portrait_path)
onready var old_name : String

#DELETE PORTRAIT ENTRY
func _on_PortraitDelete_pressed():
	if portrait_list.get_child_count() > 1:
		var item_selected = tree.get_selected()
		var character_file = TDData.get_var("res://addons/teskan/data/dialogue/characters/"+item_selected.get_metadata(0))
		character_file.portraits.erase($PortraitName.text)
		TDData.store_var("res://addons/teskan/data/dialogue/characters/"+item_selected.get_metadata(0),character_file)

		self.queue_free()

#POPUP THE MENU FOR FINDING THE FILE PATH
func _on_PortraitFindPath_pressed():
	$PortraitPickerMenu.popup(Rect2(Vector2(500,500),Vector2(1000,1000)))

#SAVE THE DATA WHEN THE FILE IS SELECTED
func _on_PortraitPickerMenu_file_selected(path):
	var item_selected = tree.get_selected()
	var character_file = TDData.get_var("res://addons/teskan/data/dialogue/characters/"+item_selected.get_metadata(0))
	character_file.portraits[$PortraitName.text] = (path)
	TDData.store_var("res://addons/teskan/data/dialogue/characters/"+item_selected.get_metadata(0),character_file)
	
	$PortraitPath.text = path
	emit_signal("selected",$PortraitPath.text)

#YELL AT THE CHARACTERSCREEN.GD TO SHOW THE PREVIEW OF THE PORTRAIT
func _on_PortraitPath_focus_entered():
	if $PortraitPath.text != "res://":
		emit_signal("selected",$PortraitPath.text)

#YELL AT THE CHARACTERSCREEN.GD TO SHOW THE PREVIEW OF THE PORTRAIT
func _on_PortraitName_focus_entered():
	if $PortraitPath.text != "res://":
		emit_signal("selected",$PortraitPath.text)
		
	old_name = $PortraitName.text

#SAVE DATA IF THE USER CHANGES THE NAME OF THE PORTRAIT ENTRY
func _on_PortraitName_text_entered(new_text):
	if $PortraitPath.text != "res://":
		var item_selected = tree.get_selected()
		var character_file = TDData.get_var("res://addons/teskan/data/dialogue/characters/"+item_selected.get_metadata(0))
		character_file.portraits.erase(old_name)
		character_file.portraits[new_text] = load($PortraitPath.text)
		TDData.store_var("res://addons/teskan/data/dialogue/characters/"+item_selected.get_metadata(0),character_file)
	
	old_name = new_text
	#$PortraitPath.text = path
	#emit_signal("selected",$PortraitPath.text)
