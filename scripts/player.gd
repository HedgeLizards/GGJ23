extends Node2D


#export var speed = 64
#export var rotation_speed = 1
#var mirror = 1
#var segments = PoolVector2Array()

func start_growing():
	_active_germ().start_growing()

func set_id_index(id, index):
	_active_germ().set_id_index(id, index)

func _active_germ():
	return get_child(get_child_count() - 1)

func die():
	return _active_germ().die()

func finish():
	return _active_germ().finish()

func y_position():
	return _active_germ().get_node('Tip').global_position.y

func is_nitro_active():
	return _active_germ().nitro_active

func set_bonus_gain(bonus):
	_active_germ().bonus_gain = bonus


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
	
	
