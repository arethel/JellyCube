extends RigidBody2D


export (float) var ang_vel = 0
export var color = Color(1,1,1)

func _ready():
	$Light2D.color=color
	$Light2D2.color=color

func _integrate_forces(state):
	linear_velocity=Vector2.ZERO
	angular_velocity=ang_vel
	
