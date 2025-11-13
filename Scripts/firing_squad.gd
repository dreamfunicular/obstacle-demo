extends Area2D

var touching: bool = false
var tracking: bool = false
var player: FloridaMan
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D as AnimatedSprite2D
@onready var shootTimer: Timer = $ShootTimer as Timer
@onready var lockOnTimer: Timer = $LockOnTimer as Timer
@export var positions: Array = [Vector2(-32, 0), Vector2(32, 0)]
var currentTargetIndex: int = 0
@export var lerpWeight: float = 0.05
@export var posTolerance: float = 16

func _ready() -> void:
	StartSearching()

func _on_body_entered(body: Node2D) -> void:
	if body is FloridaMan:
		player = body
		touching = true
		StartTracking()

func _process(delta: float) -> void:
	if touching and !tracking and player != null:
		StartTracking()
	if tracking:
		anim.global_position = player.position
	else:
		if anim.position.distance_to(positions[currentTargetIndex]) > posTolerance:
			anim.position = lerp(anim.position, positions[currentTargetIndex], lerpWeight)
		else:
			if currentTargetIndex > positions.size() - 2:
				currentTargetIndex = 0
			else:
				currentTargetIndex += 1

func _on_body_exited(body: Node2D) -> void:
	if body is FloridaMan:
		touching = false
		StartSearching()

func StartTracking():
	anim.play("Aiming")
	shootTimer.start()
	lockOnTimer.start()
	tracking = true

func StartSearching():
	anim.play("Searching")
	shootTimer.stop()
	lockOnTimer.stop()
	tracking = false

func _on_shoot_timer_timeout() -> void:
	player.Die()

func _on_lock_on_timer_timeout() -> void:
	anim.play("Locked")
