@tool
class_name CharacterModelSwapper
extends Node

@export var target: MeshInstance3D
@export var models: CharacterSwapInfo
@export var defer_until_letter_view_left: bool

var change_model := false


func _ready():
	if (defer_until_letter_view_left):
		GameManager.view_change_end.connect(_on_view_change)
		GameManager.character_changed.connect(_queue_model_change)
	else:
		GameManager.character_changed.connect(_change_model)


func _change_model():
	var new_model = models.get_model_for(GameManager.current_character)
	if new_model != null:
		target.set_mesh(new_model)
	if defer_until_letter_view_left:
		change_model = false

func _queue_model_change():
	change_model = true
	

func _on_view_change(facing: CameraController.Facing):
	if change_model and facing != CameraController.Facing.DESK:
		_change_model()
