@tool
extends Control

@onready var tree : Tree = self.get_parent().get_parent().get_node("MainTree")

@onready var dialogue_gui : Control = $DialogueBox
@onready var portrait_box : TextureRect = $DialogueBox/PortraitBox 
@onready var dialogue_background : TextureRect = $DialogueBox/DialogueBackground
@onready var name_stretcher : Label = $DialogueBox/NameStretcher
@onready var name_label : Label = $DialogueBox/NameStretcher/NameLabel
@onready var name_background : ColorRect = $DialogueBox/NameStretcher/NameBackground
@onready var text_accent : ColorRect = $DialogueBox/TextAccent
@onready var display_text : RichTextLabel = $DialogueBox/TextAccent/DisplayText

var characters = []
var character_path : String
var character

#LOAD THEME
func _on_ThemeScreen_visibility_changed():
	#if get_file():
	#	return
	
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
		
		LoadPreview()
		
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
	update_text_preview(new_text)
	
func update_text_preview(new_text):
	if new_text != null:
		display_text.text = ("[outline_color=#"+ (get_file().font_outline_colour.to_html())+"]"+"[outline_size="+var_to_str(get_file().font_outline_size)+"]"+new_text+"[/outline_size]"+"[/outline_color]")
	else:
		display_text.text = ("[outline_color=#"+ (get_file().font_outline_colour.to_html())+"]"+"[outline_size="+var_to_str(get_file().font_outline_size)+"]"+display_text.text+"[/outline_size]"+"[/outline_color]")

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
	#if property == 'font_outline_size':
		#print(theme_file)
	
	theme_file[property] = value
	#print("Storing theme file...")
	TDData.store_var("res://teskan_data/dialogue/themes/"+tree.get_selected().get_metadata(0),theme_file)
	#print("Storing theme file done!")
	LoadPreview()

func LoadPreview():
	#print("Loading preview!")
	
	
	#print(get_file().font)
		
	update_text_preview(null)
	
	#var medium_font = FontFile.new()
	#var large_font = FontFile.new()
	
		#CHARACTER
	if character_path != null and character_path != '':
		#print("Loading character...")
		
		display_text.add_theme_color_override("default_color",TDData.get_var(character_path).colour)
		name_label.add_theme_color_override("default_color",TDData.get_var(character_path).colour)
	
		name_stretcher.text = " " + TDData.get_var(character_path).name + " "
		name_label.text = " " + TDData.get_var(character_path).name + " "
		
		if TDData.get_var(character_path).portraits.has('Default'):
			portrait_box.texture = load(TDData.get_var(character_path).portraits['Default'])
		
		#print("Done loading character!")
		#$'%'
	
	
	#var font_path = get_file().font
	if get_file().font == "null":
		#print("ERROR: theme_screen.gd 123: No font found.")
		return
		
	#print("Loading font...")
	
	#var small_font : FontFile = load(get_file().font).duplicate()
	#small_font.has_meta()
	#print(get_file().font)
	#small_font.set_embolden(0,get_file().font_outline_size)
	#small_font.fixed_size = get_file().small_font
	
	#print("Font outline_colour: ",get_file().font_outline_colour)
	#print(small_font.data)
	#print("Font Embolden: ",small_font.get_embolden(0))
	#small_font.data outline_color = get_file().font_outline_colour
	#small_font.outline_size = get_file().font_outline_size
	
	#var medium_font : FontFile = load(get_file().font).duplicate()
	#medium_font = load(get_file().font)
	#medium_font.set_embolden(0,get_file().font_outline_size)
	#medium_font.fixed_size = get_file().medium_font
	
	#var large_font : FontFile = load(get_file().font).duplicate()
	#large_font = load(get_file().font)
	#large_font.set_embolden(0,get_file().font_outline_size)
	#large_font.fixed_size = get_file().large_font
	
	#print("Font Size: ", small_font.fixed_size)
	
	#if small_font.fixed_size > 1000 or medium_font.fixed_size > 1000 or large_font.fixed_size > 1000:
		##print("ERROR: Font to large. May crash program.")
	#	return
		
	#print("Done loading font!")
	
	#print("Loading textbox...")
	
	name_background.color = get_file().name_background_colour
	
	#$'%NameStretcher'.add_theme_color_override("font_color",)
	name_stretcher.add_theme_font_override("font",load(get_file().font))
	name_stretcher.add_theme_font_size_override("font_size",get_file().medium_font)
	name_stretcher.add_theme_color_override("font_outline_color",get_file().font_outline_colour)
	
	name_label.add_theme_font_override("font",load(get_file().font))
	name_label.add_theme_font_size_override("font_size",get_file().medium_font)
	name_label.add_theme_color_override("font_outline_color",get_file().font_outline_colour)
	#$'%NameLabel'.add_theme_font_override("font",get_file().font_outline_colour)
	
	display_text.add_theme_font_override("normal_font",load(get_file().font))
	display_text.add_theme_font_size_override("normal_font_size",get_file().medium_font)
	
	display_text.add_theme_font_override("italics_font",load(get_file().font))
	display_text.add_theme_font_size_override("italics_font_size",get_file().medium_font)
	
	display_text.add_theme_font_override("bold_font",load(get_file().font))
	display_text.add_theme_font_size_override("bold_font_size",get_file().medium_font)
	
	text_accent.color = get_file().text_accent_colour
	
	
	if get_file().background != "null":
		dialogue_background.texture = load(get_file().background)
		#dialogue_background.scale = Vector2(0.5,0.5)
		#$'%NameLabel'
	#print("Done loading textbox!")
		
	#print("Done loading preview")

func _on_CharacterSelecter_pressed():
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
			#print("Checking for character file...")
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
	#var dir = DirAccess.new()
	var dir = DirAccess.open("res://teskan_data/dialogue/characters")
	dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			#print("Checking for character file...")
			
			var character = TDData.get_var("res://teskan_data/dialogue/characters/"+file)
			characters.append({'name' : character.name, 'path' : "res://teskan_data/dialogue/characters/"+file})
			
	dir.list_dir_end()
	return characters
