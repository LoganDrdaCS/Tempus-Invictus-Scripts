extends Node2D

#const deathDusted = preload("res://scenes/enemies/DeathDusted.tscn")
#const deathExplosion = preload("res://scenes/enemies/DeathExplosion.tscn")

#onready var sprite = get_child(0).get_node_or_null("Sprite")
#onready var enemyDeathAnimationManager = \
#	CoreFunctions.get_main_node().get_node("Managers").get_node("EnemyManager").get_node("EnemyDeathAnimationManager")

export var initialHealth : int = 1
export var switchTime : float = 0.5
var health : int
var hitThisFrame : bool
var initialPosition : Vector2
var isDead : bool

# internal references
onready var sub1 = $IntruderSub1
onready var sub1sprite = $IntruderSub1/AnimatedSprite
onready var sub2 = $IntruderSub2
onready var sub2sprite = $IntruderSub2/AnimatedSprite
onready var sub3 = $IntruderSub3
onready var sub3sprite = $IntruderSub3/AnimatedSprite
onready var sub4 = $IntruderSub4
onready var sub4sprite = $IntruderSub4/AnimatedSprite
onready var sub5 = $IntruderSub5
onready var sub5sprite = $IntruderSub5/AnimatedSprite
onready var timer = $SwitchTimer

var switch : int
var switchRemainder : int
var firstTimeAtSwitch1 : bool
var firstTimeAtSwitch2 : bool
var transitionComplete : bool

func _ready():
	BusForSignals.connect("restart_initiated", self, "_restart")
	switch = 1
	timer.wait_time = switchTime
	timer.start()
	firstTimeAtSwitch1 = true
	firstTimeAtSwitch2 = true
	isDead = false
	initialPosition = self.global_position
	health = initialHealth
	hitThisFrame = false
	transitionComplete = false
	sub1.set_collision_layer_bit(2, true)
	sub1.set_collision_mask_bit(5, true)
	sub2.set_collision_layer_bit(2, false)
	sub2.set_collision_mask_bit(5, false)
	sub3.set_collision_layer_bit(2, false)
	sub3.set_collision_mask_bit(5, false)
	sub4.set_collision_layer_bit(2, false)
	sub4.set_collision_mask_bit(5, false)
	sub5.set_collision_layer_bit(2, false)
	sub5.set_collision_mask_bit(5, false)

func _physics_process(delta: float) -> void:
	if not transitionComplete:
		switchRemainder = switch % int(5)
		match switchRemainder:
			1:
				if not firstTimeAtSwitch1:
					sub3sprite.play("empty")
					sub4sprite.play("fading")
					sub5sprite.play("silhouette")
					sub1sprite.play("full")
					sub1.set_collision_layer_bit(2, true)
					sub1.set_collision_mask_bit(5, true)
					sub5.set_collision_layer_bit(2, false)
					sub5.set_collision_mask_bit(5, false)
				else:
					sub1sprite.play("full")
					sub2sprite.play("empty")
					sub3sprite.play("empty")
					sub4sprite.play("empty")
					sub5sprite.play("empty")

			2:
				if not firstTimeAtSwitch2:
					sub4sprite.play("empty")
					sub5sprite.play("fading")
					sub1sprite.play("silhouette")
					sub2sprite.play("full")
				else:
					sub3sprite.play("empty")
					sub4sprite.play("empty")
					sub5sprite.play("empty")
					sub1sprite.play("silhouette")
					sub2sprite.play("full")
					firstTimeAtSwitch2 = false
				sub2.set_collision_layer_bit(2, true)
				sub2.set_collision_mask_bit(5, true)
				sub1.set_collision_layer_bit(2, false)
				sub1.set_collision_mask_bit(5, false)


			3:
				sub5sprite.play("empty")
				sub1sprite.play("fading")
				sub2sprite.play("silhouette")
				sub3sprite.play("full")
				sub3.set_collision_layer_bit(2, true)
				sub3.set_collision_mask_bit(5, true)
				sub2.set_collision_layer_bit(2, false)
				sub2.set_collision_mask_bit(5, false)


			4:
				sub1sprite.play("empty")
				sub2sprite.play("fading")
				sub3sprite.play("silhouette")
				sub4sprite.play("full")
				sub4.set_collision_layer_bit(2, true)
				sub4.set_collision_mask_bit(5, true)
				sub3.set_collision_layer_bit(2, false)
				sub3.set_collision_mask_bit(5, false)

			0:
				sub2sprite.play("empty")
				sub3sprite.play("fading")
				sub4sprite.play("silhouette")
				sub5sprite.play("full")
				sub5.set_collision_layer_bit(2, true)
				sub5.set_collision_mask_bit(5, true)
				sub4.set_collision_layer_bit(2, false)
				sub4.set_collision_mask_bit(5, false)
	transitionComplete = true


