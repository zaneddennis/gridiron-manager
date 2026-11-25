extends HBoxContainer


func Activate(g: Game):
	show()
	
	var away_standings = Database.Query("""
		SELECT ConferenceID, Wins, Losses, ConfWins, ConfLosses, ConfRank
		FROM Standings_v
		WHERE SchoolID = '%s'
	""" % g.away_team.school.id)[0]
	$AwayText/Team.text = "%s %s" % [
		g.away_team.school.name,
		g.away_team.school.mascot
	]
	$AwayText/Record.text = "%d-%d (%d-%d)" % [
		away_standings["Wins"],
		away_standings["Losses"],
		away_standings["ConfWins"],
		away_standings["ConfLosses"]
	]
	var rank = away_standings["ConfRank"]
	$AwayText/Conference.text = "%d%s %s" % [
		rank,
		["", "st", "nd", "rd", "th"][rank if rank <= 4 else 4],
		away_standings["ConferenceID"]
	]
	$AwayLogo.texture = g.away_team.school.logo
	
	var home_standings = Database.Query("""
		SELECT ConferenceID, Wins, Losses, ConfWins, ConfLosses, ConfRank
		FROM Standings_v
		WHERE SchoolID = '%s'
	""" % g.home_team.school.id)[0]
	$HomeText/Team.text = "%s %s" % [
		g.home_team.school.name,
		g.home_team.school.mascot
	]
	$HomeText/Record.text = "%d-%d (%d-%d)" % [
		home_standings["Wins"],
		home_standings["Losses"],
		home_standings["ConfWins"],
		home_standings["ConfLosses"]
	]
	rank = away_standings["ConfRank"]
	$HomeText/Conference.text = "%d%s %s" % [
		rank,
		["", "st", "nd", "rd", "th"][rank if rank <= 4 else 4],
		home_standings["ConferenceID"]
	]
	$HomeLogo.texture = g.home_team.school.logo
	
	if g.away_score:
		$AwayScore.text = str(g.away_score)
		$AwayScore.show()
		$HomeScore.text = str(g.home_score)
		$HomeScore.show()
		
		$Buttons/Play.hide()
		#$Buttons/Sim.hide()
		$Buttons/Complete.show()
		
	else:
		$AwayScore.hide()
		$HomeScore.hide()
		
		$Buttons/Play.show()
		$Buttons/Complete.hide()
