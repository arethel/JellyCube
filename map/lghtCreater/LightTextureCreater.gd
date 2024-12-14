tool
extends Node2D


export (PoolVector2Array) var verticies

export var light_size = 4.0
export var light_simplicity = 10.0
export var brighting = 0.01


func create_texture_of_light(verticies, light_size, light_simplicity, brighting):
	if(!verticies):
		return
	
	var highestXY = Vector2.ZERO
	
	for vert_idx in range(verticies.size()):
		if(highestXY.x<abs(verticies[vert_idx].x)):
			highestXY.x=abs(verticies[vert_idx].x)
		if(highestXY.y<abs(verticies[vert_idx].y)):
			highestXY.y=abs(verticies[vert_idx].y)
		
		
	$Viewport.size = (highestXY)*2*light_size
	$Viewport/drawer.position=$Viewport.size/2
	
	
	var offset_sc = (light_size-1)/(light_simplicity-1)
	var ar = range(light_simplicity)
	
	$Viewport/drawer.dr(verticies,light_size, light_simplicity,brighting)
	

func get_texture_of_light():
	var fin_img = $Viewport.get_texture().get_data()
	
#	img.fix_alpha_edges()
	var text = ImageTexture.new()
	text.create_from_image(fin_img)
	
	return text

#
#func _ready():
#
#	$Sprite.texture=get_texture_of_light(verticies,light_size,light_simplicity,brighting)
#

#func _process(_delta):
#	$Node2D.texture=get_texture_of_light(verticies,light_size,light_simplicity)
