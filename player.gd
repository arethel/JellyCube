extends RigidBody2D


func _ready():
#	applied_force = Vector2(0,98)
	add_central_force(Vector2(0,98))
	apply_central_impulse(Vector2(0,200))


var set_stickness = false
var jump = false


func _integrate_forces(state):
	
	if !set_stickness&&state.get_contact_count()==0:
		rotation=linear_velocity.angle()
	
	if(set_stickness&&state.get_contact_count()>0&&state.get_contact_local_normal(0)!=Vector2.ZERO):
		var cont_norm = state.get_contact_local_normal(0)
		applied_force=-cont_norm*300
#		linear_velocity=linear_velocity-cont_norm.tangent()*(cont_norm.tangent().dot(linear_velocity))
		
		
	if jump:
		jump = false
		if state.get_contact_count()>0:
			applied_force=Vector2(0,100)
			apply_central_impulse(state.get_contact_local_normal(0)*300)
	

func _on_player_body_entered(_body):
	if !set_stickness:
		applied_force = Vector2.ZERO
		set_stickness = true

var press = false
func _input(event):
	if(event is InputEventMouseButton):
		if event.button_index==1 and press!=event.pressed:
			if event.pressed:
				press =true
				set_stickness=false
				jump=true
			else:
				press =false


