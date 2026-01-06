extends RefCounted
class_name DepthChart


var _data: Dictionary[Player.POSITION, Array] = {}  # Array[Player]


static func FromDB(team_id: String):
	var q = Database.Query("SELECT * FROM DepthCharts WHERE TeamID = '%s'" % team_id)
	var dc = DepthChart.new()
	
	for row: Dictionary in q:
		var position = Player.POSITION[row["Position"]]
		if not position in dc._data:
			dc._data[position] = []
		dc._data[position].append(
			Player.FromDB(row["PlayerID"])
		)
	
	return dc


func GetPlayer(slot: DepthChartSlot) -> Player:
	return _data[slot.position][slot.depth-1]


func _to_string() -> String:
	var result = "<Depth Chart>\n"
	
	for p in Player.POSITION.keys():
		result += "\t%s: %s\n" % [
			p,
			_data[Player.POSITION[p]]
		]
	
	return result
