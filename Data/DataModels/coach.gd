extends RefCounted
class_name Coach


var id: int
var character: Character

# Strategy
	# Playbook

# Philosophies
	# Playcalling
	# Rotations
		# Workhorses vs Rotation
		# Seniority vs Development
		# Injury Caution
		# Best Overall vs Scheme Fit

# Recruiting
# ???

# Coaching
# var evaluation_current: float  # skill at judging the current skill level of a player
# var evaluation_potential: float  # skill at predicting the potential of a player


static func FromDict(d: Dictionary) -> Coach:
	var c = Coach.new()
	
	c.id = d["ID"]
	c.character = Character.FromDB(d["CharacterID"])
	
	return c

func ToDict() -> Dictionary:
	return {
		"ID": id,
		"CharacterID": character.id
	}


static func FromDB(coach_id: int) -> Coach:
	return Coach.FromDict(Database.GetItem("Coaches", coach_id))

func AddToDB():
	Database.AddRow(
		"Coaches",
		ToDict()
	)
