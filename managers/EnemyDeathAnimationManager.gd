extends Node2D

func _ready() -> void:
	BusForSignals.connect("restart_initiated", self, "_restart")

func _restart():
	if self.get_child_count() > 0:
		for child in self.get_children():
			child.visible = false
			child.queue_free()
