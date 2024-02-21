extends Node2D

export var active : bool = false
export var speedX : float = -100.0
export var speedY : float = 0
onready var hourglass = self.get_parent()
onready var fullScreenCamera = \
	CoreFunctions.get_main_node().get_node("FullScreenCamera")

func _ready() -> void:
	if not active:
		set_physics_process(false)
		queue_free()

func _physics_process(delta: float) -> void:
	hourglass.position.x += speedX * delta
	hourglass.position.y += speedY * delta
	hourglass.position.x = clamp(hourglass.position.x, 61, fullScreenCamera.levelWidth - 61)
	hourglass.position.y = clamp(hourglass.position.y, 107 * hourglass.scale.y, fullScreenCamera.levelHeight - (107 * hourglass.scale.y))
