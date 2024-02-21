# Spawns copies of the sprite that fade out
extends Sprite

const BurstTrailSprite = preload("res://scenes/player/BurstTrailSprite.tscn")

# Rate at which ghosts spawn in number per second
export var spawn_rate : float =  30
# If `true`, ghosts spawn at a rate of `spawn_rate`
export var is_emitting := false setget set_is_emitting
# Lifespan of each ghost image
export var lifetime := 0.5

onready var timer := $BurstTrailTimer

func _ready():
	establish_timer()

func set_is_emitting(value: bool) -> void:
	is_emitting = value
	if not is_inside_tree():
		yield(self, "ready")

	if is_emitting:
		_spawn_ghost()
		timer.start()
	else:
		timer.stop()

func establish_timer() -> void:
	if not timer:
		yield(self, "ready")
	timer.wait_time = 1.0 / spawn_rate

func _spawn_ghost() -> void:
	var ghost := BurstTrailSprite.instance()
	ghost.lifetime = lifetime
	ghost.scale = scale
	ghost.rotation_degrees = self.get_parent().rotation_degrees
	ghost.offset = offset
	ghost.texture = texture
	ghost.flip_h = flip_h
	ghost.flip_v = flip_v
	add_child(ghost)
	ghost.set_as_toplevel(true)
	ghost.global_position = global_position

func _on_BurstTrailTimer_timeout() -> void:
	_spawn_ghost()
