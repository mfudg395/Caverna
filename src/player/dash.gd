extends State

# Reference to the Player that can be in this state. Needed in order to access
# their attributes (adjust velocity, set animation, etc.)
onready var player: Player
onready var state_name := "dash"

const DASH_SPEED = 750.0
const DASH_DURATION := 0.25
const DASH_COOLDOWN := 0.3
	
func enter() -> void:
#	player.animations.play("move")
	if player.is_on_wall():
		player.velocity.x = DASH_SPEED if Input.is_action_pressed("move_left") else -DASH_SPEED
	else:
		player.velocity.x = DASH_SPEED if player.is_facing_right else -DASH_SPEED
	player.velocity.y = 0
	player.can_dash = false
	get_node("../../DashDurationTimer").start(DASH_DURATION)

func exit() -> void:
	pass

func handle_input() -> void:
	pass

func physics_process(delta: float) -> void:
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	if player.is_on_wall():
		state_machine.transition_to("WallSlide")
	
func _on_DashDurationTimer_timeout() -> void:
	get_node("../../DashCooldownTimer").start(DASH_COOLDOWN)
	if !player.is_on_floor():
		state_machine.transition_to("Fall")
	elif !player.is_on_wall():
		state_machine.transition_to("Idle")

func _on_DashCooldownTimer_timeout() -> void:
	player.can_dash = true
