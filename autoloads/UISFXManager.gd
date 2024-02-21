extends Node

# STILL NEEDS A LOOKTHROUGH

var num_players = 3
var bus = "UISFX"

var available = []  # The available players.
var queue = []  # The queue of sounds to play.

onready var Click1 = $Click1
onready var Click2 = $Click2
onready var Click3 = $Click3
onready var Swipe1 = $Swipe1

func _ready():
	pass

func _on_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	available.append(stream)

func play(sound_name : String):
	self.get_node(sound_name).play()
