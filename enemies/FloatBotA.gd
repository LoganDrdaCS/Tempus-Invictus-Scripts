extends StaticBodyEnemy

export var invisibleTime : float = 0.79
export var visibleTime : float = 0.47
export var transitionTime : float = 0.4

var invisibleDurationTimer
var visibleDurationTimer
var tween

func _ready() -> void:
	pass

func _on_ready():
	invisibleDurationTimer = $InvisibleDurationTimer
	visibleDurationTimer = $VisibleDurationTimer
	tween = $Tween
	BusForSignals.connect("restart_initiated", self, "_restart")
	initialPosition = self.global_position
	health = initialHealth
	hitThisFrame = false
	isDead = false
	visibleDurationTimer.start(visibleTime)
	self.visible = true

func _restart() -> void:
	isDead = false
	self.global_position = initialPosition
	self.visible = true
	self.set_collision_layer_bit(2, true)
	self.set_collision_mask_bit(5, true)
	health = initialHealth
	hitThisFrame = false
	visibleDurationTimer.stop()
	invisibleDurationTimer.stop()
	tween.stop_all()
	self.modulate = Color(1, 1, 1, 1)
	visibleDurationTimer.start(visibleTime)

func appear():
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), transitionTime, Tween.TRANS_CIRC)
	tween.start()

func disappear():
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), transitionTime, Tween.TRANS_CIRC)
	tween.start()

func _on_InvisibleDurationTimer_timeout() -> void:
	if not isDead:
		self.visible = true
		appear()
		visibleDurationTimer.stop()
		visibleDurationTimer.start(visibleTime + transitionTime)

func _on_VisibleDurationTimer_timeout() -> void:
	if not isDead:
		self.visible = true
		disappear()
		invisibleDurationTimer.stop()
		invisibleDurationTimer.start(invisibleTime + transitionTime)
