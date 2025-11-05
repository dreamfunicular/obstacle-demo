extends CharacterBody2D
class_name FloridaMan

@onready var sprite = $AnimatedSprite2D as AnimatedSprite2D
@onready var anim = $AnimationPlayer as AnimationPlayer
@onready var coyoteTimer = $CoyoteTimer as Timer

@export_category("Movement Parameters")
@export var Jump_Peak_Time: float = .15
@export var Jump_Fall_Time: float = .25
@export var Jump_Height: float = 100.0
@export var Jump_Distance: float = 300.0
var Speed: float = 10000.0
var Jump_Velocity: float = 500.0

@export var DefaultJumpLimit: int = 1
var jumps: int = 0
var wasGrounded: bool = false
@export var CoyoteTime: float = 0.1
var canCoyote: bool = false

var Jump_Gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var Fall_Gravity: float = 980.0

var SpawnPoint: Vector2 = Vector2(0, 0)

func _ready() -> void:
	Calculate_Movement_Parameters()
	SpawnPoint = position
	GameManager.connect("Reset", resetFunc)

var resetFunc = func Reset()->void:
	position = SpawnPoint

func SetSpawn(point: Vector2)->void:
	SpawnPoint = point

func Die()->void:
	#Death sound
	GameManager.emit_signal("Reset")

func Calculate_Movement_Parameters()->void:
	Jump_Gravity = (2*Jump_Height)/pow(Jump_Peak_Time,2)
	Fall_Gravity = (2*Jump_Height)/pow(Jump_Fall_Time,2)
	Jump_Velocity = Jump_Gravity * Jump_Peak_Time
	Speed = Jump_Distance/(Jump_Peak_Time+Jump_Fall_Time)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if velocity.y<0:
			velocity.y += Jump_Gravity * delta
		else:
			velocity.y += Fall_Gravity * delta
		if wasGrounded and jumps > 0:
			canCoyote = true
			jumps -= 1
			coyoteTimer.start(CoyoteTime)
		wasGrounded = false

	if is_on_floor():
		jumps = DefaultJumpLimit
		wasGrounded = true
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and (jumps > 0 or canCoyote):
		if velocity.y > 0:
			velocity.y = 0
		velocity.y -= Jump_Velocity
		if jumps > 0:
			jumps -= 1
		canCoyote = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_axis("left", "right")
	if input_dir != 0:
		velocity.x = input_dir * Speed
	else:
		velocity.x = move_toward(velocity.x, 0, Speed)

	move_and_slide()


func _on_coyote_timer_timeout() -> void:
	canCoyote = false
