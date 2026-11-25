extends Sprite2D
class_name InGamePlayer


func Activate(p: Player, t: Team):
	$Jersey.text = str(p.jersey)
	
	self_modulate = t.school.colors[0]
	$Outline.self_modulate = t.school.colors[1]
