class_name CharacterSwapInfo
extends SwapInfo

@export var models: Dictionary[GameManager.Character, Mesh]


func get_model_for(character: GameManager.Character):
	if character in models:
		return models[character]
	return null
