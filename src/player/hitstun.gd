extends State

# Reference to the Player that can be in this state. Needed in order to access
# their attributes (adjust velocity, set animation, etc.)
onready var player: Player
onready var state_name := "hitstun"

const HITSTUN_DURATION = 0.5
	
func enter() -> void:
	player.velocity.x = 0
	$HitstunTimer.start(HITSTUN_DURATION)
	
func physics_process(delta: float) -> void:
	player.sprite.scale.x = 1 if player.is_facing_right else -1
	
	player.velocity.y += player.gravity * delta
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

func _on_HitstunTimer_timeout() -> void:
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		state_machine.transition_to("Move")
	elif !player.is_on_floor():
		state_machine.transition_to("Fall")
	else:
		state_machine.transition_to("Idle")
