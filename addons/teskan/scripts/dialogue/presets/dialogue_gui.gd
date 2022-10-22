extends CanvasLayer
signal event_finished()
#signal loop_finished()

export var VOICE_SPEED_MULTIPLIER = 0.05

onready var player = self.get_node('../%Player')

#onready var display_text = self.get_node("%DisplayText")
#onready var name_label = self.get_node("%NameLabel")
#onready var portrait_box = self.get_node("%PortraitBox")
#onready var voice = self.get_node("%Voice")
#onready var timer = self.get_node("%Timer")

var is_event_finished = false

func play_timeline(timeline_name):
	if self.visible == true and is_event_finished == false:
		skip_event()
		return
	elif self.visible == true and is_event_finished == true:
		return
	
	var dir = Directory.new()
	dir.open("res://teskan_data/dialogue/timelines/")
	
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir():
			var loaded_timeline = TDData.get_var("res://teskan_data/dialogue/timelines/"+file_name)
			if loaded_timeline.name == timeline_name:
				play_timeline_helper(loaded_timeline.events)
		file_name = dir.get_next()
		
func skip_event():
	#SKIP TEXT EVENT
	#print("Skipping")
	$'%DisplayText'.visible_characters = $'%DisplayText'.text.length()
	
#func exit_timeline():


func play_timeline_helper(events, loop_completed_emiter : Node = null):
	for event in events:
	#	print(event.type)
		is_event_finished = false
		if event.type == 'text':
			#print("im about to play")
			var character = TDData.get_var(event.character_path)
			
			load_theme(character,event.portrait)
			speak(character,event.text)
			
			yield(self,"event_finished")
			yield(player,"interact_button_pressed")
		
		if event.type == 'choice':
			$ChoiceMenu.rect_size = Vector2(300,50)
			$ChoiceMenu.rect_position = Vector2(1200,800)
			
			for child in $ChoiceMenu.get_children():
				child.queue_free()
			
			for child in event.children:
				$ChoiceMenu.rect_position.y -= 54
				var new_child = (load('res://addons/teskan/scenes/dialogue/presets/OptionButton.tscn').instance())
				new_child.text = child.prompt
				new_child.set_meta('id',str(child.id)) # (str(child.id))
				$ChoiceMenu.add_child(new_child)
			
			$ChoiceMenu.visible = true
			
			yield($ChoiceMenu,"option_button_pressed")
			$ChoiceMenu.visible = false
			for child in event.children:
				#print($ChoiceMenu.get('id'))
				#print(child.id)
				if child.id == $ChoiceMenu.get('selected_id') and child.children:
					#print("playing timeline")
					print(child.children)
					var new_loop_completed_emiter = load('res://addons/teskan/scenes/dialogue/presets/LoopCompleteEmiter.tscn').instance()
					self.add_child(new_loop_completed_emiter)
					play_timeline_helper(child.children,new_loop_completed_emiter)
					#print(new_loop_completed_emiter.get_signal_list())
					yield(new_loop_completed_emiter,'loop_completed')
					#print("loop completed")
		"""if event.type == 'if':
			print(event.parameter_1,event.operator,event.parameter_2)
			var parameter_1_ex = Expression.new()
			var operator_ex = Expression.new()
			var parameter_2_ex = Expression.new()
			
			print(parameter_1_ex.execute(event.parameter_1))		"""
		
		if event.type == 'exit':
			#ITERATE TO NEXT EVENT
			#allow player to move
			#print("exiting timeline!")
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
			


	if loop_completed_emiter != null:
		loop_completed_emiter.emit_signal('loop_completed')

##TEXT EVENTS##
func speak(character,text):
	self.visible = true
	
	$'%DisplayText'.bbcode_text = text
	$'%DisplayText'.visible_characters = 0
	#$'%NameLabel'.text = character.name
	
	#while display_text.visible_characters <= display_text.text.length():
	while true:
		$'%DisplayText'.visible_characters += 1
		$'%Timer'.start(character.voice_speed * VOICE_SPEED_MULTIPLIER)
		$'%Voice'.speak_voice(load(character.voice),character.voice_pitch_min,character.voice_pitch_max)
		
		yield($'%Timer', "timeout")
		
		if self.visible == false || $'%DisplayText'.visible_characters == $'%DisplayText'.text.length():
			break
	
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
	var theme = TDData.get_var(character.theme)
	var small_font = DynamicFont.new()
	#var medium_font = DynamicFont.new()
	#var large_font = DynamicFont.new()
	
	#CHARACTER
	$'%DisplayText'.add_color_override("default_color",character.colour)
	$'%NameLabel'.add_color_override("font_color",character.colour)

	$'%NameStretcher'.text = " " + character.name + " "
	$'%NameLabel'.text = " " + character.name + " "
	if character.portraits['Default']:
		$'%PortraitBox'.texture = load(character.portraits[portrait])

		#$'%'
	
	#var font_path = get_file().font
	
	small_font.font_data = load(theme.font)
	small_font.outline_color = theme.font_outline_colour
	small_font.outline_size = theme.font_outline_size
	
	var medium_font = small_font.duplicate()
	var large_font = small_font.duplicate()
		
	small_font.size = theme.small_font
	medium_font.size = theme.medium_font
	large_font.size = theme.large_font

	
	if small_font.size > 1000 or medium_font.size > 1000 or large_font.size > 1000:
		print("ERROR: Font to large. May crash program.")
		return
	
	$'%NameStretcher'.add_font_override("font",medium_font)
	$'%NameLabel'.add_font_override("font",medium_font)
	$'%DisplayText'.add_font_override("normal_font",medium_font)
	$'%DisplayText'.add_font_override("italics_font",small_font)
	$'%DisplayText'.add_font_override("bold_font",large_font)
	$'%TextAccent'.color = theme.text_accent_colour
	$'%DialogueBackground'.texture = load(theme.background)
	#$'%DialogueBackground'.rect_scale = Vector2(0.5,0.5)
		#$'%NameLabel'

