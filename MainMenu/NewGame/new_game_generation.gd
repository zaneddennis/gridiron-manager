extends CanvasLayer


@export var default_logo: Image

var thread: Thread


func _ready() -> void:
	print("Generating New Game")
	
	$Panel/VBox/InitDB.show()
	
	thread = Thread.new()
	thread.start(ThreadInitializeDB)


func ThreadInitializeDB():
	Database.Initialize()
	
	var logos_res_dir: DirAccess = DirAccess.open("res://Data/Data/Images/Logos/Final")
	for school_id: String in Database.GetColumnAsList("Schools", "ID", "ID"):
		if logos_res_dir.file_exists(school_id + ".png"):
			DirAccess.copy_absolute(
				"res://Data/Data/Images/Logos/Final/%s.png" % school_id,
				"user://save_data/%s/Logos/%s.png" % [TransitionManager.slot, school_id]
			)
		else:
			var new_color = Color.html(Database.Query("SELECT Color1 FROM Schools WHERE ID = '%s'" % school_id)[0]["Color1"])
			for x in default_logo.get_size().x:
				for y in default_logo.get_size().y:
					if default_logo.get_pixel(x, y).a != 0:
						default_logo.set_pixel(x, y, new_color)
			default_logo.save_png("user://save_data/%s/Logos/%s.png" % [TransitionManager.slot, school_id])
	
	call_deferred("_complete_initialize_db")


func _complete_initialize_db():
	thread.wait_to_finish()
	$Panel/VBox/GenCoaches.show()
	thread.start(ThreadGenerateCoaches)


func ThreadGenerateCoaches():
	# TODO
	call_deferred("_complete_generate_coaches")


func _complete_generate_coaches():
	thread.wait_to_finish()
	$Panel/VBox/GenPlayers.show()
	thread.start(ThreadGeneratePlayers)


func ThreadGeneratePlayers():
	# TODO
	call_deferred("_complete_generate_players")


func _complete_generate_players():
	thread.wait_to_finish()
	$Panel/VBox/HireCoaches.show()
	thread.start(ThreadHireCoaches)


func ThreadHireCoaches():
	# TODO
	call_deferred("_complete_hire_coaches")


func _complete_hire_coaches():
	thread.wait_to_finish()
	$Panel/VBox/Croots.show()
	thread.start(ThreadRecruitPlayers)


func ThreadRecruitPlayers():
	# TODO
	call_deferred("_complete_recruit_players")


func _complete_recruit_players():
	thread.wait_to_finish()
	Complete()


func Complete():
	$Panel/VBox/Start.show()


func _on_start_pressed() -> void:
	#TransitionManager.first_time_new_game = true
	#get_tree().change_scene_to_file("res://ActiveGame/active_game.tscn")  # TODO: change to different scene
	get_tree().change_scene_to_file("res://MainMenu/NewGame/new_game_setup.tscn")
