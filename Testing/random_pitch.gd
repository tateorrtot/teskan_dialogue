extends AudioStreamPlayer

var last_pitch = 1.0

func speak_voice(input_voice,min_pitch,max_pitch):
	self.stream = input_voice
	get_pitch(min_pitch,max_pitch)
	self.pitch_scale = last_pitch
	self.play()

func get_pitch(min_pitch,max_pitch):
	randomize()
	pitch_scale = rand_range(min_pitch,max_pitch)
	
	while abs(pitch_scale - last_pitch) < .1:
		randomize()
		pitch_scale = rand_range(min_pitch,max_pitch)
	
	last_pitch = pitch_scale

"""func play(from_position=0.0):
	
	randomize()
	pitch_scale = rand_range(0.8, 1.2)
	
	while abs(pitch_scale - last_pitch) < .1:
		randomize()
		pitch_scale = rand_range(0.8, 1.2)
	
	last_pitch = pitch_scale
	
	.play(from_position)"""
