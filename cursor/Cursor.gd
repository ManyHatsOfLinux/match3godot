extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"






# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.



func _input(ev):
	if ev is InputEventKey and ev.scancode == KEY_K and not ev.echo:
		print("k")
		self.set_translation(Vector3(self.global_transform.origin.x, self.global_transform.origin.y - 1 , self.global_transform.origin.z))
		
		



        #code

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
