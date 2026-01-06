extends RefCounted
class_name Team


var id: String
var school: School
var year: int


static func FromDict(d: Dictionary) -> Team:
	var t = Team.new()
	
	t.id = d["ID"]
	t.school = School.FromDB(d["SchoolID"])
	t.year = int(d["Year"])
	
	return t


static func FromDB(team_id: String) -> Team:
	return FromDict(
		Database.GetItem("Teams", team_id)
	)


func GetRoster() -> Array[Player]:
	var players = Database.Query("""
		SELECT *
		FROM Players
		WHERE SchoolID = '%s'
	""" % school.id)
	
	var roster: Array[Player] = []
	for d: Dictionary in players:
		roster.append(Player.FromDict(d))
	
	return roster


func GetDepthChart() -> DepthChart:
	return DepthChart.FromDB(id)
