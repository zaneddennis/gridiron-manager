extends RefCounted
class_name DepthChartSlot


var position: Player.POSITION
var depth: int


func _init(p: Player.POSITION, d: int) -> void:
	position = p
	depth = d


func _to_string() -> String:
	return "<DepthChartSlot:%s:%d>" % [Player.POSITION.keys()[position], depth]
