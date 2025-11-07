extends Page
class_name HomePage


signal open_task(i: int)


const MAX_TASKS = 8


func Activate(ag: ActiveGame):
	super(ag)
	
	#var date = ag.current_date
	
	# Tasks
	for i in range(MAX_TASKS):
		var b: Button = $TaskButtons.get_node("Button%d" % i)
		if not b.pressed.has_connections():
			b.pressed.connect(_on_task_button_pressed.bind(i))
		if i < len(ag.task_list):
			b.text = ag.task_list[i].display_name
			b.show()
			
			if ag.current_date.task == i:
				b.disabled = false
			else:
				b.disabled = true
			
		else:
			b.hide()
	
	if ag.current_date.task >= len(ag.task_list):
		$TaskButtons/NextWeek.disabled = false
	else:
		$TaskButtons/NextWeek.disabled = true
	
	# Panels
	RenderNextGame(ag)
	$Top/Schedule/Panel/ScheduleWidget.Render(ag.GetUserSchool().id, ag.current_date.year)


func RenderNextGame(ag: ActiveGame):
	var school_id = ag.GetUserSchool().id
	var year = ag.current_date.year
	var week = ag.current_date.week if ag.current_date.phase == Timestamp.PHASE.REGULAR_SEASON else 1
	
	var g: Dictionary = Database.Query("""
	SELECT *, CASE WHEN AwayConferenceID = HomeConferenceID THEN HomeConferenceID ELSE '-' END AS GameConference
	FROM GamesFull_v
	WHERE Year = %d AND '%s' IN (AwaySchoolID, HomeSchoolID) AND Week >= %d
	ORDER BY Week
	LIMIT 1
	""" % [year, school_id, week])[0]
	
	$Top/NextGame.Render(g)


func _on_task_button_pressed(i: int):
	open_task.emit(i)
