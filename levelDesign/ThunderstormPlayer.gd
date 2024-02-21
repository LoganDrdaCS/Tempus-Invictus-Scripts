extends AudioStreamPlayer

onready var player = CoreFunctions.get_player()

export var reduceVolumeTo : float = -3.0
export var originalVolume : float = -1.0

func _process(delta: float) -> void:
	if player.burst or player.stasis:
		self.volume_db = reduceVolumeTo
	else:
		self.volume_db = originalVolume
