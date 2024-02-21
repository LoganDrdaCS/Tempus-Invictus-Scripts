extends Node

# STILL NEEDS A LOOKTHROUGH

var num_players = 10
var bus = "SFX"

var available = []  # The available players.
var queue = []  # The queue of sounds to play.

var soundDictionary = {
	"Hitmarker1" : "res://audio/effects/custom_hit_marker1.wav",
	"Hitmarker2" : "res://audio/effects/custom_hit_marker2.wav",
	"Hitmarker3" : "res://audio/effects/custom_hit_marker3.wav",
	"Hitmarker4" : "res://audio/effects/custom_hit_marker4.wav",
	"Hitmarker5" : "res://audio/effects/custom_hit_marker5.wav",
	"Hitmarker6" : "res://audio/effects/custom_hit_marker6.wav",
	"Hitmarker7" : "res://audio/effects/custom_hit_marker7.wav"
}

func _ready():
	BusForSignals.connect("restart_initiated", self, "_restart")
	# Create the pool of AudioStreamPlayer nodes.
	for i in num_players:
		var p = AudioStreamPlayer2D.new()
		add_child(p)
		available.append(p)
		p.connect("finished", self, "_on_stream_finished", [p])
		p.bus = bus
		p.max_distance = 4000
		p.volume_db = -5.0

func _hit_marker(position):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var num = rng.randi_range(1, soundDictionary.size())
	var soundToPlay
	match num:
		1:
			soundToPlay = "Hitmarker1"
		2:
			soundToPlay = "Hitmarker2"
		3:
			soundToPlay = "Hitmarker3"
		4:
			soundToPlay = "Hitmarker4"
		5:
			soundToPlay = "Hitmarker5"
		6:
			soundToPlay = "Hitmarker6"
		7:
			soundToPlay = "Hitmarker7"
	self.play(soundToPlay, position)

func _on_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	available.append(stream)


func play(sound_name : String, position : Vector2):
	queue.append([soundDictionary[sound_name], position])


func _process(delta):
	# Play a queued sound if any players are available.
	if not queue.empty() and not available.empty():
		var fileInfo = queue.pop_front()
		available[0].stream = load(fileInfo[0])
		available[0].global_position = fileInfo[1]
		available[0].play()
		available.pop_front()

# hopefully this stops all sound effects when a quick restart is done
func _restart():
	for player in available:
		player.stop()
