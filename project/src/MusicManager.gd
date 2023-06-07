extends Node

func update_theme_song(index):
	for audio_stream_player in get_children():
		audio_stream_player.playing = false
	get_child(index).playing = true
	
	pass
