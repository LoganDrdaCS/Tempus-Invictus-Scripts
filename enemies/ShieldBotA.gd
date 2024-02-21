extends StaticBodyEnemy

export var setHealth : int = 2
export var shieldTime : float = 0.125

var timer
var shieldSprite

func _ready() -> void:
	pass

func _on_ready():
	timer = $ShieldTimer
	shieldSprite = $ShieldSprite
	initialHealth = setHealth
	BusForSignals.connect("restart_initiated", self, "_restart")
	initialPosition = self.global_position
	health = initialHealth
	hitThisFrame = false
	isDead = false

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
		timer.start(shieldTime)
		shieldSprite.visible = true
		yield(timer, "timeout")
		hitThisFrame = false
		shieldSprite.visible = false

func _restart() -> void:
	#might not need the next line:
	timer.stop()
	isDead = false
	shieldSprite.visible = false
	
	self.global_position = initialPosition
	self.visible = true
	self.set_collision_layer_bit(2, true)
	self.set_collision_mask_bit(5, true)
	health = initialHealth
	hitThisFrame = false
