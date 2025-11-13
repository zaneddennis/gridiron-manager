extends VBoxContainer
class_name NextGameWidget


func Render(g: Dictionary):
	
	if g:
		var away_school = School.FromDB(g["AwaySchoolID"])
		var home_school = School.FromDB(g["HomeSchoolID"])
	
		$HBox/Away/School.text = away_school.name
		$HBox/Away/Mascot.text = away_school.mascot
		$HBox/Away/Panel/Logo.texture = away_school.logo
	
		$HBox/Home/School.text = home_school.name
		$HBox/Home/Mascot.text = home_school.mascot
		$HBox/Home/Panel/Logo.texture = home_school.logo
	
		$Conference.text = "[Non-Conference]" if g["GameConference"] == "-" else g["GameConference"] + " Conference"
	else:
		$HBox/Away/School.text = "???"
		$HBox/Away/Mascot.text = ""
		$HBox/Away/Panel/Logo.texture = null
	
		$HBox/Home/School.text = "???"
		$HBox/Home/Mascot.text = ""
		$HBox/Home/Panel/Logo.texture = null
	
		$Conference.text = ""
