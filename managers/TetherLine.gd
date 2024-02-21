extends Line2D

onready var player = CoreFunctions.get_player()
var playerAttachmentPoint : Vector2
var tetherAttachmentPoint : Vector2
var playerRadiusMinusSmallAmount : float = 44
var tetherRadiusMinusSmallAmount : float = 35
var zeroPointsSet : bool

func _ready():
	BusForSignals.connect("restart_initiated", self, "_restart")
	BusForSignals.connect("hourglass_contacted", self, "_hourglass_contacted")
	self.set_width(2.5)
	yield(CoreFunctions.get_main_node(), "ready")
	self.set_default_color(player.get_node("Sprite").modulate)
	clear_points()
	add_point(Vector2.ZERO)
	add_point(Vector2.ZERO)

func _process(delta):
	if player.tetherSet == true:
		playerAttachmentPoint = ((player.tetherPosition1 - player.global_position).normalized()) * playerRadiusMinusSmallAmount
		tetherAttachmentPoint = ((player.global_position - player.tetherPosition1).normalized()) * tetherRadiusMinusSmallAmount
		set_point_position(0, player.tetherPosition1 + tetherAttachmentPoint)
		set_point_position(1, player.global_position + playerAttachmentPoint)
	else:
		set_point_position(0, Vector2.ZERO)
		set_point_position(1, Vector2.ZERO)
		
func _delete_line():
	clear_points()
	set_physics_process(false)

# FOR THIS TO WORK, YOU NEED TO CHANGE player.tetherSet = false in the player _restart()
func _restart() -> void:
	self.set_width(2.5)
	yield(get_tree(), "idle_frame")
	self.set_default_color(player.get_node("Sprite").modulate)
	clear_points()
	add_point(Vector2.ZERO)
	add_point(Vector2.ZERO)
	self.visible = true
	set_physics_process(true)

func _hourglass_contacted():
	self.visible = false
