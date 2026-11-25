extends Play
class_name OffensePlay


func _init(n: String, f: Formation) -> void:
	super(n, f)


func _to_string() -> String:
	return "<OffensePlay:%s:%s>" % [name, formation.name]
