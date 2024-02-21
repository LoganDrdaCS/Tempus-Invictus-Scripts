extends Sprite

var lifetime := 0.5

onready var tween := $Tween

func _ready() -> void:
	BusForSignals.connect("restart_initiated", self, "_restart")
	fade()

func fade(duration := lifetime) -> void:
	var transparent := self_modulate
	transparent.a = 0.0
	tween.interpolate_property(self, "self_modulate", self_modulate, transparent, duration)
	tween.start()
	yield(tween, "tween_all_completed")
	queue_free()

func _restart() -> void:
	queue_free()
