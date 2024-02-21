extends Label

onready var player = CoreFunctions.get_player()

#func _physics_process(delta: float) -> void:
#	var ammo : int = player.bulletsDefaultOwned + player.bulletsThornOwned + \
#		player.bulletsEtherealOwned #+ player.potionsPlatformOwned
#	self.text = "AMMO:" + str(ammo)

######

func _ready():
	BusForSignals.connect("bullet_thorn_obtained", self, "_add")
	BusForSignals.connect("bullet_ethereal_obtained", self, "_add")
	BusForSignals.connect("restart_initiated", self, "_restart")
	yield(CoreFunctions.get_main_node(), "ready")
#	waveMode = enemyManager.waveMode
	var ammo : int = player.bulletsDefaultOwnedInitial
	self.text = "AMMO:" + str(ammo)

func _add() -> void:
	var ammo : int = player.bulletsDefaultOwned + player.bulletsThornOwned + \
		player.bulletsEtherealOwned + 1
	self.text = "AMMO:" + str(ammo)
#	if ammo != 0:
#		player.aimRotator.visible = true

func _update() -> void:
	var ammo : int = player.bulletsDefaultOwned + player.bulletsThornOwned + \
		player.bulletsEtherealOwned
	self.text = "AMMO:" + str(ammo)
#	if ammo == 0:
#		player.aimRotator.visible = false
#	else:
#		player.aimRotator.visible = true

func _restart() -> void:
	var ammo : int = player.bulletsDefaultOwnedInitial
	self.text = "AMMO:" + str(ammo)
