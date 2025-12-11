class_name Choice
extends HoverOutline


func pick_up():
	process_mode = Node.PROCESS_MODE_DISABLED
	set_collision_layer_value(2, true)


func put_down(on_drop_area := false):
	process_mode = Node.PROCESS_MODE_ALWAYS
	if on_drop_area:
		set_collision_layer_value(2, false)


func left_click():
	# remove outline?
	pass
