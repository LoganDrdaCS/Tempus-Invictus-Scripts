extends KinematicBody2D

export var amplitude : float =  12.0
export var frequency : float = 1.8
export var speed : float = 100.0
export var direction : int = 1

var time : float = 0.0
var initialPosition : Vector2
var velocity : Vector2
var onWall : bool = false
var initialRotation
var initialDirection

onready var player = CoreFunctions.get_player()
onready var sprite = $Sprite
onready var collisionPolygon = $CollisionPolygon2D

func _ready() -> void:
	BusForSignals.connect("restart_initiated", self, "_restart")
	BusForSignals.connect("hourglass_contacted", self, "_hourglass_contacted")
	BusForSignals.connect("player_has_paused", self, "_player_paused")
	BusForSignals.connect("player_has_unpaused", self, "_player_unpaused")
	initialPosition = self.global_position
	initialRotation = sprite.rotation_degrees
	initialDirection = direction

func _physics_process(delta):
	time += delta * frequency
	if sin(time) > 0:
		velocity.y = sin(time) * amplitude * 50 / 1.2
	else:
		velocity.y = sin(time) * amplitude * 50
	if not onWall:
		velocity.x = speed * direction
	else:
		velocity.x = 0.0

	self.global_position.x += velocity.x * delta
	self.global_position.y = initialPosition.y + (velocity.y * delta)
	sprite.rotation_degrees = 2.3 + sin(time / 2.0) * 1.8
	collisionPolygon.rotation_degrees = sprite.rotation_degrees

func _restart() -> void:
	time = 0.0
	self.position = initialPosition
	sprite.rotation_degrees = initialRotation
	collisionPolygon.rotation_degrees = sprite.rotation_degrees
	onWall = false
	direction = initialDirection
	self.set_physics_process(true)

func _on_WallDetector_body_entered(body: Node) -> void:
	if not body.name == "GroundFloor":
		onWall = true
		direction = -direction
		onWall = false

func _hourglass_contacted():
	self.set_physics_process(false)

func _player_paused() -> void:
	self.set_physics_process(false)

func _player_unpaused() -> void:
	self.set_physics_process(true)
