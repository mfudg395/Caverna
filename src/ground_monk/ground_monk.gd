extends KinematicBody2D

export var gravity := 835.0
export var speed := 250.0

var velocity = Vector2()

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
