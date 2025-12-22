extends Control


var selected_op: OffensePersonnel


func Activate(st: Strategy):
	$Panel/OffensePersonnel.Activate(st)


func _on_offense_personnel_selected(op: OffensePersonnel) -> void:
	selected_op = op
	print("User selected offensive personnel: ", op)
