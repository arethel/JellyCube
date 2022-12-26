extends RigidBody2D



var gravity_force = 200
var jump_impulse = 700
var sticking_force = 1000

func _ready():
#	applied_force = Vector2(0,98)
	add_central_force(Vector2(0,gravity_force))
	
	
	



var set_stickness = false
var jump = false


func _integrate_forces(state):
	
#	if !set_stickness&&state.get_contact_count()==0&&linear_velocity.length()>50:
#		if(abs(rotation-needed_angel(linear_velocity.angle(),rotation))>PI/4):
#			print(round(rotation/PI*180)," ",round(linear_velocity.angle()/PI*180)," ",round(needed_angel(linear_velocity.angle(),rotation)/PI*180))
#		rotation=needed_angel(linear_velocity.angle(),rotation)
#		$velocity.rotation=linear_velocity.angle()-rotation
	
	if(set_stickness):
		if(state.get_contact_count()>0&&state.get_contact_local_normal(0)!=Vector2.ZERO):
			var cont_norm = state.get_contact_local_normal(0)
			$velocity.global_position=global_position-cont_norm*20
			$velocity.global_rotation=cont_norm.angle()
			$"../sticking_pos".global_position=global_position-cont_norm*20
			
			$"../sticking_joint".global_position=global_position
			$"../sticking_joint".global_rotation=cont_norm.angle()+PI/2
			$"../sticking_joint".rest_length=cont_norm.length()*10
			$"../sticking_joint".length=cont_norm.length()*20
			$"../sticking_joint".node_a=self.get_path()
			$"../sticking_joint".node_b=state.get_contact_collider_object(0).get_path()
			
			
			
#			applied_force=-cont_norm*sticking_force
		elif !area_of_stickness:
			set_stickness=false
			applied_force=Vector2(0,gravity_force)
#		linear_velocity=linear_velocity-cont_norm.tangent()*(cont_norm.tangent().dot(linear_velocity))
		
		
	if jump:
		if state.get_contact_count()>0:
			jump = false
			$"../sticking_joint".node_a=""
			applied_force=Vector2(0,gravity_force)
			linear_velocity = state.get_contact_local_normal(0)*jump_impulse
#			apply_central_impulse(state.get_contact_local_normal(0)*jump_impulse)
	

func needed_angel(ang1, ang2):
	var n1 = int((ang1-ang2)*4/PI)
	var n2=1
	if(n1!=0):
		n2 = n1/abs(n1)
	var am_rot=n2*round(float(abs(n1))/2)
	return ang1-PI/2*am_rot


func _on_player_body_entered(_body):
	if !set_stickness:
		applied_force = Vector2.ZERO
		linear_velocity = Vector2.ZERO
		set_stickness = true
		area_of_stickness = true
		sticking_body=_body
		

var press = false
func _input(event):
	if(event is InputEventMouseButton):
		if event.button_index==1 and press!=event.pressed:
			print(set_stickness)
			if event.pressed:
				press =true
				set_stickness=false
				jump=true
			else:
				press =false


var sticking_body = null
var area_of_stickness = false
func _on_Area2D_body_exited(body):
	if sticking_body==body:
		area_of_stickness = false
