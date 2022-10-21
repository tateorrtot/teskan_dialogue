extends KinematicBody2D
signal interact_button_pressed()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var can_move = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if can_move:
		self.move_and_slide(Vector2.RIGHT * 300)

func _input(event):
	if Input.is_key_pressed(KEY_D):
		can_move = true
	else:
		can_move = false
		
	if Input.is_key_pressed(KEY_E):
		get_tree().get_current_scene().get_node('DialogueUI').play_timeline('No Name')
		emit_signal("interact_button_pressed")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
