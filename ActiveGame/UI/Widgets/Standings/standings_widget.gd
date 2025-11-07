extends VBoxContainer
class_name StandingsWidget


func Render():
	for n: Node in get_children():
		n.queue_free()
