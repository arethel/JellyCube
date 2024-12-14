tool
extends Node2D

var arr2
var alpha = 1
var brighting = 0
func dr(verticies, light_size, light_simplicity, brighting_l):
	var polygons = []
	brighting=brighting_l
	alpha = 1/(light_simplicity)
	
	var scale_offset = (light_size-1)/(light_simplicity-1)
	
	
	for i in range(light_simplicity):
		var verticies2 = PoolVector2Array()
		for vert_idx in range(verticies.size()):
			verticies2.push_back(Vector2(verticies[vert_idx].x*(1+scale_offset*i),
			verticies[vert_idx].y*(1+scale_offset*i)))
		polygons.append(verticies2)
	arr2=polygons
	update()

func _draw():
	if arr2:
		for pol_idx in range(arr2.size()):
			draw_colored_polygon(arr2[pol_idx],Color(1.0,1.0,1.0,alpha+brighting))
