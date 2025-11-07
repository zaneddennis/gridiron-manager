extends Panel


signal pressed


func Activate(s: School):
	$Button/HBox/VBox/HBoxContainer/NameMascot.text = "%s %s" % [s.name, s.mascot]
	$Button/HBox/VBox/Conference.text = "Conference: " + s.conference.name
	
	$Button/HBox/VBox/HBoxContainer/Swatch0.color = s.colors[0]
	$Button/HBox/VBox/HBoxContainer/Swatch1.color = s.colors[1]
	$Button/HBox/VBox/HBoxContainer/Swatch2.color = s.colors[2]
	
	$Button/HBox/Logo/TextureRect.texture = s.logo


func _on_button_pressed() -> void:
	pressed.emit()
