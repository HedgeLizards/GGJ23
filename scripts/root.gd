extends StaticBody2D


export var segment_distance = 5
export var collision_radius = 10
var collision_offset = 5

var latest_position = null
var latest_progress = null
var collision_queue = []
var start_progress = null
var end_progress = null

func extend(pos, progress):
	latest_position = pos
	latest_progress = progress
	if is_empty() or pos.distance_to(last_point()) >= segment_distance:
		add_point(pos, progress)

	if collision_queue.size() != 0 and collision_queue[0].position.distance_to(pos) > collision_radius + collision_offset:
		add_child(collision_queue.pop_front())

func finish():
	add_point(latest_position, latest_progress)
	for collision in collision_queue:
		call_deferred("add_child", collision)
	collision_queue = []

func add_point(pos, progress):
	if start_progress == null:
		start_progress = progress
		print(start_progress)
		$Line.material.set_shader_param("line_start", start_progress)
	end_progress = progress
	$Line.material.set_shader_param("line_end", end_progress)
	$Line.add_point(pos)
	var obstacleShape = CollisionShape2D.new()
	obstacleShape.shape = CircleShape2D.new()
	obstacleShape.position = pos
	obstacleShape.shape.radius = collision_radius
	collision_queue.push_back(obstacleShape)


func is_empty():
	return $Line.get_point_count() == 0

func last_point():
	return $Line.get_point_position($Line.get_point_count() - 1)
