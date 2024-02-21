extends Area2D

var velocityVector : Vector2 = Vector2.ZERO

export var isMeantToMove : bool = false
export var amplitude := 6.0
export var frequency := 2.5
var timeItem := 0.0

onready var player = CoreFunctions.get_player()
onready var fullScreenCamera = \
	CoreFunctions.get_main_node().get_node("FullScreenCamera")

# internal references
onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite

onready var initialPosition = self.global_position
onready var initialLocalPosition = self.position

export var speed : float = 1350.0
const deleteAfterPixels : int = 1500
var isCurrentlyItem : bool = true

var enemiesAlreadyHit = []
var hourglassContacted : bool = false
var waitForHourglass : bool = false
var waitForCamera : bool = false
var hitBody = null
var hitArea = null

###############################################################################
# # # # # # # # # # # # # # # # ROOT FUNCTIONS # # # # # # # # # # # # # # # #
###############################################################################

func _ready():
	BusForSignals.connect("restart_initiated", self, "_restart")
	BusForSignals.connect("hourglass_contacted", self, "_hourglass_contacted")
	fullScreenCamera.get_node("ZoomOutTimer").connect("timeout", self, "_zoom_out_timer_finished")

func _physics_process(delta):
	if isCurrentlyItem:
		timeItem += delta * frequency
		if isMeantToMove:
			self.position = initialLocalPosition + Vector2(0, sin(timeItem) * amplitude)
		else:
			self.global_position = initialPosition + Vector2(0, sin(timeItem) * amplitude)
	if not isCurrentlyItem:
		sprite.is_emitting = true
		self.position += transform.x * speed * delta
		if self.global_position.x < -deleteAfterPixels or self.global_position.x \
		> fullScreenCamera.levelWidth + deleteAfterPixels:
			queue_free()
		elif self.global_position.y < -deleteAfterPixels or self.global_position.y \
		> fullScreenCamera.levelHeight + deleteAfterPixels:
			queue_free()

func obtained_by_player() -> void:
	self.visible = false
	self.set_collision_layer_bit(7, false)
	self.set_collision_mask_bit(1, false)

func _instanced():
	isCurrentlyItem = false
	animationPlayer.stop()
	self.set_collision_layer_bit(7, false)
	self.set_collision_layer_bit(5, true)
	self.set_collision_mask_bit(1, false)
	self.set_collision_mask_bit(2, true)
	set_physics_process(true)

###############################################################################
# # # # # # # # # # # # # # # # SIGNAL FUNCTIONS # # # # # # # # # # # # # # #
###############################################################################

func _on_BulletEthereal_area_entered(area):
	match area.get_collision_layer():
		4:
			if not (player.stasis or player.burst) and player.mode == "Flow":
				if not enemiesAlreadyHit.has(area):
					enemiesAlreadyHit.append(area)
					area._hit_by_bullet_ethereal()
			elif player.mode == "Flow":
				if not enemiesAlreadyHit.has(area):
					enemiesAlreadyHit.append(area)
					var enemyBody = weakref(area)
					wait_for_time()
					yield(wait_for_time(), "completed")
					if not enemyBody.get_ref():
						pass
					else:
						area._hit_by_bullet_ethereal()
			elif player.mode == "Freeze" and not hourglassContacted:
				if not enemiesAlreadyHit.has(area):
					enemiesAlreadyHit.append(area)
					waitForHourglass = true
					hitArea = area
			else:
				if not enemiesAlreadyHit.has(area):
					enemiesAlreadyHit.append(area)
					area._hit_by_bullet_ethereal()

func _on_BulletEthereal_body_entered(body):
	match body.get_collision_layer():
		2:
			if isCurrentlyItem:
				BusForSignals.emit_signal("bullet_ethereal_obtained")
				obtained_by_player()
		4:
			if not (player.stasis or player.burst) and not player.mode == "Freeze":
				if not enemiesAlreadyHit.has(body):
					enemiesAlreadyHit.append(body)
					body._hit_by_bullet_ethereal()
			elif player.mode == "Flow":
				if not enemiesAlreadyHit.has(body):
					enemiesAlreadyHit.append(body)
					var enemyBody = weakref(body)
					wait_for_time()
					yield(wait_for_time(), "completed")
					if not enemyBody.get_ref():
						pass
					else:
						body._hit_by_bullet_ethereal()

			elif player.mode == "Freeze" and not hourglassContacted:
				if not enemiesAlreadyHit.has(body):
					enemiesAlreadyHit.append(body)
					waitForHourglass = true
					hitBody = body
			else:
				if not enemiesAlreadyHit.has(body):
					enemiesAlreadyHit.append(body)
					body._hit_by_bullet_ethereal()
		256:
			pass
		1024:
			pass

func _hourglass_contacted() -> void:
	hourglassContacted = true
	if waitForHourglass:
		if not fullScreenCamera.zoomOutTimer.is_stopped():
			waitForCamera = true
		else:
			if hitBody:
				hitBody._hit_by_bullet_ethereal()
			if hitArea:
				hitArea._hit_by_bullet_ethereal()

func _zoom_out_timer_finished():
	if waitForCamera:
		if hitBody:
			hitBody._hit_by_bullet_ethereal()
		if hitArea:
			hitArea._hit_by_bullet_ethereal()

func _restart() -> void:
	if isCurrentlyItem:
		yield(get_tree(), "idle_frame")
		self.visible = true
		self.set_collision_layer_bit(7, true)
		self.set_collision_mask_bit(1, true)
	else:
		queue_free()

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
