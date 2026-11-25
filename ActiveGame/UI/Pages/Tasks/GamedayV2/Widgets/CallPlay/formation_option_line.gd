extends HBoxContainer
class_name FormationOptionLine


signal formation_selected(f: Formation)
signal formation_hovered(f: Formation)


@export var SELECT_FORMATION_BUTTON: PackedScene


func Activate(p: String, fs: Array[Formation]):
	$Personnel.text = p
	
	for f in fs:
		var b: Button = SELECT_FORMATION_BUTTON.instantiate()
		$GridBox.add_child(b)
		b.text = f.name
		b.pressed.connect(_on_button_pressed.bind(f))
		b.mouse_entered.connect(_on_button_hovered.bind(f))


func _on_button_pressed(f: Formation):
	formation_selected.emit(f)

func _on_button_hovered(f: Formation):
	formation_hovered.emit(f)
