extends Node2D

var time
var amplitude = 150
var frequency = 1.8
var velocity
var initialPosition
var tideRisePosition
export var tideRiseRate : float = 0.1

func _ready() -> void:
	BusForSignals.connect("restart_initiated", self, "_restart")
	BusForSignals.connect("player_has_paused", self, "_player_paused")
	BusForSignals.connect("player_has_unpaused", self, "_player_unpaused")
	time = 0.0
	velocity = Vector2.ZERO
	initialPosition = self.global_position
	tideRisePosition = initialPosition
	if tideRiseRate == 0:
		self.set_physics_process(false)

func _physics_process(delta: float) -> void:
	time += delta * frequency
	if sin(time) > 0:
		velocity.y = sin(time) * amplitude / 1.4
	else:
		velocity.y = sin(time) * amplitude / 1.2
	velocity.x = sin(time) * amplitude
#	self.global_position.x += velocity.x * delta
#	self.global_position.y += velocity.y * delta * 5
	self.global_position.x = tideRisePosition.x + (velocity.x * delta)
	self.global_position.y = tideRisePosition.y + (velocity.y * delta * 5)
	tideRisePosition.y -= tideRiseRate

func _restart():
	self.global_position = initialPosition
	tideRisePosition = initialPosition

func _player_paused() -> void:
	self.set_physics_process(false)

func _player_unpaused() -> void:
	self.set_physics_process(true)
