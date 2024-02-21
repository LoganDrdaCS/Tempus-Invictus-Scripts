extends Area2D

export var isMeantToMove : bool = false
export var amplitude : float =  4.3
export var frequency : float = 2.3
var time : float = 0.0

onready var initialPosition = self.global_position
onready var initialLocalPosition = self.position

func _ready() -> void:
	BusForSignals.connect("restart_initiated", self, "_restart")

func _physics_process(delta):
	time += delta * frequency
	if isMeantToMove:
		self.position = initialLocalPosition + Vector2(sin(time) * amplitude / 5.0, sin(time) * amplitude)
	else:
		self.global_position = initialPosition + Vector2(sin(time) * amplitude / 5.0, sin(time) * amplitude)

func obtained_by_player() -> void:
	self.visible = false
	self.set_collision_layer_bit(7, false)
	self.set_collision_mask_bit(1, false)

func _restart() -> void:
	yield(get_tree(), "idle_frame")
	self.visible = true
	self.set_collision_layer_bit(7, true)
	self.set_collision_mask_bit(1, true)

func _on_PotionPlatform_body_entered(body: Node) -> void:
	match body.get_collision_layer():
		2:
			BusForSignals.emit_signal("potion_platform_obtained")
			obtained_by_player()
