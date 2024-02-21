extends StaticBodyEnemy

func die(hitBy : String):
	BusForSignals.emit_signal("enemy_killed")
	isDead = true
	self.visible = false
	self.set_collision_layer_bit(2, false)
	self.set_collision_mask_bit(5, false)
	var deathAnimation = null
	if hitBy == "BulletDefault":
		deathAnimation = deathExplosion.instance()
	elif hitBy == "Bomb" or hitBy == "BulletEthereal":
		deathAnimation = deathDusted.instance()
	if not deathAnimation == null:
		deathAnimation.process_material.set_shader_param("sprite", sprite.texture)
		deathAnimation.process_material.set_shader_param("emission_box_extents",
			Vector3(sprite.texture.get_width() / 2.0, sprite.texture.get_height() / 2.0, 1))
		if "Follow" in self.get_parent().name:
			deathAnimation.scale.x = sprite.scale.x * self.scale.x * self.get_parent().\
				get_parent().get_parent().scale.x
			deathAnimation.scale.y = sprite.scale.y * self.scale.y * self.get_parent().\
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
