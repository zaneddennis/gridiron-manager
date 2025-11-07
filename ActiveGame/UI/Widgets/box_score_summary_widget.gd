extends Panel
class_name BoxScoreSummaryWidget


func Activate(g: Game):
	#var away_school = School.FromDB(d["AwaySchoolID"])
	#var home_school = School.FromDB(d["HomeSchoolID"])
	
	$VBox/Away/School.text = g.away_team.school.name
	$VBox/Home/School.text = g.home_team.school.name
	
	$VBox/Away/Logo.texture = g.away_team.school.logo
	$VBox/Home/Logo.texture = g.home_team.school.logo
	
	$VBox/Footer/HBox/Conf.text = ""
	
	#$VBox/Away/Score.text = str(d["AwayScore"])
	#$VBox/Home/Score.text = str(d["HomeScore"])
	$VBox/Away/Score.text = str(g.away_score)
	$VBox/Home/Score.text = str(g.home_score)
