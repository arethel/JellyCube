extends Position2D

func _ready():
	randomize()
	#LIGHTCODE
#	var lighttextcreate=get_tree().get_nodes_in_group('lighttextcreate')[0]
	
	var blocks = [
		load("res://map/blocks/block1.tscn"),
		load("res://map/blocks/block2.tscn"),
		load("res://map/blocks/block3.tscn"),
		load("res://map/blocks/block4.tscn"),
		load("res://map/blocks/block5.tscn")
		
	]
	
	var block = blocks[randi()%blocks.size()].instance()
	
	block.ang_vel=2*randf()+0.5
		
	var  r_color = [0.0,0.0,0.0]
	
	var n_cl = randi()%3
	r_color[n_cl]=1.0
	var n_cl2 = randi()%3
	while(n_cl2==n_cl):
		n_cl2 = randi()%3
	r_color[n_cl2]=randf()
	
	
	
#	block.global_position = global_position
	
	add_child(block)
	
	block.set_color(Color(r_color[0],r_color[1],r_color[2]))
	
	#LIGHTCODE
#	yield($block, "ready")
#	lighttextcreate.create_texture_of_light($block.text_pol,lighttextcreate.light_size,
#	lighttextcreate.light_simplicity,lighttextcreate.brighting)
#	yield(get_tree().create_timer(0.2), "timeout")
#	$block.get_node('Light2D').texture=lighttextcreate.get_texture_of_light()

func block_spawner():
	pass

