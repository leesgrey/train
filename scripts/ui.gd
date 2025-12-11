extends Control

@export var uiAnimationPlayer: AnimationPlayer


func _ready() -> void:
	uiAnimationPlayer.play("fade_in")
	AudioManager.play_sound("train_bg", AudioManager.SoundType.BG)


func start():
	GameManager.start.emit()
