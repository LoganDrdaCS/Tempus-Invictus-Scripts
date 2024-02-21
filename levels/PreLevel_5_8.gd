extends Node2D

onready var player = CoreFunctions.get_player()
onready var blackLight = $LevelDesign/Light2DSubtract
onready var blackLight2 = $LevelDesign/Light2DSubtract2
onready var lightningTimer = $LevelDesign/LightningTimer
onready var lightningTimer2 = $LevelDesign/LightningTimer2

func _ready() -> void:
	BusForSignals.connect("restart_initiated", self, "_restart")
	player.get_node("Light2D").texture_scale = 1.75
	player.get_node("Light2D").energy = 1.7
	player.get_node("Camera2D").zoom = Vector2(0.75, 0.75)
	var random = RandomNumberGenerator.new()
	random.randomize()
	var lightningRandom = (random.randf_range(1.0, 3.0))
	lightningTimer.start(lightningRandom)

func _restart() -> void:
	player.get_node("Light2D").texture_scale = 1.75
	player.get_node("Light2D").energy = 1.7
	player.movementSpeed = 475

func _on_LightningTimer_timeout() -> void:
	var random = RandomNumberGenerator.new()
	random.randomize()
	var lightningRandom = (random.randf_range(0.03, 0.06))
	blackLight.visible = false
	blackLight2.visible = true
#	yield(get_tree().create_timer(lightningRandom), "timeout")
	lightningTimer2.start(lightningRandom); yield(lightningTimer2, "timeout")
	blackLight.visible = true
	blackLight2.visible = false
	lightningRandom = (random.randf_range(2.0, 4.0))
	lightningTimer.start(lightningRandom)


func _on_FastArea_body_entered(body: Node) -> void:
	player.movementSpeed = 1000


func _on_FastArea_body_exited(body: Node) -> void:
	player.movementSpeed = 475


func _on_SlowArea_body_entered(body: Node) -> void:
	player.velocity.y = 0
	player.fallGravity /= 125
	player.jumpGravity /= 125
	player.canBurst = false
	player.canStasis = false
	player.canJump = false
	player.canTether = false


func _on_SlowArea_body_exited(body: Node) -> void:
	player.velocity.y = 0
	player.fallGravity *= 125
	player.jumpGravity *= 125
	player.canBurst = true
	player.canStasis = true
	player.canJump = true
	player.canTether = true


func _on_ZoomOutArea_body_entered(body: Node) -> void:
	player.get_node("Camera2D").zoom = Vector2(1.75, 1.75)


func _on_ZoomOutArea_body_exited(body: Node) -> void:
	player.get_node("Camera2D").zoom = Vector2(0.75, 0.75)
