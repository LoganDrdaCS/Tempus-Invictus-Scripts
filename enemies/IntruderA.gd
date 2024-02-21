extends Area2D

const deathDusted = preload("res://scenes/enemies/DeathDusted.tscn")
const deathExplosion = preload("res://scenes/enemies/DeathExplosion.tscn")

onready var parent = self.get_parent()
onready var sprite = get_node_or_null("Sprite")
onready var enemyDeathAnimationManager = \
	CoreFunctions.get_main_node().get_node("Managers").get_node("EnemyManager").get_node("EnemyDeathAnimationManager")


var order : int

func _ready() -> void:
	if "1" in self.name:
		order = 1
	elif "2" in self.name:
		order = 2
	elif "3" in self.name:
		order = 3
	elif "4" in self.name:
		order = 4
	elif "5" in self.name:
		order = 5

func _hit_by_bomb():
	parent._hit_by_bomb(order)

func _hit_by_bullet_ethereal():
	parent._hit_by_bullet_ethereal(order)

func _hit_by_bullet_thorn() -> void:
	parent._hit_by_bullet_thorn(order)

func _hit_by_bullet_default():
	parent._hit_by_bullet_default(order)

func _explode(hitBy : String) -> void:
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
