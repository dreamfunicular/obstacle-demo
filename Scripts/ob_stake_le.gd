extends StaticBody2D
class_name ObStakeLe

@onready var bulletPrefab = preload("res://bullet.tscn")
@export var bulletVelocity: Vector2 = Vector2(-500, 0)
@onready var timer = $Timer as Timer
var canShoot = true
@export var cooldown: float = 1.0

func _on_trigger_area_2d_body_entered(body: Node2D) -> void:
	if canShoot and body is FloridaMan:
		SpawnBullet()
		canShoot = false
		timer.start(cooldown)

func SpawnBullet()->void:
	var bullet = bulletPrefab.instantiate()
	add_child(bullet)
	bullet.vel = bulletVelocity


func _on_timer_timeout() -> void:
	canShoot = true
