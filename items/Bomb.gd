extends Area2D


#### IMPORTANT ####
# I set the explosionCollisionShape2D shape resource to "Local To Scene" to
# avoid making changes to every single instance of the bomb at the same time
# during the _explode() function. Alternatively, you could uncheck that box
# and use the code in lines 25-27 in the _ready() to create a new shap resource
# for every instance. 
#### IMPORTANT ####

onready var player = CoreFunctions.get_player()
onready var fullScreenCamera = \
	CoreFunctions.get_main_node().get_node("FullScreenCamera")

# internal references
onready var sprite = $Sprite
onready var collisionShape2D = $CollisionShape2D
onready var animationPlayer = $AnimationPlayer
onready var explosionCollisionShape2D = $ExplosionCollisionShape2D
onready var explosionSprite = $ExplosionSprite
onready var light = $Light2D
onready var explosionSound = $SoundEffects/Explosion

export var isMeantToMove : bool = false
export var finalExplosionRadius = 275

var lerpWeight = 0.15
var explosionSpriteExtensionPastCollider = 1.05
var isCurrentlyItem : bool = true

export var amplitude := 5.0
export var frequency := 2.8
var time := 0.0
var timeItem := 0.0

onready var initialPosition = self.global_position
onready var initialLocalPosition = self.position

var enemiesAlreadyHit = []

func _ready():
	BusForSignals.connect("restart_initiated", self, "_restart")
	light.visible = false

func _physics_process(delta):
	if isCurrentlyItem:
		timeItem += delta * frequency
		if isMeantToMove:
			self.position = initialLocalPosition + Vector2(0, sin(timeItem) * amplitude)
		else:
			self.global_position = initialPosition + Vector2(0, sin(timeItem) * amplitude)
	if not isCurrentlyItem:
		time += delta
		explosionCollisionShape2D.shape.radius = \
			lerp(explosionCollisionShape2D.shape.radius, finalExplosionRadius, lerpWeight)
		explosionSprite.scale.x = lerp(explosionSprite.scale.x, \
			finalExplosionRadius / 992.0 * 2 * explosionSpriteExtensionPastCollider, lerpWeight)
		explosionSprite.scale.y = lerp(explosionSprite.scale.y, \
			finalExplosionRadius / 996.0 * 2 * explosionSpriteExtensionPastCollider, lerpWeight)
		light.texture_scale = lerp(light.texture_scale, 0.75, lerpWeight)
		if explosionCollisionShape2D.shape.radius >= finalExplosionRadius * 0.98:
			self.visible = false
			explosionCollisionShape2D.disabled = true

func _explode():
	isCurrentlyItem = false
	sprite.visible = false
	animationPlayer.stop()
	collisionShape2D.disabled = true
	self.set_collision_layer_bit(7, false)
	self.set_collision_layer_bit(5, true)
	self.set_collision_mask_bit(1, false)
	self.set_collision_mask_bit(2, true)
	explosionCollisionShape2D.shape.radius = 5
	explosionCollisionShape2D.disabled = false
	explosionSprite.scale.x = 0.03
	explosionSprite.scale.y = 0.03
	explosionSprite.visible = true
	light.texture_scale = 0.03
	light.visible = true
	set_physics_process(true)
	explosionSound.play()

func obtained_by_player() -> void:
	self.visible = false
	self.set_collision_layer_bit(7, false)
	self.set_collision_mask_bit(1, false)

#		                              *
#		                              *
###############################################################################
# # # # # # # # # # # # # # # # SIGNAL FUNCTIONS # # # # # # # # # # # # # # #
###############################################################################
#		                              *
#		                              *


func _on_Bomb_area_entered(area):
	match area.get_collision_layer():
		4:
			if not (player.stasis or player.burst):
				area._hit_by_bomb()
			else:
				var enemyArea = weakref(area)
				wait_for_time()
				yield(wait_for_time(), "completed")
				if not enemyArea.get_ref():
					pass
				else:
					area._hit_by_bullet_bomb()

func _on_Bomb_body_entered(body):
	match body.get_collision_layer():
		2:
			if isCurrentlyItem:
				BusForSignals.emit_signal("bomb_obtained")
				obtained_by_player()
		4:
			if not (player.stasis or player.burst):
				if not enemiesAlreadyHit.has(body):
					body._hit_by_bomb()
					enemiesAlreadyHit.append(body)
					#print(enemiesAlreadyHit)
			else:
				var enemyBody = weakref(body)
				wait_for_time()
				yield(wait_for_time(), "completed")
				if not enemyBody.get_ref():
					pass
				else:
					if not enemiesAlreadyHit.has(body):
						body._hit_by_bomb()
						enemiesAlreadyHit.append(body)

func _restart() -> void:
	if isCurrentlyItem:
		yield(get_tree(), "idle_frame")
		self.visible = true
		self.set_collision_layer_bit(7, true)
		self.set_collision_mask_bit(1, true)
	else:
		explosionSound.stop()
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


func _on_Explosion_finished() -> void:
	queue_free()
