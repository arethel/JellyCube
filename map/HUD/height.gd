extends Label


var main
func _ready():
	main=get_tree().get_nodes_in_group('main')[0]
	

func _process(_delta):
	text=str(main.height)
