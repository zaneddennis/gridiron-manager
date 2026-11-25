extends Panel
class_name BoxScoreSummaryWidget


func Activate(g: Game):
	$VBox/Away/School.text = g.away_team.school.name
	$VBox/Home/School.text = g.home_team.school.name
	
	$VBox/Away/Logo.texture = g.away_team.school.logo
	$VBox/Home/Logo.texture = g.home_team.school.logo
	
	$VBox/Footer/HBox/Conf.text = ""
	
	if g.away_score or g.home_score:  # a game cannot end 0-0  TODO: add an actual field to Game for started/complete/etc
		$VBox/Away/Score.text = str(g.away_score)
		$VBox/Home/Score.text = str(g.home_score)
	else:
		$VBox/Away/Score.text = "-"
		$VBox/Home/Score.text = "-"
		
		$VBox/Footer/HBox/Final.text = ""
