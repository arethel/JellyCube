extends Node2D


export var sides = 4

export var size = 50.0
export var radius = 5
export var simplicity = 5


func _ready():
	randomize()
	
	var temp_vert = create_temp_vert(generateAngels(sides), size)
	var mesh_pol = create_mesh_polygon(temp_vert,radius,simplicity)
	$MeshInstance2D.mesh = create_mesh(mesh_pol)
	$CollisionPolygon2D.polygon=create_coll_polygon(temp_vert,radius)
	$LightOccluder2D.occluder.polygon=PoolVec3ToVec2(mesh_pol)


func generateAngels(sides, randomness=5):
	var angels_hint = 2*PI/sides
	var angels_offset = angels_hint/2
	
	var angels = []
	
	for i in range(sides):
		angels.append((angels_hint)*i+randf()*angels_offset)
	
	
	randomness =min(randomness,sides-2)
	
	for i in range(randomness):
		if randf()<0.8:
			var ang = randi()%angels.size()
			angels[ang]=angels[ang-1]+angels_offset/2
	
	return angels

func create_temp_vert(angels, size):
	var temp_vertices = PoolVector2Array()
	for angel in angels:
		temp_vertices.push_back(Vector2(cos(angel)*size, -sin(angel)*size))
	return temp_vertices


func create_coll_polygon(temp_vertices,radius=5):
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
		
		var dist = radius/sin(PI/2-nb_offset)
		
		vertices.push_back(temp_vertices[vert_idx]+
		Vector2(cos(ang1+nb_offset)*dist, -sin(ang1+nb_offset)*dist))
		
	
	return vertices

func create_mesh_polygon(temp_vertices, radius=5 , simplicity=5):
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
		
		var nb_offset = angel_range/float(simplicity-1)
		
		for i in range(simplicity):
			vertices.push_back(Vector3(temp_vertices[vert_idx].x,temp_vertices[vert_idx].y,0)+
			Vector3(cos(ang1+nb_offset*i)*radius, -sin(ang1+nb_offset*i)*radius, 0))
	
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
