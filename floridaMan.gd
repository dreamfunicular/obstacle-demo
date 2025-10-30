extends RigidBody2D

const maxSpeed = 65
const acceleration = 40
var velocity : Vector2 = Vector2(0, 0)

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("left"):
		velocity.x -= acceleration * delta
	elif Input.is_action_pressed("right"):
		velocity.x += acceleration * delta
	else:
		velocity.x = move_toward(velocity.x, 0, delta * acceleration)
			
	position.x += velocity.x * delta
