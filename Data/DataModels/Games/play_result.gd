extends RefCounted
class_name PlayResult


var offense_play: OffensePlay
var defense_play: DefensePlay

var yards: int
var seconds: int

var description: String


func _init(op: OffensePlay, dp: DefensePlay, y: int, s: int, d: String) -> void:
	offense_play = op
	defense_play = dp
	yards = y
	seconds = s
	description = d
