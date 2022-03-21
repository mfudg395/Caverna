extends State

# Reference to the Player that can be in this state. Needed in order to access
# their attributes (adjust velocity, set animation, etc.)
onready var player: Player
# A string that's used as this state's key in the state machine's dictionary of
# states. Just used for debugging/ease-of-access purposes at the moment.
onready var state_name := "wall_slide"

const WALL_SLIDE_GRAVITY_COEFFICIENT = 0.9
const WALL_JUMP_COOLDOWN = 0.3

#func enter() -> void:
#	player.animations.play("wall_slide")

func physics_process(delta: float) -> void:
#	player.sprite.flip_h = false if player.is_facing_right else true
	player.sprite.scale.x = 1 if player.is_facing_right else -1
	
	var direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	if !player.just_wall_jumped:
		player.velocity.x = direction * player.speed
	
	player.velocity.y += player.gravity * delta
	player.velocity.y *= WALL_SLIDE_GRAVITY_COEFFICIENT
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	if direction == 0:
		state_machine.transition_to("Fall")
	
	if player.is_on_floor():
		if direction == 0:
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Move")
	if !player.is_on_wall():
		state_machine.transition_to("Fall")
	
	if Input.is_action_just_pressed("jump"):
		get_node("../../WallJumpTimer").start(WALL_JUMP_COOLDOWN)
		player.just_wall_jumped = true
		if Input.is_action_pressed("move_right") and !Input.is_action_pressed("move_left"):
			player.velocity.x = -player.speed
			state_machine.transition_to("Jump")
		elif Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right"):
			player.velocity.x = player.speed
			state_machine.transition_to("Jump")
		return

	elif Input.is_action_just_pressed("dash") and player.can_dash:
		state_machine.transition_to("Dash")

func _on_WallJumpTimer_timeout() -> void:
	player.just_wall_jumped = false
