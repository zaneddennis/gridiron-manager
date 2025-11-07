extends ScrollContainer
class_name ScheduleWidget


@export var RowScene: PackedScene

var query2 = """
SELECT
	Week, AwayTeamID, HomeTeamID, AwayScore, HomeScore, AwaySchoolID, HomeSchoolID,
	CASE WHEN AwayConferenceID = HomeConferenceID THEN HomeConferenceID ELSE '-' END AS Conference
FROM GamesFull_v
WHERE Year = %d AND '%s' IN (AwaySchoolID, HomeSchoolID)
ORDER BY Week
"""


func Render(school_id: String, year: int):
	for n: Node in $VBox.get_children():
		n.queue_free()
	
	var week_dicts = []
	week_dicts.resize(Timestamp.PHASE_LENGTH[Timestamp.PHASE.REGULAR_SEASON])
	
	#var user_team_id: String = "TBU2025"
	#var team_id: String = school_id + str(year)
	var data = Database.Query(query2 % [year, school_id])
	for game: Dictionary in data:
		week_dicts[game["Week"] - 1] = game
	
	for d in week_dicts:
		var r = RowScene.instantiate()
		if d:
			r.get_node("Conference").text = d["Conference"]
			r.get_node("Bye").hide()
			
			if d["AwaySchoolID"] == school_id:
				var opp = School.FromDB(d["HomeSchoolID"])
				r.get_node("Vs").text = "@"
				r.get_node("Opponent").text = opp.id
				r.get_node("OppLogo").texture = opp.logo
				if d["AwayScore"]:
					r.get_node("Score").text = "%d - %d" % [d["AwayScore"], d["HomeScore"]]
					if d["AwayScore"] > d["HomeScore"]:
						r.get_node("Result").text = "W"
					else:
						r.get_node("Result").text = "L"
				else:
					r.get_node("Result").text = ""
					r.get_node("Score").text = ""
			else:
				var opp = School.FromDB(d["AwaySchoolID"])
				r.get_node("Vs").text = "vs"
				r.get_node("Opponent").text = opp.id
				r.get_node("OppLogo").texture = opp.logo
				if d["AwayScore"]:
					r.get_node("Score").text = "%d - %d" % [d["HomeScore"], d["AwayScore"]]
					if d["AwayScore"] > d["HomeScore"]:
						r.get_node("Result").text = "L"
					else:
						r.get_node("Result").text = "W"
				else:
					r.get_node("Result").text = ""
					r.get_node("Score").text = ""
		else:
			for n: Control in r.get_children():
				n.hide()
			r.get_node("Bye").show()
			
		$VBox.add_child(r)
