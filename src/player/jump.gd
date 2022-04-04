extends State

# Reference to the Player that can be in this state. Needed in order to access
# their attributes (adjust velocity, set animation, etc.)
onready var player: Player
onready var state_name := "jump"

func enter() -> void:
	player.velocity.y = player.jump_strength
#	player.animations.play("jump")

func physics_process(delta: float) -> void:
#	player.sprite.flip_h = false if player.is_facing_right else true
	player.sprite.scale.x = 1 if player.is_facing_right else -1
	
	var direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var is_jump_halted = Input.is_action_just_released("jump") and player.velocity.y < 0.0
	
	if !player.just_wall_jumped:
		player.velocity.x = direction * player.speed
		
	if is_jump_halted:
		player.velocity.y = 0
	
	player.velocity.y += player.gravity * delta
	player.velocity = player.move_and_slide(player.velocity, Vector2.UP)
	
	if player.velocity.y > 0:
		state_machine.transition_to("Fall")
	elif Input.is_action_just_pressed("dash") and player.can_dash:
		state_machine.transition_to("Dash")
