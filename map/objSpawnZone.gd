extends Area2D

var borders = [Vector2.ZERO,Vector2.ZERO]

var bodies = 0
var blocks
var lighttextcreate

func _ready():
	randomize()
	blocks = [
		load("res://map/blocks/block1.tscn"),
		load("res://map/blocks/block2.tscn"),
		load("res://map/blocks/block3.tscn"),
		load("res://map/blocks/block4.tscn"),
		load("res://map/blocks/block5.tscn")
		
	]
	
	var size = $CollisionShape2D.shape.extents
	borders=[position-Vector2(size.x/2,size.y/4),position+Vector2(size.x/2,size.y/4)]
	
#LIGHTCODE
#	lighttextcreate=get_tree().get_nodes_in_group('lighttextcreate')[0]
	
	while not spawn_object():
		yield(get_tree().create_timer(0.2), "timeout")
	

func _on_objSpawnZone_body_entered(_body):
	bodies+=1

func _on_objSpawnZone_body_exited(_body):
	bodies-=1
	if(bodies==0):
		spawn_object()



func get_difficulty(height):
	if height<200:
		return [1.5, 0.5, 0]
	elif height<400:
		return [1.5, 1, 10]
	elif height<600:
		return [1.5, 1, 15]
	elif height<800:
		return [2, 1, 20]
	elif height<1000:
		return [2, 1.5, 25]
	elif height<1200:
		return [2, 1.5, 30]
	elif height<1400:
		return [2, 1.5, 35]
	elif height<1600:
		return [2, 1.5, 40]
	else:
		return [2, 1.5, 45]



func spawn_object():
	randomize()
	var r_coords = get_parent().global_position+Vector2(rand_range(borders[0].x,borders[1].x),
	rand_range(borders[0].y,borders[1].y))
	
	var obj = blocks[randi()%blocks.size()].instance()
	
	
	if get_tree().get_nodes_in_group('objects'):
		obj.global_position = r_coords
		
		var params = get_difficulty($"..".height)
		
		obj.ang_vel=(params[1]*randf()+params[0])*pow(-1,randi()%2)
		obj.velocity=Vector2(0,params[2])
		
		var  r_color = [0.0,0.0,0.0]
		
		var n_cl = randi()%3
		r_color[n_cl]=1.0
		var n_cl2 = randi()%3
		while(n_cl2==n_cl):
			n_cl2 = randi()%3
		r_color[n_cl2]=randf()
		
		obj.color = Color(r_color[0],r_color[1],r_color[2])
		
		get_tree().get_nodes_in_group('objects')[0].call_deferred('add_child',obj)
		
		#LIGHTCODE
#		yield(obj, "ready")
#		lighttextcreate.create_texture_of_light(obj.text_pol,lighttextcreate.light_size,
#		lighttextcreate.light_simplicity,lighttextcreate.brighting)
#		yield(get_tree().create_timer(0.2), "timeout")
#		obj.get_node('Light2D').texture=lighttextcreate.get_texture_of_light()
		
		return true
	
	return false
