extends Polygon2D
class_name GameField


@export var LINE_NUMBER: PackedScene


const DIMENSIONS = Vector2(53.3, 120.0)  # yards
const DISPLAY_SCALE: float = 20.0  # px/yard

@onready var dimensions = DIMENSIONS * DISPLAY_SCALE  # px


func Activate():
	SetField()
	PlaceLines()
	# TODO: borders, end zones, midfield
	
	show()


func SetField():
	polygon = [
		dimensions * Vector2(-1, -1) / 2,
		dimensions * Vector2(1, -1) / 2,
		dimensions * Vector2(1, 1) / 2,
		dimensions * Vector2(-1, 1) / 2
	] as PackedVector2Array


func PlaceLines():
	PlaceLine(50, 0)
	for y in [45, 40, 35, 30, 25, 20, 15, 10, 5, 0]:
		PlaceLine(y, -1)
		PlaceLine(y, 1)
	
	PlaceLine(25, 1, Color.CORNFLOWER_BLUE, "LOS")
	PlaceLine(35, 1, Color.YELLOW, "LTG")

func PlaceLine(yardline: int, side: int, color: Color = Color.WHITE, n: String=""):
	var y = side * (50 - yardline) * DISPLAY_SCALE
	
	var line = Line2D.new()
	line.points = [
		Vector2(-dimensions.x/2, 0),
		Vector2(dimensions.x/2, 0)
	] as PackedVector2Array
	line.position.y = y
	line.width = 2
	line.default_color = color
	add_child(line)
	
	if yardline % 10 == 0 and yardline > 0:
		PlaceNumber(line, str(yardline), -1)
		PlaceNumber(line, str(yardline), 1)
	
	if n:
		line.name = n



func PlaceNumber(line: Line2D, number: String, sideline: int):
	var num: Label = LINE_NUMBER.instantiate()
	line.add_child(num)
	
	num.text = "%s %s" % [number[0], number[1]]
	num.position.x = sideline * (dimensions.x - 200)/2 - 24
	
	num.rotation = sideline * TAU/4
