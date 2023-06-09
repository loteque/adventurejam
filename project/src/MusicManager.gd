extends Node

var current_track: AudioStreamPlayer

onready var music = get_node("Music")
onready var sfx = get_node("SFX")
onready var bg = get_node("Background")

func update_theme_song(index):
	current_track = music.get_child(index)
	for audio_stream_player in music.get_children():
		audio_stream_player.playing = false
	current_track.playing = true

func stop():
	current_track.playing = false

func play_sfx(index):
	current_track = sfx.get_child(index)
	for audio_stream_player in sfx.get_children():
		audio_stream_player.playing = false
	current_track.play()
