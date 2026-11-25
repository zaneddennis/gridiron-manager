extends OffensePlay
class_name PassPlay


enum ROUTE{  # will probably expand this into a full class at some point?
	SCREEN,  # 0
	FLAT,  # 1
	SLANT,  # 2
	COMEBACK,  # 3
	CURL,  # 4
	OUT,  # 5
	DIG,  # 6
	CORNER,  # 7
	POST,  # 8
	GO  # 9
}


var routes: Dictionary[int, ROUTE]


func _init(n: String, f: Formation, r: Dictionary[int, ROUTE]) -> void:
	super(n, f)
	routes = r
