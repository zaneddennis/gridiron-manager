extends CanvasLayer
class_name GamedayUI


@export var BoxScoreSummaryWidgetScene: PackedScene


func Clear():
	$Background.hide()
	$Preview.hide()
	$Scoreboard.hide()
	#$CallPlay.hide()


func ShowSlate(user_game: Game, other_games: Array[Game]):
	$InGame.hide()
	$Slate.Activate(user_game, other_games)
	
	# TODO: move this inside Slate.Activate()
	for n: Node in $Slate/VBox/HBox/ScrollContainer/VBox/GridBox.get_children():
		n.queue_free()
	
	for g: Game in other_games:
		var widget: BoxScoreSummaryWidget = BoxScoreSummaryWidgetScene.instantiate()
		widget.Activate(g)
		$Slate/VBox/HBox/ScrollContainer/VBox/GridBox.add_child(widget)


func ShowInGame(g: Game):
	$Slate.hide()
	$InGame.Activate(g)
