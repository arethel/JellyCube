extends RigidBody2D



func vert_block():
	pass

onready var def_a = $VertBlock.modulate.a

var grad0

func set_grad(grad):
	grad0=grad
	var gr = GradientTexture.new()
	gr.gradient=grad
	material.set_shader_param('gradient', gr)
	$Particles2D.process_material.set_shader_param('gradient',gr)
	


func _ready():
	set_grad(get_tree().get_nodes_in_group('main')[0].grad)
	
	set_new_screen_size( Transition.get_node('screen_size').rect_size,0)
	


func set_new_screen_size(screen_size, y_offset):
	
	var rect_new =screen_size
	
	var rect_newy = rect_new.y-y_offset
	
	var offset_up = -(rect_newy-960)/2
	
	$MeshInstance2D.position.x=offset_up
	$Particles2D.position.x=offset_up
	$VertBlock.position.x=offset_up
	
	var scaler = rect_newy/960
	
	$MeshInstance2D.mesh.size.y=rect_newy-y_offset
	$Particles2D.process_material.set_shader_param("emission_box_extents",Vector3(rect_newy/2,1,1))
	$Particles2D.amount=int(scaler*float($Particles2D.amount))
	$VertBlock.scale.y=$VertBlock.scale.y*scaler
	

func _process(_delta):
	if $Particles2D2.emitting:
		$Particles2D2.process_material.set_shader_param("particle_color",grad0.interpolate(
			($MeshInstance2D.mesh.size.y/2+$Particles2D2.position.x)/$MeshInstance2D.mesh.size.y
		))
#	print(($MeshInstance2D.mesh.size.y/2+$Particles2D2.position.x)/$MeshInstance2D.mesh.size.y)
