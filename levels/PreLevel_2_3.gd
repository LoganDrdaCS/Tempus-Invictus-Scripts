extends Node2D

onready var hourglassAnimationPlayer = $LevelDesign/Hourglass/AnimationPlayer
onready var player = CoreFunctions.get_player()
onready var floatBot1 = $Managers/EnemyManager/FloatBotA
onready var floatBot2 = $Managers/EnemyManager/FloatBotA2

func _ready() -> void:
	BusForSignals.connect("restart_initiated", self, "_restart")
	BusForSignals.connect("player_has_begun", self, "_player_has_begun")
	hourglassAnimationPlayer.stop()
	hourglassAnimationPlayer.play("move")

func _restart():
	hourglassAnimationPlayer.stop()
	hourglassAnimationPlayer.play("move")

func _player_has_begun():
	floatBot1.visible = false
	floatBot2.visible = false
