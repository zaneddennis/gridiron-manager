extends RefCounted
class_name Player


var id: int
var character: Character
var jersey: int  # 0-99

enum POSITION{QB, RB, WR, TE, OT, OG, C, DT, EDGE, LB, CB, S}
var position: POSITION
var skill: float


static func FromDict(d: Dictionary) -> Player:
	var p = Player.new()
	
	p.id = d["ID"]
	p.character = Character.FromDB(d["CharacterID"])
	p.jersey = d["Jersey"]
	
	p.position = POSITION.values()[POSITION.keys().find(d["Position"])]
	p.skill = d["Skill"]
	
	return p


static func FromDB(player_id: int):
	return FromDict(
		Database.GetItem("Players", player_id)
	)


func _to_string() -> String:
	return "<Player:%d>" % id
