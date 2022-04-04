extends KinematicBody2D

export var health := 15

export var gravity := 835.0
export var speed := 250.0

var velocity = Vector2()
var is_facing_right := false
onready var player = get_parent().get_node("Player")

func _ready() -> void:
	$AnimationPlayer.play("idle")

func _physics_process(delta: float) -> void:
	var direction = -1 if player.position.x < self.position.x else 1
	is_facing_right = false if direction == -1 else true
	if $AnimationPlayer.current_animation != "attack1":
		$AnimationPlayer.play("move")
		if is_facing_right:
			$Sprite.flip_h = false
			$AttackDetector.scale.x = 1
			$PlayerDetector.scale.x = 1
		else:
			$Sprite.flip_h = true
			$AttackDetector.scale.x = -1
			$PlayerDetector.scale.x = -1			
		velocity.x = speed * direction
	else:
		velocity.x = 0
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
func hit():
	$AttackDetector.monitoring = true
	
func end_of_hit():
	$AttackDetector.monitoring = false

func _on_PlayerDetector_body_entered(_body):
	$AnimationPlayer.play("attack1")

func _on_AttackDetector_body_entered(_body):
	pass # Player takes damage here

func _on_MonkHurtbox_area_entered(area):
	if area.name == "PlayerHitbox":
		health -= 1
		if health <= 0:
			set_physics_process(false)
			$AttackDetector.queue_free()
			$PlayerDetector.queue_free()
			$MonkHurtbox.queue_free()
			$AnimationPlayer.play("death")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "death":
		queue_free()
