extends Node

enum ChoiceType {CHARACTER, SETTING}
enum Character {NONE, COWBOY, HITMAN, THIEF}
enum Setting {NONE, DESERT, CITY}

signal letter_view_entered
signal letter_view_exited
signal start
signal character_changed
signal setting_changed

var current_character: Character = Character.NONE
var current_setting: Setting = Setting.NONE


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func set_character(character: Character):
	current_character = character
	print("character is now ", current_character)
	character_changed.emit()


func set_setting(setting: Setting):
	current_setting = setting
	print("setting is now ", current_setting)
	setting_changed.emit()


func get_choice(type: ChoiceType):
	if type == ChoiceType.CHARACTER:
		return current_character
	else:
		return current_setting
