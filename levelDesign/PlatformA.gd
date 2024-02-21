extends StaticBody2D

export var amplitude : float =  12.0
export var frequency : float = 2.8
var time : float = 0.0
var initialPosition : Vector2
var viaPotion : bool

onready var platformPlacedSound: AudioStreamPlayer2D = $SoundEffects/PlatformPlaced

func _ready() -> void:
	BusForSignals.connect("restart_initiated", self, "_restart")
	initialPosition = self.global_position
	viaPotion = false

func _physics_process(delta):
	time += delta * frequency
	self.global_position = initialPosition + Vector2(sin(time) * amplitude / 5.0, sin(time) * amplitude)

func _instanced(instancedPosition) -> void:
	viaPotion = true
	initialPosition = instancedPosition

func _restart() -> void:
	if viaPotion:
		platformPlacedSound.stop()
		queue_free()
