extends RefCounted
class_name CoachGenerator


func GenerateCoach(character_id: int) -> Dictionary:
	return {
		"CharacterID": character_id,
	}
