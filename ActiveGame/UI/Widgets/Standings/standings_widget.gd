extends VBoxContainer
class_name StandingsWidget


@export var StandingsRowScene: PackedScene


func Render(conf_table: Array[Dictionary], conf_name: String):
	for n: Node in get_children():
		if "StandingsRow" in n.name:
			n.queue_free()
	
	$Title/Label.text = conf_name
	
	for d: Dictionary in conf_table:
		var row: HBoxContainer = StandingsRowScene.instantiate()
		row.get_node("Place").text = "  %d." % d["ConfRank"]
		
		row.get_node("School").text = d["SchoolID"]
		
		row.get_node("Record").text = "%d-%d (%.2f)" % [d["Wins"], d["Losses"], d["Pct"]]
		row.get_node("ConfRecord").text = "%d-%d (%.2f)" % [d["ConfWins"], d["ConfLosses"], d["ConfPct"]]
		
		add_child(row)
