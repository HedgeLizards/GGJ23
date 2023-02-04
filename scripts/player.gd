extends Node2D


#export var speed = 64
#export var rotation_speed = 1
export var id = 0
#var mirror = 1
#var segments = PoolVector2Array()

func start_growing():
	$Germ.start_growing()

#func __physics_process(delta):
#	var inp = mirror * int(Input.is_action_pressed("right" + str(id))) - int(Input.is_action_pressed("left" + str(id)))
#	$Germ/Tip.rotation += inp * delta * rotation_speed
#
#	var vel = Vector2(0, -speed).rotated($Germ/Tip.rotation)
#
#	$Germ/Tip.move_and_slide(vel)
#
#	if $Germ/Segments.get_point_count() == 0 || $Germ/Tip.position.distance_to($Germ/Segments.get_point_position($Germ/Segments.get_point_count() - 1)) > 5:
#		$Germ/Segments.add_point($Germ/Tip.position)
	
	
