extends Node2D

onready var animationPlayer1 = $LevelDesign/AnimationPlayer
onready var animationPlayer2 = $LevelDesign/AnimationPlayer2

func _ready() -> void:
	BusForSignals.connect("restart_initiated", self, "_restart")

func _restart() -> void:
	animationPlayer1.play("RESET")
	animationPlayer1.play("updown")
	animationPlayer2.play("RESET")
	animationPlayer2.play("move")
