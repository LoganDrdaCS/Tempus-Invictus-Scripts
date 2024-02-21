extends Camera2D

export var fullScreenFromStart : bool = false

export var screensWide : int = 1
export var screensTall : int = 1

onready var levelWidth : int = 1920 * screensWide
onready var levelHeight : int = 1080 * screensTall
onready var screenRatio : float = screensWide / screensTall
onready var zoomNecessary = max(screensWide, screensTall)
onready var startZoom : Vector2 = Vector2(1, 1)
onready var endZoom : Vector2 = Vector2(zoomNecessary, zoomNecessary)
onready var durationOfZoomOut : float = 2.5

onready var player := CoreFunctions.get_player()

# internal references
onready var zoomTween = $ZoomTween
onready var zoomOutTimer = $ZoomOutTimer

func _ready():
	BusForSignals.connect("restart_initiated", self, "_restart")
	zoomTween.connect("tween_all_completed", self, "_zoom_completed")
	if fullScreenFromStart:
		self.current = true
		_instant_zoom()
	zoomTween.interpolate_property(self, "zoom", startZoom, endZoom, \
		durationOfZoomOut, zoomTween.TRANS_CIRC, zoomTween.EASE_OUT)
	if screensTall == screensWide:
		equal()
	elif screensTall == 1 and screensWide == 2:
		oneTwo()
	elif screensTall == 2 and screensWide == 1:
		twoOne()
	elif screensTall == 1 and screensWide == 3:
		oneThree()
	elif screensTall == 3 and screensWide == 1:
		threeOne()
	else:
		print("FullScreenCamera script doesn't have a case for this screen setup.")
	yield(CoreFunctions.get_main_node(), "ready")
	if fullScreenFromStart:
		player.cameraOverridden = true

func _begin_zoom() -> void:
	if not zoomNecessary == 1:
		zoomTween.start()
		zoomOutTimer.start(durationOfZoomOut)
		self.reset_smoothing()
	else:
		# zoom not necessary
		pass
	
func _instant_zoom() -> void:
	self.current = true
	self.zoom.x = zoomNecessary
	self.zoom.y = zoomNecessary

func _zoom_completed() -> void:
	self.zoom = endZoom

func _restart() -> void:
	zoomOutTimer.stop()
	player.pauseForCameraAdjustment = false
	zoomOutTimer.emit_signal("timeout")
	zoomTween.queue_free()
	self.zoom = startZoom
	player.camera.current = true
	yield(get_tree(), "idle_frame")
	zoomTween = Tween.new()
	zoomTween.name = "ZoomTween"
	self.add_child(zoomTween)
	if fullScreenFromStart:
		self.current = true
		_instant_zoom()
	zoomTween.interpolate_property(self, "zoom", startZoom, endZoom, \
		durationOfZoomOut, zoomTween.TRANS_CIRC, zoomTween.EASE_OUT)
	if screensTall == screensWide:
		equal()
	elif screensTall == 1 and screensWide == 2:
		oneTwo()
	elif screensTall == 2 and screensWide == 1:
		twoOne()
	elif screensTall == 1 and screensWide == 3:
		oneThree()
	elif screensTall == 3 and screensWide == 1:
		threeOne()
	else:
		print("FullScreenCamera script doesn't have a case for this screen setup.")

func equal() -> void:
	self.limit_left = 0
	self.limit_top = 0
	self.limit_right = levelWidth
	self.limit_bottom = levelHeight

func oneTwo() -> void:
	self.limit_left = 0
	self.limit_top = -540
	self.limit_right = levelWidth
	self.limit_bottom = 1620

func twoOne() -> void:
	self.limit_left = -960
	self.limit_top = 0
	self.limit_right = 2880
	self.limit_bottom = levelHeight

func oneThree() -> void:
	self.limit_left = 0
	self.limit_top = -1080
	self.limit_right = levelWidth
	self.limit_bottom = 2160

func threeOne() -> void:
	self.limit_left = -1920
	self.limit_top = 0
	self.limit_right = 3840
	self.limit_bottom = levelHeight
