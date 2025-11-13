extends Page
class_name StandingsPage


@export var StandingsWidgetScene: PackedScene


func Activate(ag: ActiveGame):
	super(ag)
	
	for n: Node in $Panel/VBoxContainer/ScrollContainer/GridContainer.get_children():
		if not "Spacer" in n.name:
			n.queue_free()
	
	var conferences: Array[Conference] = Conference.GetAll("Name")
	for conf in conferences:
		var conf_table = Database.Query("""
			SELECT *
			FROM Standings_v
			WHERE Year = %d AND ConferenceID = '%s'
		""" % [ag.current_date.year, conf.id])
		var num_teams = len(conf_table)
		
		var p = Panel.new()
		p.size_flags_horizontal = Control.SIZE_EXPAND | Control.SIZE_SHRINK_CENTER
		p.custom_minimum_size = Vector2(444, 4 + (2 + num_teams) * 24)
		$Panel/VBoxContainer/ScrollContainer/GridContainer.add_child(p)
		
		var w: StandingsWidget = StandingsWidgetScene.instantiate()
		w.Render(conf_table, conf.name)
		p.add_child(w)
