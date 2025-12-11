class_name HoverOutline
extends HoverTarget

@export var mesh: MeshInstance3D
@export var outline_shader: Material


func hover():
	super()
	# add outline shader
	mesh.get_active_material(0).next_pass = outline_shader


func unhover():
	# remove outline shader
	mesh.get_active_material(0).next_pass = null
