extends Area2D

var touching: bool = false
var player: FloridaMan

func _ready() -> void:
	$AnimatedSprite2D.play("default")

func _on_body_entered(body: Node2D) -> void:
	if body is FloridaMan:
		body.SetOnFire()
		player = body
		touching = true

func _process(delta: float) -> void:
	if touching and player != null:
		player.SetOnFire()

func _on_body_exited(body: Node2D) -> void:
	if body is FloridaMan:
		touching = false
