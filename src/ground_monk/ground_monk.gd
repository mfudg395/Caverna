extends KinematicBody2D

export var gravity := 835.0
export var speed := 250.0

var velocity = Vector2()
var is_facing_right := false
onready var player = get_parent().get_node("Player")

func _ready() -> void:
	$AnimationPlayer.play("idle")

func _physics_process(delta: float) -> void:
	var direction = -1 if player.position.x < position.x else 1
	is_facing_right = false if direction == -1 else true
	if $AnimationPlayer.current_animation != "attack1":
		$AnimationPlayer.play("move")
		if is_facing_right:
			self.scale.x = 1
		else:
			self.scale.x = -1
		velocity.x = speed * direction
	else:
		velocity.x = 0
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
func hit():
	$AttackDetector.monitoring = true
	
func end_of_hit():
	$AttackDetector.monitoring = false
	
#func start_walk():
#	$AnimationPlayer.play("move")

func _on_PlayerDetector_body_entered(_body):
	$AnimationPlayer.play("attack1")

func _on_AttackDetector_body_entered(_body):
	pass # Player takes damage here
