extends Area2D

var velocityVector : Vector2 = Vector2.ZERO

onready var player = CoreFunctions.get_player()
onready var fullScreenCamera = \
	CoreFunctions.get_main_node().get_node("FullScreenCamera")

onready var sprite = $Sprite

export var speed : float = 900.0
var bounceCount = 0
const deleteAfterPixels : int = 1500
const bounceCountMax = 3

var enemiesAlreadyHit = []
var hourglassContacted : bool = false
var waitForHourglass : bool = false
var waitForCamera : bool = false
var bulletTeleporterCount : int
var hitBody = null
var hitArea = null

###############################################################################
# # # # # # # # # # # # # # # # ROOT FUNCTIONS # # # # # # # # # # # # # # # #
###############################################################################

func _ready():
	BusForSignals.connect("restart_initiated", self, "_restart")
	BusForSignals.connect("hourglass_contacted", self, "_hourglass_contacted")
	fullScreenCamera.get_node("ZoomOutTimer").connect("timeout", self, "_zoom_out_timer_finished")
	bulletTeleporterCount = 0
	sprite.is_emitting = true

func _physics_process(delta):
	self.position += transform.x * speed * delta
	if self.global_position.x < -deleteAfterPixels or self.global_position.x \
	> fullScreenCamera.levelWidth + deleteAfterPixels:
		queue_free()
	elif self.global_position.y < -deleteAfterPixels or self.global_position.y \
	> fullScreenCamera.levelHeight + deleteAfterPixels:
		queue_free()

###############################################################################
# # # # # # # # # # # # # # # # SIGNAL FUNCTIONS # # # # # # # # # # # # # # #
###############################################################################

func _on_BulletDefault_area_entered(area):
	var destroy : bool = true
	match area.get_collision_layer():
		0:
			if area.name in ["BulletTeleporter", "BulletTeleporter1", "BulletTeleporter2", "BulletTeleporter3"]:
				destroy = false
				if bulletTeleporterCount >= 2:
					destroy = true
				bulletTeleporterCount += 1
		4:
			if not (player.stasis or player.burst) and player.mode == "Flow":
				if enemiesAlreadyHit.size() == 0:
					enemiesAlreadyHit.append(area)
					area._hit_by_bullet_default()
					destroy = true
			elif player.mode == "Flow":
				destroy = false
				if enemiesAlreadyHit.size() == 0:
					enemiesAlreadyHit.append(area)
					var enemyBody = weakref(area)
					wait_for_time()
					yield(wait_for_time(), "completed")
					if not enemyBody.get_ref():
						pass
					else:
						area._hit_by_bullet_default()
						destroy = true
						queue_free()
			elif player.mode == "Freeze" and not hourglassContacted:
				destroy = false
				if enemiesAlreadyHit.size() == 0:
					enemiesAlreadyHit.append(area)
					waitForHourglass = true
					hitArea = area
			else:
				if enemiesAlreadyHit.size() == 0:
					enemiesAlreadyHit.append(area)
					area._hit_by_bullet_default()
					destroy = true
		8:
			if area.get_collision_mask_bit(5) == true:
				queue_free()
		16:
			destroy = true
		256:
			#print("hit mirror area")
			if bounceCount < bounceCountMax:
				bounceCount += 1
				var mirrorRadians = deg2rad(area.get_parent().rotation_degrees - 90.0)
				var mirrorNormalizedVector = Vector2(cos(mirrorRadians), sin(mirrorRadians))
				self.transform.x = (self.transform.x.bounce(mirrorNormalizedVector))
				destroy = false
			else:
				destroy = false
		264:
			#print("hit mirror/platform area")
			if bounceCount < bounceCountMax:
				bounceCount += 1
				var mirrorRadians = deg2rad(area.get_parent().rotation_degrees - 90.0)
				var mirrorNormalizedVector = Vector2(cos(mirrorRadians), sin(mirrorRadians))
				self.transform.x = (self.transform.x.bounce(mirrorNormalizedVector))
				destroy = false
			else:
				destroy = false
		1024:
			destroy = true
		2048:
			destroy = true
	if destroy:
		queue_free()

func _on_BulletDefault_body_entered(body):
	var destroy : bool = true
	match body.get_collision_layer():
		4:
			if not (player.stasis or player.burst) and not player.mode == "Freeze":
				if enemiesAlreadyHit.size() == 0:
					enemiesAlreadyHit.append(body)
					body._hit_by_bullet_default()
					destroy = true
			elif player.mode == "Flow":
				destroy = false
				if enemiesAlreadyHit.size() == 0:
					enemiesAlreadyHit.append(body)
					var enemyBody = weakref(body)
					wait_for_time()
					yield(wait_for_time(), "completed")
					if not enemyBody.get_ref():
						pass
					else:
						body._hit_by_bullet_default()
						destroy = true
						queue_free()
			elif player.mode == "Freeze" and not hourglassContacted:
				destroy = false
				if enemiesAlreadyHit.size() == 0:
					enemiesAlreadyHit.append(body)
#					var enemyBody = weakref(body)
					waitForHourglass = true
					hitBody = body
			else:
				if enemiesAlreadyHit.size() == 0:
					enemiesAlreadyHit.append(body)
					body._hit_by_bullet_default()
					destroy = true
		8:
			if body.get_collision_mask_bit(5) == true:
				queue_free()
		16:
			destroy = true
		256:
			#print("hit mirror body")
			if bounceCount < bounceCountMax:
				bounceCount += 1
				var mirrorRadians = deg2rad(body.get_parent().rotation_degrees - 90.0)
				var mirrorNormalizedVector = Vector2(cos(mirrorRadians), sin(mirrorRadians))
				self.transform.x = (self.transform.x.bounce(mirrorNormalizedVector))
				destroy = false
			else:
				destroy = false
		264:
			#print("hit mirror/platform body")
			if bounceCount < bounceCountMax:
				bounceCount += 1
				var mirrorRadians = deg2rad(body.get_parent().rotation_degrees - 90.0)
				var mirrorNormalizedVector = Vector2(cos(mirrorRadians), sin(mirrorRadians))
				self.transform.x = (self.transform.x.bounce(mirrorNormalizedVector))
				destroy = false
			else:
				destroy = false
		1024:
			destroy = true
		2048:
			destroy = true
	if destroy:
		queue_free()

func _hourglass_contacted() -> void:
	hourglassContacted = true
	if waitForHourglass:
		if not fullScreenCamera.zoomOutTimer.is_stopped():
			waitForCamera = true
		else:
			if hitBody:
				hitBody._hit_by_bullet_default()
			if hitArea:
				hitArea._hit_by_bullet_default()
			queue_free()

func _zoom_out_timer_finished():
	if waitForCamera:
		if hitBody:
			hitBody._hit_by_bullet_default()
		if hitArea:
			hitArea._hit_by_bullet_default()
		queue_free()

func _restart() -> void:
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
