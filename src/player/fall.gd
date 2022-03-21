extends State

# Reference to the Player that can be in this state. Needed in order to access
# their attributes (adjust velocity, set animation, etc.)
onready var player: Player
# A string that's used as this state's key in the state machine's dictionary of
# states. Just used for debugging/ease-of-access purposes at the moment.
onready var state_name := "fall"

#func enter() -> void:
#	player.animations.play("fall")

func physics_process(delta: float) -> void:
#	player.sprite.flip_h = false if player.is_facing_right else true
	player.sprite.scale.x = 1 if player.is_facing_right else -1
	
	var direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	player.velocity.x = direction * player.speed
	
	player.velocity.y += player.gravity * delta
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)

	if player.is_on_floor():
		if direction == 0:
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Move")
	elif player.is_on_wall() and (Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")):
		if !(Input.is_action_pressed("move_left") and Input.is_action_pressed("move_right")):
			state_machine.transition_to("WallSlide")
	elif Input.is_action_just_pressed("dash") and player.can_dash:
		state_machine.transition_to("Dash")
