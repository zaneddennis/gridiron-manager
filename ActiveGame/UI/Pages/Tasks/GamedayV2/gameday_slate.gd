extends Panel


func Activate(user_game: Game, other_games: Array[Game]):
	#$VBox/UserGame.visible = true if user_game else false
	#$VBox/UserBye.visible = !$VBox/UserGame.visible
	
	if user_game:
		$VBox/UserGame.Activate(user_game)
		$VBox/UserBye.hide()
	
	else:
		$VBox/UserBye.show()
		$VBox/UserGame.hide()
		
		if len(other_games) > 0 and other_games[0].away_score:
			$VBox/UserBye/Buttons/Sim.hide()
			$VBox/UserBye/Buttons/Complete.show()
		else:
			$VBox/UserBye/Buttons/Sim.show()
			$VBox/UserBye/Buttons/Complete.hide()
	
	show()
