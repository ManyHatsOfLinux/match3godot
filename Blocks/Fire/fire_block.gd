extends Spatial
export var I_match = int(0) 
export var block_type = 7
export var is_falling = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("not_spawned")
	add_to_group("spawned")
	randomize()
	block_type = randi() %2+1
	

	






	

	
	
	