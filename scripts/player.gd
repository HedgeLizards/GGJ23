extends Node2D


export var speed = 64
export var rotation_speed = 1
#var segments = PoolVector2Array()


func _physics_process(delta):
	var inp = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	$Germ.rotation += inp * delta * rotation_speed

	var vel = Vector2(0, -speed).rotated($Germ.rotation)

	$Germ.move_and_slide(vel)

	if $Segments.get_point_count() == 0 || $Germ.position.distance_to($Segments.get_point_position($Segments.get_point_count() - 1)) > 5:
		$Segments.add_point($Germ.position)
	
	
