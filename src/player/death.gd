extends State

# Reference to the Player that can be in this state. Needed in order to access
# their attributes (adjust velocity, set animation, etc.)
onready var player: Player
onready var state_name := "death"


func enter() -> void:
	player.velocity.x = 0
	player.animations.play("death")
	
func physics_process(delta):
	player.velocity.y += player.gravity * delta
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
