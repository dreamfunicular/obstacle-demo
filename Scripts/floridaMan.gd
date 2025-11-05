extends RigidBody2D

const maxSpeed = 65
const acceleration = 400
var velocity : Vector2 = Vector2(0, 0)

const JUMP_VELOCITY = 380

var jumpsAvailable = 0;
var defaultJumps = 1;

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("left"):
		velocity.x -= acceleration * delta
	elif Input.is_action_pressed("right"):
		velocity.x += acceleration * delta
	else:
		velocity.x = clampf(move_toward(velocity.x, 0, delta * acceleration), -maxSpeed, maxSpeed)
			
	position.x += velocity.x * delta
