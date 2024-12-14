extends Node2D

var last_height = 0

func get_height():
	if $player:
		var height = (global_position.y-$player.global_position.y)/20
		if height<=last_height:
			return last_height
		else:
			last_height=int(height)
			return last_height
