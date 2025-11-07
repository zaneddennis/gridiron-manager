extends RefCounted
class_name Game


var id: int
var year: int
var week: int

var away_team: Team
var home_team: Team

var away_score: int
var home_score: int


static func FromDict(d: Dictionary) -> Game:
	var g = Game.new()
	
	g.id = d["ID"]
	
	g.year = d["Year"]
	g.week = d["Week"]
	
	g.away_team = Team.FromDB(d["AwayTeamID"])
	g.home_team = Team.FromDB(d["HomeTeamID"])
	
	if "AwayScore" in d:
		g.away_score = d["AwayScore"]
		g.home_score = d["HomeScore"]
	
	return g


func ToDict() -> Dictionary:
	return {
		"ID": id,
		"Year": year,
		"Week": week,
		
		"AwayTeamID": away_team.id,
		"HomeTeamID": home_team.id,
		
		"AwayScore": away_score,
		"HomeScore": home_score
	}


func UpdateDB():
	Database.UpdateRow(
		"Games",
		id,
		ToDict()
	)
