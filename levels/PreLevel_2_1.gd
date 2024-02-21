extends Node2D

onready var enemyManager = $Managers/EnemyManager
onready var fullScreenCamera = $FullScreenCamera
onready var player = CoreFunctions.get_player()
onready var levelDivider = $LevelDesign/LevelDivider
onready var levelDividerBody = $LevelDesign/LevelDivider/LevelDividerBody

var enemies : int

func _ready():
	BusForSignals.connect("enemy_killed", self, "_enemy_killed")
	BusForSignals.connect("restart_initiated", self, "_restart")
	player.cameraOverridden = true
	player.toggleFullscreenOverridden = true
	enemies = enemyManager.get_child_count() - 1

func _enemy_killed():
	enemies -= 1
	if enemies == 4:
		open_up_level()

func open_up_level():
	levelDivider.visible = false
	levelDividerBody.set_collision_layer_bit(4, false)
	levelDividerBody.set_collision_mask_bit(1, false)
	levelDividerBody.set_collision_mask_bit(5, false)

func _restart() -> void:
	enemies = enemyManager.get_child_count() - 1
	levelDividerBody.set_collision_layer_bit(4, true)
	levelDividerBody.set_collision_mask_bit(1, true)
	levelDividerBody.set_collision_mask_bit(5, true)
	levelDivider.visible = true
