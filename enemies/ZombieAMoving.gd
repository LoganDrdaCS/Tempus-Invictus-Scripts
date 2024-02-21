extends Node2D

export var linearWaitTime : float = 1.0
export var speed : float = 150.0

onready var animatedSprite = $LinearPath/LinearPathFollow/ZombieA/AnimatedSprite
onready var linearEnemyBody = $LinearPath/LinearPathFollow/ZombieA
onready var linearFollow = $LinearPath/LinearPathFollow
onready var linearPath = $LinearPath
onready var linearWaitTimer = $LinearWaitTimer
onready var zombie = $LinearPath/LinearPathFollow/ZombieA

var initialBodyScale : int
var initialOffsetLinear : float
var initialPosition : Vector2
var originalDirection = 1
var previousOffset : float
var previousXCoordinate : float
var startingFrame : bool = true

###############################################################################
# # # # # # # # # # # # # # # # ROOT FUNCTIONS # # # # # # # # # # # # # # # #
###############################################################################

func _ready():
	BusForSignals.connect("restart_initiated", self, "_restart")
	initialPosition = self.global_position
	initialOffsetLinear = linearFollow.get_offset()
	originalDirection = 1
	startingFrame = true
	linearFollow.position = Vector2.ZERO
	animatedSprite.play("saunter")
	initialBodyScale = linearEnemyBody.scale.x

func _physics_process(delta):
	if not get_node("LinearPath/LinearPathFollow/ZombieA").isDead:
		previousOffset = linearFollow.unit_offset
		if originalDirection == 1:
			if linearFollow.unit_offset == 1:
				animatedSprite.play("idle")
				if linearWaitTimer.is_stopped():
					linearWaitTimer.start(linearWaitTime)
				yield(linearWaitTimer, "timeout")
				animatedSprite.play("saunter")
				originalDirection = 0
			else:
				if previousOffset == 0 and !startingFrame:
					linearEnemyBody.scale.x *= -1
				linearFollow.set_offset(linearFollow.get_offset() + speed * delta)
		else:
			if linearFollow.unit_offset == 0:
				animatedSprite.play("idle")
				if linearWaitTimer.is_stopped():
					linearWaitTimer.start(linearWaitTime)
				yield(linearWaitTimer, "timeout")
				animatedSprite.play("saunter")
				originalDirection = 1
			else:
				if previousOffset == 1:
					linearEnemyBody.scale.x *= -1
				linearFollow.set_offset(linearFollow.get_offset() + speed * delta * -1)
	startingFrame = false

func _restart() -> void:
	linearWaitTimer.emit_signal("timeout")
	linearWaitTimer.stop()
	self.global_position = initialPosition
	originalDirection = 1
	startingFrame = true
	linearFollow.position = Vector2.ZERO
	linearFollow.set_offset(initialOffsetLinear)
	linearEnemyBody.scale.x = initialBodyScale
