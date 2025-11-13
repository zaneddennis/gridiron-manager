extends Node
class_name ActiveGame


var slot: String

var task_list: Array[Task]

# persistent data
var current_date: Timestamp


func _ready() -> void:
	print("Activating Game")
	var s = randi()
	print("\tRandom Seed: ", s)
	seed(s)
	
	if TransitionManager.slot:
		print("\tLoading Saved Data: ", TransitionManager.slot)
		slot = TransitionManager.slot
	else:
		print("\tLoading Debug Data: ", Constants.DEBUG_SAVE)
		slot = Constants.DEBUG_SAVE
		Database.Open(slot)
	LoadSavedData()
	
	if TransitionManager.first_time_new_game:
		NewSeason()
	
	NewWeek()


func LoadSavedData():
	var filepath = "%s/%s/game_status.json" % [Constants.SAVES_LOCATION, slot]
	var save_dict = JSON.parse_string(
		FileAccess.open(filepath, FileAccess.READ).get_as_text()
	)
	current_date = Timestamp.FromISO(save_dict["current_date"])

func SaveData():
	var filepath = "%s/%s/game_status.json" % [Constants.SAVES_LOCATION, slot]
	var save_file = FileAccess.open(filepath, FileAccess.WRITE)
	var data = JSON.stringify({
		"slot": slot,
		"last_played": Time.get_datetime_string_from_system(),
		"current_date": current_date.ToISO(),
	}, "\t", false)
	save_file.store_string(data)


func NewWeek():
	task_list = TaskScheduler.GetTasks(current_date)
	
	$UI.Refresh()
	#$UI.OpenPage($UI/VBox/Pages/Home)
	$UI/VBox/Pages/Home.Activate(self)


func NewSeason():
	print("Generating New Season...")
	SeasonGenerator.GenerateTeams(current_date.year)
	SeasonGenerator.GenerateSchedules(current_date.year)


func GetUserSchool() -> School:
	return School.FromDict(
		Database.Query("SELECT * FROM Schools WHERE HeadCoachID = %d" % Constants.USER_ID)[0]
	)


func _on_home_open_task(i: int) -> void:
	var task = task_list[i]
	
	var page = $UI/VBox/Pages/PlaceholderTask
	if task == TaskScheduler.gameday:
		page = $UI/Gameday
	elif task == TaskScheduler.conference_champions:
		page = $UI/VBox/Pages/ConferenceChampionsTask
	
	#$UI.OpenPage(page)
	page.Activate(self)


func _on_task_completed(task_page: TaskPage) -> void:
	task_page.Close()
	
	current_date.task += 1
	
	SaveData()
	
	$UI.Refresh()
	$UI/VBox/Pages/Home.Activate(self)


func _on_week_completed() -> void:
	current_date.week += 1
	current_date.task = 0
	
	if current_date.week > Timestamp.PHASE_LENGTH[current_date.phase]:
		current_date.phase += 1
		current_date.week = 1
		
		if current_date.phase >= len(Timestamp.PHASE.keys()):
			current_date.year += 1
			current_date.phase = 0
			NewSeason()
		
		# NewPhase()
	
	SaveData()
	
	NewWeek()
	
	$UI.Refresh()
	#$UI.OpenPage($UI/VBox/Pages/Home)
	$UI/VBox/Pages/Home.Activate(self)
