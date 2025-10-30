extends CharacterBody2D

@onready var sprite = $Sprite2D as Sprite2D
@onready var anim = $AnimationPlayer as AnimationPlayer

@export_category("Movement Parameters")
@export var Jump_Peak_Time: float = .15
@export var Jump_Fall_Time: float = .25
@export var Jump_Height: float = 100.0
@export var Jump_Distance: float = 300.0
var Speed: float = 10000.0
var Jump_Velocity: float = 500.0

var Jump_Gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var Fall_Gravity: float = 980.0

func _ready() -> void:
	Calculate_Movement_Parameters()

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

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y -= Jump_Velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_axis("left", "right")
	if input_dir != 0:
		velocity.x = input_dir * Speed
	else:
		velocity.x = move_toward(velocity.x, 0, Speed)

	move_and_slide()
