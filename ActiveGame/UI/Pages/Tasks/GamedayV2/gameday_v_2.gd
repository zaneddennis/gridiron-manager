extends Node2D
class_name GamedayV2


@export var IN_GAME_PLAYER: PackedScene
@export var ASSIGNMENT_RUN: PackedScene
@export var ASSIGNMENT_PASS_ROUTES: Array[PackedScene]


var gs: GameSimulator
var user_side: GameSimulator.SIDE

var user_game: Game
var other_games: Array[Game] = []


func _ready() -> void:
	if TransitionManager.slot:
		Activate()
	else:
		ActivateDebug()


func ActivateDebug():
	Database.Create("_debug")
	Database.InitializeDebug()
	
	user_game = Game.FromDict({
		"ID": 0,
		"Year": 2025,
		"Week": 0,
		"AwayTeamID": "COLO2025",
		"HomeTeamID": "BAY2025"
	})
	user_side = GameSimulator.SIDE.HOME
	other_games = []
	
	$UI.show()
	$UI.ShowSlate(user_game, other_games)


func Activate():
	# get games
	user_game = null
	other_games = []
	var query = Database.Query("""
	SELECT
		ID, Year, Week,
		AwayTeamID, HomeTeamID, AwaySchoolID, HomeSchoolID,
		CASE WHEN AwayConferenceID = HomeConferenceID THEN HomeConferenceID ELSE '' END AS Conference
	FROM GamesFull_v
	WHERE Year = %d AND Week = %d
	""" % [TransitionManager.current_date.year, TransitionManager.current_date.week])
	
	var user_school_id = Database.Query("""
	SELECT ID
	FROM Schools
	WHERE HeadCoachID = %d
	""" % Constants.USER_ID)[0]["ID"]
	
	for d: Dictionary in query:
		var g = Game.FromDict(d)
		
		#if user_school_id in [g.away_team.school.id, g.home_team.school.id]:
		#	user_game = g
		#else:
		#	other_games.append(g)
		match user_school_id:
			g.away_team.school.id:
				user_game = g
				user_side = GameSimulator.SIDE.AWAY
			g.home_team.school.id:
				user_game = g
				user_side = GameSimulator.SIDE.HOME
			_:
				other_games.append(g)
	
	$UI.show()
	$UI.ShowSlate(user_game, other_games)


# main loop of the game
func StartGame():
	$UI/InGame.ShowGame()
	
	gs = GameSimulator.new(user_game, true)
	gs.StartGame()
	
	$Field.Activate()
	
	while true:
		if gs.UpdateQuarters() == "END":
			$UI/InGame/CallPlay.hide()
			break
		else:
			RenderPrePlay()
			var playcalls = await $UI/InGame/CallPlay.plays_called
			var result = gs.SimulatePlay(playcalls[0], playcalls[1])
			RenderPostPlay(result)
			await $UI/InGame/PlayDescription/HBoxContainer/NextPlay.pressed
	
	RenderConclusion()


func RenderPrePlay():
	for n: Node in $Players.get_children():
		n.queue_free()
	PlaceBall(true)
	$Ball/Camera2D.position = Vector2(0, $Field.DISPLAY_SCALE * 2.5)
	$UI/InGame.ShowCallPlay(gs, user_side)


func RenderOffenseFormation(of: OffenseFormation):
	for n: Node in $Players.get_children():
		n.queue_free()
	
	print("Rendering: ", of)
	var dc: DepthChart = user_game.home_team.GetDepthChart() #TODO: home/away
	#print("Depth Chart: ", dc)
	for slot in of.lineup:
		var li: LineupInstruction = of.lineup[slot]
		print("\t", slot, ": ", li)
		var p: Player = dc.GetPlayer(slot)
		print("\t\t", p, "\t", p.character.last, "\t#", p.jersey)
		print("\t\t", li.GetAbsolutePos())
		var igp: InGamePlayer = IN_GAME_PLAYER.instantiate()
		$Players.add_child(igp)
		igp.global_position = FieldToWorld(gs.ball_on) + li.GetAbsolutePos() * $Field.DISPLAY_SCALE
		igp.Activate(p, user_game.home_team)


func RenderOffensePlay(op: OffensePlay):
	for n: Node in $Assignments.get_children():
		n.queue_free()
	
	if op is RunPlay:
		var a: Line2D = ASSIGNMENT_RUN.instantiate()
		$Assignments.add_child(a)
		var pos = op.formation.lineup.values()[op.ballcarrier_ix].GetAbsolutePos()
		a.global_position = FieldToWorld(gs.ball_on) + pos * $Field.DISPLAY_SCALE
	elif op is PassPlay:
		for p_ix in op.routes:
			var r_ix = op.routes[p_ix]
			var a: Line2D = ASSIGNMENT_PASS_ROUTES[r_ix].instantiate()
			$Assignments.add_child(a)
			var pos = op.formation.lineup.values()[p_ix].GetAbsolutePos()
			a.global_position = FieldToWorld(gs.ball_on) + (pos * $Field.DISPLAY_SCALE) - Vector2(0, 16)
			a.scale.x *= (-1 * sign(a.global_position.x))


func RenderPostPlay(result: PlayResult):
	$UI/InGame/CallPlay.hide()
	
	var prev_camera_pos = $Ball/Camera2D.global_position
	PlaceBall(false)
	$Ball/Camera2D.global_position = prev_camera_pos
	
	$UI/InGame/PlayDescription/HBoxContainer/Label.text = result.description
	$UI/InGame/PlayDescription.show()


func RenderConclusion():
	$UI/InGame.ShowConclusion(user_game, gs)


func PlaceBall(update_lines: bool = true):
	var pos = FieldToWorld(gs.ball_on)
	$Ball.position = pos
	$Ball.show()
	
	if update_lines:
		$Field/LOS.position = pos
		var ltg_pos = FieldToWorld(gs.ball_on + gs.to_go)
		$Field/LTG.position = ltg_pos


func FieldToWorld(yard: float) -> Vector2:
	return Vector2(
		0,
		(50.0 - yard) * $Field.DISPLAY_SCALE
	)


func SimulateOtherGames():
	for g: Game in other_games:
		print("\t", g)
		var gs_other = GameSimulator.new(g)
		gs_other.SimulateGame()
		g.away_score = gs_other.away_score
		g.home_score = gs_other.home_score


func _on_play_user_game_pressed() -> void:
	$UI.ShowInGame(user_game)

func _on_simulate_week_pressed() -> void:
	SimulateOtherGames()
	$UI.ShowSlate(user_game, other_games)

func _on_complete_week_pressed() -> void:
	for g: Game in other_games:
		g.UpdateDB()
	if user_game:
		user_game.UpdateDB()
	
	TransitionManager.GamedayToAG()


func _on_start_game_pressed() -> void:
	StartGame()

func _on_complete_game_pressed() -> void:
	user_game.away_score = gs.away_score
	user_game.home_score = gs.home_score
	
	SimulateOtherGames()
	
	$UI.ShowSlate(user_game, other_games)

func _on_offense_formation_selected(of: OffenseFormation) -> void:
	#RenderOffenseFormation(of)
	pass

func _on_offense_formation_hovered(of: OffenseFormation):
	RenderOffenseFormation(of)

func _on_offense_play_hovered(op: OffensePlay):
	RenderOffensePlay(op)
