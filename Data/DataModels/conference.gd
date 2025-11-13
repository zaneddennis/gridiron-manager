extends RefCounted
class_name Conference


var id: String
var name: String
var league: String


static func GetAll(order_by: String = "") -> Array[Conference]:
	var ob = "ORDER BY %s" % order_by if order_by else ""
	var dicts = Database.Query("SELECT * FROM Conferences %s" % ob)
	var result: Array[Conference]
	result.assign(dicts.map(func(d: Dictionary): return Conference.FromDict(d)))
	return result


static func FromDB(conference_id: String) -> Conference:
	var d = Database.GetItem("Conferences", conference_id)
	return FromDict(d)


static func FromDict(d: Dictionary) -> Conference:
	var c = Conference.new()
	
	c.id = d["ID"]
	c.name = d["Name"]
	c.league = d["League"]
	
	return c


func _to_string() -> String:
	return "<Conference:%s>" % id
