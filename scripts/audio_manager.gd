extends Node

enum SoundType { BG, SFX }

@export var stream_dict: Dictionary[String, AudioStream]

@export var bg_players: Node
@export var sfx_players: Node

var player_tracker: Dictionary[int, PanelContainer]


func _ready():
	for audio_player in bg_players.get_children():
		audio_player.finished.connect(_on_sound_finished.bind(audio_player.get_instance_id()))

	for audio_player in sfx_players.get_children():
		audio_player.finished.connect(_on_sound_finished.bind(audio_player.get_instance_id()))


func play_sound(sound, sound_type: SoundType, pitch_range: float = 0., fade_out: float = 0.):
	var audio_players: Array[Node]
	if sound_type == SoundType.BG:
		audio_players = bg_players.get_children()
	elif sound_type == SoundType.SFX:
		audio_players = sfx_players.get_children()
	for audio_player in audio_players:
		if not audio_player.playing:
			audio_player.volume_db = 0.
			if fade_out > 0.:
				var tween = get_tree().create_tween()
				tween.tween_property(audio_player, "volume_db", -60, fade_out)
				tween.finished.connect(_on_sound_finished.bind(audio_player.get_instance_id()))
			audio_player.stream = stream_dict[sound]
			if pitch_range > 0.:
				audio_player.pitch_scale = randf_range(1. - pitch_range, 1. + pitch_range)
			audio_player.play()
			return audio_player


func _on_sound_finished(player_id: int):
	if player_id in player_tracker and player_tracker[player_id] != null:
		player_tracker[player_id].queue_free()


func fade_out_player(player: AudioStreamPlayer, time: float):
	var tween = get_tree().create_tween()
	tween.tween_property(player, "volume_db", -60, time)


func stop(player: AudioStreamPlayer):
	player.stop()
	_on_sound_finished(player.get_instance_id())
