extends Spatial

onready var block = preload("res://Blocks/block.tscn")
onready var water_meterial = preload("res://Blocks/Water/water.material")
onready var fire_meterial = preload("res://Blocks/Fire/fire.material")

onready var cursor = preload("res://cursor/Cursor.tscn")
onready var cursor_material = preload("res://cursor/Material.material")

#push board every num frames
export var push_count = 1
var push_loop = 0
var x_cursor
var stoptime = 0
var horizontal_pos = [-5,-3,-1,1,3,5]
var offset = .25
#will hold all block names in order. 
var grid = []
#to hold current falling blocks offset
var fallset = 0 

	

#rebuild grid from x_blocks transforms
func update_grid():
	#generate new blank grid
	var newgrid = []
	#if blocks are spawned	
	#storage for columns
	var newrow = []
	#iterate on rows
	for rows in range(12):
		#and columns
		for columns in range(6):
			#add 
			newrow.append([rows,columns,0,99,"DEAD"])

		newgrid.append(newrow)
		newrow = []
	#also if blocks are spawned
	if len(get_tree().get_nodes_in_group("spawned")) > 0:
		for x_block in get_tree().get_nodes_in_group("spawned"):
			var xpos
			var ypos
			var zpos = 0
			#print(x_block.get_name(),":",x_block.global_transform.origin.x)
			match x_block.global_transform.origin.x :
				float(-5):
					xpos = 0
				float(-3):
					xpos = 1
				float(-1):
					xpos = 2
				float(1):
					xpos = 3
				float(3):
					xpos = 4
				float(5):
					xpos = 5
			if x_block.global_transform.origin.y < 1:
				ypos = 0
			else:
				ypos = int(round(x_block.global_transform.origin.y / 2))
			newgrid[ypos][xpos] = [x_block.global_transform.origin.x, x_block.global_transform.origin.y, x_block.global_transform.origin.z, x_block.block_type,x_block.get_name()]
			#newgrid[ypos][xpos] = grid[ypos][xpos]
			x_block.grid_pos[1] = xpos
			x_block.grid_pos[0] = ypos
			
		grid = newgrid









func spawn_row():	
	for x in horizontal_pos:
		var y = block.instance()
		y.grid_pos = [0,x]
		y.set_translation(Vector3(x,-0.75,0))
		add_child(y)
	update_grid()





func spawn_cursor():
	x_cursor = cursor.instance()
	x_cursor.set_translation(Vector3(0,9,3))
	x_cursor.get_node("cursor/CollisionShape/cursor_mesh").material_override = cursor_material
	add_child(x_cursor)
	
	
func _ready():
	spawn_cursor()

	

func push_board_up():
	#for every block
	var clean_count = int(0)
	for x in get_tree().get_nodes_in_group("spawned"):
		#clean floor off blocks
		if  x.global_transform.origin.y == 1 :
			x.remove_from_group("not_spawned")

	
			match x.block_type:
				1:
					x.get_node("Block/CollisionShape/block").material_override = water_meterial
				2:
					x.get_node("Block/CollisionShape/block").material_override = fire_meterial
					
			clean_count = clean_count + 1
			if clean_count == 6:
				
				clean_count = 0
				
				
		#kill blocks over pos 22
		if  x.global_transform.origin.y > 22:
				x.queue_free()
				
		#raise blocks
		x.set_translation(Vector3(x.global_transform.origin.x,x.global_transform.origin.y + 0.25 ,x.global_transform.origin.z))
	#	x_cursor.set_translation(Vector3(x_cursor.global_transform.origin.x, x_cursor.global_transform.origin.y + 0.25 , x_cursor.global_transform.origin.z))
	


			
		

func two_to_down(x_block):
	#if x_block.global_transform.origin.x > 4.9:
		if grid[x_block.grid_pos[0]][x_block.grid_pos[1]][3] == grid[x_block.grid_pos[0] - 1][x_block.grid_pos[1]][3] and grid[x_block.grid_pos[0] - 2][x_block.grid_pos[1]][3] == x_block.block_type and x_block.block_type != 99:
			x_block.I_match = 1
			pass

func two_to_up(x_block):
	if grid[x_block.grid_pos[0]][x_block.grid_pos[1]][3] == grid[x_block.grid_pos[0] + 1][x_block.grid_pos[1]][3] and grid[x_block.grid_pos[0] + 2][x_block.grid_pos[1]][3] == x_block.block_type and x_block.block_type != 99:
		x_block.I_match = 1
	
func two_to_right(x_block):
	if grid[x_block.grid_pos[0]][x_block.grid_pos[1]][3] == grid[x_block.grid_pos[0]][x_block.grid_pos[1] + 1][3] and grid[x_block.grid_pos[0]][x_block.grid_pos[1] + 2][3] == x_block.block_type and x_block.block_type != 99:
		x_block.I_match = 1

