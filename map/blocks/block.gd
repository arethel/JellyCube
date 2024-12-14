tool

extends RigidBody2D

export var velocity = Vector2.ZERO
export (float) var ang_vel = 0.0
export var color = Color(1,1,1)



export var sides = 4

export var size = 50.0
export var radius = 5
export var simplicity = 5

export var scale0 = 0.8

var temp_vert
var mesh_pol
export (PoolVector2Array) var text_pol


export var light_size = 3.0
export var light_simplicity = 10
export var brighting = 0.01

var def_a

func block():
	pass

func get_tag():
	return 'block'

var main
func _ready():
	
	main = get_tree().get_nodes_in_group('main')[0]
	
	modulate=color*2
	
#	$block_sprite_glowing.modulate=color
#	$block_sprite.modulate=color
	
	
#	$Particles2D.modulate=color
#	$Particles2D2.modulate=color
	
	$block_sprite_glowing.scale=Vector2(scale0,scale0)
	$block_sprite.scale=Vector2(scale0,scale0)
	def_a = $block_sprite_glowing.modulate.a
#	$CollisionPolygon2D.polygon=scaling_polygon($CollisionPolygon2D.polygon,scale0,$CollisionPolygon2D.position,$block_sprite.position)
	
#	$block_sprite_glowing.scale=Vector2(2,2)
	
	#GENERATE CODE
#	temp_vert = create_temp_vert(generateAngels(sides), size)
#	mesh_pol = create_mesh_polygon(temp_vert,radius,simplicity)
#	$MeshInstance2D.mesh = create_mesh(mesh_pol)
#	$CollisionPolygon2D.polygon=create_coll_polygon(temp_vert,radius)
	
#LIGHTCODE
#	text_pol = PoolVec3ToVec2(mesh_pol)
#	$LightOccluder2D.occluder.polygon=text_pol
#	$Light2D.color=color
#	$Light2D2.color=color
	

func set_color(col):
	$Particles2D.modulate=col
	$Particles2D2.modulate=col
	modulate=col*2





func _integrate_forces(state):
	if !main.pl.dead:
		linear_velocity=velocity
#		linear_velocity=Vector2(0,20)
	else:
		linear_velocity=Vector2.ZERO
	angular_velocity=ang_vel
	
	if state.get_contact_count()==0:
		$Particles2D2.emitting=false
	
	if state.get_contact_count()>0:
		if state.get_contact_collider_object(0).last_block!=self:
			
			state.get_contact_collider_object(0).last_block=self
			$Particles2D.global_position=state.get_contact_local_position(0)
			$Particles2D.global_rotation=state.get_contact_local_normal(0).angle()-PI/2
			$Particles2D.process_material.set_shader_param("initial_linear_velocity",
			state.get_contact_collider_velocity_at_position(0).length()/2)
			
			$Particles2D.restart()
			$Particles2D.emitting=false
			$Particles2D.one_shot=false
			$Particles2D.emitting=true
			$Particles2D.one_shot=true
			
#			if(get_tree().get_nodes_in_group('shockWave')):
#				var shockWave = get_tree().get_nodes_in_group('shockWave')[0]
#				shockWave.global_position = state.get_contact_local_position(0)
#				shockWave.emit()
			
		
		$Particles2D2.global_position=state.get_contact_local_position(0)
		$Particles2D2.global_rotation=state.get_contact_local_normal(0).angle()-PI/2
#		$Particles2D2.process_material.set_shader_param("initial_linear_velocity",50)
		$Particles2D2.emitting=true
		
		
	
	


func scaling_polygon(pol, sc, center, offst):
	var diff = center-offst
	for i in range(pol.size()):
		pol[i]=(pol[i]+diff)*sc-diff
	return pol

#GENERATE CODE
func generateAngels(sides0, randomness=5):
	var angels_hint = 2*PI/sides0
	var angels_offset = angels_hint/2
	
	var angels = []
	
	for i in range(sides0):
		angels.append((angels_hint)*i+randf()*angels_offset)
	
	
	randomness =min(randomness,sides-2)
	
	for _i in range(randomness):
		if randf()<0.8:
			var ang = randi()%angels.size()
			angels[ang]=angels[ang-1]+angels_offset/2
	
	return angels

func create_temp_vert(angels, size0):
	var temp_vertices = PoolVector2Array()
	var center = Vector2.ZERO
	for angel in angels:
		temp_vertices.push_back(Vector2(cos(angel)*size0, -sin(angel)*size0))
		center+=temp_vertices[-1]
		
	center=center/temp_vertices.size()
	
	for vert_idx in range(temp_vertices.size()):
		temp_vertices[vert_idx]-=center
		
	return temp_vertices

func create_coll_polygon(temp_vertices,radius0=5):
	var vertices = PoolVector2Array()
	
	for vert_idx in range(temp_vertices.size()):
		var ang1 = -(-((temp_vertices[vert_idx]-temp_vertices[vert_idx-1]).tangent())).angle()
		var ang2 = 0
		if vert_idx+1<temp_vertices.size():
			ang2 = -(-((temp_vertices[vert_idx+1]-temp_vertices[vert_idx]).tangent())).angle()
		else:
			ang2 = -(-((temp_vertices[0]-temp_vertices[vert_idx]).tangent())).angle()
		
		var angel_range = ang2-ang1
		
		if angel_range<0:
			angel_range=angel_range+2*PI
		
		var nb_offset = angel_range/2
		
		var dist = radius0/sin(PI/2-nb_offset)
		
		vertices.push_back(temp_vertices[vert_idx]+
		Vector2(cos(ang1+nb_offset)*dist, -sin(ang1+nb_offset)*dist))
		
	
	return vertices

func create_mesh_polygon(temp_vertices, radius0=5 , simplicity0=5):
	var vertices = PoolVector3Array()
	
	for vert_idx in range(temp_vertices.size()):
		var ang1 = -(-((temp_vertices[vert_idx]-temp_vertices[vert_idx-1]).tangent())).angle()
		var ang2 = 0
		if vert_idx+1<temp_vertices.size():
			ang2 = -(-((temp_vertices[vert_idx+1]-temp_vertices[vert_idx]).tangent())).angle()
		else:
			ang2 = -(-((temp_vertices[0]-temp_vertices[vert_idx]).tangent())).angle()
		
		var angel_range = ang2-ang1
		
		if angel_range<0:
			angel_range=angel_range+2*PI
		
		var nb_offset = angel_range/float(simplicity0-1)
		
		for i in range(simplicity0):
			vertices.push_back(Vector3(temp_vertices[vert_idx].x,temp_vertices[vert_idx].y,0)+
			Vector3(cos(ang1+nb_offset*i)*radius0, -sin(ang1+nb_offset*i)*radius0, 0))
	
	return vertices

func create_mesh(vertices):
	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = vertices
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLE_FAN, arrays)
	
	return arr_mesh

func PoolVec3ToVec2(Vec3):
	var Vec2 = PoolVector2Array()
	
	for el in Vec3:
		Vec2.push_back(Vector2(el.x, el.y))
	
	return Vec2


