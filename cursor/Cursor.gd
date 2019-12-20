extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var grid_pos = [0,0]




# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_translation(Vector3(0,5,2))
	self.grid_pos = [2,2]
	pass # Replace with function body.



func _input(ev):
	if len(get_tree().get_nodes_in_group("swapping")) == 0:
	#UP
		if Input.is_key_pressed(KEY_UP):
			if self.global_transform.origin.y < 20:
				self.set_translation(Vector3(self.global_transform.origin.x, self.global_transform.origin.y + 2 , self.global_transform.origin.z))
				self.grid_pos[0] = self.grid_pos[0] + 1
				print("CURSOR  X:",self.grid_pos[0]," Y:",self.grid_pos[1])
		if Input.is_key_pressed(KEY_DOWN):
			if self.global_transform.origin.y > 2:
				self.set_translation(Vector3(self.global_transform.origin.x, self.global_transform.origin.y - 2 , self.global_transform.origin.z))
				self.grid_pos[0] = self.grid_pos[0] - 1
				print("CURSOR  X:",self.grid_pos[0]," Y:",self.grid_pos[1])
	#LEFT
		if Input.is_key_pressed(KEY_LEFT):
			if self.global_transform.origin.x > -3 :
				self.set_translation(Vector3(self.global_transform.origin.x - 2, self.global_transform.origin.y, self.global_transform.origin.z))
				self.grid_pos[1] = self.grid_pos[1] - 1
				print("CURSOR  X:",self.grid_pos[0]," Y:",self.grid_pos[1])
	#RIGHT
		if Input.is_key_pressed(KEY_RIGHT):
			if self.global_transform.origin.x < 3 :
				self.set_translation(Vector3(self.global_transform.origin.x + 2, self.global_transform.origin.y, self.global_transform.origin.z))
				self.grid_pos[1] = self.grid_pos[1] + 1
				print("CURSOR  X:",self.grid_pos[0]," Y:",self.grid_pos[1])


        #code

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
