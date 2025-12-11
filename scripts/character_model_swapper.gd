@tool
class_name CharacterModelSwapper
extends Node

@export var target: MeshInstance3D
@export var models: CharacterSwapInfo
@export var defer_until_letter_view_left: bool


func _ready():
	if (defer_until_letter_view_left):
		GameManager.letter_view_exited.connect(_letter_view_left)
	else:
		GameManager.character_changed.connect(_change_model)


func _change_model():
	var new_model = models.get_model_for(GameManager.current_character)
	if new_model:
		target.set_mesh(new_model)

func _letter_view_left():
	_change_model()
