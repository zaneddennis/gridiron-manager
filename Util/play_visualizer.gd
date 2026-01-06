extends Node2D


const DISPLAY_SCALE = 24.0  # px per yard


@export var PLAYER_INSTANCE: PackedScene

var off_pis  # TODO: HERE


func _ready() -> void:
	Database.Create("_debug")
	Database.InitializeDebug()
	
	var gs = GameSimulator.new(Game.FromDict({
			"ID": -1, "Year": 2025,
			"Week": 0,
			"AwayTeamID": "COLO2025",
			"HomeTeamID": "BAY2025"
	}), true)
	
	var default_strategy = Strategy.new()
	var off_play = default_strategy.offense_plays[0]  # HB Zone
	var def_play = default_strategy.defense_plays[0]  # 4-2-5 Base
	
	var ps = PlaySimulator.new(gs, off_play, def_play)
	
	LineUp(ps.off_players, ps.def_players)
	var ticks = ps.SimulatePlay()
	for tick in ticks:
		RenderTick(tick)
		await get_tree().create_timer(1.0).timeout


func LineUp(off_players: Array[SimulationPlayer], def_players: Array[SimulationPlayer]):
	for sp in off_players:
		var pi = PLAYER_INSTANCE.instantiate()
		$Players.add_child(pi)
		pi.position = sp.position * DISPLAY_SCALE
		pi.self_modulate = Color(0, 0, 1.0)
		pi.get_node("Label").text = sp.display_char
	
	for sp in def_players:
		var pi = PLAYER_INSTANCE.instantiate()
		$Players.add_child(pi)
		pi.position = sp.position * DISPLAY_SCALE
		pi.self_modulate = Color(1.0, 0, 0.0)
		pi.get_node("Label").text = sp.display_char


func RenderTick(tick: TickResult):
	print("Render Tick: %f - %f" % [tick.start_time, tick.start_time + PlaySimulator.TICK_LENGTH])
	
	# actions/statuses
	
	# end positions
