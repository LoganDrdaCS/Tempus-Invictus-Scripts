extends Area2D

onready var player = CoreFunctions.get_player()

func _on_DeathWalls_body_entered(body: Node) -> void:
	if body.get_collision_layer() == 2:
		BusForSignals.emit_signal("deathwall_contacted")
		player.position = player.initialPosition
