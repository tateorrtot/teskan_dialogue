extends CanvasLayer
class_name DialogueGUI

signal event_finished()
#signal loop_finished()

@export var VOICE_SPEED_MULTIPLIER = 0.05

## Must have a signal for
@export var player : Node #= self.get_node('../Player')

@export var name_stretcher_with_portrait_pos := Vector2(247,9)
@export var text_box_with_portrait_pos := Vector2(270.8,103.91)
@export var text_box_with_portrait_size := Vector2(995.9,218.75)

@export var name_stretcher_no_portrait_pos := Vector2(-102,9)
@export var text_box_no_portrait_pos := Vector2(-100,103.91)
@export var text_box_no_portrait_size := Vector2(1370,218.75)

#onready var display_text = self.get_node("%DisplayText")
#onready var name_label = self.get_node("%NameLabel")
#onready var portrait_box = self.get_node("%PortraitBox")
#onready var voice = self.get_node("%Voice")
#onready var timer = self.get_node("%Timer") 

var is_event_finished = false

func _ready():
	#player.connect("interact_button_pressed",Callable(self,"skip_event"))
	pass

func play_timeline(timeline_name):
	#if self.visible == true and is_event_finished == false:
	#	skip_event()
	#	return
		
	#if self.visible == true and is_event_finished == true:
	#	return
	
	var dir = DirAccess.open("res://teskan_data/dialogue/timelines/")
	
	dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir():
			#print("file_name: ",file_name)
			
			var loaded_timeline = TDData.get_var("res://teskan_data/dialogue/timelines/"+file_name)
			if loaded_timeline.name == timeline_name:
				
				play_timeline_helper(loaded_timeline.events)
		file_name = dir.get_next()
		
func skip_event():
	#SKIP TEXT EVENT
	if self.visible == true and is_event_finished == false:
		$'%DisplayText'.visible_characters = $'%DisplayText'.text.length()
		
	#$'%DisplayText'.visible_characters = $'%DisplayText'.text.length()
	
#func exit_timeline():

