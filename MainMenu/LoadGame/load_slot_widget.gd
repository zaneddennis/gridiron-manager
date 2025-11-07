extends Panel
class_name LoadSlotWidget


signal load_game(slot: String)


func Activate(data: Dictionary):
	$VBoxContainer/Slot.text = data["slot"]
	$VBoxContainer/CurrentDate.text = str(Timestamp.FromISO(data["current_date"]))
	$VBoxContainer/LastPlayed.text = data["last_played"]
	show()


func _on_button_pressed() -> void:
	load_game.emit($VBoxContainer/Slot.text)
