extends RefCounted
class_name SimulationPlayer


var player: Player
var li: LineupInstruction


func _init(p: Player, l: LineupInstruction) -> void:
	player = p
	li = l
