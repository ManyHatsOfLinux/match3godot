extends Spatial

onready var block = preload("res://Blocks/block.tscn")
onready var water_meterial = preload("res://Blocks/Water/water.material")
onready var fire_meterial = preload("res://Blocks/Fire/fire.material")

onready var cursor = preload("res://cursor/Cursor.tscn")
onready var cursor_material = preload("res://cursor/Material.material")

#push board every num frames
export var push_count = 5
var push_loop = 0

var x_cursor
var init_pos = Vector3(0,-10,0)
var stoptime = 0
var horizontal_pos = [-5,-3,-1,1,3,5]
var offset = 0
#will hold all block names in order. 
var grid = []


	
	
	

func spawn_row():
	#generate row 0 
	var row = []
	var column = []
	for x in horizontal_pos:
		var y = block.instance()
		y.set_translation(Vector3(x,-2,0))
		add_child(y)
		row.append([y.global_transform.origin.x, y.global_transform.origin.y, y.global_transform.origin.z, y.block_type,y.get_name()])
	# add rows from grid to our row
	column.append(row)
	for x in grid:
		column.append(x)
	grid = column
		
		

func spawn_cursor():
	x_cursor = cursor.instance()
	x_cursor.set_translation(Vector3(0,9,3))
	x_cursor.get_node("cursor/CollisionShape/cursor_mesh").material_override = cursor_material
	add_child(x_cursor)
	
	
func _ready():
	spawn_cursor()
	spawn_row()
	

func push_board_up():
#	print(grid)
	#print_tree()
	#for every block
	for x in get_tree().get_nodes_in_group("spawned"):
		#clean floor off blocks
		if  x.global_transform.origin.y == 1 :
			x.remove_from_group("not_spawned")
	
			match x.block_type:
				1:
					x.get_node("Block/CollisionShape/block").material_override = water_meterial
				2:
					x.get_node("Block/CollisionShape/block").material_override = fire_meterial
					
		#kill I_match blocks
		if x.I_match == 1:
			x.queue_free()
			print(grid)
		#kill blocks over pos 22
		if  x.global_transform.origin.y > 22:
				x.queue_free()
		
		#raise blocks /TODO/ if not gavity and stuff
		x.set_translation(Vector3(x.global_transform.origin.x,x.global_transform.origin.y + 0.25 ,x.global_transform.origin.z))
	#	x_cursor.set_translation(Vector3(x_cursor.global_transform.origin.x, x_cursor.global_transform.origin.y + 0.25 , x_cursor.global_transform.origin.z))
	offset = offset + 0.25
	
	if offset == 2 : 
			spawn_row()
			offset = 0
			
		



func match_board():
	#if grid not empty
	if len(grid) > 0:
		#for every row
		for x in range(len(grid)):
			#for every block in row
			var column = str("")
			for y in range(len(grid[x])):
				#get current block
				var z = get_node(grid[x][y][4])
				
				#If not empty
				if grid[x][y][3] != 99 :
				
				#if not spawned
					if z.is_in_group("not_spawned"):
						pass
					else:
						#if not on edge
						if x < int(len(grid[x]) ):
							#or on other edge
							if y < int(len(grid[x][y]) ):
					
								#if block_type equals next block
								if grid[x][y][3] ==  grid[x][y + 1][3] and grid[x][y][3] ==  grid[x][y - 1][3]:
									z.I_match = 1
									z.queue_free()
									grid[x][y][3] = 99 
					column = column + str(z.I_match)
				print(column)
							

#make blocks fall if nothing underneath
func fall_blocks():
	for x in range(len(grid)):
		for y in range(len(grid[x])):
			#if block empty
			if grid[x][y][3] == 99:
				#all blocks above must fall
				for z in range(y+1,len(grid)):
					#if not on edge
					if x < int(len(grid[x]) -1):
						#or on other edge
						if z < int(len(grid[x][y]) -1):
							if  grid[x][z][3] != 99 :
								get_node(grid[x][z][4]).add_to_group("falling")
								get_node(grid[x][z][4]).set_translation(Vector3(get_node(grid[x][z][4]).global_transform.origin.x,get_node(grid[x][z][4]).global_transform.origin.y - 0.25 ,get_node(grid[x][z][4]).global_transform.origin.z))
								
		#push blocks down
		for x in get_tree().get_nodes_in_group("falling"):
			if x.global_transform.origin.y in [0+offset,2+offset,4+offset,6+offset,8+offset,10+offset,12+offset,14+offset,16+offset,18+offset,20+offset,22+offset,24+offset]:  
				x.remove_from_group("falling")
			else: 
				x.set_translation(Vector3(x.global_transform.origin.x,x.global_transform.origin.y - 0.25 ,x.global_transform.origin.z))
				
			
			
					
				


func kill_blocks():
	for x in range(len(grid)):
		for y in range(len(grid[x])):
			if grid[x][y][3] != 99:
				#if not on edge
				if x < int(len(grid[x]) ):
					#or on other edge
					if y < int(len(grid[x][y]) ):
						var z = get_node(grid[x][y][4])
						if z.I_match == 1:
							z.queue_free()
				



#this runs every frame. essentially mainloop
func _on_Timer_timeout():
	var fallset = 0 
	fall_blocks()
	match_board()
	
	kill_blocks()
	
	#push board
	if stoptime == 0 and len(get_tree().get_nodes_in_group("falling")) < 1 and push_loop == push_count:
		push_board_up()
		
	
	#decrement stop time every "frame" thing
	if stoptime > 0:
		stoptime = stoptime - 1
	
	
	#reset push_loop if full
	if push_loop == push_count:
		push_loop = 0
	#or increase it
	else: 
		push_loop = push_loop + 1


		
		
 


