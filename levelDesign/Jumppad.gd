extends Area2D

onready var player = CoreFunctions.get_player()

export var jumpForce : float = 4000

func _ready() -> void:
	pass

func _on_Jumppad_body_entered(body: Node) -> void:
	if body.get_collision_layer() == 2:
		player._jumppad(jumpForce)