func two_to_left(x_block):
	if grid[x_block.grid_pos[0]][x_block.grid_pos[1]][3] == grid[x_block.grid_pos[0]][x_block.grid_pos[1] - 1][3] and grid[x_block.grid_pos[0]][x_block.grid_pos[1] - 2][3] == x_block.block_type and x_block.block_type != 99:
		x_block.I_match = 1

func two_to_v_sides(x_block):
	#if x_block.global_transform.origin.x > 2.9:
		if grid[x_block.grid_pos[0]][x_block.grid_pos[1]][3] == grid[x_block.grid_pos[0] - 1][x_block.grid_pos[1]][3] and grid[x_block.grid_pos[0] + 1][x_block.grid_pos[1]][3] == x_block.block_type and x_block.block_type != 99:
			x_block.I_match = 1
	
func two_to_h_sides(x_block):
	if grid[x_block.grid_pos[0]][x_block.grid_pos[1]][3] == grid[x_block.grid_pos[0]][x_block.grid_pos[1] + 1][3] and grid[x_block.grid_pos[0]][x_block.grid_pos[1] - 1][3] == x_block.block_type and x_block.block_type != 99:
		x_block.I_match = 1


func is_blank_below(x_block):
	var falling = false
	for rows in range(1, x_block.grid_pos[0]):
		if grid[rows][x_block.grid_pos[1]][3] == 99:
			falling = true
		return falling;


func match_blocks():
	#for every row
	for x_block in get_tree().get_nodes_in_group("spawned"):
		if x_block.is_in_group("not_spawned") == false and x_block.is_in_group("falling") == false :  
			match x_block.grid_pos[1]:
				0:
					two_to_right(x_block)
				1:
					two_to_right(x_block)
					two_to_h_sides(x_block)
				2,3:
					two_to_h_sides(x_block)
					two_to_right(x_block)
					two_to_left(x_block)
				4:
					two_to_h_sides(x_block)
					two_to_left(x_block)
				5:
					two_to_left(x_block)
			
			match x_block.grid_pos[0]:
				
				1:
					two_to_up(x_block)
						
				2:
					two_to_up(x_block)
					two_to_v_sides(x_block)
						
				3,4,5,6,7,8,9:
					two_to_up(x_block)
					two_to_down(x_block)
					two_to_v_sides(x_block)
					
				10:
					two_to_down(x_block)
					two_to_v_sides(x_block)
				11:
					two_to_down(x_block)








func fall_blocks():
	print(fallset)
	print("push")
	#mark to fall and keep falling 
	if fallset < 2:
		for x_block in get_tree().get_nodes_in_group("spawned"):
			if is_blank_below(x_block) == true:
						x_block.is_falling = 1
						x_block.add_to_group("falling")
			if x_block.is_falling == 1:
				x_block.set_translation(Vector3(x_block.global_transform.origin.x,x_block.global_transform.origin.y - 0.25 ,x_block.global_transform.origin.z))
		if len(get_tree().get_nodes_in_group("falling"))  > 0:
			fallset = fallset + 0.25
	else:
		#reset fallset
		fallset = 0 
		update_grid()
		for x_block in get_tree().get_nodes_in_group("falling"):
				if  is_blank_below(x_block) == false:
					x_block.is_falling = 0
					x_block.remove_from_group("falling")
					#if is_blank_below(x_block) == false:

	

#for columns in grid
#for blocks
#if empty block below
#mark fall + push...wait 7 ticks.

#then push + remove_fall to allow match_board

	



func kill_blocks():
	for x_block in get_tree().get_nodes_in_group("spawned"): 
				if x_block.I_match == 1:
					grid[x_block.grid_pos[0]][x_block.grid_pos[1]] = [x_block.grid_pos[0], x_block.grid_pos[1], 0, 99, "DEAD"]
					x_block.queue_free()
				


#this runs every "frame". essentially mainloop
func _on_Timer_timeout():
	#update_grid()
	if offset == 2 or len(grid) == 0:
		spawn_row()
		offset = 0



	if len(grid) > 0:
		fall_blocks()
		pass
	
	if len(get_tree().get_nodes_in_group("done_falling")) > 0 or offset == .25:
		match_blocks()
		kill_blocks()



	if stoptime == 0 and len(get_tree().get_nodes_in_group("falling")) == 0 and push_loop == push_count:
		push_board_up()
		offset = offset + 0.25
		

	#decrement stop time every "frame" thing
	if stoptime > 0:
		stoptime = stoptime - 1
	
	
	#reset push_loop if full
	if push_loop == push_count:
		push_loop = 0
	#or increase it
	else: 
		push_loop = push_loop + 1
		
		
 


