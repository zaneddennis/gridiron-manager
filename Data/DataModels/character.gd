extends RefCounted
class_name Character


var id: int
var first: String
var last: String
var birth: int


static func FromDict(d: Dictionary) -> Character:
	var c = Character.new()
	
	c.id = d["ID"]
	c.first = d["First"]
	c.last = d["Last"]
	c.birth = int(d["Birth"])
	
	return c

func ToDict() -> Dictionary:
	return {
		"ID": id,
		"First": first,
		"Last": last,
		"Birth": birth
	}


static func FromDB(character_id: int) -> Character:
	return Character.FromDict(Database.GetItem("Characters", character_id))

func AddToDB():
	Database.AddRow(
		"Characters",
		ToDict()
	)
