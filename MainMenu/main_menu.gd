extends CanvasLayer
class_name MainMenu


var saves: Array[Dictionary] = []


func _ready():
	# first-time setup
	CheckFirstTimeSetup()
	
	saves = GetSaves()
	if len(saves) > 0:
		$Buttons/Continue.Activate(saves[0])
	else:
		$Buttons/Continue.hide()


func CheckFirstTimeSetup():
	print("Checking for first-time setup")
	if DirAccess.dir_exists_absolute(Constants.SAVES_LOCATION):
		print("\tExisting saves folder detected")
	else:
		print("\tSaves folder not detected; creating...")
		DirAccess.make_dir_absolute(Constants.SAVES_LOCATION)


func GetSaves() -> Array[Dictionary]:
	var saves_dir = DirAccess.open(Constants.SAVES_LOCATION)
	
	var result = [] as Array[Dictionary]
	for slot: String in saves_dir.get_directories():
		if slot != "_debug":
			var filepath = "%s/%s/game_status.json" % [Constants.SAVES_LOCATION, slot]
			var save_data = JSON.parse_string(
				FileAccess.open(filepath, FileAccess.READ).get_as_text()
			)
		
			result.append(save_data)
	
	result.sort_custom(func(a, b): return a["last_played"] > b["last_played"])
	return result


func _on_new_pressed() -> void:
	$Buttons.hide()
	$NewGamePanel.Activate()

func _on_load_pressed() -> void:
	$Buttons.hide()
	$LoadGamePanel.Activate(saves)


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_new_game_panel_back_to_main_menu() -> void:
	$NewGamePanel.hide()
	$Buttons.show()

func _on_new_game_panel_start_new_game(slot: String) -> void:
	TransitionManager.slot = slot
	get_tree().change_scene_to_file("res://MainMenu/NewGame/new_game_generation.tscn")

# note: this is also used for Continue
func _on_load_game_panel_start_load_game(slot: String) -> void:
	TransitionManager.slot = slot
	Database.Open(slot)
	get_tree().change_scene_to_file("res://ActiveGame/active_game.tscn")
