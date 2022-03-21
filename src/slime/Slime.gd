extends KinematicBody2D


export var gravity := 835.0
export var speed := 150.0 

onready var sprite = get_node("Sprite")
var velocity = Vector2()
var direction = -1
var on_edge = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("move")

func _physics_process(delta: float) -> void:
	$Sprite.flip_h = true if direction == 1 else false

	on_edge = (not $RayCast2DLeft.is_colliding() or not $RayCast2DRight.is_colliding()) and is_on_floor()
	if on_edge or is_on_wall():
		direction = -direction

	velocity.x = speed * direction
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func handle_slime_death():
	set_physics_process(false)
	$AnimationPlayer.play("death")

func _on_SlimeHurtbox_area_entered(area: Area2D) -> void:
	if area.name == "PlayerHitbox":
		handle_slime_death()
	
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	queue_free()
