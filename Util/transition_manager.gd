extends Node
# global TransitionManager


var slot: String = ""
enum TRANSITION_TYPE{  # TODO: use this system for other transitions
	AG_TO_GAMEDAY, GAMEDAY_TO_AG
}
var transition_type: TRANSITION_TYPE


# Main Menu -> Active Game
var first_time_new_game: bool = false


# Active Game -> Gameday
var current_date: Timestamp


func AGToGameday(ag: ActiveGame):
	transition_type = TRANSITION_TYPE.AG_TO_GAMEDAY
	
	current_date = ag.current_date
	
	get_tree().change_scene_to_file("res://ActiveGame/UI/Pages/Tasks/GamedayV2/gameday_v2.tscn")


func GamedayToAG():
	transition_type = TRANSITION_TYPE.GAMEDAY_TO_AG
	
	current_date.task += 1
	
	get_tree().change_scene_to_file("res://ActiveGame/active_game.tscn")
