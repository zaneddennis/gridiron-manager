extends Panel
class_name ConferenceChampionSummaryWidget


func Activate(conf: Conference, year: int):
	var d = Database.Query("""
	SELECT *
	FROM (
		SELECT Year, ConferenceID, SchoolID, Wins, Losses, ConfWins, ConfLosses,
			ROW_NUMBER() OVER(PARTITION BY Year, ConferenceID) AS FinalRank
		FROM Standings_v
	)
	WHERE FinalRank = 1 AND ConferenceID = '%s' AND Year = %d
	""" % [conf.id, year])[0]
	
	var school = School.FromDB(d["SchoolID"])
	
	$HBox/VBox/Conference.text = conf.name.to_upper()
	$HBox/VBox/Team.text = school.name + " " + school.mascot
	$HBox/VBox/Record.text = "%d - %d (%d - %d)" % [d["Wins"], d["Losses"], d["ConfWins"], d["ConfLosses"]]
