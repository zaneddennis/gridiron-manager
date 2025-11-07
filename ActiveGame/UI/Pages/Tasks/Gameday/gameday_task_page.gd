extends TaskPage
class_name GamedayTaskPage


@export var BoxScoreSummaryWidgetScene: PackedScene

var games: Array[Game] = []


func Activate(ag: ActiveGame):
	super(ag)
	
	for n in $Panel/ScrollBox/VBox/GridBox.get_children():
		n.queue_free()
	
	var query = Database.Query("""
	SELECT
		ID, Year, Week,
		AwayTeamID, HomeTeamID, AwaySchoolID, HomeSchoolID,
		CASE WHEN AwayConferenceID = HomeConferenceID THEN HomeConferenceID ELSE '' END AS Conference
	FROM GamesFull_v
	WHERE Year = %d AND Week = %d
	""" % [ag.current_date.year, ag.current_date.week])
	
	for d: Dictionary in query:
		var g = Game.FromDict(d)
		
		var scores = SimulateGame()
		g.away_score = scores[0]
		g.home_score = scores[1]
		
		games.append(g)
		
		var widget: BoxScoreSummaryWidget = BoxScoreSummaryWidgetScene.instantiate()
		widget.Activate(g)
		$Panel/ScrollBox/VBox/GridBox.add_child(widget)
	
	$Panel/ScrollBox.scroll_vertical = 0


func SimulateGame() -> Array[int]:
	var away_score = max(7 * roundi(randfn(3.5, 1)), 0)
	var home_score = max(7 * roundi(randfn(3.5, 1)), 0)
	if away_score == home_score:
		home_score += 3
	
	return [away_score, home_score]


func RecordGameResults():
	for g in games:
		g.UpdateDB()


func _on_complete_pressed() -> void:
	RecordGameResults()
	task_completed.emit(self)