func play_timeline_helper(events, loop_completed_emiter : Node = null):
	#print("Timeline helper!")
	
	for event in events:
		is_event_finished = false
		
		print("next!")
		
		if event.type == 'text':
			var character = TDData.get_var(event.character_path)
			#print("character: ",character)
			
			if character == null:
				printerr("ERROR: No character was assigned to this event.")
				return
				
			
			
			load_theme(character,event.portrait)
			speak(character,event.text)
			
			#print("getting ready to wait...")
			if event.autocomplete == false:
				await self.event_finished
				is_event_finished = true
				#print("FINISHEDD1")
				await player.interact_button_pressed
				#print("Interact button pressed!")
			else:
				await self.event_finished
				#print("FINISHEDD2")
				is_event_finished = true
			
			$TextTimer.start()
			await $TextTimer.timeout
		
		if event.type == 'choice':
			$ChoiceMenu.size = Vector2(300,50)
			$ChoiceMenu.position = Vector2(1200,800)
			
			for child in $ChoiceMenu.get_children():
				child.queue_free()
			
			for child in event.children:
				$ChoiceMenu.position.y -= 54
				var new_child = (load('res://addons/teskan/scenes/dialogue/presets/OptionButton.tscn').instantiate())
				new_child.text = child.prompt
				new_child.set_meta('id',str(child.id)) # (str(child.id))
				$ChoiceMenu.add_child(new_child)
				new_child.grab_focus()
				
			$ChoiceMenu.visible = true
			
			await $ChoiceMenu.option_button_pressed
			$ChoiceMenu.visible = false
			for child in event.children:
				if child.id == $ChoiceMenu.get('selected_id') and child.children:
					###print("playing timeline")
					var new_loop_completed_emiter = load('res://addons/teskan/scenes/dialogue/presets/LoopCompleteEmiter.tscn').instantiate()
					self.add_child(new_loop_completed_emiter)
					play_timeline_helper(child.children,new_loop_completed_emiter)
					###print(new_loop_completed_emiter.get_signal_list())
					await new_loop_completed_emiter.loop_completed
		"""if event.type == 'if':
			##print(event.parameter_1,event.operator,event.parameter_2)
			var parameter_1_ex = Expression.new()
			var operator_ex = Expression.new()
			var parameter_2_ex = Expression.new()
			
			##print(parameter_1_ex.execute(event.parameter_1))		"""
		
		if event.type == 'exit':
			#ITERATE TO NEXT EVENT
			#allow player to move
			###print("exiting timeline!")
			$ExitTimer.start()
			await $ExitTimer.timeout
			player.interact_cooldown.start(1)
			self.visible = false
			is_event_finished = false
			
		if event.type == 'script':
			var new_node = Node.new()
			new_node.set_script(load(event.file_path))
			$Scripts.add_child(new_node)
			#var script := load(event.file_path)
			#script.static_method_name()
			#var instance = script.new()
			#OS.execute(event.file_path,['test'])
			#OS.execute(event.file_path)
			#instance.method_name()
			
		if event.type == 'animation':
			#This used to be find_child() not sure why?
			var animation_player = self.get_parent().get_node(event.node_path)
			if not animation_player is AnimationPlayer:
				animation_player = find_descendant_animation_player(animation_player)
				
			animation_player.play(event.animation)
			
			if event.wait_until_done == 'true' or event.wait_until_done == 'True':
				await animation_player.animation_finished
				
		if event.type == 'wait':
			if float(event.time) > 0:
				$WaitTimer.start(float(event.time))
				await $WaitTimer.timeout

		if event.type == 'sound':
			var sound_source = self.get_parent().get_node(event.node_path)
			if not sound_source is AudioStreamPlayer and not sound_source is AudioStreamPlayer2D and not sound_source is AudioStreamPlayer3D and not sound_source is RandPitchAudioStream:
				sound_source = find_descendant_audio_player(sound_source)
			
			#var stream = load(event.file_path)
			#stream.set_loop(false)
			
			sound_source.stream = load(event.file_path)
			sound_source.play()
			
			if event.wait_until_done == 'true' or event.wait_until_done == 'True':
				await sound_source.finished

		if event.type == 'change_scene_to_file':
			get_tree().change_scene_to_file(event.scene)

	if loop_completed_emiter != null:
		loop_completed_emiter.emit_signal('loop_completed')



##TEXT EVENT HELPERS##
func speak(character,text):
	visible = true
	
	$'%DisplayText'.text = text
	$'%DisplayText'.visible_characters = 0
	#$'%NameLabel'.text = character.name
	
	#while display_text.visible_characters <= display_text.text.length():
	while true:
		#print("Speaking...")
		
		$'%DisplayText'.visible_characters += 1
		$'%SpeakTimer'.start(character.voice_speed * VOICE_SPEED_MULTIPLIER)
		#$'SpeakTimer'.start(1)
		
		if not $'%DisplayText'.text[$'%DisplayText'.visible_characters - 1] == " ":
			$'%Voice'.speak_voice(load(character.voice),character.voice_pitch_min,character.voice_pitch_max)
		
		#print("About to await! ",$'%SpeakTimer'.time_left)
		#$'%SpeakTimer'. += 1
		await  $'%SpeakTimer'.timeout
		#print("Done waiting.")
		
		if self.visible == false || $'%DisplayText'.visible_characters == $'%DisplayText'.text.length():
			#print("BREAK!")
			break
	
	#print("Emitting signal...")
	emit_signal("event_finished")

func string_slicer(string : String):
	var in_brackets = false
	var new_string = ""
	for s in string:
		if s == "[" and not in_brackets:
			in_brackets = true
		elif s == "]" and in_brackets:
			in_brackets = false
		elif not in_brackets:
			new_string += s
	return new_string

