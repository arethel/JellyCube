extends Node2D

var height = 0

func _process(_delta):
	height=$"../center".get_height()
	get_parent().height=height
