extends Area2D

@onready var sprite = $AnimatedSprite2D as AnimatedSprite2D
@onready var refreshTimer = $Timer as Timer
var active: bool = true

func _on_body_entered(body: Node2D) -> void:
	if body is FloridaMan and active:
		pickup(body)

func pickup(player: FloridaMan):
	active = false
	player.jumps += 1
	refreshTimer.start(1.5)
	sprite.play("Break")

func refresh():
	active = true
	sprite.play("Active")

func _on_timer_timeout() -> void:
	refresh()
