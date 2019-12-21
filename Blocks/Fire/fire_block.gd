extends Spatial

var I_match = int(0) 
var block_type = 7
var is_falling = 0
var grid_pos = [0,0]
var fallset = 0
var fall_distance = 0
var swapset = 0
var swap_direction = ""



	




# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("not_spawned")
	add_to_group("spawned")
	randomize()
	block_type = randi() %3+1
	

	






	

	
	
	