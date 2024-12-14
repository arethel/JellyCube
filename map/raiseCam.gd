extends Position2D

var main
func _ready():
	if get_tree().get_nodes_in_group('main'):
		main=get_tree().get_nodes_in_group('main')[0]

func _process(_delta):
	
	if(main.pl && main.pl.get_node('RayCast2D').enabled &&
	 main.pl.sitting_body&&main.pl.sitting_body.has_method('get_tag')&&main.pl.sitting_body.get_tag()=='block'):
		checkForRaiseCam()


func checkForRaiseCam():
	if(main.pl.global_position.y<=global_position.y):
		if(!$"../boxRaiser".is_active()):
			$"../boxRaiser".interpolate_property($"..",'global_position',$"..".global_position,
			$"..".global_position+Vector2(0,
			main.pl.global_position.y-$"..".global_position.y-$"../playerPosForCam".position.y
			),2,Tween.TRANS_QUART,Tween.EASE_IN_OUT)
			$"../boxRaiser".start()

