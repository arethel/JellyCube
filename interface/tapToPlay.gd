extends TextureButton



func _on_tapToPlay_pressed():
	$txtTTP/anim.stop()
	$txtTTP/Tween.interpolate_property($txtTTP,'modulate:a',$txtTTP.modulate.a, 0, 0.5)
	$txtTTP/Tween.start()
	Transition.hide_node($"../interface_buttons",0.5)
	get_tree().get_nodes_in_group('main')[0].pl.start()
	yield($txtTTP/Tween,"tween_completed")
	visible=false
	$"../jump_button".visible=true
