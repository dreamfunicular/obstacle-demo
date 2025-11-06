extends Area2D
class_name Bullet

@export var vel: Vector2 = Vector2(-100, 0)

func _ready() -> void:
	GameManager.connect("ResetBullets", resetFunc)

func  _physics_process(delta: float) -> void:
	position += vel * delta

var resetFunc = func ResetExplode()->void:
	Explode()

func Explode():
	queue_free()

func _on_timer_timeout() -> void:
	Explode()


func _on_body_entered(body: Node2D) -> void:
	if body is FloridaMan:
		body.Die()
	if body is not ObStakeLe:
		Explode()
