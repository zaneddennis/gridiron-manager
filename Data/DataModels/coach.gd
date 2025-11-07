extends RefCounted
class_name Coach


var id: int
var character: Character


static func FromDict(d: Dictionary) -> Coach:
	var c = Coach.new()
	
	c.id = d["ID"]
	c.character = Character.FromDB(d["CharacterID"])
	
	return c

func ToDict() -> Dictionary:
	return {
		"ID": id,
		"CharacterID": character.id
	}


static func FromDB(coach_id: int) -> Coach:
	return Coach.FromDict(Database.GetItem("Coaches", coach_id))

func AddToDB():
	Database.AddRow(
		"Coaches",
		ToDict()
	)
