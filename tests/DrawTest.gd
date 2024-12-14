tool
extends Node2D


export (PoolVector2Array) var arr2

func _draw():
	if arr2:
		draw_colored_polygon(arr2,Color(1.0,1.0,1.0))

func _process(_delta):
	update()

