extends RigidBody2D


var gravity_force = 300
var jump_impulse = 700
var sticking_force = 1000

var menu

onready var def_a = $CubeGlow.modulate.a

func _ready():
	menu = get_tree().get_nodes_in_group('menu')[0]
	if get_tree().get_nodes_in_group('main'):
		get_tree().get_nodes_in_group('main')[0].pl=self
		

func start():
	applied_force=Vector2(0,gravity_force)
	jump = false
	last_cont_norm = Vector2.ZERO
	on_vert_block = false
	friction=1

var jump = false

var last_cont_norm = Vector2.ZERO

var obj=null
var rel_pos_obj=Vector2.ZERO
var rel_rot_obj=0

var last_block

var on_vert_block = false

func _integrate_forces(state):
	if dead: 
		linear_velocity=Vector2.ZERO
	
	if(state.get_contact_count()>0&&state.get_contact_local_normal(0)!=Vector2.ZERO):
		last_cont_norm=state.get_contact_local_normal(0)
	
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
			angular_damp=0
			applied_force=Vector2(0,gravity_force)
			linear_velocity = last_cont_norm*jump_impulse
			last_cont_norm = Vector2.ZERO
			on_vert_block = false
			friction=1
			yield(get_tree().create_timer(0.05),"timeout")
			waiting=false
			
	
	if on_vert_block:
		linear_velocity=Vector2(0,100)
		particles_of_vert_block.emitting = true
		particles_of_vert_block.global_position = global_position
	elif particles_of_vert_block:
		particles_of_vert_block.emitting = false
	

func stop_block_touched():
	$RayCast2D.enabled=false
	obj=null
	angular_damp=0
	applied_force=Vector2(0,gravity_force)
	linear_velocity = Vector2.ZERO
	last_cont_norm = Vector2.ZERO
	on_vert_block = false
	friction=1
	yield(get_tree().create_timer(0.05),"timeout")
	waiting=false

var particles_of_vert_block
var waiting = false
var sitting_body
func _on_player_body_entered(_body):
	if dead: return
	
	if _body.has_method('stop_block'):
		stop_block_touched()
		return
		
	if _body.has_method('death_block'):
		death()
	if !$RayCast2D.enabled&&(!waiting||_body.has_method('vert_block')):
		waiting=true
		sitting_body=_body
		$RayCast2D.enabled=true
		applied_force = Vector2.ZERO
		linear_velocity = Vector2.ZERO
		angular_damp=4
		yield(get_tree().create_timer(0.01),"timeout")
		last_block=_body
		if sitting_body.has_method('vert_block'):
			on_vert_block=true
			friction=0
			particles_of_vert_block = sitting_body.get_node('Particles2D2')
		else:
			on_vert_block=false
			friction=1
			


var dead = false
func death():
	dead=true
#	$MeshInstance2D.visible=false
	waiting = false
	$RayCast2D.enabled=false
	$CubeGlow.visible=false
	$Cube.visible=false
	$death_effect.emitting=true
	
	on_vert_block=false
	if particles_of_vert_block:
		particles_of_vert_block.emitting = false
	
	menu.get_node('rect/jump_button').visible = false
	menu.get_node('rect/DeathButtons').visible = true
	menu.get_node('rect/DeathButtons/appearance').play('anim')
	
	
	get_tree().get_nodes_in_group('main')[0].save_record()
	
	var tween = Transition.get_node('change_pitch_of_song')
	var music = Transition.get_node('music')
	tween.interpolate_property(music, "pitch_scale", music.pitch_scale, 0.5, 1.5)
	tween.start()



func respawn():
	Transition.just_start()
	yield(Transition,"anim_finished")
	
	$CubeGlow.visible=true
	$Cube.visible=true
	$death_effect.emitting=false
	$RayCast2D.enabled=false
	
	menu.get_node('rect/DeathButtons').visible = false
	menu.get_node('rect/tapToPlay').visible = true
	menu.get_node('rect/tapToPlay/txtTTP').modulate.a=1.0
	
	Transition.end()
	var tween = Transition.get_node('change_pitch_of_song')
	var music = Transition.get_node('music')
	tween.interpolate_property(music, "pitch_scale", music.pitch_scale, 1.0, 1.5)
	tween.start()
	
	var objects = get_tree().get_nodes_in_group('objects')[0]
	global_position = objects.get_position_of_block(objects.get_children().size()-3)-Vector2(0,120)
	linear_velocity=Vector2(0,0)
	applied_force=Vector2(0,0)
	on_vert_block=false
	dead = false
	waiting = false


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
#func _input(event):
#	return
#	if(event is InputEventMouseButton or event is InputEventScreenTouch):
#		if event.button_index==1 and press!=event.pressed:
#			if event.pressed:
#				press =true
#				jump=true
#			else:
#				press =false


func _on_jump_button_button_down():
	jump=true
	



