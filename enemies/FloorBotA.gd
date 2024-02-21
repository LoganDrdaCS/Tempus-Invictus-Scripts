extends StaticBodyEnemy

export var setHealth : int = 2

func _ready() -> void:
	pass

func _on_ready():
	initialHealth = setHealth
	BusForSignals.connect("restart_initiated", self, "_restart")
	initialPosition = self.global_position
	health = initialHealth
	hitThisFrame = false
	isDead = false
