extends Node2D
class_name GamedayV2


var game: Game
var gs: GameSimulator


func _ready() -> void:	
	if get_tree().current_scene == self:
		ActivateDebug()
		var gs_full_sim = GameSimulator.new(Game.FromDict({
			"ID": -1, "Year": 2025,
			"Week": 0,
			"AwayTeamID": "COLO2025",
			"HomeTeamID": "BAY2025"
		}), true)
		gs_full_sim.Simulate()


func ActivateDebug():
	Database.Create("_debug")
	Database.InitializeDebug()
	
	#var colorado = Team.FromDB("COLO2025")
	#var baylor = Team.FromDB("BAY2025")
	
	game = Game.FromDict({
		"ID": 0,
		"Year": 2025,
		"Week": 0,
		"AwayTeamID": "COLO2025",
		"HomeTeamID": "BAY2025"
	})
	
	$UI.ShowPreview(game)


func StartGame():
	gs = GameSimulator.new(game, true)
	$Field.Activate()
	RenderCallPlay()


func RenderCallPlay():
	PlaceBall()
	$UI.ShowCallPlay(gs.default_strategy)


func PlaceBall():
	var pos = FieldToWorld(gs.ball_on)
	$Ball.position = pos
	$Ball.show()


func FieldToWorld(yard: float) -> Vector2:
	return Vector2(
		0,
		(50.0 - yard) * $Field.DISPLAY_SCALE
	)


func _on_start_game_pressed() -> void:
	StartGame()
