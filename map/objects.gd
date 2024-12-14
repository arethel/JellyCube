extends Node2D

func get_position_of_block(n_block):
	if get_children().size()>n_block:
		return get_children()[n_block].global_position
	else:
		return Vector2(0,0)
