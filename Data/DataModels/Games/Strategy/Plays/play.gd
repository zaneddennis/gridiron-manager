extends RefCounted
class_name Play


var name: String
var formation: Formation

func _init(n: String, f: Formation) -> void:
	name = n
	formation = f


# what players are on the field when this play is run
func GetLineup(depth_chart: DepthChart) -> Array[SimulationPlayer]:
	var result = [] as Array[SimulationPlayer]
	for slot: DepthChartSlot in formation.lineup:
		var li: LineupInstruction = formation.lineup[slot]
		result.append(
			SimulationPlayer.new(depth_chart.GetPlayer(slot), li)
		)
	
	return result
