extends Particles2D

func _ready() -> void:
	BusForSignals.connect("restart_initiated", self, "_restart")
	emitting = true

func _physics_process(delta: float) -> void:
	if !emitting:
		queue_free()

func _restart():
	self.visible = false
	queue_free()
