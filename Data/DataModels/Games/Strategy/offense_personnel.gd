extends RefCounted
class_name OffensePersonnel

var rbs: int
var tes: int


func _init(r: int, t: int) -> void:
	rbs = r
	tes = t


func _to_string() -> String:
	return "<OffensePersonnel:%d%d>" % [rbs, tes]
