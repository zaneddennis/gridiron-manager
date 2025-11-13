extends TaskPage
class_name ConferenceChampionsTaskPage


@export var SummaryWidgetScene: PackedScene


func Activate(ag: ActiveGame):
	super(ag)
	
	for n: Node in $Panel/ScrollBox/VBox/GridContainer.get_children():
		if not "Spacer" in n.name:
			n.queue_free()
	
	var conferences: Array[Conference] = Conference.GetAll("Name")
	for conf in conferences:
		var w: ConferenceChampionSummaryWidget = SummaryWidgetScene.instantiate()
		
		w.Activate(conf, ag.current_date.year)
		$Panel/ScrollBox/VBox/GridContainer.add_child(w)


func _on_complete_pressed() -> void:
	task_completed.emit(self)
