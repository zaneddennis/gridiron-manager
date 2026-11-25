extends OffensePlay
class_name RunPlay


var ballcarrier_ix: int
var gap: LineupInstruction.GAP


func _init(
	n: String, f: Formation,
	b: int,
	g: LineupInstruction.GAP,
) -> void:
	super(n, f)
	ballcarrier_ix = b
	gap = g
