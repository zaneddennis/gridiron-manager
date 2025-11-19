extends CanvasLayer


@export var default_logo: Image

var thread: Thread

var character_generator: CharacterGenerator
var coach_generator: CoachGenerator
var player_generator: PlayerGenerator

const COACHES_PER_SCHOOL: float = 1.5
const PLAYERS_PER_SCHOOL: int = 60
var num_coaches: int
var num_players: int


const MAX_PER_POSITION = {
	"QB": 3,
	"RB": 4,
	"WR": 6,
	"TE": 3,
	"OT": 4,
	"OG": 4,
	"C": 3,
	"DT": 4,
	"EDGE": 4,
	"LB": 5,
	"CB": 6,
	"S": 5
}


func _ready() -> void:
	print("Generating New Game World")
	
	$Panel/VBox/InitDB.show()
	
	thread = Thread.new()
	thread.start(ThreadInitializeDB)


func ThreadInitializeDB():
	print("\tInitializing Database...")
	Database.Initialize()
	
	var logos_res_dir: DirAccess = DirAccess.open("res://Data/Data/Images/Logos/Final")
	for school_id: String in Database.GetColumnAsList("Schools", "ID", "ID"):
		if logos_res_dir.file_exists(school_id + ".png"):
			DirAccess.copy_absolute(
				"res://Data/Data/Images/Logos/Final/%s.png" % school_id,
				"user://save_data/%s/Logos/%s.png" % [TransitionManager.slot, school_id]
			)
		else:
			# I'm pretty sure this loop is why InitializeDB takes so long
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
	print("\tGenerating Coaches...")
	
	character_generator = CharacterGenerator.new()
	coach_generator = CoachGenerator.new()
	
	num_coaches = int(Database.GetCount("Schools") * COACHES_PER_SCHOOL)
	var characters: Array[Dictionary] = []
	var coaches: Array[Dictionary] = []
	
	for i in range(1, num_coaches+1):
		characters.append(character_generator.GenerateCharacter(1960, 1995))
		coaches.append(coach_generator.GenerateCoach(i))
	
	Database.AddRows("Characters", characters)
	Database.AddRows("Coaches", coaches)
	
	call_deferred("_complete_generate_coaches")


func _complete_generate_coaches():
	thread.wait_to_finish()
	$Panel/VBox/GenPlayers.show()
	thread.start(ThreadGeneratePlayers)


func ThreadGeneratePlayers():
	print("\tGenerating Players...")
	
	player_generator = PlayerGenerator.new()
	
	num_players = int(Database.GetCount("Schools") * PLAYERS_PER_SCHOOL)
	var characters: Array[Dictionary] = []
	var players: Array[Dictionary] = []
	
	for i in range(1, num_players+1):
		characters.append(character_generator.GenerateCharacter(2007, 2007))
		players.append(player_generator.GeneratePlayer(num_coaches + i))
	
	Database.AddRows("Characters", characters)
	Database.AddRows("Players", players)
	
	call_deferred("_complete_generate_players")


func _complete_generate_players():
	thread.wait_to_finish()
	$Panel/VBox/HireCoaches.show()
	thread.start(ThreadHireCoaches)


func ThreadHireCoaches():
	print("\tHiring Coaches...")
	
	var schools_list = Database.GetColumnAsList("Schools", "ID", "ID")
	var coaches_list = Database.GetColumnAsList("Coaches", "ID", "ID")
	schools_list.shuffle()
	coaches_list.shuffle()
	
	for i in range(len(schools_list)):
		var school_id: String = schools_list[i]
		var coach_id: int = coaches_list[i]
		Database.UpdateRow("Schools", school_id, {"HeadCoachID": coach_id})
	
	call_deferred("_complete_hire_coaches")


func _complete_hire_coaches():
	thread.wait_to_finish()
	$Panel/VBox/Croots.show()
	thread.start(ThreadRecruitPlayers)


func ThreadRecruitPlayers():
	print("\tRecruiting Players...")
	
	#var player_list = Database.GetColumnAsList("Players", "ID", "Skill DESC")
	var players = Database.Query("SELECT ID, Position FROM Players ORDER BY Skill DESC")
	#var schools = Database.Query("SELECT ID, Prestige FROM Schools")
	var schools = Database.QueryToDict("SELECT ID, Prestige FROM Schools")
	# TODO: convert schools from Array[Dictionary] to Dictionary[Dictionary]
		# make Database.QueryToDict() function?
	
	# set up position counts
	for s_id: String in schools.keys():
		var s = schools[s_id]
		for pos in Player.POSITION.keys():
			s[pos] = 0
	
	for p: Dictionary in players:
		var pos = p["Position"]
		print("\t\tPlayer ID: ", p["ID"], " ", pos)
		
		# calculate appeal for each school
		var appeals: Dictionary[String, float] = {}
		for s: Dictionary in schools.values():
			var P = (1 + s["Prestige"]) / 7.0
			var N = 1.0 - (s[pos] / MAX_PER_POSITION[pos])
			var noise = randfn(0.0, 0.1)
			appeals[s["ID"]] = clamp(P * N + noise, 0.01, 1.0)
		
		# pick school with highest appeal
		var max_appeal = appeals.values().max()
		print("\t\t\tMax Appeal: ", max_appeal)
		var finalists = appeals.keys().filter(func(s_id: String): return appeals[s_id] >= max_appeal)
		print("\t\t\tFinalists: ", finalists)
		
		var selection = finalists.pick_random()
		print("\t\t\tSelection: ", selection)
		p["Selection"] = selection
		schools[selection][pos] += 1
		
		Database.UpdateRow("Players", p["ID"], {"SchoolID": selection})
	
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
