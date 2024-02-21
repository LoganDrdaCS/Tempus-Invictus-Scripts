extends Line2D

# Speed at which the laser extends when first fired, in pixels per seconds.
export var castSpeed : float = 22000.0
# Base duration of the tween animation in seconds.
export var growthTime : float = 0.2
# Time at which the laserbeam lingers around after reaching max length:
export var lingerTime : float = 0.1

# external references
onready var fullScreenCamera = CoreFunctions.get_main_node().get_node("FullScreenCamera")
onready var player = CoreFunctions.get_player()

# internal references
onready var light = $Light2D
onready var colliderArea = $Area2D
onready var colliderTop = $Area2D/CollisionShape2DTop
onready var colliderMiddle = $Area2D/CollisionShape2DMiddle
onready var colliderBottom = $Area2D/CollisionShape2DBottom
onready var tween = $Tween

var maxLength : float
var timeToMax : float
var time : float
var enemiesAlreadyHit = []

func _ready() -> void:
	BusForSignals.connect("restart_initiated", self, "_restart")
	time = 0.0
	self.clear_points()
	self.add_point(Vector2(20, 0))
	self.add_point(Vector2(20, 0))
	maxLength = max(fullScreenCamera.levelWidth, fullScreenCamera.levelHeight) * sqrt(2.0) / 0.99
	timeToMax = maxLength / castSpeed
	appear()

func _physics_process(delta: float) -> void:
	time += delta
	self.points[1] = self.points[1] + (Vector2.RIGHT * castSpeed * delta)
	# using * 0.99 here just to have the laser visually hit the enemy first before
	# the collision occurs in the code
	colliderTop.get_shape().set_b(colliderTop.get_shape().get_b() + \
	(Vector2.RIGHT * castSpeed * delta * 0.99))
	colliderMiddle.get_shape().set_b(colliderMiddle.get_shape().get_b() + \
	(Vector2.RIGHT * castSpeed * delta * 0.99))
	colliderBottom.get_shape().set_b(colliderBottom.get_shape().get_b() + \
	(Vector2.RIGHT * castSpeed * delta * 0.99))
	
	if time > timeToMax:
		colliderArea.set_collision_layer_bit(5, false)
		colliderArea.set_collision_mask_bit(2, false)
		disappear()
		set_physics_process(false)

func appear() -> void:
	if tween.is_active():
		tween.stop_all()
	tween.interpolate_property(self, "width", 0, self.width, growthTime)
	tween.start()

func disappear() -> void:
	if tween.is_active():
		yield(tween, "tween_all_completed")
	tween.interpolate_property(self, "width", self.width, 0, growthTime / 2.0)
	# the following commented out code will make the beam linger during time pause
#	if (
#		not player.burstDurationTimer.time_left == 0.0 or \
#		not player.stasisDurationTimer.time_left == 0.0 or \
#		not fullScreenCamera.get_node("ZoomOutTimer").time_left == 0.0
#	):
#		wait_for_time()
#		yield(wait_for_time(), "completed")
	tween.start()
	yield(tween, "tween_all_completed")
	queue_free()


###############################################################################
# # # # # # # # # # # # # # # # SIGNAL FUNCTIONS # # # # # # # # # # # # # # #
###############################################################################

func _restart() -> void:
	queue_free()

func _on_Area2D_body_entered(body: Node) -> void:
	match body.get_collision_layer():
		4:
			if not (player.stasis or player.burst):
				if not enemiesAlreadyHit.has(body):
					body._hit_by_bullet_thorn()
					enemiesAlreadyHit.append(body)
			else:
				if not enemiesAlreadyHit.has(body):
					body._hit_by_bullet_thorn()
					enemiesAlreadyHit.append(body)

func _on_Area2D_area_entered(area: Area2D) -> void:
	match area.get_collision_layer():
		4:
			if not (player.stasis or player.burst):
				area._hit_by_bullet_thorn()
			else:
				area._hit_by_bullet_thorn()

func wait_for_time():
	if not player.burstDurationTimer.time_left == 0.0:
		$Timer.start(player.burstDurationTimer.time_left); yield($Timer, "timeout")
	if not player.stasisDurationTimer.time_left == 0.0:
		$Timer.start(player.stasisDurationTimer.time_left); yield($Timer, "timeout")
	if not fullScreenCamera.get_node("ZoomOutTimer").time_left == 0.0:
		$Timer.start(fullScreenCamera.get_node("ZoomOutTimer").time_left); yield($Timer, "timeout")
	if not player.burstDurationTimer.time_left == 0.0:
		$Timer.start(player.burstDurationTimer.time_left); yield($Timer, "timeout")
	if not player.stasisDurationTimer.time_left == 0.0:
		$Timer.start(player.stasisDurationTimer.time_left); yield($Timer, "timeout")
