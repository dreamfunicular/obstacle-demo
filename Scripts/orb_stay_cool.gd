extends Area2D

@onready var sprite = $AnimatedSprite2D as AnimatedSprite2D
@onready var refreshTimer = $Timer as Timer
var active: bool = true
var touching: bool = false
var player: FloridaMan

func _ready() -> void:
	sprite.play("Active")

func _on_body_entered(body: Node2D) -> void:
	if body is FloridaMan and active:
		pickup(body)
		player = body
	elif body is FloridaMan:
		touching = true

func _process(delta: float) -> void:
	if touching and active and player != null:
		pickup(player)
		touching = false

func pickup(player: FloridaMan):
	active = false
	player.Chill()
	refreshTimer.start(1.5)
	sprite.play("Break")

func refresh():
	active = true
	sprite.play("Active")

func _on_timer_timeout() -> void:
	refresh()


func _on_body_exited(body: Node2D) -> void:
	if body is FloridaMan:
		touching = false
