extends Panel
class_name MainMenuLoadGame


signal start_load_game(slot: String)


@export var widget_scene: PackedScene


func Activate(saves: Array[Dictionary]):
	show()
	
	for data in saves:
		var w: LoadSlotWidget = widget_scene.instantiate()
		$ScrollContainer/MarginContainer/VBoxContainer.add_child(w)
		w.Activate(data)
		w.load_game.connect(_on_slot_pressed)


func _on_slot_pressed(slot: String):
	start_load_game.emit(slot)
