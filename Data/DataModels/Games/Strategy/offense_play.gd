extends RefCounted
class_name OffensePlay


#var formation: OffenseFormation
var name: String

# outcome factors
# ???


func _init(n: String) -> void:
	name = n


func _to_string() -> String:
	return "<OffensePlay:%s>" % name
