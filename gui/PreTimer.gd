extends Label

var time : float

func _ready() -> void:
	BusForSignals.connect("player_has_begun", self, "_player_has_begun")
	BusForSignals.connect("restart_initiated", self, "_restart")
	time = 0.0
	self.text = "Pre-Timer: 0:00:000"

func _physics_process(delta: float) -> void:
	time += delta
	var ms = int(round(fmod(time, 1) * 1000))
	var seconds = fmod(time, 60)
	var minutes = fmod(time, 3600) / 60
	var strElapsed = "%01d:%02d:%03d" % [minutes, seconds, ms]
	self.text = "Pre-Timer: " + strElapsed

func _player_has_begun():
	self.set_physics_process(false)
	
func _restart():
	time = 0.0
	self.text = "Pre-Timer: 0:00:000"
	self.set_physics_process(true)
