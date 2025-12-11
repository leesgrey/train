extends Control

@export var container: VBoxContainer

var dict = {}


func update_dict(key: String, val = null):
	if val == null:
		dict.erase(key)
	dict[key] = val
	_update_view()


func _update_view():
	for entry in container.get_children():
		entry.queue_free()

	for key in dict:
		#print(key)
		var label := RichTextLabel.new()
		label.text = "%s: %s" % [key, str(dict[key])]
		label.fit_content = true
		container.add_child(label)
