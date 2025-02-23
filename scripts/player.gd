extends CharacterBody2D
class_name Player

@export var move_speed = 150.0
var input: Vector2

func _physics_process(delta: float) -> void:
	input.x = Input.get_axis("left", "right")
	input.y = Input.get_axis("up", "down")
	input = input.normalized()
	
	# flip
	if input.x > 0: %Sprite.flip_h = false
	elif input.x < 0: %Sprite.flip_h = true
	
	if input:
		velocity = input * move_speed
		if %Sprite.animation != "run": %Sprite.animation = "run"
	else:
		velocity = velocity.move_toward(Vector2.ZERO, move_speed)
		if %Sprite.animation != "idle": %Sprite.animation = "idle"
		
	move_and_slide()
