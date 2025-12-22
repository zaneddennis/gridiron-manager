extends RefCounted
class_name DefensePlay


var name: String


func _init(n: String) -> void:
	name = n


func _to_string() -> String:
	return "<DefensePlay:%s>" % [name]
