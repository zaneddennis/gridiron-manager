extends CanvasLayer


# player Character and Coach always have id of 0
# this should be always doable because SQL starts normal indexing at 1, leaving 0 open
#const USER_ID: int = 0


@export var SelectSchoolWidgetScene: PackedScene


var selected_school: School


func _ready() -> void:
	var schools = School.GetAll("Name")
	for s: School in schools:
		var widget = SelectSchoolWidgetScene.instantiate()
		widget.Activate(s)
		widget.pressed.connect(_on_select_school_widget_pressed.bind(s))
		$Panel/VBoxContainer/HBox/School/ScrollContainer/VBoxContainer.add_child(
			widget
		)
	
	SelectSchool(schools[0])


func SelectSchool(school: School):
	selected_school = school
	$Panel/VBoxContainer/HBox/School/Selected/Label2.text = selected_school.name


func _on_select_school_widget_pressed(school: School):
	SelectSchool(school)


func _on_start_game_pressed() -> void:
	var user_character = Character.FromDict({
		"ID": Constants.USER_ID,
		"First": "John",
		"Last": "Smith",
		"Birth": 1995
	})
	user_character.AddToDB()
	
	var user_coach = Coach.FromDict({
		"ID": Constants.USER_ID,
		"CharacterID": Constants.USER_ID
	})
	user_coach.AddToDB()
	
	selected_school.head_coach = user_coach
	selected_school.UpdateDB()
	
	TransitionManager.first_time_new_game = true
	get_tree().change_scene_to_file("res://ActiveGame/active_game.tscn")
