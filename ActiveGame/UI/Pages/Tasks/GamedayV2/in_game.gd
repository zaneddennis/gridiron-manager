extends Control


func Activate(g: Game):
	show()
	ShowPreview(g)


func Clear():
	for n: Node in get_children():
		n.hide()


func ShowPreview(g: Game):
	Clear()
	
	$Preview/Center/Logos/Home/VBox/Team.text = g.home_team.school.name
	$Preview/Center/Logos/Away/VBox/Team.text = g.away_team.school.name
	
	$Preview/Center/Logos/Home/VBox/Mascot.text = g.home_team.school.mascot
	$Preview/Center/Logos/Away/VBox/Mascot.text = g.away_team.school.mascot
	
	$Preview/Center/Logos/Home/VBox/TextureRect.texture = g.home_team.school.logo
	$Preview/Center/Logos/Away/VBox/TextureRect.texture = g.away_team.school.logo
	
	$Preview/Center/Text/VBox/Date.text = "Week %d, 2025" % g.week
	
	$Background.show()
	$Preview.show()


func ShowConclusion(g: Game, gs: GameSimulator):
	Clear()
	
	$Conclusion/Center/Panel/VBox/Scores/AwayLogo.texture = g.away_team.school.logo
	$Conclusion/Center/Panel/VBox/Scores/AwayTexts/School.text = g.away_team.school.name
	$Conclusion/Center/Panel/VBox/Scores/AwayTexts/Mascot.text = g.away_team.school.mascot
	# TODO: records
	
	$Conclusion/Center/Panel/VBox/Scores/AwayScore.text = str(gs.away_score)
	$Conclusion/Center/Panel/VBox/Scores/HomeScore.text = str(gs.home_score)
	
	$Conclusion/Center/Panel/VBox/Scores/HomeLogo.texture = g.home_team.school.logo
	$Conclusion/Center/Panel/VBox/Scores/HomeTexts/School.text = g.home_team.school.name
	$Conclusion/Center/Panel/VBox/Scores/HomeTexts/Mascot.text = g.home_team.school.mascot
	# TODO: records
	
	$Background.show()
	$Conclusion.show()


func ShowGame():
	Clear()
	
	$Scoreboard.show()


func ShowCallPlay(gs: GameSimulator, side: GameSimulator.SIDE):
	Clear()
	UpdateScoreboard(gs)
	#$CallPlay.show()
	$CallPlay.Activate(gs, side)


func UpdateScoreboard(gs: GameSimulator):
	$Scoreboard/HBox/Away.text = gs.teams[0].school.id
	$Scoreboard/HBox/Home.text = gs.teams[1].school.id
	
	$Scoreboard/HBox/AwayScore.text = "%02d" % gs.away_score
	$Scoreboard/HBox/HomeScore.text = "%02d" % gs.home_score
	
	$Scoreboard/HBox/Center/Quarter.text = "Q%d" % gs.quarter
	@warning_ignore("integer_division")
	$Scoreboard/HBox/Center/Clock.text = "%d:%02d" % [gs.clock/60, gs.clock % 60]
	
	if gs.offense == gs.SIDE.AWAY:
		$Scoreboard/HBox/AwayBall/TextureRect.show()
		$Scoreboard/HBox/HomeBall/TextureRect.hide()
	elif gs.offense == gs.SIDE.HOME:
		$Scoreboard/HBox/AwayBall/TextureRect.hide()
		$Scoreboard/HBox/HomeBall/TextureRect.show()
	else:
		assert(false)
	
	var down = str(gs.down) + ["", "st", "nd", "rd", "th"][gs.down]
	$Scoreboard/DownDistance/Label.text = "%s & %d" % [down, gs.to_go]
	
	$Scoreboard.show()
