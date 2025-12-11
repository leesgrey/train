@tool

extends Control

@export var text: String
@export var paragraph_container: VBoxContainer

@export_tool_button("Generate", "Callable") var generate_action = generate_letter


func generate_letter():
	# reset
	for child in paragraph_container.get_children():
		child.queue_free()
	var words = text.split(" ")
	create_paragraph()
	for word in words:
		if word == "\\n":
			create_paragraph()
		else:
			create_word(word)


func create_paragraph():
	#print("create paragraph")
	var new_paragraph = HFlowContainer.new()
	paragraph_container.add_child(new_paragraph)
	new_paragraph.owner = get_tree().edited_scene_root


func create_word(word: String):
	#print("create word")
	#print(word)
	var word_panel = PanelContainer.new()
	var text_label = RichTextLabel.new()

	text_label.text = word
	text_label.fit_content = true
	text_label.autowrap_mode = TextServer.AUTOWRAP_OFF

	word_panel.add_child(text_label)
	paragraph_container.get_child(paragraph_container.get_child_count() - 1).add_child(word_panel)

	word_panel.owner = get_tree().edited_scene_root
	text_label.owner = get_tree().edited_scene_root
