extends Node

var current_track: AudioStreamPlayer

func update_theme_song(index):
	current_track = get_child(index)
	for audio_stream_player in get_children():
		audio_stream_player.playing = false
	current_track.playing = true

func stop():
	current_track.playing = false
