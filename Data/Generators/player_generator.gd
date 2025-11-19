extends RefCounted
class_name PlayerGenerator


func GeneratePlayer(character_id: int) -> Dictionary:
	return {
		"CharacterID": character_id,
		"Position": Player.POSITION.keys().pick_random(),  # TODO: weighted
		"Skill": randfn(0.5, 0.15)
	}
