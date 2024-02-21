extends StaticBody2D

class_name StaticBodyEnemy

const deathDusted = preload("res://scenes/enemies/DeathDusted.tscn")
const deathExplosion = preload("res://scenes/enemies/DeathExplosion.tscn")
var initialHealth : int = 1
var health : int
var hitThisFrame : bool
var initialPosition : Vector2
var isDead : bool

onready var sprite = get_node_or_null("Sprite")
onready var enemyDeathAnimationManager = \
	CoreFunctions.get_main_node().get_node("Managers").get_node("EnemyManager").get_node("EnemyDeathAnimationManager")

func _ready() -> void:
	_on_ready()

func _on_ready() -> void:
	BusForSignals.connect("restart_initiated", self, "_restart")
	initialPosition = self.global_position
	health = initialHealth
	hitThisFrame = false
	isDead = false

func _hit_by_bomb():
	if not hitThisFrame:
		health -= 100
		hitThisFrame = true
		health_check("Bomb")

func _hit_by_bullet_ethereal():
	if not hitThisFrame:
		PositionalSFXManager._hit_marker(self.global_position)
		health -= 1
		hitThisFrame = true
		health_check("BulletEthereal")

func _hit_by_bullet_thorn() -> void:
	if not hitThisFrame:
		health -= 1
		hitThisFrame = true
		health_check("BulletThorn")

func _hit_by_bullet_default():
	if not hitThisFrame:
		PositionalSFXManager._hit_marker(self.global_position)
		health -= 1
		hitThisFrame = true
		health_check("BulletDefault")

func health_check(hitBy : String):
	if health <= 0:
		if hitBy == "BulletDefault":
			die("BulletDefault")
		elif hitBy == "BulletThorn":
			die("BulletThorn")
		elif hitBy == "Bomb":
			die("Bomb")
		elif hitBy == "BulletEthereal":
			die("BulletEthereal")
		else:
			print("THERE IS NO DEATH ANIMATION FOR THIS PROJECTILE")
	else:
		hitThisFrame = false

func die(hitBy : String):
	BusForSignals.emit_signal("enemy_killed")
	isDead = true
	self.visible = false
	self.set_collision_layer_bit(2, false)
	self.set_collision_mask_bit(5, false)
	var deathAnimation = null
	if hitBy == "BulletDefault" or hitBy == "BulletThorn":
		deathAnimation = deathExplosion.instance()
	elif hitBy == "Bomb" or hitBy == "BulletEthereal":
		deathAnimation = deathDusted.instance()
	if not deathAnimation == null:
		deathAnimation.process_material.set_shader_param("sprite", sprite.texture)
		deathAnimation.process_material.set_shader_param("emission_box_extents",
			Vector3(sprite.texture.get_width() / 2.0, sprite.texture.get_height() / 2.0, 1))
		if self.scale.x < 0:
			deathAnimation.scale.x = -sprite.scale.x
		else:
			deathAnimation.scale.x = sprite.scale.x
		deathAnimation.scale.y = sprite.scale.y
		if not abs(self.scale.x) == 1:
			deathAnimation.scale.x *= abs(self.scale.x)
		if not abs(self.scale.y) == 1:
			deathAnimation.scale.y *= abs(self.scale.y)
		deathAnimation.global_position = self.global_position
		enemyDeathAnimationManager.add_child(deathAnimation)

func _restart() -> void:
	isDead = false
	self.global_position = initialPosition
	self.visible = true
	self.set_collision_layer_bit(2, true)
	self.set_collision_mask_bit(5, true)
	health = initialHealth
	hitThisFrame = false
