extends State

# Reference to the Player that can be in this state. Needed in order to access
# their attributes (adjust velocity, set animation, etc.)
onready var player: Player
onready var state_name := "death"


func enter() -> void:
	player.animations.play("death")
	
func physics_process(delta):
	pass
