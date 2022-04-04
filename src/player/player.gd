class_name Player
extends KinematicBody2D

const INVULNERABLE_TIME = 3

export var gravity := 835.0
export var speed := 250.0 
export var jump_strength := -635.0
export var wall_slide_gravity := 635.0

onready var animations = get_node("AnimationPlayer")
onready var sprite = get_node("Sprite")
onready var state_machine = get_node("PlayerFSM")

var velocity = Vector2()
var is_facing_right := true
var just_wall_jumped := false
var can_dash := true
var is_attacking := false
var max_health = 2
var current_health = max_health

onready var attackSounds = [
	$AttackSound1,
	$AttackSound2,
	$AttackSound3,
	$AttackSound4,
	$AttackSound5,
	$AttackSound6
]

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine.init(self)

# Called every frame. 'delta' is the elapsed time since the prDevious frame.
func _process(delta: float) -> void:
	state_machine._process(delta)
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("attack") and state_machine.current_state != state_machine.states["death"]:
		animations.play("attack")
		is_attacking = true
		attackSounds[rng.randi_range(0, 5)].play()
	
	if Input.is_action_pressed("move_right"):
		is_facing_right = true
	elif Input.is_action_pressed("move_left"):
		is_facing_right = false
	
	if state_machine.current_state != state_machine.states["death"]:
		state_machine._physics_process(delta)

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "attack":
		is_attacking = false
		animations.stop()

func _on_PlayerHurtbox_area_entered(area):
	if area.is_in_group("Enemy"):
		if area.is_in_group("Slime"):
			current_health -= 0.7
		else:
			current_health -= 1
		get_parent().find_node("UI").find_node("Healthbar").frame -= 1
		if current_health <= 0:
			state_machine.transition_to("Death")
		else:
			state_machine.transition_to("Hitstun")
