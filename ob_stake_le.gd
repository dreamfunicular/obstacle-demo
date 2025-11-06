extends StaticBody2D

@onready var bulletPrefab = preload("res://bullet.tscn")

func _on_trigger_area_2d_body_entered(body: Node2D) -> void:
	SpawnBullet()

func SpawnBullet()->void:
	var bullet = bulletPrefab.instantiate()
	add_child(bullet)
