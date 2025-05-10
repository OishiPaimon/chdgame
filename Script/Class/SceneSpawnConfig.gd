class_name SceneSpawnConfig
extends Resource

@export var spawn_groups: Dictionary = {
	"group1": {
		"min_monsters": 2,
		"max_monsters": 4,
		"monster_weights": {
			"owlet": 0.7,
			"pink": 0.3
		}
	},
	"group2": {
		"min_monsters": 3,
		"max_monsters": 5,
		"monster_weights": {
			"owlet": 0.4,
			"pink": 0.6
		}
	}
} 
