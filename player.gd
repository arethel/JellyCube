extends RigidBody2D


var gravity_force = 200
var jump_impulse = 700
var sticking_force = 1000

func _ready():
	add_central_force(Vector2(0,gravity_force))


var jump = false

var last_cont_norm = Vector2.ZERO

var obj=null
var rel_pos_obj=Vector2.ZERO
var rel_rot_obj=0

func _integrate_forces(state):
	
	if(state.get_contact_count()>0&&state.get_contact_local_normal(0)!=Vector2.ZERO):
		last_cont_norm=state.get_contact_local_normal(0)
		$"../sticking_pos".global_position=state.get_contact_local_position(0)
	
	get_pos_of_ray(-last_cont_norm*50)
	
	if($RayCast2D.enabled):
			get_pos_of_ray(-last_cont_norm*50)
			if object_ray:
				applied_force=(object_ray.global_position+
				relative_pos_ray.rotated(object_ray.global_rotation-relative_rot_ray)
				-global_position).normalized()*sticking_force
			else:
				if state.get_contact_count()>0:
					obj = state.get_contact_collider_object(0)
					rel_pos_obj=state.get_contact_local_position(0)-obj.global_position
					rel_rot_obj=obj.global_rotation
				if(obj):
					applied_force=(obj.global_position+
					rel_pos_obj.rotated(obj.global_rotation-rel_rot_obj)
					-global_position).normalized()*sticking_force
			
	if jump:
		jump = false
		if $RayCast2D.enabled:
			$RayCast2D.enabled=false
			obj=null
			applied_force=Vector2(0,gravity_force)
			linear_velocity = last_cont_norm*jump_impulse
			last_cont_norm = Vector2.ZERO



func _on_player_body_entered(_body):
	if !$RayCast2D.enabled:
		$RayCast2D.enabled=true
		applied_force = Vector2.ZERO
		linear_velocity = Vector2.ZERO
		


var relative_pos_ray = Vector2.ZERO
var relative_rot_ray = 0
var object_ray = null

func get_pos_of_ray(cast):
	$RayCast2D.cast_to=cast
	$RayCast2D.global_rotation=0
	$RayCast2D.force_raycast_update()
	object_ray=$RayCast2D.get_collider()
	if($RayCast2D.get_collider()):
		relative_pos_ray=$RayCast2D.get_collision_point()-$RayCast2D.get_collider().global_position
		relative_rot_ray=$RayCast2D.get_collider().global_rotation
	else:
		relative_pos_ray = Vector2.ZERO
		relative_rot_ray = 0


var press = false
func _input(event):
	if(event is InputEventMouseButton):
		if event.button_index==1 and press!=event.pressed:
			if event.pressed:
				press =true
				jump=true
			else:
				press =false


