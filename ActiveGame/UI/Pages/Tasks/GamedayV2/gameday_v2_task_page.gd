extends ColorRect
#class_name GamedayV2


func _ready() -> void:
	if get_tree().current_scene == self:
		ActivateDebug()


#TODO
func Activate():
	pass


func ActivateDebug():
	Database.Create("_debug")
	Database.InitializeDebug()
	
	#var colorado = Team.FromDB("COLO2025")
	#var baylor = Team.FromDB("BAY2025")
	
	var game = Game.FromDict({
		"ID": 0,
		"Year": 2025,
		"Week": 1,
		"AwayTeamID": "COLO2025",
		"HomeTeamID": "BAY2025"
	})
	print(game)
	
	ShowPreview(game)


func ShowPreview(g: Game):
	$Preview/Center/Logos/Home/VBox/Team.text = g.home_team.school.name
	$Preview/Center/Logos/Away/VBox/Team.text = g.away_team.school.name
	
	$Preview/Center/Logos/Home/VBox/Mascot.text = g.home_team.school.mascot
	$Preview/Center/Logos/Away/VBox/Mascot.text = g.away_team.school.mascot
	
	$Preview/Center/Logos/Home/VBox/TextureRect.texture = g.home_team.school.logo
	$Preview/Center/Logos/Away/VBox/TextureRect.texture = g.away_team.school.logo
	
	$Preview/Center/Text/VBox/Date.text = "Week %d, 2025" % g.week


func _on_start_game_pressed() -> void:
	$Preview.hide()
	$Background.hide()
	$Scoreboard.show()
