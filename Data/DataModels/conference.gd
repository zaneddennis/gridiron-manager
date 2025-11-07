extends RefCounted
class_name Conference


var id: String
var name: String
var league: String


static func GetAll(order_by: String = ""):
	var ob = "ORDER BY %s" % order_by if order_by else ""
	var dicts = Database.Query("SELECT * FROM Conferences %s" % ob)
	return dicts.map(func(d: Dictionary): return Conference.FromDict(d))


static func FromDB(conference_id: String) -> Conference:
	var d = Database.GetItem("Conferences", conference_id)
	return FromDict(d)


static func FromDict(d: Dictionary) -> Conference:
	var c = Conference.new()
	
	c.id = d["ID"]
	c.name = d["Name"]
	c.league = d["League"]
	
	return c
