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
