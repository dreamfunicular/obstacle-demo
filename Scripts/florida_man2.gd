extends CharacterBody2D
class_name FloridaMan

@onready var sprite = $AnimatedSprite2D as AnimatedSprite2D
@onready var anim = $AnimationPlayer as AnimationPlayer
@onready var coyoteTimer = $CoyoteTimer as Timer
@onready var chillTimer = $ChillTimer as Timer
@onready var burnTimer = $BurnTimer as Timer
@onready var respawnTimer = $RespawnIFramesTimer as Timer

@export_category("Movement Parameters")
@export var Jump_Peak_Time: float = .15
@export var Jump_Fall_Time: float = .25
@export var Jump_Height: float = 100.0
@export var Jump_Distance: float = 300.0
@export var max_speed: float = 1000.0
@export var ice_max_speed: float = 2000.0
@export_range(0.0, 1.0) var speed_smooth: float
@export_range(0.0, 1.0) var ice_speed_smooth: float
var Jump_Velocity: float = 500.0

@export var DefaultJumpLimit: int = 1
var jumps: int = 0
var wasGrounded: bool = false
@export var CoyoteTime: float = 0.1
var canCoyote: bool = false

var on_ice: bool = false
var current_speed: float = 0.0

var Jump_Gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var Fall_Gravity: float = 980.0

var SpawnPoint: Vector2 = Vector2(0, 0)

var chilly: bool = false
var burning: bool = false
var invuln: bool = false
var on_honey: bool = false
@export var honeySpeed: float = 100.0
@export var honeyVerticalSpeed: float = 1000.0

func _ready() -> void:
	Calculate_Movement_Parameters()
	SpawnPoint = position
	GameManager.connect("Reset", resetFunc)

var resetFunc = func Reset()->void:
	position = SpawnPoint
	velocity = Vector2(0, 0)
	current_speed = 0
	Extinguish()
	Unchill()
	UnHoney()

func SetSpawn(point: Vector2)->void:
	SpawnPoint = point

func Die()->void:
	if (!invuln):
		#Death sound
		GameManager.emit_signal("Reset")
		GameManager.emit_signal("ResetBullets")
		invuln = true
		respawnTimer.start()

func Chill()->void:
	Extinguish()
	chilly = true
	sprite.modulate = Color(0.75, 0.75, 1, 1)
	chillTimer.start()

func Unchill()->void:
	chilly = false
	sprite.modulate = Color(1, 1, 1, 1)
	chillTimer.stop()

func SetOnFire()->void:
	if not chilly and not burning and not invuln:
		burning = true
		burnTimer.start()
		sprite.modulate = Color(1, 0.75, 0.25, 1)

func Extinguish()->void:
	burning = false
	burnTimer.stop()
	sprite.modulate = Color(1, 1, 1, 1)

func Honey()->void:
	if !invuln:
		on_honey = true
	
func UnHoney()->void:
	on_honey = false

func Calculate_Movement_Parameters()->void:
	Jump_Gravity = (2*Jump_Height)/pow(Jump_Peak_Time,2)
	Fall_Gravity = (2*Jump_Height)/pow(Jump_Fall_Time,2)
	Jump_Velocity = Jump_Gravity * Jump_Peak_Time
	max_speed = Jump_Distance/(Jump_Peak_Time+Jump_Fall_Time)

func _physics_process(delta: float) -> void:
	var on_floor: bool = true
	# Add the gravity.
	if not is_on_floor():
		on_floor = false
		if velocity.y<0:
			velocity.y += Jump_Gravity * delta
			if on_honey:
				velocity.y = clampf(velocity.y, -honeyVerticalSpeed, honeyVerticalSpeed)
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
	var input_dir: float = Input.get_axis("left", "right")
	if input_dir != 0:
		if on_ice or chilly:
			current_speed = lerpf(current_speed, ice_max_speed * input_dir, ice_speed_smooth)
		else:
			current_speed = lerpf(current_speed, max_speed * input_dir, speed_smooth)
		if on_honey:
			current_speed = clampf(current_speed, -honeySpeed, honeySpeed)
		velocity.x = current_speed
	else:
		if on_floor:
			if on_ice or chilly:
				current_speed = lerpf(current_speed, 0, ice_speed_smooth)
			else:
				current_speed = lerpf(current_speed, 0, speed_smooth)
				if abs(current_speed) < 0.05:
					current_speed = 0
			if on_honey:
				current_speed = clampf(current_speed, -honeySpeed, honeySpeed)
			velocity.x = current_speed

	move_and_slide()
	check_is_on_ice()


func _on_coyote_timer_timeout() -> void:
	canCoyote = false

func AddVelocity(vel: Vector2, resety: bool = false, resetx: bool = false)->void:
	if resetx and vel.x != 0:
		velocity.x = 0
	if resety and vel.y != 0:
		velocity.y = 0
	velocity.x += vel.x
	velocity.y += vel.y
	if wasGrounded and jumps > 0:
		jumps -= 1
	canCoyote = false
	wasGrounded = false

func check_is_on_ice():
	on_ice = false
	for collision: int in get_slide_collision_count():
		var current_collision: KinematicCollision2D = get_slide_collision(collision)
		if current_collision.get_collider() is Ice:
			on_ice = true
			return


func _on_chill_timer_timeout() -> void:
	Unchill()


func _on_burn_timer_timeout() -> void:
	Die()
	burning = false
	sprite.modulate = Color(1, 1, 1, 1)


func _on_respawn_i_frames_timer_timeout() -> void:
	invuln = false
