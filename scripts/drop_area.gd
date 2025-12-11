class_name DropArea
extends HoverOutline

@export var choice_type: GameManager.ChoiceType
var placed_choice: Choice


func update_choice(choice: Choice):
	placed_choice = choice
	if choice_type == GameManager.ChoiceType.CHARACTER:
		GameManager.set_character(choice.character)
		set_collision_layer_value(3, false)
	if choice_type == GameManager.ChoiceType.SETTING:
		GameManager.set_setting(choice.setting)
		set_collision_layer_value(4, false)
	set_collision_layer_value(2, true)


func clear_choice():
	placed_choice = null
	if choice_type == GameManager.ChoiceType.CHARACTER:
		GameManager.set_character(GameManager.Character.NONE)
		set_collision_layer_value(3, true)
	if choice_type == GameManager.ChoiceType.SETTING:
		GameManager.set_setting(GameManager.Setting.NONE)
		set_collision_layer_value(4, true)
	set_collision_layer_value(2, false)
