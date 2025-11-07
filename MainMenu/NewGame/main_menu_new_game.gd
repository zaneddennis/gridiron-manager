extends Panel
class_name MainMenuNewGame


signal back_to_main_menu
signal start_new_game(slot: String)


var slot: String = ""


func Activate():
	$Content/LineEdit.text = "new_career_" + Time.get_date_string_from_system()
	
	# TODO: data sources
	# TODO: macro parameters
	
	show()


func CreateSaveSlot():
	print("\tCreating save slot")
	var dir = DirAccess.open(Constants.SAVES_LOCATION)
	dir.make_dir(slot)
	
	var save_file = FileAccess.open(Constants.SAVES_LOCATION + "/%s/game_status.json" % slot, FileAccess.WRITE)
	var data = JSON.stringify({
		"slot": slot,
		"last_played": Time.get_datetime_string_from_system(),
		"current_date": Timestamp.new(2025, Timestamp.PHASE.PRESEASON, 1, 0).ToISO(),
	}, "\t", false)
	save_file.store_string(data)
	
	var slot_dir = DirAccess.open(Constants.SAVES_LOCATION + "/" + slot)
	slot_dir.make_dir("Logos")
	
	Database.Create(slot)


func StartNewGame():
	print("Starting New Game")
	slot = $Content/LineEdit.text
	CreateSaveSlot()
	start_new_game.emit(slot)


func _on_back_pressed() -> void:
	back_to_main_menu.emit()


func _on_next_pressed() -> void:
	StartNewGame()
