extends CanvasLayer
class_name GamedayUI


func Clear():
	$Background.hide()
	$Preview.hide()
	$Scoreboard.hide()
	#$CallPlay.hide()


func ShowPreview(g: Game):
	$Preview/Center/Logos/Home/VBox/Team.text = g.home_team.school.name
	$Preview/Center/Logos/Away/VBox/Team.text = g.away_team.school.name
	
	$Preview/Center/Logos/Home/VBox/Mascot.text = g.home_team.school.mascot
	$Preview/Center/Logos/Away/VBox/Mascot.text = g.away_team.school.mascot
	
	$Preview/Center/Logos/Home/VBox/TextureRect.texture = g.home_team.school.logo
	$Preview/Center/Logos/Away/VBox/TextureRect.texture = g.away_team.school.logo
	
	$Preview/Center/Text/VBox/Date.text = "Week %d, 2025" % g.week
	
	Clear()
	$Background.show()
	$Preview.show()


func ShowCallPlay(st: Strategy):
	#$CallPlay/Panel/OffensePersonnel.Activate(st)
	$CallPlay.Activate(st)
	
	Clear()
	$Scoreboard.show()
	$CallPlay.show()
