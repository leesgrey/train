@tool

class_name CameraController
extends Camera3D

enum Facing {WINDOW, DESK, DOOR, CEILING, MIRROR}

@export var window_target: Node3D
@export var door_target: Node3D
@export var ceiling_target: Node3D
@export var mirror_target: Node3D
@export var desk_target: Node3D

@export var skeleton: Skeleton3D
@export var bone_name: String

var facing_to_target = {}

var neck_bone: int
var bone_up: Vector3

@export var turn_speed: int

@export var facing_to_rotation: Dictionary[Facing, Quaternion] = {}

var current_facing: Facing:
	set(value):
		if value == current_facing:
			return
		current_facing = value
		turn_to(value)

var turn_tween: Tween
var input_enabled := false


func _ready() -> void:
	GameManager.start.connect(_start)

	facing_to_target = {
		Facing.WINDOW: window_target,
		Facing.DOOR: door_target,
		Facing.CEILING: ceiling_target,
		Facing.MIRROR: mirror_target,
		Facing.DESK: desk_target
	}
	neck_bone = skeleton.find_bone(bone_name)


func _start():
	turn_to(Facing.MIRROR)
	input_enabled = true


func _input(event):
	if input_enabled:
		if event.is_action_pressed("look_up"):
			if current_facing == Facing.DESK:
				current_facing = Facing.MIRROR
			else:
				current_facing = Facing.CEILING
		elif event.is_action_pressed("look_down"):
			if current_facing == Facing.CEILING:
				current_facing = Facing.MIRROR
			else:
				current_facing = Facing.DESK
		elif event.is_action_pressed("look_left"):
			if current_facing == Facing.DOOR:
				current_facing = Facing.MIRROR
			else:
				current_facing = Facing.WINDOW
		elif event.is_action_pressed("look_right"):
			if current_facing == Facing.WINDOW:
				current_facing = Facing.MIRROR
			else:
				current_facing = Facing.DOOR
		

func turn_to(facing: Facing, skip_tween := false):
	if Engine.is_editor_hint():
		facing_to_target = {
			Facing.WINDOW: window_target,
			Facing.DOOR: door_target,
			Facing.CEILING: ceiling_target,
			Facing.MIRROR: mirror_target,
			Facing.DESK: desk_target
		}
		transform = transform.looking_at(facing_to_target[facing].position)
		return

	GameManager.view_change_start.emit(facing)

	if !skip_tween:
		if turn_tween && turn_tween.is_running():
			turn_tween.kill()
		turn_tween = get_tree().create_tween()
		turn_tween.parallel().tween_property(
			self, "transform", transform.looking_at(facing_to_target[facing].position), 0.15
		)
		var target_rotation
		if facing in facing_to_rotation:
			target_rotation = facing_to_rotation[facing].normalized()
		else:
			target_rotation = Quaternion.IDENTITY
		turn_tween.parallel().tween_property(
			skeleton, "bones/%s/rotation" % neck_bone, target_rotation, 0.15
		)
		turn_tween.tween_callback(GameManager.view_change_end.emit.bind(facing))
	else:
		transform = transform.looking_at(facing_to_target[facing].position)
		GameManager.view_change_end.emit(facing)
