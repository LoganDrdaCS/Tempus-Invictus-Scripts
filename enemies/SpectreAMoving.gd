extends Node2D

export var curved : bool = false
export var linear : bool = true
export var linearWaitTime : float = 0.75
export var speed : float = 150.0

# internal references
onready var curvedEnemyBody = $CurvedPath/CurvedPathFollow/SpectreA
onready var curvedFollow = $CurvedPath/CurvedPathFollow
onready var curvedPath = $CurvedPath
onready var linearEnemyBody = $LinearPath/LinearPathFollow/SpectreA
onready var linearFollow = $LinearPath/LinearPathFollow
onready var linearPath = $LinearPath
onready var linearWaitTimer = $LinearWaitTimer

var curvedDirection : int
var initialBodyScale : int
var initialOffsetCurved : float
var initialOffsetLinear : float
var initialPosition : Vector2
var linearDirection : int
var previousCurvedDirection : int
var previousOffset : float
var previousXCoordinate : float
var realBody : Node
var startingFrame : bool

###############################################################################
# # # # # # # # # # # # # # # # ROOT FUNCTIONS # # # # # # # # # # # # # # # #
###############################################################################

func _ready():
	BusForSignals.connect("restart_initiated", self, "_restart")
	initialPosition = self.global_position
	initialOffsetLinear = linearFollow.get_offset()
	initialOffsetCurved  = curvedFollow.get_offset()
	curvedDirection = 1
	linearDirection = 1
	startingFrame = true
	if linear and curved:
		realBody = linearEnemyBody
		curved = false
		curvedPath.queue_free()
		linearFollow.position = Vector2.ZERO
	elif linear:
		realBody = linearEnemyBody
		curvedPath.queue_free()
		linearFollow.position = Vector2.ZERO
	elif curved:
		realBody = curvedEnemyBody
		linearPath.queue_free()
		curvedFollow.position = Vector2.ZERO
	initialBodyScale = realBody.scale.x

func _physics_process(delta):
	if curved and not get_node("CurvedPath/CurvedPathFollow/SpectreA").isDead:
		previousXCoordinate = curvedFollow.position.x
		previousCurvedDirection = curvedDirection
		curvedFollow.set_offset(curvedFollow.get_offset() + speed * delta)
		if not startingFrame and curvedFollow.position.x - previousXCoordinate > 0:
			curvedDirection = 1
		elif not startingFrame and curvedFollow.position.x - previousXCoordinate < 0:
			curvedDirection = -1
		if not startingFrame and curvedDirection != previousCurvedDirection:
			realBody.scale.x *= -1
	elif linear and not get_node("LinearPath/LinearPathFollow/SpectreA").isDead:
		previousOffset = linearFollow.unit_offset
		if linearDirection == 1:
			if linearFollow.unit_offset == 1:
				if linearWaitTimer.is_stopped():
					linearWaitTimer.start(linearWaitTime)
				yield(linearWaitTimer, "timeout")
				linearDirection = 0
			else:
				if previousOffset == 0 and !startingFrame:
					realBody.scale.x *= -1
				linearFollow.set_offset(linearFollow.get_offset() + speed * delta)
		else:
			if linearFollow.unit_offset == 0:
				if linearWaitTimer.is_stopped():
					linearWaitTimer.start(linearWaitTime)
				yield(linearWaitTimer, "timeout")
				linearDirection = 1
			else:
				if previousOffset == 1:
					realBody.scale.x *= -1
				linearFollow.set_offset(linearFollow.get_offset() + speed * delta * -1)
	startingFrame = false

func _restart() -> void:
	linearWaitTimer.emit_signal("timeout")
	linearWaitTimer.stop()
	self.global_position = initialPosition
	curvedDirection = 1
	linearDirection = 1
	startingFrame = true
	if linear and curved:
		linearFollow.position = Vector2.ZERO
		linearFollow.set_offset(initialOffsetLinear)
	elif linear:
		linearFollow.position = Vector2.ZERO
		linearFollow.set_offset(initialOffsetLinear)
	elif curved:
		curvedFollow.position = Vector2.ZERO
		curvedFollow.set_offset(initialOffsetCurved)
	realBody.scale.x = initialBodyScale