func _hit_by_bomb(order):
	if not hitThisFrame:
		health -= 2
		hitThisFrame = true
		health_check("Bomb", order)

func _hit_by_bullet_ethereal(order):
	if not hitThisFrame:
		PositionalSFXManager._hit_marker(self.global_position)
		health -= 1
		hitThisFrame = true
		health_check("BulletEthereal", order)

func _hit_by_bullet_thorn(order) -> void:
	if not hitThisFrame:
		PositionalSFXManager._hit_marker(self.global_position)
		health -= 1
		hitThisFrame = true
		health_check("BulletThorn", order)

func _hit_by_bullet_default(order):
	if not hitThisFrame:
		PositionalSFXManager._hit_marker(self.global_position)
		health -= 1
		hitThisFrame = true
		health_check("BulletDefault", order)

func health_check(hitBy : String, order : int):
#	if health <= 0:
#		die(order)
#	else:
#		hitThisFrame = false
	if health <= 0:
		if hitBy == "BulletDefault":
			die("BulletDefault", order)
		elif hitBy == "BulletThorn":
			die("BulletThorn", order)
		elif hitBy == "Bomb":
			die("Bomb", order)
		elif hitBy == "BulletEthereal":
			die("BulletEthereal", order)
		else:
			print("THERE IS NO DEATH ANIMATION FOR THIS PROJECTILE")
	else:
		hitThisFrame = false

func die(hitBy : String, order : int):
	BusForSignals.emit_signal("enemy_killed")
	isDead = true
	self.visible = false
	sub1.set_collision_layer_bit(2, false)
	sub1.set_collision_mask_bit(5, false)
	sub2.set_collision_layer_bit(2, false)
	sub2.set_collision_mask_bit(5, false)
	sub3.set_collision_layer_bit(2, false)
	sub3.set_collision_mask_bit(5, false)
	sub4.set_collision_layer_bit(2, false)
	sub4.set_collision_mask_bit(5, false)
	sub5.set_collision_layer_bit(2, false)
	sub5.set_collision_mask_bit(5, false)
	get_child(order - 1)._explode(hitBy)

func _restart() -> void:
	switch = 1
	isDead = false
	firstTimeAtSwitch1 = true
	firstTimeAtSwitch2 = true
	self.global_position = initialPosition
	health = initialHealth
	hitThisFrame = false
	transitionComplete = false
	sub1.set_collision_layer_bit(2, true)
	sub1.set_collision_mask_bit(5, true)
	sub2.set_collision_layer_bit(2, false)
	sub2.set_collision_mask_bit(5, false)
	sub3.set_collision_layer_bit(2, false)
	sub3.set_collision_mask_bit(5, false)
	sub4.set_collision_layer_bit(2, false)
	sub4.set_collision_mask_bit(5, false)
	sub5.set_collision_layer_bit(2, false)
	sub5.set_collision_mask_bit(5, false)
	sub1sprite.play("full")
	sub2sprite.play("empty")
	sub3sprite.play("empty")
	sub4sprite.play("empty")
	sub5sprite.play("empty")
	self.visible = true
	timer.start()

func _on_SwitchTimer_timeout() -> void:
	switch += 1
	firstTimeAtSwitch1 = false
	transitionComplete = false
