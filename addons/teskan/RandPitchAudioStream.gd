class_name RandPitchAudioStream extends AudioStreamPlayer2D


var last_pitch = 1.0

func random_pitch(min_pitch,max_pitch):
	randomize()
	self.pitch_scale = randf_range(min_pitch,max_pitch)
	
	while abs(self.pitch_scale - last_pitch) < .1:
		randomize()
		self.pitch_scale = randf_range(min_pitch,max_pitch)
	
	last_pitch = self.pitch_scale
