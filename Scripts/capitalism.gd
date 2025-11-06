extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is FloridaMan:
		pickup(body)

func pickup(player: FloridaMan):
	queue_free()
