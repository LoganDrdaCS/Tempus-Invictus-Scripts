extends Area2D

onready var hourglassMovementManager = $HourglassMovementManager
onready var animationPlayer = $AnimationPlayer
onready var sfxPlayer = $AudioStreamPlayer
var initialPosition : Vector2

func _ready() -> void:
	BusForSignals.connect("restart_initiated", self, "_restart")
	self.pause_mode = Node.PAUSE_MODE_PROCESS
	initialPosition = self.position

func _on_Hourglass_body_entered(body: Node) -> void:
	if body.get_collision_layer() == 2:
		sfxPlayer.play()
		BusForSignals.emit_signal("hourglass_contacted")
		self.visible = false
		self.set_collision_layer_bit(12, false)
		self.set_collision_mask_bit(1, false)

func _restart() -> void:
	sfxPlayer.stop()
	position = initialPosition
	self.pause_mode = Node.PAUSE_MODE_PROCESS
	yield(get_tree(), "idle_frame")
	self.visible = true
	self.set_collision_layer_bit(12, true)
	self.set_collision_mask_bit(1, true)
