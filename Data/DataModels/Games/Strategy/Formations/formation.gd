extends RefCounted
class_name Formation


var name: String = ""
var lineup: Dictionary[DepthChartSlot, LineupInstruction]


func _init(n: String) -> void:
	name = n
