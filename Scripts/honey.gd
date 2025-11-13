extends Area2D

var touching: bool = false
var player: FloridaMan
@export var sprite: String = "default"

func _ready() -> void:
	$AnimatedSprite2D.play(sprite)

func _on_body_entered(body: Node2D) -> void:
	if body is FloridaMan:
		player = body
		player.Honey()
		touching = true

func _process(delta: float) -> void:
	if touching and player != null:
		player.Honey()

func _on_body_exited(body: Node2D) -> void:
	if body is FloridaMan:
		touching = false
		player.UnHoney()
