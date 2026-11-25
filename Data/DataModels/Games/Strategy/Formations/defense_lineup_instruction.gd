extends LineupInstruction
class_name DefenseLineupInstruction

# 1  == strong
# -1 == weak
const STRONGNESS = {
	ROLE.NT: 0,
	ROLE.DTS: 1,
	ROLE.DTW: -1,
	ROLE.DES: 1,
	ROLE.DEW: -1,
	ROLE.SAM: 1,
	ROLE.MIKE: 0,
	ROLE.WILL: -1,
	ROLE.STAR: 1,
	ROLE.JACK: -1,
	ROLE.FS: 0
}

const DEPTH = {
	ROLE.SAM: 4,
	ROLE.MIKE: 4,
	ROLE.WILL: 4,
	ROLE.STAR: 3,
	ROLE.JACK: 3,
	ROLE.FS: 10
}


func _init(r: ROLE, g: GAP) -> void:
	role = r
	gap = g


func GetAbsolutePos(strong_side: int = 1) -> Vector2:
	var offset = Vector2(GAP_POS[gap], 1.25)
	offset.x *= strong_side * STRONGNESS[role]
	if role in DEPTH:
		offset.y = DEPTH[role]
	offset.y *= -1
	return offset


func _to_string() -> String:
	return "<DefenseLineupInstruction:%s>" % [
		ROLE.keys()[role]
	]
