extends Control

func _ready():
	set_new_screen_size(Transition.get_node('screen_size').rect_size,0)

func set_new_screen_size(screen_size, y_offset):
	
	var rect_new = screen_size
	
	rect_size=rect_new
	
