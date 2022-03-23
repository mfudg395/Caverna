extends KinematicBody2D

export var gravity := 835.0
export var speed := 300.0

var velocity = Vector2()
var is_facing_right := false
onready var player = get_parent().get_node("Player")

func _ready() -> void:
	$AnimationPlayer.play("idle")

func _physics_process(delta: float) -> void:
	if is_facing_right:
		$Sprite.set_flip_h(false)
	else:
		$Sprite.set_flip_h(true)
	
	if velocity.x != 0:
		$AnimationPlayer.play("move")
	
	var direction = -1 if player.position.x < position.x else 1
	is_facing_right = false if direction == -1 else true
	velocity.x = speed * direction
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