func load_theme(character,portrait):
	# print("char theme: ",character.theme)
	if TDData.get_var(character.theme) == null:
		printerr("ERROR: No theme found for: ",character)
		return
	
	if portrait == "":
		portrait = "Default"
		
	var theme = TDData.get_var(character.theme)
	var small_font = FontFile.new()
	#var medium_font = FontFile.new()
	#var large_font = FontFile.new()
	

	if $GuiControl.has_node("NameStretcher2"):
		$GuiControl.get_node("NameStretcher2").queue_free()
	else:
		$GuiControl.get_node("NameStretcher").queue_free()
	#$GuiControl.remove_child($'%NameStretcher')
	var new_name_stretcher = load("res://addons/teskan/scenes/dialogue/presets/NameStretcher.tscn").instantiate()
	
	$GuiControl.add_child(new_name_stretcher,true)
	
	
	#CHARACTER
	$'%DisplayText'.add_theme_color_override("default_color",character.colour)
	new_name_stretcher.get_node('NameLabel').add_theme_color_override("font_color",character.colour)
	
	
	new_name_stretcher.text = " " + character.name + " "
	new_name_stretcher.get_node('NameLabel').text = " " + character.name + " "
	if character.portraits.has("Default"):
		$'%PortraitBox'.texture = load(character.portraits[portrait])
		new_name_stretcher.position = name_stretcher_with_portrait_pos
		$'%TextAccent'.position = text_box_with_portrait_pos
		$'%TextAccent'.size = text_box_with_portrait_size
	else:
		$'%PortraitBox'.texture = null
		new_name_stretcher.position = name_stretcher_no_portrait_pos
		$'%TextAccent'.position = text_box_no_portrait_pos
		$'%TextAccent'.size = text_box_no_portrait_size
	
	#var font_path = get_file().font
	
	small_font = load(theme.font)
	#small_font.outline_color = theme.font_outline_colour
	#small_font.outline_size = theme.font_outline_size
	
	var medium_font = small_font.duplicate()
	var large_font = small_font.duplicate()
		
	small_font.fixed_size = theme.small_font
	medium_font.fixed_size = theme.medium_font
	large_font.fixed_size = theme.large_font
	
	small_font.set_embolden(0,theme.font_outline_size)
	medium_font.set_embolden(0,theme.font_outline_size)
	large_font.set_embolden(0,theme.font_outline_size)
	
	if small_font.fixed_size > 1000 or medium_font.fixed_size > 1000 or large_font.fixed_size > 1000:
		printerr("ERROR: Font to large. May crash program.")
		return
	
	new_name_stretcher.get_node('NameBackground').color = theme.name_background_colour
	new_name_stretcher.add_theme_font_override("font",medium_font)
	new_name_stretcher.get_node('NameLabel').add_theme_font_override("font",medium_font)
	$'%DisplayText'.add_theme_font_override("normal_font",medium_font)
	$'%DisplayText'.add_theme_font_override("italics_font",small_font)
	$'%DisplayText'.add_theme_font_override("bold_font",large_font)
	$'%TextAccent'.color = theme.text_accent_colour
	
	new_name_stretcher.get_node('NameLabel').add_theme_color_override("font_outline_color",theme.font_outline_colour)
	$'%DisplayText'.add_theme_color_override("font_outline_color",theme.font_outline_colour)
	
	if (theme.background) != "null":
		$'%DialogueBackground'.texture = load(theme.background)
	#$'%DialogueBackground'.scale = Vector2(0.5,0.5)
		#$'%NameLabel'
		
	#print($'%NameStretcher'.size.x)

##ANIMATION HELPERS##
func find_descendant_animation_player(node):
	for child in node.get_children():
		if child.get_child_count() > 0:
			find_descendant_animation_player(child)
		if child is AnimationPlayer:
			return child

##ANIMATION HELPERS##
func find_descendant_audio_player(node):
	for child in node.get_children():
		if child.get_child_count() > 0:
			find_descendant_audio_player(child)
		if child is AudioStreamPlayer or child is AudioStreamPlayer2D or child is AudioStreamPlayer3D or child is RandPitchAudioStream:
			return child


