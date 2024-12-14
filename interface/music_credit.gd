extends Button


export (Gradient) var grad

func _ready():
	yield(get_tree().create_timer(0.2),"timeout")
	grad = get_tree().get_nodes_in_group('main')[0].grad
	var modA = modulate.a
	modulate=grad.interpolate(1)
	modulate.a=modA
	
	Transition.get_node('music').set_credit()


func _on_music_credit_pressed():
	$appearance.play("credit")
