@tool
extends Control

@onready var tree = self.find_parent("Dialogue").get_node("MainTree")
var characters = []
var portraits

@onready var timeline_screen = self.find_parent("TimelineScreen")
@onready var events_list = timeline_screen.get_node("HSplitContainer/LeftSide/EventList")
@onready var wait_after_drag = timeline_screen.get_node("WaitAfterDrag")

var is_dragging = false
var change_order = false
var add_child_event = false

var character_path : String

#MAKE THE POP UP APPEAR TO SELECT A CHARACTER TO SPEAK
func _on_SelectCharacter_pressed():
	characters = get_characters()
	$PopupMenu.clear()
	for i in characters:
		$PopupMenu.add_item(i.name)
	
	$PopupMenu.popup_centered(Vector2(800,800))

	###print(self.get_node("%Character").text)
#WHEN THE USER SELECTS A CHARACTER IN THE CHARACTER POP UP MENU, 
#LOAD CHARACTER INTO THE EVENT
func _on_PopupMenu_index_pressed(index):
	var characters_in_tree = tree.get_root().get_child(0)
	var current_tree_item_character = characters_in_tree.get_child(0)
	var item_selected = tree.get_selected()
	
	#LOOP THROUGH ALL THE CHARACTERS IN THE TREE UNTIL I FIND THE ONE THAT WAS SELECTED IN THE POPUP MENU
	while true:
		#If the current character being iterated over is what we picked, save it
		if current_tree_item_character.get_text(0) == characters[index].name:
			#Save the character that was selected into the text event, which is in the timeline's file
			print("Checking for character file...")
			var character_file = TDData.get_var("res://teskan_data/dialogue/characters/"+current_tree_item_character.get_metadata(0))
			
			
			self.get_node('%CharacterName').text = character_file.name
			character_path = "res://teskan_data/dialogue/characters/"+current_tree_item_character.get_metadata(0)
			self.get_node('%CharacterColour').color = character_file.colour
	
			break
		else: 
			current_tree_item_character = current_tree_item_character.get_next()

#GET ALL THE CHARACTERS THAT CAN BE PICKED
func get_characters():
	var characters = []
	var dir = DirAccess.open("res://teskan_data/dialogue/characters")
	dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			print("Checking for character files...")
			var character = TDData.get_var("res://teskan_data/dialogue/characters/"+file)
			characters.append({'name' : character.name, 'path' : "res://teskan_data/dialogue/characters/"+file})
			
	dir.list_dir_end()
	return characters


func _on_SelectPortrait_pressed():
	if $'%CharacterName'.text == '':
		return
	
	print("Checking for portraits...")
	portraits = TDData.get_var(character_path).portraits.keys()
	
	$PortraitMenu.clear()
	for i in portraits:
		$PortraitMenu.add_item(i)
	
	$PortraitMenu.popup_centered(Vector2(800,800))

func _on_PortraitMenu_index_pressed(index):
	$'%PortraitName'.text = portraits[index]
