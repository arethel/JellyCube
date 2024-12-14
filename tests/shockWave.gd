extends MeshInstance2D

var viewport_size = Vector2(540, 960)
var rel_pos = Vector2.ZERO

func _process(_delta):
	rel_pos = (-$"../../box".global_position+global_position+viewport_size/2.0)/viewport_size
	rel_pos.y = 1-rel_pos.y
	material.set_shader_param("center",rel_pos)

func emit():
	$anim.play("shwv")
