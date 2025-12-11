@tool

class_name CameraController
extends Camera3D

enum Facing { WINDOW, DESK, DOOR, CEILING, MIRROR }

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
				GameManager.letter_view_exited.emit()
				#turn_to(mirror_target)
				current_facing = Facing.MIRROR
			else:
				#turn_to(ceiling_target)
				current_facing = Facing.CEILING
		elif event.is_action_pressed("look_down"):
			if current_facing == Facing.CEILING:
				#turn_to(mirror_target)
				current_facing = Facing.MIRROR
			else:
				#turn_to(desk_target)
				GameManager.letter_view_entered.emit()
				current_facing = Facing.DESK
		elif event.is_action_pressed("look_left"):
			if current_facing == Facing.DOOR:
				#turn_to(mirror_target)
				current_facing = Facing.MIRROR
			else:
				GameManager.letter_view_exited.emit()
				#turn_to(window_target)
				current_facing = Facing.WINDOW
		elif event.is_action_pressed("look_right"):
			if current_facing == Facing.WINDOW:
				#turn_to(mirror_target)
				current_facing = Facing.MIRROR
			else:
				GameManager.letter_view_exited.emit()
				#turn_to(door_target)
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
		# var start = skeleton.get_bone_pose_rotation(neck_bone).normalized()
		turn_tween.parallel().tween_property(
			skeleton, "bones/%s/rotation" % neck_bone, target_rotation, 0.15
		)
	else:
		transform = transform.looking_at(facing_to_target[facing].position)
