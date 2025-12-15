extends Node3D

@export var right_hand: Node3D
@export var camera: Camera3D

const RAY_LENGTH = 10.0

var mouse_enabled := false

# camera-mouse raycast
var from: Vector3
var to: Vector3
var intersection: Vector3
var hover_target: HoverTarget

# choice handling
var held_choice: Choice
var previous_origin: Vector3
var previous_rotation: Vector3


func _ready() -> void:
	GameManager.view_change_start.connect(_on_view_change_start)
	GameManager.view_change_end.connect(_on_view_change_end)


func _input(event: InputEvent) -> void:
	if mouse_enabled:
		if event is InputEventMouseMotion:
			# update raycast for hover target
			from = camera.project_ray_origin(event.position)
			to = from + camera.project_ray_normal(event.position) * RAY_LENGTH

			# move right hand
			right_hand.transform.origin = (
				camera.project_position(event.position, 0.4) + Vector3(-0.05, 0, 0.12)
			) # temp offset, remove once rigged

			# move held choice
			if held_choice:
				held_choice.transform.origin = camera.project_position(event.position, 0.3)

		if event is InputEventMouseButton:
			if event.pressed:
				# pick up hovered choice
				if hover_target is Choice:
					_pick_up_choice()
					held_choice.transform.origin = camera.project_position(event.position, 0.3)
				# pick up choice on drop area
				elif hover_target is DropArea and hover_target.placed_choice:
					_pick_up_choice(hover_target.placed_choice)
					hover_target.clear_choice()
				hover_target.left_click()

			elif !event.pressed and held_choice:
				_put_down_choice()


func _pick_up_choice(choice = null):
	if choice:
		held_choice = choice
	else:
		held_choice = hover_target
		previous_origin = held_choice.transform.origin
		previous_rotation = held_choice.rotation
	held_choice.pick_up()
	held_choice.rotation = Vector3(0, 0, 0)


func _put_down_choice():
	if (
		hover_target is DropArea
		and not hover_target.placed_choice
		and hover_target.choice_type == held_choice.choice_type
	):
		held_choice.transform = hover_target.transform
		held_choice.put_down(true)
		hover_target.update_choice(held_choice)
		held_choice = null
	elif hover_target.can_place_choice:
		held_choice.transform.origin = intersection
		held_choice.put_down()
		held_choice = null
	else:
		held_choice.rotation = previous_rotation
		held_choice.global_transform.origin = previous_origin
		held_choice.put_down()
		held_choice = null


func _physics_process(_delta: float) -> void:
	# raycast for hover targets
	if mouse_enabled:
		var space_stage = get_world_3d().direct_space_state
		var collision_mask
		if held_choice:
			if held_choice.choice_type == GameManager.ChoiceType.CHARACTER:
				collision_mask = (1 << 3 - 1)
			else:
				collision_mask = (1 << 4 - 1)
		else:
			collision_mask = (1 << 2 - 1)
		var query = PhysicsRayQueryParameters3D.create(from, to, collision_mask)
		query.collide_with_areas = true
		var result = space_stage.intersect_ray(query)
		if !result.is_empty():
			intersection = result.position
			if result.collider != hover_target:
				if hover_target:
					hover_target.unhover() # old
				hover_target = result.collider # change
				hover_target.hover() # new


func _on_view_change_start(_view: CameraController.Facing):
	print("view change end")
	mouse_enabled = false


func _on_view_change_end(view: CameraController.Facing):
	print("view change end")
	if (view == CameraController.Facing.DESK or view == CameraController.Facing.DOOR):
		mouse_enabled = true
	else:
		mouse_enabled = false
