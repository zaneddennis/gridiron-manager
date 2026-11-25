extends RefCounted
class_name LineupInstruction


# H == Hybrid (Star/Jack)
enum GAP {ZERO, A, B, C, D, SPILL}
const GAP_POS = {
	GAP.ZERO: 0,
	GAP.A: 1,
	GAP.B: 3,
	GAP.C: 5,
	GAP.D: 7,
	GAP.SPILL: 9,
}
var gap: GAP


enum ROLE{
	C, OG, OT,
	QBU, QBS,
	FB, TB, RBS, RBP,
	WRX, WRZ, WRA, WRB,
	TE, HBACK,
	NT, DTS, DTW,
	DES, DEW,
	SAM, MIKE, WILL,
	STAR, JACK, FS
}

const OFFSETS = {  # yards
	ROLE.C: Vector2(0, 0.5),
	ROLE.OG: Vector2(2, 1),
	ROLE.OT: Vector2(4, 1),
	ROLE.QBU: Vector2(0, 2),
	ROLE.QBS: Vector2(0, 5),
	ROLE.FB: Vector2(0, 3.5),
	ROLE.TB: Vector2(0, 5),
	ROLE.RBS: Vector2(2, 5),
	ROLE.RBP: Vector2(0, 8),
	ROLE.WRX: Vector2(-16, 1),
	ROLE.WRZ: Vector2(16, 2),
	ROLE.WRA: Vector2(-12, 2),
	ROLE.WRB: Vector2(12, 2),
	ROLE.TE: Vector2(6, 1.25),
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
		"X", "Z", "A", "B",
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
