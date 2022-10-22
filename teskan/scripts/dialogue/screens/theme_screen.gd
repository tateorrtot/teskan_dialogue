tool
extends Control

onready var tree : Tree = self.get_node("../../MainTree")

var characters = []
var character_path : String
var character

#LOAD THEME
func _on_ThemeScreen_visibility_changed():
	if self.visible == true && tree.get_selected():
		var theme_file = get_file()
		
		$"%Background".text = theme_file.background
		$"%Name".text = theme_file.name
		$"%NameColourChanger".color = theme_file.colour
		$"%Desc".text = theme_file.desc
		$"%Font".text = theme_file.font
		
		$"%SmallFont".text = str(theme_file.small_font)
		$"%MediumFont".text = str(theme_file.medium_font)
		$"%LargeFont".text = str(theme_file.large_font)
		$"%FontOutlineSize".text = str(theme_file.font_outline_size)
		
		$"%OutlineColour".color = theme_file.font_outline_colour
		$"%NameBackgroundColour".color = theme_file.name_background_colour
		$"%TextAccentColour".color = theme_file.text_accent_colour
		
func _on_NameColourChanger_color_changed(color):
	get_store_file('colour',color)
	tree.get_selected().set_icon_modulate(0,color)

func _on_Name_text_changed(new_text):
	get_store_file('name',new_text)
	tree.get_selected().set_text(0,new_text)

func _on_Font_pressed():
	$FontMenu.popup_centered(Vector2(800,800))

func _on_FontMenu_file_selected(path):
	$"%Font".text = $FontMenu.current_path
	get_store_file('font',$FontMenu.current_path)

func _on_Desc_text_changed(new_text):
	get_store_file('desc',new_text)

func _on_SmallFont_text_changed(new_text):
	if int(new_text):
		get_store_file('small_font',int(new_text))

func _on_MediumFont_text_changed(new_text):
	if int(new_text):
		get_store_file('medium_font',int(new_text))

func _on_LargeFont_text_changed(new_text):
	if int(new_text):
		get_store_file('large_font',int(new_text))
		
func _on_OutlineColour_color_changed(color):
	get_store_file('font_outline_colour',color)

func _on_NameBackgroundColour_color_changed(color):
	get_store_file('name_background_colour',color)
	
func _on_TextAccentColour_color_changed(color):
	get_store_file('text_accent_colour',color)

func _on_TextPreview_text_changed(new_text):
	$'%DisplayText'.bbcode_text = new_text

func _on_BackgroundMenu_file_selected(path):
	$"%Background".text = $BackgroundMenu.current_path
	get_store_file('background',$BackgroundMenu.current_path)
	
func _on_Background_pressed():
	$BackgroundMenu.popup_centered(Vector2(800,800))
	
func _on_FontOutlineSize_text_changed(new_text):
	get_store_file('font_outline_size',int(new_text))
	
	

func get_file():
	var theme_file = TDData.get_var("res://teskan_data/dialogue/themes/"+tree.get_selected().get_metadata(0))
	return theme_file
func get_store_file(property,value):
	var theme_file = TDData.get_var("res://teskan_data/dialogue/themes/"+tree.get_selected().get_metadata(0))
	theme_file[property] = value
	TDData.store_var("res://teskan_data/dialogue/themes/"+tree.get_selected().get_metadata(0),theme_file)
	LoadPreview()

func LoadPreview():
		
	var small_font = DynamicFont.new()
	#var medium_font = DynamicFont.new()
	#var large_font = DynamicFont.new()
	
		#CHARACTER
	if character_path != null and character_path != '':
		$'%DisplayText'.add_color_override("default_color",TDData.get_var(character_path).colour)
		$'%NameLabel'.add_color_override("default_color",TDData.get_var(character_path).colour)
	
		$'%NameStretcher'.text = " " + TDData.get_var(character_path).name + " "
		$'%NameLabel'.text = " " + TDData.get_var(character_path).name + " "
		if TDData.get_var(character_path).portraits['Default']:
			$'%PortraitBox'.texture = load(TDData.get_var(character_path).portraits['Default'])

		#$'%'
	
	#var font_path = get_file().font
	
	small_font.font_data = load(get_file().font)
	small_font.outline_color = get_file().font_outline_colour
	small_font.outline_size = get_file().font_outline_size
	
	var medium_font = small_font.duplicate()
	var large_font = small_font.duplicate()
		
	small_font.size = get_file().small_font
	medium_font.size = get_file().medium_font
	large_font.size = get_file().large_font

	
	if small_font.size > 1000 or medium_font.size > 1000 or large_font.size > 1000:
		print("ERROR: Font to large. May crash program.")
		return
	
	$'%NameBackground'.color = get_file().name_background_colour
	$'%NameStretcher'.add_font_override("font",medium_font)
	$'%NameLabel'.add_font_override("font",medium_font)
	$'%DisplayText'.add_font_override("normal_font",medium_font)
	$'%DisplayText'.add_font_override("italics_font",small_font)
	$'%DisplayText'.add_font_override("bold_font",large_font)
	$'%TextAccent'.color = get_file().text_accent_colour
	$'%DialogueBackground'.texture = load(get_file().background)
	#$'%DialogueBackground'.rect_scale = Vector2(0.5,0.5)
		#$'%NameLabel'

func _on_CharacterSelecter_pressed():
	characters = get_characters()
	$PopupMenu.clear()
	for i in characters:
		$PopupMenu.add_item(i.name)
	
	$PopupMenu.popup_centered(Vector2(800,800))

	#print(self.get_node("%Character").text)
#WHEN THE USER SELECTS A CHARACTER IN THE CHARACTER POP UP MENU, 
#LOAD CHARACTER INTO THE EVENT
func _on_PopupMenu_index_pressed(index):
	var characters_in_tree = tree.get_root().get_children()
	var current_tree_item_character = characters_in_tree.get_children()
	var item_selected = tree.get_selected()
	
	#LOOP THROUGH ALL THE CHARACTERS IN THE TREE UNTIL I FIND THE ONE THAT WAS SELECTED IN THE POPUP MENU
	while true:
		#If the current character being iterated over is what we picked, save it
		if current_tree_item_character.get_text(0) == characters[index].name:
			#Save the character that was selected into the text event, which is in the timeline's file
			var character_file = TDData.get_var("res://teskan_data/dialogue/characters/"+current_tree_item_character.get_metadata(0))
			
			#self.get_node('%CharacterName').text = character_file.name
			character_path = "res://teskan_data/dialogue/characters/"+current_tree_item_character.get_metadata(0)
			LoadPreview()
			break
		else: 
			current_tree_item_character = current_tree_item_character.get_next()

#GET ALL THE CHARACTERS THAT CAN BE PICKED
func get_characters():
	var characters = []
	var dir = Directory.new()
	dir.open("res://teskan_data/dialogue/characters")
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			var character = TDData.get_var("res://teskan_data/dialogue/characters/"+file)
			characters.append({'name' : character.name, 'path' : "res://teskan_data/dialogue/characters/"+file})
			
	dir.list_dir_end()
	return characters
