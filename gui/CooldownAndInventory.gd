extends Control

onready var player = CoreFunctions.get_player()

# internal references
onready var bombIcon = $Panel/BombIcon
onready var bulletEtherealIcon = $Panel/BulletEtherealIcon
onready var burstLabel = $Panel/BurstContainer/DurationCooldownLabel
onready var stasisLabel = $Panel/StasisContainer/DurationCooldownLabel
onready var potionPlatformIcon = $Panel/PotionPlaformIcon
onready var bulletThornIcon = $Panel/BulletThornIcon

func _ready():
	bombIcon.visible = false
	bulletEtherealIcon.visible = false
	potionPlatformIcon.visible = false
	bulletThornIcon.visible = false
	
	BusForSignals.connect("restart_initiated", self, "_restart")
	BusForSignals.connect("bomb_obtained", self, "_show_bomb")
	BusForSignals.connect("bomb_activated", self, "_bomb_check")
	BusForSignals.connect("bullet_ethereal_obtained", self, "_item_check")
	BusForSignals.connect("bullet_ethereal_activated", self, "_item_check")
	BusForSignals.connect("potion_platform_obtained", self, "_item_check")
	BusForSignals.connect("potion_platform_activated", self, "_item_check")
	BusForSignals.connect("bullet_thorn_activated", self, "_item_check")
	BusForSignals.connect("bullet_thorn_obtained", self, "_item_check")

func _physics_process(delta):
	burstLabel.text = "Duration:\n%s\nCooldown:\n%s" \
	% [str(player.burstDurationTimer.time_left).left(3), str(player.burstCooldownTimer.time_left).left(3)]
	stasisLabel.text = "Duration:\n%s\nCooldown:\n%s" \
	% [str(player.stasisDurationTimer.time_left).left(3), str(player.stasisCooldownTimer.time_left).left(3)]

func _bomb_check(bombsOwned):
	if bombsOwned > 0:
		_show_bomb()
	else:
		bombIcon.visible = false

func _show_bomb():
	bombIcon.visible = true

func _item_check() -> void:
	yield(get_tree(), "idle_frame")
	if player.itemsOwnedOrder.size() == 0:
		bulletEtherealIcon.visible = false
		potionPlatformIcon.visible = false
		bulletThornIcon.visible = false
	elif player.itemsOwnedOrder[-1] == "bulletEthereal":
		bulletEtherealIcon.visible = true
		potionPlatformIcon.visible = false
		bulletThornIcon.visible = false
	elif player.itemsOwnedOrder[-1] == "potionPlatform":
		bulletEtherealIcon.visible = false
		potionPlatformIcon.visible = true
		bulletThornIcon.visible = false
	elif player.itemsOwnedOrder[-1] == "bulletThorn":
		bulletEtherealIcon.visible = false
		potionPlatformIcon.visible = false
		bulletThornIcon.visible = true

func _restart() -> void:
	bombIcon.visible = false
	bulletEtherealIcon.visible = false
	potionPlatformIcon.visible = false
	bulletThornIcon.visible = false
