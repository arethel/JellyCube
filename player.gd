extends RigidBody2D


var gravity_force = 200
var jump_impulse = 700
var sticking_force = 1000

func _ready():
	add_central_force(Vector2(0,gravity_force))


var jump = false

var last_cont_norm = Vector2.ZERO

func _integrate_forces(state):
	
	if($"../sticking_joint".node_b!=""):
		if(state.get_contact_count()>0&&state.get_contact_local_normal(0)!=Vector2.ZERO):
			var cont_norm = state.get_contact_local_normal(0)
			last_cont_norm=cont_norm
			$velocity.global_position=global_position-cont_norm*20
			$velocity.global_rotation=cont_norm.angle()+PI
			$"../sticking_pos".global_position=global_position
			
			$"../sticking_joint".global_position=global_position
			$"../sticking_joint".global_rotation=cont_norm.angle()+PI/2
			$"../sticking_joint".rest_length=1
			$"../sticking_joint".length=26
			$"../sticking_joint".node_a=self.get_path()
			$"../sticking_joint".node_b=state.get_contact_collider_object(0).get_path()
			
		
		
	if jump:
		jump = false
		if $"../sticking_joint".node_b!="":
			$"../sticking_joint".node_b=""
			applied_force=Vector2(0,gravity_force)
			linear_velocity = last_cont_norm*jump_impulse



func _on_player_body_entered(_body):
	if $"../sticking_joint".node_b=="":
		$"../sticking_joint".node_b=_body.get_path()
		applied_force = Vector2.ZERO
		linear_velocity = Vector2.ZERO
		

var press = false
func _input(event):
	if(event is InputEventMouseButton):
		if event.button_index==1 and press!=event.pressed:
			if event.pressed:
				press =true
				jump=true
			else:
				press =false


