extends StaticBodyEnemy

export var setHealth : int = 2

var killZone

func _ready() -> void:
	pass

func _on_ready():
	killZone = $Killzone
	sprite = $AnimatedSprite
	initialHealth = setHealth
	BusForSignals.connect("restart_initiated", self, "_restart")
	isDead = false
	initialPosition = self.global_position
	health = initialHealth
	hitThisFrame = false

func die(hitBy : String):
	BusForSignals.emit_signal("enemy_killed")
	isDead = true
	self.visible = false
	self.set_collision_layer_bit(2, false)
	self.set_collision_mask_bit(5, false)
	killZone.set_collision_mask_bit(1, false)
	var deathAnimation = null
	if hitBy == "BulletDefault" or hitBy == "BulletThorn":
		deathAnimation = deathExplosion.instance()
	elif hitBy == "Bomb" or hitBy == "BulletEthereal":
		deathAnimation = deathDusted.instance()
	if not deathAnimation == null:
		deathAnimation.process_material.set_shader_param("sprite", sprite.get_sprite_frames().\
			get_frame(sprite.animation, sprite.get_frame()))
		deathAnimation.process_material.set_shader_param("emission_box_extents",
			Vector3(sprite.get_sprite_frames().get_frame(sprite.animation, sprite.get_frame()).\
				get_width() / 2.0, sprite.get_sprite_frames().get_frame(sprite.animation, \
					sprite.get_frame()).get_height() / 2.0, 1))
		if "Follow" in self.get_parent().name:
			deathAnimation.scale.x = self.scale.x * sprite.scale.x * self.get_parent().\
				get_parent().get_parent().scale.x
			deathAnimation.scale.y = self.scale.y * sprite.scale.y * self.get_parent().\
				get_parent().get_parent().scale.y
		else:
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
	killZone.set_collision_mask_bit(1, true)
	health = initialHealth
	hitThisFrame = false

func _on_Killzone_body_entered(body: Node) -> void:
	if body.get_collision_layer() == 2:
		BusForSignals.emit_signal("restart_initiated")
