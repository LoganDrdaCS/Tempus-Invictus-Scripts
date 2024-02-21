extends Control

var enemies : int
var waveMode : bool = false
onready var enemyManager = CoreFunctions.get_main_node().get_node("Managers").get_node("EnemyManager")
#onready var waveManager = CoreFunctions.get_main_node().get_node("WaveManager")

# internal references
onready var counterLabel = $CounterLabel

func _ready():
	BusForSignals.connect("enemy_killed", self, "_enemy_killed")
	BusForSignals.connect("restart_initiated", self, "_restart")
	yield(CoreFunctions.get_main_node(), "ready")
#	waveMode = enemyManager.waveMode
	enemies = enemyManager.get_child_count() - 1
	counterLabel.text = str(enemies)

func _enemy_killed():
	enemies -= 1
	if enemies > 0:
		counterLabel.text = str(enemies)
	elif enemies <= 0:
		if waveMode:
#			if waveManager.waveCount == waveManager.totalWaves:
#				BusForSignals.emit_signal("all_enemies_killed")
#				counterLabel.text = str(0)
#			else:
#				BusForSignals.emit_signal("next_wave")
#				yield(get_tree(), "idle_frame")
#				_update()
			pass
		else:
			BusForSignals.emit_signal("all_enemies_killed")
			counterLabel.text = str(0)

func _update() -> void:
	enemies = enemyManager.get_child_count() - 1
	counterLabel.text= str(enemies)

func _restart() -> void:
	enemies = enemyManager.get_child_count() - 1
	counterLabel.text= str(enemies)
