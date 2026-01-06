extends RefCounted
class_name LineupInstruction


enum ROLE{
	C, OG, OT,
	QBU, QBS,
	FB, TB, RBS, RBP,
	# WRs
	TE, HBACK,
	NT, DTS, DTW,
	DES, DEW,
	SAM, MIKE, WILL,
	STAR, JACK, FS
}

const OFFSETS = {  # yards
	ROLE.C: Vector2(0, 1),
	ROLE.OG: Vector2(2, 1),
	ROLE.OT: Vector2(4, 1),
	ROLE.QBU: Vector2(0, 2),
	ROLE.QBS: Vector2(0, 5),
	ROLE.FB: Vector2(0, 3),
	ROLE.TB: Vector2(0, 5),
	ROLE.RBS: Vector2(2, 5),
	ROLE.RBP: Vector2(0, 8),
	# WRs
	ROLE.TE: Vector2(6, 1),
	ROLE.HBACK: Vector2(3, 3)
}

var role: ROLE
var side: int = 0  # {-1, 0, 1}


func _init(r: ROLE, s: int = 0) -> void:
	role = r
	side = s


func GetAbsolutePos(_strong_side: int = 1) -> Vector2:
	var offset = OFFSETS[role]
	offset.x *= side
	
	return offset

func GetDisplayChar() -> String:
	return [
		"C", "G", "T",
		"Q", "Q",
		"F", "R", "R", "R",
		"Y", "Y",
		"T", "T", "T",
		"E", "E",
		"S", "M", "W",
		"$", "J", "F"
	][role]


func _to_string() -> String:
	return "<LineupInstruction:%s:%s>" % [
		ROLE.keys()[role],
		["L", "C", "R"][side+1]
	]
