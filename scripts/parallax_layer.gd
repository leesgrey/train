extends Node3D

@export var speed: float
@export var reset_point: Marker3D
var width: float


func _ready() -> void:
	var aabb = _calculate_spatial_bounds(self, false)
	width = aabb.size.z


func _process(delta: float) -> void:
	self.transform.origin.z += speed * delta
	if self.transform.origin.z > width:
		self.transform.origin.z = reset_point.position.z


#https://www.reddit.com/r/godot/comments/18bfn0n/how_to_calculate_node3d_bounding_box/
func _calculate_spatial_bounds(parent: Node3D, exclude_top_level_transform: bool) -> AABB:
	var bounds: AABB = AABB()
	if parent is VisualInstance3D:
		bounds = parent.get_aabb()

	for i in range(parent.get_child_count()):
		var child: Node3D = parent.get_child(i)
		if child:
			var child_bounds: AABB = _calculate_spatial_bounds(child, false)
			if bounds.size == Vector3.ZERO && parent:
				bounds = child_bounds
			else:
				bounds = bounds.merge(child_bounds)
	if bounds.size == Vector3.ZERO && !parent:
		bounds = AABB(Vector3(-0.2, -0.2, -0.2), Vector3(0.4, 0.4, 0.4))
	if !exclude_top_level_transform:
		bounds = parent.transform * bounds
	return bounds
