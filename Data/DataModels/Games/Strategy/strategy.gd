extends RefCounted
class_name Strategy


var offense_plays: Array[OffensePlay]
var defense_plays: Array[DefensePlay]


func _init() -> void:
	# default strategy
	var hb_zone = RunPlay.new("HB Zone")
	var quick_slants = PassPlay.new("Quick Slants")
	
	offense_plays = [
		hb_zone, quick_slants
	]
	
	var base = DefensePlay.new("Base")
	var soft_zone = DefensePlay.new("Soft Zone")
	var press = DefensePlay.new("Press Coverage")
	var blitz = DefensePlay.new("Blitz")
	
	defense_plays = [
		base, soft_zone, press, blitz
	]


func GetOffensePersonnels() -> Array[OffensePersonnel]:
	return [
		OffensePersonnel.new(0, 0),
		OffensePersonnel.new(1, 0),
		OffensePersonnel.new(1, 1)
	]


func PickOffensePlay():
	return offense_plays.pick_random()

func PickDefensePlay():
	return defense_plays.pick_random()
