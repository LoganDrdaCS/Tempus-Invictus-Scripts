extends Node2D

onready var animationPlayer1 = $AnimationPlayer

func _ready() -> void:
	BusForSignals.connect("restart_initiated", self, "_restart")

func _restart() -> void:
	animationPlayer1.play("RESET")
	animationPlayer1.play("move")
